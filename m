Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF9F19D069;
	Thu,  6 Jun 2024 14:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683454; cv=none; b=QDyKywCw39iVKNNswek7MOWp11LOZhAKimadZoK6Wiudjp6JODYaAZYyfuetYgW3WEDesf4EtSAMkeIef6U3BeefFGVxq25O73Nrv0VWeip00DCT51RjuJ3/R7Hp7zGuitdn5MVJw3Ht3APGowlt25KNHR60cLfBkV8tgUsFa10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683454; c=relaxed/simple;
	bh=3zYIx55xsZYaKcAe4i3WfxktfQUusNMt763/iGVG3RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TksLNKPIETICj4Qx4M5B7mM85Uwaf0MCZRWBFZ9AThtJ9jAyKN8nc+mmMXmNe+MDqEGME3/2ZOd8LWaPAE5GVXEKSKuH58B09xbepiiHymnoEjQiI81rnWCJ//lYQbN3NU90G9R1lvEpMtZDed4PaeWS896roQIelCI8o2NQRkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cP8uIKOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cP8uIKOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F8AC2BD10;
	Thu,  6 Jun 2024 14:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683454;
	bh=3zYIx55xsZYaKcAe4i3WfxktfQUusNMt763/iGVG3RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cP8uIKOfzSFlibRJV7BGY04RtPzMMJoGGmzs+o5HY4cpwq3BU7vybpHqoiprqH87t
	 rpaXW+EdJoe0x8K8Tf6IEah8oJG4fA6SgIBsCa9MK2h7f7zC7N9ZjheucbT7fDI7qa
	 zwIylN+CPcEk7u3h/E+URa5kmx7hK7XVyrcQ4Cik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/473] f2fs: compress: fix to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock
Date: Thu,  6 Jun 2024 16:04:31 +0200
Message-ID: <20240606131711.219979869@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 69023b8fc67a7..2b0f8408917bb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3515,9 +3515,12 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
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
@@ -3535,6 +3538,8 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 
 		f2fs_put_dnode(&dn);
 
+		f2fs_unlock_op(sbi);
+
 		if (ret < 0)
 			break;
 
@@ -3687,9 +3692,12 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
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
@@ -3707,6 +3715,8 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 
 		f2fs_put_dnode(&dn);
 
+		f2fs_unlock_op(sbi);
+
 		if (ret < 0)
 			break;
 
-- 
2.43.0



