Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D4363D5;
	Thu, 15 Aug 2024 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732243; cv=none; b=uyYaRTcwMwDchDn8JMEnSH09eNLuOcFIo8lbQns1JkGPVUvYkUQbJVLcJFOtGOSPjxlWBIlomveaEMUiEWGUeGVSLN+x+kS77WcdbcBfruQziL6rBoFCvzmnzJOVJlQCqmDy927BpmaiUvpqKhEh/1T+6epRZNCO98/3iGwu5NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732243; c=relaxed/simple;
	bh=EM7ku2TAfeoXs5IZMf2EkZ0ozEgfAoOgqylguXup5bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xahx7CHLZezgqpmQjd2Mn8mNA8q5Ruh5JpP/wCJGfyp7hCc7AkCeDnkNYWbpiewyDR/3pxhkdaVvZK6lT2/rVHyMj1/xjpl4zLyTYbnOHSD+tOjFgisvOYd9RTqm0k2Rr5nqvA27baw+JyvIJsRE50x2c+Jwn15pzZfyx43q/Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0FwUlpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0FwUlpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B227C4AF0D;
	Thu, 15 Aug 2024 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732242;
	bh=EM7ku2TAfeoXs5IZMf2EkZ0ozEgfAoOgqylguXup5bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0FwUlpAW6WsUbqoFtSzxqFQprRurIwiaTlFihmbWpGCDD8iWXM97FWEVB4DEz1Zw
	 f1IAL9NgegP/UoNdsEyMwvFTaG2b6w3yyWjSJsvWtePGmyxJzJlX9d0HtDEYWHaDlZ
	 FeGB/2s6ff6JJ6Rbbm6Kaa6gUMtTlNYWXhtyjuh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/352] ext4: fix infinite loop when replaying fast_commit
Date: Thu, 15 Aug 2024 15:22:33 +0200
Message-ID: <20240815131922.622890007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

[ Upstream commit 907c3fe532253a6ef4eb9c4d67efb71fab58c706 ]

When doing fast_commit replay an infinite loop may occur due to an
uninitialized extent_status struct.  ext4_ext_determine_insert_hole() does
not detect the replay and calls ext4_es_find_extent_range(), which will
return immediately without initializing the 'es' variable.

Because 'es' contains garbage, an integer overflow may happen causing an
infinite loop in this function, easily reproducible using fstest generic/039.

This commit fixes this issue by unconditionally initializing the structure
in function ext4_es_find_extent_range().

Thanks to Zhang Yi, for figuring out the real problem!

Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20240515082857.32730-1-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index f37e62546745b..be3b3ccbf70b6 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -312,6 +312,8 @@ void ext4_es_find_extent_range(struct inode *inode,
 			       ext4_lblk_t lblk, ext4_lblk_t end,
 			       struct extent_status *es)
 {
+	es->es_lblk = es->es_len = es->es_pblk = 0;
+
 	if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 		return;
 
-- 
2.43.0



