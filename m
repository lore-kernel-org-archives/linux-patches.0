Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7C33BBF2;
	Mon, 14 Oct 2024 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917903; cv=none; b=CkG1+GSxF+uEqdbqC5Z8QYQc7Hq95Umt7KZ5mPKh03ZAsKcqArbMYFjgA2E8Dl2vNP6V1DG550nFbtZSYaqQEvBLrHZTaYAJR22bZNDf0EpDzWylzPcd9ZDhnogXF1NsbWCnv13C7vi1ZSDK1aXtxCLccg8aT/Gt7FzA3Hfbvig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917903; c=relaxed/simple;
	bh=LMPLDxH2OJ7PfxpdNICs4HDB2sJaKrb/38RMUw0BYH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vq6uclvoSM1SeII0D6wshyQmVqj6HTO+Y+tjTnFTi78anD49ATkIGSjWaOOMeWBSybz4BqJAZj7uDwbbRtEQ2z3fagbc5UvfREeS0kBEUFNM7/hbzcq7ZZ8b4ra/ANYjgnZ1eiwA2sqxGp5oWWkgK/RbGmV2hM48pAAAiTlPftg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwK5VJEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwK5VJEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F374C4CEC3;
	Mon, 14 Oct 2024 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917902;
	bh=LMPLDxH2OJ7PfxpdNICs4HDB2sJaKrb/38RMUw0BYH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwK5VJEfPzuWOU3nWXTP527h7cR623TjOjVOeoDepvhRpspFWKCpEPH5/b1beBp1n
	 AhCv2MJK2WG8XEQrXMz2YfacKlUnjjvZC1NNPtZyASPXYIXq/67HTIJ8Mb3a/+kiSK
	 E+oahKSBHEZ5Vo7uI2fzcT8prjHrNfrRAllYdOro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/798] ext4: avoid negative min_clusters in find_group_orlov()
Date: Mon, 14 Oct 2024 16:12:02 +0200
Message-ID: <20241014141224.528225196@linuxfoundation.org>
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
index 99e8852c4e1dd..8a8d802275608 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -514,6 +514,8 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	if (min_inodes < 1)
 		min_inodes = 1;
 	min_clusters = avefreec - EXT4_CLUSTERS_PER_GROUP(sb)*flex_size / 4;
+	if (min_clusters < 0)
+		min_clusters = 0;
 
 	/*
 	 * Start looking in the flex group where we last allocated an
-- 
2.43.0



