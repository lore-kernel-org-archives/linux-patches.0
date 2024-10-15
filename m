Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9171A76DA;
	Tue, 15 Oct 2024 11:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992757; cv=none; b=nENhYxYZSE3C7VdguqzqfBJCV+GbB4yZNWxinA74xM+44toytNM2y5RDIWu+loTquy0fB8PZ18vjzAWZiAcC2R/h7DDT89eKe3e2Y23vLG7EBS05BqbdrcYS/GLp/hz4pOdxkOmHqcyrRePILWYDzTaaas8ZHFiY328U9QiLX9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992757; c=relaxed/simple;
	bh=VI6tCz7wxQXs1OQqROQhZSLOA5iTsiegGuC62C8BJEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQZ/3VjsHzT1U7xmMu9gmm8iw93uogVdck2R/rio/7m8CNXHANFouljr8cTvKWwsYmuSJ5T+CxwoPtmPQLOBZduIgfhWd/Hz9rc5MgviC5/a4Y/uw6AKOCq0bAl4vKSsHuBvBZXlJ1JxtH47sBIoA2nXZ3Y3O4eldIUdvfRx68I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nySW5yZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nySW5yZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13541C4CEC6;
	Tue, 15 Oct 2024 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992757;
	bh=VI6tCz7wxQXs1OQqROQhZSLOA5iTsiegGuC62C8BJEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nySW5yZxkGQ3o2+uOUCVbY3l7E1eGYwNHnIT6obelhL9AVrJOqtqFU4KmErDzrQJB
	 YKOOT7OcFYfYxOk40sLm+H7Pi/QC71dyMRuLe5q9OZ8p2qSlv1LALFgf1JykcG110H
	 Z5UNcDu2coLou9Tfp/Irfp61MyhtlTB8IoL4m66g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/691] ext4: avoid negative min_clusters in find_group_orlov()
Date: Tue, 15 Oct 2024 13:22:35 +0200
Message-ID: <20241015112448.576489487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit bb0a12c3439b10d88412fd3102df5b9a6e3cd6dc ]

min_clusters is signed integer and will be converted to unsigned
integer when compared with unsigned number stats.free_clusters.
If min_clusters is negative, it will be converted to a huge unsigned
value in which case all groups may not meet the actual desired free
clusters.
Set negative min_clusters to 0 to avoid unexpected behavior.

Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Link: https://patch.msgid.link/20240820132234.2759926-4-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ialloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a00c91aa755c4..5841686e80b3a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -515,6 +515,8 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	if (min_inodes < 1)
 		min_inodes = 1;
 	min_clusters = avefreec - EXT4_CLUSTERS_PER_GROUP(sb)*flex_size / 4;
+	if (min_clusters < 0)
+		min_clusters = 0;
 
 	/*
 	 * Start looking in the flex group where we last allocated an
-- 
2.43.0



