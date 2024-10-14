Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190A83BBF2;
	Mon, 14 Oct 2024 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917896; cv=none; b=hU9/DvSuplh9TwtyyelpWHa39rlF0q84k0yZptl2CDwuvMgBjrcIZBrGi5EoHrEZ1wlD8WA2BYjyxf22AbnBZqn9NeTEPE8IoYHwiZUfLDel1Jj3i0pZeB8CYSRdt6fvTJX4IMTSiHxbAUaQm4aNw1hWfUwE7EkA1ftaih82Zr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917896; c=relaxed/simple;
	bh=0DKItOBCJGZz3BPLzOlThAFOOSPwdkktSg1+UcutrKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7CT3t1SCjrmC+s8sRsAMMZolDlAKlo5OBRctpYndu9GtdXuyexB2FFu1PuDNcFXckNXaV6m+vVqyw+/OSJUMOOiNQcg+9GB+fTMu9olGBtcYDDO8zJV0pHi2e/ByKYdQHJWIA8CqFP1ZmwLYuAEQNu+Dj1VqJVWn5v1pDNCOKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLPSFWjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLPSFWjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70327C4CEC3;
	Mon, 14 Oct 2024 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917895;
	bh=0DKItOBCJGZz3BPLzOlThAFOOSPwdkktSg1+UcutrKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLPSFWjG9wEMXRANdjiTyrWSgeMheEp0yWytm+Q5eXFyrk5uS22/enL8kIYxcBLRZ
	 VY+E3LjBVWMPwAfCE5bxY9l/54e608Sk3hGqqPeIA6+1mrw1tJ062Ktxs8MvWufm7I
	 JwKRi7ekGbQHKJRUcFpxvaimuutJs0XGvrfNNmJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/798] ext4: avoid buffer_head leak in ext4_mark_inode_used()
Date: Mon, 14 Oct 2024 16:12:00 +0200
Message-ID: <20241014141224.449539225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index e09c74927a430..14831c3df0cda 100644
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
@@ -861,6 +861,7 @@ int ext4_mark_inode_used(struct super_block *sb, int ino)
 	err = ext4_handle_dirty_metadata(NULL, NULL, group_desc_bh);
 	sync_dirty_buffer(group_desc_bh);
 out:
+	brelse(inode_bitmap_bh);
 	return err;
 }
 
-- 
2.43.0



