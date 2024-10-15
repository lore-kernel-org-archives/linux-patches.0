Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663061C07CC;
	Tue, 15 Oct 2024 13:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997317; cv=none; b=DmC0NvTQmCcV3egDdZPNqDKOk3FSrl7cFOOv/YFnkoiGJHGKU+IocaLcSkx7ZSnvAbH/8heWm24/LKNUSM0W8qD4Uu073VbAEa15m3/CWOUbpGebn0XOzCrpT/5QcN+jhqqmCRWULBhoDE+zcDj2+LfgKjtdF8xWThGOnjC8Qxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997317; c=relaxed/simple;
	bh=TNfV6C0oxHR4EyMWEz24g+QKRma1T7Kk/JYQsEZMzuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svlrEN7J0aga1ejJHvLin2DTWBuJ0yNbFzDwc3Z9XDhAteodGZ4PaOMl1cNt7E5FuKL42+qgl99bxVLzmiFNfYC6/u+B47VaiPfFT2VsXYnPHnHgILEqPuruOWwiH1w+CcLWhwUcU4f7lKCnC1j2Kfi3IwKIFn4VCx+Qnr9TEYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdQuMSTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdQuMSTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3225C4CEC6;
	Tue, 15 Oct 2024 13:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997317;
	bh=TNfV6C0oxHR4EyMWEz24g+QKRma1T7Kk/JYQsEZMzuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdQuMSTUSslIxGYVEDJPRLy9n4Eko0KhtpFdKRNSN+arkLMnHVUzm/+En1ofFn/Vv
	 bJBq4WHhZxf/Ko8uGce+2cxSD7GAcHYnzTeslQD7VKCXiz5CAJkr4d7gkkY3n28NZV
	 4P4YrlmWjRwRt5zay4OdZOEDZosZe1TQEnPJcRyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/518] ext4: avoid buffer_head leak in ext4_mark_inode_used()
Date: Tue, 15 Oct 2024 14:40:53 +0200
Message-ID: <20241015123922.751611837@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 5e5b2a56c57def1b41efd49596621504d7bcc61c ]

Release inode_bitmap_bh from ext4_read_inode_bitmap() in
ext4_mark_inode_used() to avoid buffer_head leak.
By the way, remove unneeded goto for invalid ino when inode_bitmap_bh
is NULL.

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://patch.msgid.link/20240820132234.2759926-2-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index d178543ca13f1..34def2892b838 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -754,10 +754,10 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	struct ext4_group_desc *gdp;
 	ext4_group_t group;
 	int bit;
-	int err = -EFSCORRUPTED;
+	int err;
 
 	if (ino < EXT4_FIRST_INO(sb) || ino > max_ino)
-		goto out;
+		return -EFSCORRUPTED;
 
 	group = (ino - 1) / EXT4_INODES_PER_GROUP(sb);
 	bit = (ino - 1) % EXT4_INODES_PER_GROUP(sb);
@@ -860,6 +860,7 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	err = ext4_handle_dirty_metadata(NULL, NULL, group_desc_bh);
 	sync_dirty_buffer(group_desc_bh);
 out:
+	brelse(inode_bitmap_bh);
 	return err;
 }
 
-- 
2.43.0



