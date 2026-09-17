Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5EF4DEC1D;
	Thu, 17 Sep 2026 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666564; cv=none; b=CUO20ivYwkvr+mSD/Up7PBMoBlYqF4k/exmwPRa7CFBj1vZawSRV1IVjiYWUOj+xh6SbGaVcx7zHlkK4E/7bWQuNRMlir+kJy/W/WpTTcpZEZGLObKc0blcbbQEpfTKUDZVZasoKN0zgtp7kaGlYP9UBRCb1b9GmtTcjfo2yFHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666564; c=relaxed/simple;
	bh=f6tSjzRuPZUZ1FY8VJCK8kDw1LmWYsk/NvqCxLdeZkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHw+BIMTwFR32zayS7u+ZD0pK2Sp0JwjfHE5Dgwk5NN/Jwe/yl/COB5KEeZn3Fjn+RYDL2f6+qQbXSb9I/gX5jOPG6FbupW5Sn+yUdxyrFNPWu5YzlL3nBqEONueHzLTK/bSF/5aSSbXzU6LyNRj+F1hGkWfmDvpyUScREH7D0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9AROwHw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9AROwHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752381F000FF;
	Thu, 17 Sep 2026 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666562;
	bh=nhKG3A/FHIfd57ZzH7A6/f9R7ColNuLv8oIsmO+a6J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p9AROwHw1Ti1gnvUfeF16pOiFvIdP5KmW9zGqOMK3FHwWu3+WJGoE5Jwysf0VxDnI
	 lKXv1GqOWEdO9meNhJByVxF2GYqZU1iV9wpKGCd0E6wBFOr5JpcJx51W5JDJA6NXLt
	 kyaSVYZR4Uf3bWPqQqQr2mHtPsRRHlxAkTX06I7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 1080/1250] smb: client: pin DFS superblock in iterator callback
Date: Thu, 17 Sep 2026 16:14:35 +0100
Message-ID: <20260917151621.419866247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit d806d5a85dcbe2a0f181b2f0f9f61ddfbefa1818 upstream.

tcon_super_cb() stores a raw superblock pointer, but __cifs_get_super()
takes its active reference only after iterate_supers_type() has dropped
s_umount and its passive reference. Concurrent DFS automount expiry can
therefore free the superblock before cifs_sb_active() uses it.

A deterministic KASAN test reproduces the race as:

  BUG: KASAN: slab-use-after-free in cifs_sb_active+0x77/0x80

The same test passes with this change applied.

Take the active reference in the callback while iterate_supers_type()
still holds s_umount shared. cifs_put_tcp_super() remains the matching
release.

Fixes: bacd704a95ad ("cifs: handle prefix paths in reconnect")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1210,8 +1210,14 @@ static void tcon_super_cb(struct super_b
 	     t1->ses->dfs_root_ses == t2->ses->dfs_root_ses) &&
 	    t1->ses->server == t2->ses->server &&
 	    t2->origin_fullpath &&
-	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath))
+	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath)) {
+		/*
+		 * Take the active reference while iterate_supers_type() still
+		 * holds s_umount shared.
+		 */
+		cifs_sb_active(sb);
 		sd->sb = sb;
+	}
 	spin_unlock(&t2->tc_lock);
 }
 
@@ -1228,15 +1234,8 @@ static struct super_block *__cifs_get_su
 
 	for (; *fs_type; fs_type++) {
 		iterate_supers_type(*fs_type, f, &sd);
-		if (sd.sb) {
-			/*
-			 * Grab an active reference in order to prevent automounts (DFS links)
-			 * of expiring and then freeing up our cifs superblock pointer while
-			 * we're doing failover.
-			 */
-			cifs_sb_active(sd.sb);
+		if (sd.sb)
 			return sd.sb;
-		}
 	}
 	pr_warn_once("%s: could not find dfs superblock\n", __func__);
 	return ERR_PTR(-EINVAL);


