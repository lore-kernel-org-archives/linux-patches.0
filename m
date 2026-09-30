Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18474FC8E0;
	Wed, 30 Sep 2026 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783145; cv=none; b=JV6OogobmzjJv45mb1MaTAdWV81QiEP44NBTSFkCU3Qq4j1x4qQEHimHdXnbMcYwnuzxWSUueIm9WOLEqQQAp9Cc2i9vcm6aBFUpMU8ZsbOQwq3ZXP8K7Zl+oynlNxNOZaXsDlPucnYUT1rlRY0FeqD6+KjXrxYx0mE+ZVvQe4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783145; c=relaxed/simple;
	bh=IPJQkBuJ3IPwLfMtk2vfDWq4Pt4guErObtU5R51oSQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jy6iFynGcHb3SaALl1gQL3mhneT5XtC1B5DSZzRiTMAMPbpq22qwAZ9COxzNL86uJhWmEsnqBqt3Z6sasG8WhQswePgWcixiOLgvIrMC+5FYfKzfmh6jX/W0FfL+ZgmSXHKkcb+T3WPxPpwdivjpuU3EZsxMHQZualrpiE8qjYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLjOq2CS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLjOq2CS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13BB1F00893;
	Wed, 30 Sep 2026 15:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783140;
	bh=oxm9T8uP9WaWMRs6kW6dVyGMujUe1UlKDQ42lyUIqK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLjOq2CS3ovuPC+VxdWdLtKtzGGqm4Hia0Bcaycc6MPc72FeOSFKH7T7Tb2/QQVtB
	 xuYJBUBzqi/a/Jd/w+d5daNc2Cjtjaw04OXRK/1+cFNMyVDGav1VW3Y2Cd8hE2CXQO
	 p8vsjD3kjwkMomonIqUgFe2CkoNhRd3Au09QwMsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 293/595] ufs: validate cylinder group metadata before caching it
Date: Wed, 30 Sep 2026 17:23:06 +0200
Message-ID: <20260930152353.997994711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit c9d263be26806d388129fab8c6904bed197fc6af upstream.

ufs_read_cylinder() copies the cylinder group index and the rotor
positions straight from the on-disk group and caches them without any
check:

	ucpi->c_cgx    = fs32_to_cpu(sb, ucg->cg_cgx);
	ucpi->c_rotor  = fs32_to_cpu(sb, ucg->cg_rotor);
	ucpi->c_frotor = fs32_to_cpu(sb, ucg->cg_frotor);
	ucpi->c_irotor = fs32_to_cpu(sb, ucg->cg_irotor);

They are then used as indices during allocation and free:

  - c_cgx indexes the cylinder summary array as
    UFS_SB(sb)->fs_cs(ucpi->c_cgx), so a value past s_ncg writes a 32
    bit count outside the s_csp allocation.

  - c_frotor becomes a bitmap scan start, start = c_frotor >> 3, and
    then length = ((s_fpg + 7) >> 3) - start. A start beyond the block
    bitmap wraps the unsigned length to a huge value, so ubh_scanc()
    walks far past the cylinder group buffers. c_irotor drives the
    inode bitmap the same way.

A crafted image can set any of these freely, turning an ordinary
allocation into an out of bounds access.

Reject a cylinder group whose recorded index does not match the group
being read, or whose rotors fall outside the group, before the metadata
is cached. Valid filesystems keep cg_cgx equal to the group number and
the rotors within the group, so only malformed images are rejected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260801071306.59484-3-ali@iusegentoo.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ufs/cylinder.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/ufs/cylinder.c
+++ b/fs/ufs/cylinder.c
@@ -66,6 +66,16 @@ static void ufs_read_cylinder (struct su
 	ucpi->c_clustersumoff = fs32_to_cpu(sb, ucg->cg_u.cg_44.cg_clustersumoff);
 	ucpi->c_clusteroff = fs32_to_cpu(sb, ucg->cg_u.cg_44.cg_clusteroff);
 	ucpi->c_nclusterblks = fs32_to_cpu(sb, ucg->cg_u.cg_44.cg_nclusterblks);
+
+	/* these on-disk values become array and bitmap indices */
+	if (ucpi->c_cgx != cgno ||
+	    ucpi->c_rotor >= uspi->s_fpg ||
+	    ucpi->c_frotor >= uspi->s_fpg ||
+	    ucpi->c_irotor >= uspi->s_ipg) {
+		ufs_error(sb, __func__,
+			  "inconsistent metadata in cylinder group %u\n", cgno);
+		goto failed;
+	}
 	UFSD("EXIT\n");
 	return;	
 	


