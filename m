Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0F01D07B7;
	Wed,  2 Oct 2024 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878033; cv=none; b=Xf28ufYqw4MQoC/Kw/Cc732mIyqqo87KPV6Dbou0FEY77Op5Ptay6xjFpFNOfxK+4BwXbsNHwg6HripubJ2BT33ApVzJI0IzqQpfC68NLOryD1mxBbW98jy6qjtfkjz9TIBHwUAXD8ASRnqwP1hb8U09M2xmICW5y5JVurMuANA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878033; c=relaxed/simple;
	bh=L9ol85dt6bMOMLVCFIQp0vfYgmTLLp7pQzUvyiluOUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpJLhL3Je8lHagjLbHOknNQGun3lP+tD4rzH2zY0jtkoVfHtls613t70NvZjxLzQeqlbEIdUy0AFGGyA8I7P45jGGBoNIFBzw0iB2f2Dh8efjnUlhfPGW4wj9bRoW2g6lCjBTETrDFyhXuW+pvhGVscncJNcgi13pY3scCG+cXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmahaiKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmahaiKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B668C4CEC2;
	Wed,  2 Oct 2024 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878032;
	bh=L9ol85dt6bMOMLVCFIQp0vfYgmTLLp7pQzUvyiluOUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmahaiKN+rr86eiwLIqu/n2iemNOslPeub4Ra8u7lctA73avgXmCrVRx8o+AxRiId
	 pis+rGqPX9DfPSTK/w3KDFomEaaIDlsU4pLM4uHT9uXGBaN00e8tr79DtRnOpT7f2l
	 Lbsqn0UnHpZup80Nc2UYwd0zQqm/qnjMfm5IgxnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 279/634] ext4: avoid negative min_clusters in find_group_orlov()
Date: Wed,  2 Oct 2024 14:56:19 +0200
Message-ID: <20241002125822.124816539@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index de04f4400d926..5a3b4bc124149 100644
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



