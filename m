Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973AB377039
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301640; cv=none; b=ZDqPKS3rRmp4lSAjZMFEDH7G2VDGm6yx9fXRUa8fVdK82jRISRuwfY4v1LGdOCbMdmfmG0Q4QLzWmEutCVQyhbnZxYMsJKZmlwt3gCXQTCA/L2b8aUF+ScuUrvgdGg0LY1S+T/UCQNJDaYQjUab4yzAC1BOpE04/0qRa+Iofci4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301640; c=relaxed/simple;
	bh=V7JF2DG8Z8xYXqYk5NQVdyXibj1omJz4ZzcSmR5Izbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uazUOc9tcNVf0KVDx6/+xhKOAPghoBh70h/dLbQuwcnZUjcBWz7lFelPTWdx5rLWTltoB8GZwt60lUAqakXqguvijBxEJHZ78b2qbVVJze5J24jRzd6jVmYYwhvcicMg3GiAdanNZ0PKhwFyd9zLNkyINhX8yMOSAzLFQ4qMPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p1X2TjAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p1X2TjAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F23C116D0;
	Sat, 28 Feb 2026 18:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301640;
	bh=V7JF2DG8Z8xYXqYk5NQVdyXibj1omJz4ZzcSmR5Izbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1X2TjAS532xgXt+3sSvMVlK6cDyvvK8c0zOud7MMm+E/LAnNBJlXYLkWDbXFPrOg
	 Auc3cEpOH3XE+rpVfsMNsABBBxBBSmmBfNTkhBGuNxytvSUhs8LiZslcbkDL2+uG6X
	 YsfhYQbZCrsboGjUOKA6TjlQ/2Ig9C37BeO3V+QsAdADWOK8HSXxEzHHyP5q/Ho3kJ
	 QffoT0HYdtjDvjo2fBfGDTppFCmmh4P8ai0QY3JD4lpQg+bdOHegu/ec/0Sq5F1sYh
	 02KRv9Mrvi3Y2zM+CFqMFgCWw092jF720Xuce3QbIu7+7GgoQWgVOOwTDDtLNj25rr
	 xoNSA8quDj8Zw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/385] md/raid10: fix any_working flag handling in raid10_sync_request
Date: Sat, 28 Feb 2026 12:54:16 -0500
Message-ID: <20260228180011.1568201-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 99582edb3f62e8ee6c34512021368f53f9b091f2 ]

In raid10_sync_request(), 'any_working' indicates if any IO will
be submitted. When there's only one In_sync disk with badblocks,
'any_working' might be set to 1 but no IO is submitted. Fix it by
setting 'any_working' after badblock checks.

Link: https://lore.kernel.org/linux-raid/20260105110300.1442509-11-linan666@huaweicloud.com
Fixes: e875ecea266a ("md/raid10 record bad blocks as needed during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a91911a9fc036..db07c99c4d947 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3417,7 +3417,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
-				any_working = 1;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3432,6 +3431,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.51.0

