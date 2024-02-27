Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBCC14264A;
	Tue, 27 Feb 2024 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040575; cv=none; b=h/3e0GZ+efx+JcvqwRz6AgWESLzMB/GFuZpNrThLiirlQGdCtMH+26PD+ER0p9DfjHG+T8ft9SrBsIiaR2z4QMf82w3r3MMQFqhsQIJGKZorB+Xcw6hDhbYqTlCpe5egdN93kYkMy0EXgDxFrX8ja2MoGO6M5bVw9H4ADrRYsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040575; c=relaxed/simple;
	bh=HYbVUNNUh57DhTa0jsDIrAWm++TWf1kjSGjIg8dYhbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4N0+d8+j/G5AMxsOdOlTEAaoY+dgCQaZEj088SuUDnZryRIu0RhFvwMq5pYeLjf3VoXeGVotpkX3/5eDFocc5SptJEMWVjBUaj/xtEvjivUjBLFor0ezMFhaYpOMiOqXMpxTy3bjIbXI/LXBuTQ7DFp5mJ/+pRTwDHTXQ+5gAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hu/yjbUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hu/yjbUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475B4C43390;
	Tue, 27 Feb 2024 13:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040575;
	bh=HYbVUNNUh57DhTa0jsDIrAWm++TWf1kjSGjIg8dYhbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hu/yjbUsFyZYE3saA7zyMBwQHVfJWzKvOh6ZQWDQuSjAFz823/pEGzrK+s/98qddR
	 8dqd0+UuDKWGwaUzG05T0pd37OMKGmJqLeED76WUvmOZvjIebCEjmfxrxOSXlOsxvt
	 2icVlwG9ykMAck5L/MpfEPf+Guz6ZF0JTDfsiWvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 034/334] ext4: avoid dividing by 0 in mb_update_avg_fragment_size() when block bitmap corrupt
Date: Tue, 27 Feb 2024 14:18:12 +0100
Message-ID: <20240227131631.695709267@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 993bf0f4c393b3667830918f9247438a8f6fdb5b ]

Determine if bb_fragments is 0 instead of determining bb_free to eliminate
the risk of dividing by zero when the block bitmap is corrupted.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-6-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index be63744c95d3b..528d15630a94f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -842,7 +842,7 @@ mb_update_avg_fragment_size(struct super_block *sb, struct ext4_group_info *grp)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	int new_order;
 
-	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_free == 0)
+	if (!test_opt2(sb, MB_OPTIMIZE_SCAN) || grp->bb_fragments == 0)
 		return;
 
 	new_order = mb_avg_fragment_size_order(sb,
-- 
2.43.0



