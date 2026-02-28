Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AF1301EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301407; cv=none; b=TvtaXjMEpFRU8cbbC2XwyBZY+HsirVbUxD0+rEghDqzDE3glHfgnhRl9plKR8xugIDHwhJZEDumu2ePN31w5LgY1P2P6Gd5ds0MeBecoPSmfnFax36+vGicD52KMIUX7t0HDV7ZwN4hPauQGyo07mpsx2TDbiv+ULiObx5QXKts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301407; c=relaxed/simple;
	bh=fp1s/Q7tHaLyjsrulurs6UUQlDGA8a88fPiCQOYui7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvgVgAAGuZ+TEjR0AE1ezr3RK/IwphAwvLu0Q2IMfn4QOPkIN9Laof5FYjd58FQNuI6ltwwXNg4Qgf1PXHjJVkP5qq6wMuwx4+gl6gGhxYV7R9mIVP2NcGU9aHg/0MYSE2jTPFeIYTT/scBA75xPdFIalW2sld/S1Gv5Bo5l4xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jX5clrAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jX5clrAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCD6C19423;
	Sat, 28 Feb 2026 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301407;
	bh=fp1s/Q7tHaLyjsrulurs6UUQlDGA8a88fPiCQOYui7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jX5clrAxdXYqFYAPY27wrE9bGI8YevqFbWBpZZ5Lf4ZRxe4UPwgZSMUUbyrYcDzd8
	 XVeDNztvj1oFms5gZVjMRfPiK6ooaeh8TRHFaUgMXk2roO3IWUVQPz0nEJKxGrq/91
	 NLQO/yokFzOS628YCLlR47iMtQSj0XHfs1qfZea8gMRwqtHA6DJwnYcntBD0wDqAxG
	 V9q3pEJhadHO5xJGvMl/xHkbrK4q1tHFvPddNX2R6Bo+grkyPGGa4qK4CfmrcjclQt
	 0HbVsa1b6v/grsgoUHNBoKJpjg3IZdYIm4xePoaLe5bVaElvlZDBL11danblLpKDZ9
	 NKn81opEgwrug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>,
	stable@kernel.org,
	Hongbo Li <lihongbo22@huawei.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 596/752] erofs: fix incorrect early exits for invalid metabox-enabled images
Date: Sat, 28 Feb 2026 12:45:07 -0500
Message-ID: <20260228174750.1542406-596-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 643575d5a4f24b23b0c54aa20aa74a4abed8ff5e ]

Crafted EROFS images with metadata compression enabled can trigger
incorrect early returns, leading to folio reference leaks.

However, this does not cause system crashes or other severe issues.

Fixes: 414091322c63 ("erofs: implement metadata compression")
Cc: stable@kernel.org
Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 5136cda5972a9..b54083128e0f4 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -330,12 +330,13 @@ static int erofs_read_superblock(struct super_block *sb)
 	}
 	sbi->packed_nid = le64_to_cpu(dsb->packed_nid);
 	if (erofs_sb_has_metabox(sbi)) {
+		ret = -EFSCORRUPTED;
 		if (sbi->sb_size <= offsetof(struct erofs_super_block,
 					     metabox_nid))
-			return -EFSCORRUPTED;
+			goto out;
 		sbi->metabox_nid = le64_to_cpu(dsb->metabox_nid);
 		if (sbi->metabox_nid & BIT_ULL(EROFS_DIRENT_NID_METABOX_BIT))
-			return -EFSCORRUPTED;	/* self-loop detection */
+			goto out;		/* self-loop detection */
 	}
 	sbi->inos = le64_to_cpu(dsb->inos);
 
-- 
2.51.0

