Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED46753ECF3;
	Wed, 30 Sep 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790083; cv=none; b=CDdIcIqcr4sh3IS4hvmysVglLmz+zMp8RCZb6bXlOhcUQtMfJLDUYZ0a6y5cDr4gyoahbS2v32M4WQacBGMlM03TinjaxOhFRFYSRcyVmL7qF/mZRenvrAP2lyy50C5RdUR3ZmECBHGlugH9RH9SGFvEZ1ljDCn4sd6r7ZMLOBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790083; c=relaxed/simple;
	bh=b/+GwjUYbBRN15ad5Lm3GmqwT//wtMgdMzAz8C6WGxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WrK0Za48RtA3G8yvxCRpW9JoW9aqvA0Ke/H4aJjmahxPEYeHpn7W+zILLNJQj4K1tN6iuT/OMSAE6ptJ/RFt4HrLY+z/hk/tBwkumHJWLTftkpntpag9PNAxIzfhsqrktV5U/V7RJcIDJ7rVWLfhyHlo/UOPOq1XRtdDwvv2JMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWSTQmox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWSTQmox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F131F000FF;
	Wed, 30 Sep 2026 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790081;
	bh=v9MgxOmIeQjeqgLa9NAZos4cnqtbDA4r8kiz0JtALJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWSTQmoxvgNhjg1B3nhbirfzBE2HItC4T66U4pnei/BiBRtx13QO2KiTWKwRdGdIL
	 rRRFamMvU11cUHyO5adEIDNd6Eh7K3wl7tS6WLSwaE5golp0ZLWbZdA7qLElbtcONm
	 tpS88UstovXhpBDIGYD4qPN4dhr1RVV/+vidFeMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 687/877] f2fs: convert F2FS_I_SB to sbi in f2fs_setattr()
Date: Wed, 30 Sep 2026 17:26:38 +0200
Message-ID: <20260930152429.501307709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangzijie <wangzijie1@honor.com>

[ Upstream commit 90c5ce37adf074ed85b26d1cd43074f29c0743ba ]

Introduce sbi in f2fs_setattr() and convert F2FS_I_SB to it. No logic
change, just cleanup and prepare to get CAP_BLKS_PER_SEC(sbi).

Signed-off-by: wangzijie <wangzijie1@honor.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: d0a481fad5c7 ("f2fs: fix to avoid potential section-unaligned pinfile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1064,9 +1064,10 @@ int f2fs_setattr(struct mnt_idmap *idmap
 {
 	struct inode *inode = d_inode(dentry);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int err;
 
-	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
+	if (unlikely(f2fs_cp_error(sbi)))
 		return -EIO;
 
 	err = setattr_prepare(idmap, dentry, attr);
@@ -1105,12 +1106,11 @@ int f2fs_setattr(struct mnt_idmap *idmap
 	}
 	if (i_uid_needs_update(idmap, attr, inode) ||
 	    i_gid_needs_update(idmap, attr, inode)) {
-		f2fs_lock_op(F2FS_I_SB(inode));
+		f2fs_lock_op(sbi);
 		err = dquot_transfer(idmap, inode, attr);
 		if (err) {
-			set_sbi_flag(F2FS_I_SB(inode),
-					SBI_QUOTA_NEED_REPAIR);
-			f2fs_unlock_op(F2FS_I_SB(inode));
+			set_sbi_flag(sbi, SBI_QUOTA_NEED_REPAIR);
+			f2fs_unlock_op(sbi);
 			return err;
 		}
 		/*
@@ -1120,7 +1120,7 @@ int f2fs_setattr(struct mnt_idmap *idmap
 		i_uid_update(idmap, attr, inode);
 		i_gid_update(idmap, attr, inode);
 		f2fs_mark_inode_dirty_sync(inode, true);
-		f2fs_unlock_op(F2FS_I_SB(inode));
+		f2fs_unlock_op(sbi);
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
@@ -1188,7 +1188,7 @@ err_out:
 	f2fs_mark_inode_dirty_sync(inode, true);
 
 	/* inode change will produce dirty node pages flushed by checkpoint */
-	f2fs_balance_fs(F2FS_I_SB(inode), true);
+	f2fs_balance_fs(sbi, true);
 
 	return err;
 }


