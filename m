Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BCE42DFEC;
	Tue, 21 Jul 2026 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673059; cv=none; b=qwbjHiG+RBrmQWgTqcf02R8ZJMXJikIERRBJb6e/Ug7j/mUh3ULJZy30p1gOfixhiYZ/BqFRasjMk6slas/u3QJw35I0KJx0gWu1GZ7jeE48F+Qhnvo6TZZArU0beJyzAvO62ec9u1VK3+AiRHzudqn3EXQfD2+P++WMcBQaEVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673059; c=relaxed/simple;
	bh=NxMBeA549eXvQhkw964Kwd8qn1ojp2w8mhKb8OvSTI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlZPX2bhkIBsIKsFR6J4AQM3wom4fiAYtaJUFeukjnK9nfjbmKs0LZDRGVtZ4/FVBICaguckTYabnQJychZMfB6F+X/AkZ1vmJpAELG+YFc+e5nKnHjccV5qe3GAw+frzVtH9wllKNpsgj/IIPSxK8C3T3uoRB/VVXJc6xZ6CUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=az0+RL6E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="az0+RL6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DC71F000E9;
	Tue, 21 Jul 2026 22:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673057;
	bh=lTJDi7KzPAS1nmqdxauVk+/hnwwrJr4BmsZinej6LJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=az0+RL6E7WtMYOd3UKgWOYCA6h0037TPK4Mj6LiSVvpM/1hzEQWl/U5CkYFzShQDX
	 CaSJMlli6sC0gcqupe8DydlH17PBSj6yuHWgqhWTVhDO0dyKG7dQC9sPpdryXqquz+
	 y3I3KWSESmuZDh2ntk9wyDr6//hAGNd76xIhAo7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/699] f2fs: validate orphan inode entry count
Date: Tue, 21 Jul 2026 17:16:19 +0200
Message-ID: <20260721152356.148102963@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 846c499a65816d13f1186e3090e825e8bb8bcb8b ]

f2fs_recover_orphan_inodes() trusts the orphan block entry_count when
replaying orphan inodes from the checkpoint pack. A corrupted entry_count
larger than F2FS_ORPHANS_PER_BLOCK makes the recovery loop read past the
ino[] array and interpret footer or following data as inode numbers.

On a crafted image, mounting an unpatched kernel can drive orphan recovery
into f2fs_bug_on() and panic the kernel. Validate entry_count before
consuming entries so corrupted checkpoint data fails the mount with
-EFSCORRUPTED and requests fsck instead.

Set ERROR_INCONSISTENT_ORPHAN as well, so the corruption reason can be
recorded in the superblock s_errors[] field. This gives fsck a persistent
hint even though mount-time orphan recovery failure may leave no chance to
persist SBI_NEED_FSCK through a checkpoint.

Cc: stable@kernel.org
Fixes: 127e670abfa7 ("f2fs: add checkpoint operations")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Folio API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -723,6 +723,7 @@ int f2fs_recover_orphan_inodes(struct f2
 	for (i = 0; i < orphan_blocks; i++) {
 		struct page *page;
 		struct f2fs_orphan_block *orphan_blk;
+		unsigned int entry_count;
 
 		page = f2fs_get_meta_page(sbi, start_blk + i);
 		if (IS_ERR(page)) {
@@ -731,7 +732,17 @@ int f2fs_recover_orphan_inodes(struct f2
 		}
 
 		orphan_blk = (struct f2fs_orphan_block *)page_address(page);
-		for (j = 0; j < le32_to_cpu(orphan_blk->entry_count); j++) {
+		entry_count = le32_to_cpu(orphan_blk->entry_count);
+		if (entry_count > F2FS_ORPHANS_PER_BLOCK) {
+			f2fs_err(sbi, "invalid orphan inode entry count %u",
+				 entry_count);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			err = -EFSCORRUPTED;
+			f2fs_put_page(page, 1);
+			goto out;
+		}
+
+		for (j = 0; j < entry_count; j++) {
 			nid_t ino = le32_to_cpu(orphan_blk->ino[j]);
 			err = recover_orphan_inode(sbi, ino);
 			if (err) {


