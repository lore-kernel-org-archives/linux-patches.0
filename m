Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C333D994;
	Wed,  2 Oct 2024 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879755; cv=none; b=mYMQFX9X4sqH4ayn9s/pdBBrZlpJ1PCJGsvdp3dtONqauWsxXGUgKrqLLnUyJf9LDBe9f0XWLgSmT0aIagnuN6NwPd/sHZUj5bgsSIxoYPVrn3QytH42PBrcHFS7hgWk3m2P2dxAyMPL226owJhgRWdQk4oWli1sB8LqP6Gj6lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879755; c=relaxed/simple;
	bh=CFXQrmo9wqZkRClh7ypt6OyyK4cEGm46R2D+ljVxDcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQoCxWTeI23/2dxexK8b8xhsgUoxP2xVkEE/TyheGESZ8Y/1bERMifaMxKNmRQL9uQarG9K0HR511lUn9ZBdHOcNezjC+rXnRMn2y/yirOeUCNsUnpMbjoYUiZ75/h1uvTPmD+OCZjk7VIKttZYZjRLDi2o95pixbtY3WajyLbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BePWNvYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BePWNvYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0874C4CEC2;
	Wed,  2 Oct 2024 14:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879755;
	bh=CFXQrmo9wqZkRClh7ypt6OyyK4cEGm46R2D+ljVxDcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BePWNvYeftvB9VqNVBMP3myuCjlmLAK9gSE4RwkysmnEZNJ4CpwpKyKMEZanZCtP5
	 YgRQy+jQhsfi1pUo/w2K3C4347A49SjTD9KgwLdMCJQtw3MMjuGKmfPQsFaLr7SWgT
	 hctGesC9T8iEJZsvho2U4kqDfCqDbYR5PblgHVCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/538] ext4: avoid buffer_head leak in ext4_mark_inode_used()
Date: Wed,  2 Oct 2024 14:57:45 +0200
Message-ID: <20241002125801.173886309@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index b65058d972f95..b4699a415c210 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -755,10 +755,10 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
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



