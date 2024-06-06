Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336AB1C230B;
	Thu,  6 Jun 2024 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683645; cv=none; b=ayxzPLsU+1T2k0ZrmjWJ4zYu06RbodaOVx26xdrXxs0u6VDvBAPjZBdYXAgxyH2fw2ZY48mkU0e0CXsLMC+xRrkIQ7Eugj/5vAOCtaA+ne3U8I9yD68Qyks4qHFBuNZOy4B2BsErwqi9ZrRRQYi4hvqpw2AWqTyUzplf8R5MM4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683645; c=relaxed/simple;
	bh=Rm9z06xz1WunTVJ8iiIJBJL4/LDQKFHVo/++s49w3x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=US0HTEQTuwqYZrYj9UtpFamyy2UT/kV9qgKFqN6gEWaaN831WRozp35f9BtxnUObSU0W558EE+6aJjQ/xavRk//KEuuPo4yYQQ90jwHY6Gyarg9lTxQ5MubH8RZM5kTnpkxRbvALRc6VMDqA7NPMc29yFbeH2CGuQUkKUsNZWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6ZBVISp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6ZBVISp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E807C2BD10;
	Thu,  6 Jun 2024 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683645;
	bh=Rm9z06xz1WunTVJ8iiIJBJL4/LDQKFHVo/++s49w3x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6ZBVISphGYWn16YTfqTS8Uq082UYuetr4iW9OtT+n2p5N5tlFJYTJFKMPGvr84bm
	 zv2da8MrViwJ0oJeSQ+KkXBOlPNorttJE/O1/4PpIO/cGREIrdBCgiSfOc8l+huFui
	 DiBt6WHn2Iiyr7B20OonHunyDgqKt/+wBMvM/ShU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 516/744] f2fs: compress: fix to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock
Date: Thu,  6 Jun 2024 16:03:08 +0200
Message-ID: <20240606131748.992975076@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0a4ed2d97cb6d044196cc3e726b6699222b41019 ]

It needs to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock
to avoid racing with checkpoint, otherwise, filesystem metadata including
blkaddr in dnode, inode fields and .total_valid_block_count may be
corrupted after SPO case.

Fixes: ef8d563f184e ("f2fs: introduce F2FS_IOC_RELEASE_COMPRESS_BLOCKS")
Fixes: c75488fb4d82 ("f2fs: introduce F2FS_IOC_RESERVE_COMPRESS_BLOCKS")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index fdd9825e57483..ac592059c68be 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3547,9 +3547,12 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 		struct dnode_of_data dn;
 		pgoff_t end_offset, count;
 
+		f2fs_lock_op(sbi);
+
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		ret = f2fs_get_dnode_of_data(&dn, page_idx, LOOKUP_NODE);
 		if (ret) {
+			f2fs_unlock_op(sbi);
 			if (ret == -ENOENT) {
 				page_idx = f2fs_get_next_page_offset(&dn,
 								page_idx);
@@ -3567,6 +3570,8 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 
 		f2fs_put_dnode(&dn);
 
+		f2fs_unlock_op(sbi);
+
 		if (ret < 0)
 			break;
 
@@ -3719,9 +3724,12 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 		struct dnode_of_data dn;
 		pgoff_t end_offset, count;
 
+		f2fs_lock_op(sbi);
+
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		ret = f2fs_get_dnode_of_data(&dn, page_idx, LOOKUP_NODE);
 		if (ret) {
+			f2fs_unlock_op(sbi);
 			if (ret == -ENOENT) {
 				page_idx = f2fs_get_next_page_offset(&dn,
 								page_idx);
@@ -3739,6 +3747,8 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 
 		f2fs_put_dnode(&dn);
 
+		f2fs_unlock_op(sbi);
+
 		if (ret < 0)
 			break;
 
-- 
2.43.0



