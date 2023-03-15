Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3824431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9515C4339B;
	Wed, 15 Mar 2023 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883127;
	bh=Edrase2a+V9ntO5dtbFDUhndC+P8208cBlG9RBWJynE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koQnfU+16NdbcX3S3O0InsEctgWua9xe5UMcLREfGJRtLTgSFbfnMsrRCOD/koOon
	 kPRQ58gQ6fijMxmPhc4Unaqa37rpGyV483Xmnh6WK9ET2bvFY+cqoAs8Cf6giEVFEp
	 WjEC5VqDdfWk/c+5AvASSIMRXhdojfmfRJ9st/i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/145] f2fs: avoid down_write on nat_tree_lock during checkpoint
Date: Wed, 15 Mar 2023 13:11:31 +0100
Message-Id: <20230315115739.868011504@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 0df035c7208c5e3e2ae7685548353ae536a19015 ]

Let's cache nat entry if there's no lock contention only.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 3aa51c61cb4a ("f2fs: retry to update the inode page given data corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f810c6bbeff02..7f00f3004a665 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -430,6 +430,10 @@ static void cache_nat_entry(struct f2fs_sb_info *sbi, nid_t nid,
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct nat_entry *new, *e;
 
+	/* Let's mitigate lock contention of nat_tree_lock during checkpoint */
+	if (rwsem_is_locked(&sbi->cp_global_sem))
+		return;
+
 	new = __alloc_nat_entry(sbi, nid, false);
 	if (!new)
 		return;
-- 
2.39.2



