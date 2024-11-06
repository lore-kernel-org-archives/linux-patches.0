Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFDF646;
	Wed,  6 Nov 2024 13:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898026; cv=none; b=lLHCIu5aicCi9MhQQP/9VE4YfEJHOzCRuEPHeY8Dk6SjoIZ5KTZ9bEc7g3SkhuM7o4M6vowoYsmrMpfEtZ342Oql2Ksn3mVYa+OVtQiHIIsrCJrSjbxeMp2T5CPfiTTRzhavB/aJDRnfEJ3mOh3tzsnqHi0IQ5A9PqS5UczoZa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898026; c=relaxed/simple;
	bh=izLJgiYWsUkDBuWGARK4eHYdGxYNFXNXCEXmzh50eKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuZXxWPIArmGDsAVJm05wHG4el/EadAlAsxImFSnQrZN5s+IMHmSwQ3DhZoDuX421dTUdRKqX0ymUDJ1s1qdPMduqEkbFuM9Uobf6/DfFrCOHdqt88Aa8vUTb0GqkjxXEuMVUKGFJ1eAitE0maGm3yI5GzOPT+txxpc0P1sok/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wh/tS9Er; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wh/tS9Er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520C9C4CECD;
	Wed,  6 Nov 2024 13:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898026;
	bh=izLJgiYWsUkDBuWGARK4eHYdGxYNFXNXCEXmzh50eKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wh/tS9ErB5WqtzExNk97qNf8rVBKU3Q2UW/sJyklVx/kF8yIDpmK3+ucMH4OAUkTA
	 lcXVGaLkCLhydHng2G75N4TWA9IpKrLYmNmS8nFaBz9nNaYRyK0fL7dHO1u/tQCY76
	 X+xZp2BFzK6gYnisS/t6PXnmEnFgvUZ2WVQtxuPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/462] ext4: avoid negative min_clusters in find_group_orlov()
Date: Wed,  6 Nov 2024 12:59:51 +0100
Message-ID: <20241106120333.929483077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index cbde5a096c7bf..48e4406fd59a3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -505,6 +505,8 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	if (min_inodes < 1)
 		min_inodes = 1;
 	min_clusters = avefreec - EXT4_CLUSTERS_PER_GROUP(sb)*flex_size / 4;
+	if (min_clusters < 0)
+		min_clusters = 0;
 
 	/*
 	 * Start looking in the flex group where we last allocated an
-- 
2.43.0



