Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC952566F6;
	Tue, 25 Mar 2025 12:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905552; cv=none; b=oI8BaZEgK0RxhJIEDzuY4lrpLYYkooSSCEABSP3SyYrDOJJV58At/voheEwqfwOsKNBN6hQoa6dFF6iP80vyavtrH2KO8g2L2IMQ9lVBw6tQQ0v9qMq828QMTPXdNmMGFmE/G8j3lV4cSvI50IeLJGbHIlR7xzPL6HAMznXyBQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905552; c=relaxed/simple;
	bh=Et9kzSbCLZ14ZQt1L0Q36+5yVaJXnxXByb6DBJQ38rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/A5G+xoRE2VUYCFadBgdabfcNqDuo1vywYlFaRijtTTER2YiVHvTOenkaG/sfauGsi+tvmWkxXPOsPyY/qBtD17CxNca/qBlgS1WJ2hsxRr7tnqycbGpbfMypQcQdkIQjh23hMdPgJplGYTszUaKTsMOyzniopBW2k1hZpk0Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtYK2bYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtYK2bYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24116C4CEE9;
	Tue, 25 Mar 2025 12:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905552;
	bh=Et9kzSbCLZ14ZQt1L0Q36+5yVaJXnxXByb6DBJQ38rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtYK2bYtO9olFtCy7XwtZjHzH2L1a+xDQNF+9xm5EbdvyEdVj6jr5MmUJ0mSD+ATE
	 03ZUN8rQCRdZblQ6IlwUYBFtvkTJxu3hP+nwBGGb9vdHxJw3HnFVuXfqW0r+fcEh3E
	 PvWbhBsSD7GL3IKmyEgE7YVSyRQIyuIQlWfJK+xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marc=20Aur=C3=A8le=20La=20France?= <tsi@tuyoix.net>,
	Rik van Riel <riel@surriel.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/198] scsi: core: Use GFP_NOIO to avoid circular locking dependency
Date: Tue, 25 Mar 2025 08:19:57 -0400
Message-ID: <20250325122157.561309561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

[ Upstream commit 5363ee9d110e139584c2d92a0b640bc210588506 ]

Filesystems can write to disk from page reclaim with __GFP_FS
set. Marc found a case where scsi_realloc_sdev_budget_map() ends up in
page reclaim with GFP_KERNEL, where it could try to take filesystem
locks again, leading to a deadlock.

WARNING: possible circular locking dependency detected
6.13.0 #1 Not tainted
------------------------------------------------------
kswapd0/70 is trying to acquire lock:
ffff8881025d5d78 (&q->q_usage_counter(io)){++++}-{0:0}, at: blk_mq_submit_bio+0x461/0x6e0

but task is already holding lock:
ffffffff81ef5f40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x9f/0x760

The full lockdep splat can be found in Marc's report:

https://lkml.org/lkml/2025/1/24/1101

Avoid the potential deadlock by doing the allocation with GFP_NOIO, which
prevents both filesystem and block layer recursion.

Reported-by: Marc Aurèle La France <tsi@tuyoix.net>
Signed-off-by: Rik van Riel <riel@surriel.com>
Link: https://lore.kernel.org/r/20250129104525.0ae8421e@fangorn
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 852d509b19b2b..69288303e6004 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -245,7 +245,7 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 	}
 	ret = sbitmap_init_node(&sdev->budget_map,
 				scsi_device_max_queue_depth(sdev),
-				new_shift, GFP_KERNEL,
+				new_shift, GFP_NOIO,
 				sdev->request_queue->node, false, true);
 	if (!ret)
 		sbitmap_resize(&sdev->budget_map, depth);
-- 
2.39.5



