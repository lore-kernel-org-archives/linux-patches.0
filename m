Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641BB81F;
	Tue,  2 Jul 2024 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940584; cv=none; b=QAURo3iWIK5zMEdi41nazoqgxm9R3ujkI8HAO1fuMbkg26HXHfWViRAeLE/ieloPAqeAeaNksH0d0zGR6GbzixH0Bpj8ALsNH+iBHKW+GhFwITpy/K/UqoAW3MTDrJbv9f2PD0U0A3fpk9aSEDtSkF7zIuSJtU6xRNBkZ7wAhT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940584; c=relaxed/simple;
	bh=gD0FfXZVW5sj2r1fDKCm4BwUpPJXG6OcAzTCSUxNg6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijnvWSM0OExrotxDYhjjA+oJlMlioYr6liHAvUrggvPPtJ5mzoSEBtSwRxtZg+zh//qq5L0j3D0cKCNxGKpN51rL4c2OT3b3+CzKmziVmf0I9uFCZp6P1Zcm+k2DXcjULj/e4Q5UK1lwijr1kCTOirnp9jlPZyfWLLMiYsER50U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6L7uVn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6L7uVn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7898AC116B1;
	Tue,  2 Jul 2024 17:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940583;
	bh=gD0FfXZVW5sj2r1fDKCm4BwUpPJXG6OcAzTCSUxNg6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6L7uVn36QNDcrQME/gTU9MpL4W3QtD7EJRqOhPFZ8zLf+zR+QF7Wj7/YbMTTY3VJ
	 L4YQE+IpyMdH+OkjNE0F4zA6gprUb554/pxPMPG6VDDTZHkBqNfxiu/w7YfxXp7f/2
	 ys/7VijHXVTC5VaDrkOI257Q83vz2d34O/dnpx0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6.9 199/222] bcachefs: Fix setting of downgrade recovery passes/errors
Date: Tue,  2 Jul 2024 19:03:57 +0200
Message-ID: <20240702170251.591232513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kent.overstreet@linux.dev>

commit 247c056bde2ebc9fad2fc62332dc7cc99b58d720 upstream.

bch2_check_version_downgrade() was setting c->sb.version, which
bch2_sb_set_downgrade() expects to be at the previous version; and it
shouldn't even have been set directly because c->sb.version is updated
by write_super().

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/bcachefs/super-io.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -1123,18 +1123,12 @@ bool bch2_check_version_downgrade(struct
 	 * c->sb will be checked before we write the superblock, so update it as
 	 * well:
 	 */
-	if (BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb) > bcachefs_metadata_version_current) {
+	if (BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb) > bcachefs_metadata_version_current)
 		SET_BCH_SB_VERSION_UPGRADE_COMPLETE(c->disk_sb.sb, bcachefs_metadata_version_current);
-		c->sb.version_upgrade_complete = bcachefs_metadata_version_current;
-	}
-	if (c->sb.version > bcachefs_metadata_version_current) {
+	if (c->sb.version > bcachefs_metadata_version_current)
 		c->disk_sb.sb->version = cpu_to_le16(bcachefs_metadata_version_current);
-		c->sb.version = bcachefs_metadata_version_current;
-	}
-	if (c->sb.version_min > bcachefs_metadata_version_current) {
+	if (c->sb.version_min > bcachefs_metadata_version_current)
 		c->disk_sb.sb->version_min = cpu_to_le16(bcachefs_metadata_version_current);
-		c->sb.version_min = bcachefs_metadata_version_current;
-	}
 	c->disk_sb.sb->compat[0] &= cpu_to_le64((1ULL << BCH_COMPAT_NR) - 1);
 	return ret;
 }


