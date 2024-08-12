Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A7B183CA6;
	Mon, 12 Aug 2024 16:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478912; cv=none; b=iqiQejAs8meBmQMa9VJib+LXwC5hpY6wQBhpOxJRjQJbEt2Nt+Kz8y3XznlNftW+AUKoGyjR4TYpV9Aw2rYNaeRYNEG3HdA6OQvW170BvwD+ozG5Ez49YLeWDgVFYB9jboks8qgIY1W2O87o3E2EN6F2XvrHh43TrBqpWDhBhRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478912; c=relaxed/simple;
	bh=2jGCqExZG6ovB+Y9gZrsi41G80n2DYmhAJS4qltJ6tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTyIlYZHTRS/lIWC2OpIzDHchiHqZWbnZWhF/f0kqPTimtAAzFJ+NnOWiz4uWg7nUIs7tmj5xT07V4d6DROfc88CNe1AcxEFjvndQ3NDK08RsNej+RzUICvm3R3V1RON7xDQ1oxSZLvHTg8EeiHXi2pn5s1gFbop9QBJpzUU680=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+f5DhLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+f5DhLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6218AC4AF09;
	Mon, 12 Aug 2024 16:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478911;
	bh=2jGCqExZG6ovB+Y9gZrsi41G80n2DYmhAJS4qltJ6tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+f5DhLNa8tN4uwWjd6IGXIA4jdMDInOLSci3iKxEM26HvgpHpJP/u1a15RuxRaVB
	 0LuPAXeBAOsVcMjV6o75UPYOzKDch01sOJU5wiN/JXP4S6Y2W9expH6W5nZTKc7uOS
	 y+LOdgHS4CGqDlJbDxbdeB50cT46crqF1GOXmfY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/150] ext4: fix wrong unit use in ext4_mb_find_by_goal
Date: Mon, 12 Aug 2024 18:02:18 +0200
Message-ID: <20240812160127.374364419@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

[ Upstream commit 99c515e3a860576ba90c11acbc1d6488dfca6463 ]

We need start in block unit while fe_start is in cluster unit. Use
ext4_grp_offs_to_block helper to convert fe_start to get start in
block unit.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-4-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 71ce3ed5ab6ba..004ad321a45d6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2226,8 +2226,7 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 	if (max >= ac->ac_g_ex.fe_len && ac->ac_g_ex.fe_len == sbi->s_stripe) {
 		ext4_fsblk_t start;
 
-		start = ext4_group_first_block_no(ac->ac_sb, e4b->bd_group) +
-			ex.fe_start;
+		start = ext4_grp_offs_to_block(ac->ac_sb, &ex);
 		/* use do_div to get remainder (would be 64-bit modulo) */
 		if (do_div(start, sbi->s_stripe) == 0) {
 			ac->ac_found++;
-- 
2.43.0



