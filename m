Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E77E1D049A;
	Wed,  2 Oct 2024 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876042; cv=none; b=mhGCXwuOfg1fEOXqB+v/A2zxgMz8UjvIuSZsj8Cb6nCBlrHburZMeoUc8Y7joi45CjapR2jfFyeB4lCwLOPuxD2b0g0+vaUneTVvxWYS6Ocxm8BR7X+Jlfa1F4OFEoVh+R1FeDYtGo1HQlhubjIbM9S/9FX4I4+EPSoI0PzVKL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876042; c=relaxed/simple;
	bh=QCiKu3emtmb8XjYaRTM4fDtY2Qlm28CzwXzIDTDGluo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzoDCCxYfPwFAq1K3Vl6J+TeUlXL1ZrhR7WrDLy4zHtc8+V4J12nYGm4xeTMGOkIglawbQ0O6lFo39ogZeBzHZPCsVEhy1CSHCmAbRXBXOTBxFqfPmYR0sehAd949cVVqa07bh2SS9rmGqkuv53aCueYokvXmYlInOLY3j1KogI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+dZuiYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+dZuiYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B4AC4CEC5;
	Wed,  2 Oct 2024 13:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876042;
	bh=QCiKu3emtmb8XjYaRTM4fDtY2Qlm28CzwXzIDTDGluo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+dZuiYW2ZjvYUfaWjMAdfqeuAz1jMFyhoiLep8wpEfuyo5i0/slG3NrJsrzAofdu
	 eWrC0JxPQB4Oqah7KasnmnlUFJQjANzRQgnmLER+PZcoKQRZpplY/fanUPeLDcx7Zk
	 qy/0gIyxK+Tq9A21rpQ+tWJ9a1dO6zWoJdVjQp+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 308/695] ext4: avoid buffer_head leak in ext4_mark_inode_used()
Date: Wed,  2 Oct 2024 14:55:06 +0200
Message-ID: <20241002125834.734668606@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9dfd768ed9f8d..ad7f13976dc60 100644
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



