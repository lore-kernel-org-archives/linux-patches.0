Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5301D016B;
	Wed,  2 Oct 2024 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876048; cv=none; b=EljvNEUhYOodwAM6DYqyxHWD1LxeznwCEz2yGPBlzcpQB9E3OXldV9/7380QRidV4imd18jumYVVVSO7umtvCyg/MsMu/MSQr3Jiqoxi6cLuX8e5dHbO4sTGD4HwiOwNIDtLdd4XXsWg3ua2ykL3S7MPjo64O5fa4mloblFfxf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876048; c=relaxed/simple;
	bh=EpWsX0nwFawm41D4jQC7nNiwIvOSnpQk/912kP8OkHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3d5ayvoHmT6DlPYUsBqvFcz87bIFxmluZNHTzMjuP3OLS89Hn5UNIfuDMxZ3ohLDp9RoPyvEYntXkskTWefOMzYwve17e3t2zRX3eiaMNLdd+j8d/5lFCjEu7ubTjK8iSVsq2MDauyJc+MCMUOhfGqNyKAcuiETSwXupEUqQak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCFfyXxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCFfyXxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8227DC4CEC5;
	Wed,  2 Oct 2024 13:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876047;
	bh=EpWsX0nwFawm41D4jQC7nNiwIvOSnpQk/912kP8OkHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCFfyXxogLaUrC9eEEXMaDWn/oG8+EwFqJJxdKX037/jGsD/3ysUFZw6Ak479KGTr
	 dOpLJL0YTt5A+K47gPMtiZBTHPVArDLPDEASNnepvXU9Uyhkp8E6+PC+s6XwtqDLZP
	 vHHEezHjNzAtIUjk7GWo4fq3ZoPwMCx02Co9emL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 310/695] ext4: avoid negative min_clusters in find_group_orlov()
Date: Wed,  2 Oct 2024 14:55:08 +0200
Message-ID: <20241002125834.823793660@linuxfoundation.org>
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
index 9e2c08a8665f2..81641be38c0e8 100644
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



