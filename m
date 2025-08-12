Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245472EBDC5;
	Tue, 12 Aug 2025 19:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026639; cv=none; b=pt4xRkZAibfsMkisNUO6/ZmFpy5QrX5+37fEciojaicK19wEC1P6ASWORHwVEl69iAUNcoGi3xaiy/XNIvKd2GUuDCdT1FyWpvyFcL/fz68HFAtpDBVA3C803F22hvTK4A/z56QaztChmcRw46lfs7GiVHD7YeP8sWJ+qiWr+U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026639; c=relaxed/simple;
	bh=8v7YGUQjx8unT/TmtZg11zqOIXxF02nbyX+pfVw5RNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8xAb6BjJQfKYRcjp+oCx0rRIlOuwabcPiDecewfdepaXde/WkFhDDXYTd0a8qDK0cjIZa1Lqt2oHCBylEcUeL+MoT1RZHeMbMoLF/lxLu7YltvVXPRZMnABgDYl5sgjhtcf6iyTpCLmQ0poqDRbRfm/wgaA9J0vG54p6gQwP7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVs2YSai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVs2YSai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E05C4CEF0;
	Tue, 12 Aug 2025 19:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026638;
	bh=8v7YGUQjx8unT/TmtZg11zqOIXxF02nbyX+pfVw5RNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVs2YSai7huNKUMxDwNdhBCzb2kjtWdvVLw4xdgqDjChj+xZUCu+qhM14XM+g3Hub
	 vxx+zsFlXPq9l4PY8GcR6RrgFeTapffWg2aYWVoNCWolEJX1bwtRqAKJWLV6cPFhhR
	 0ZyzdNbOKG6yCt4GTaw56Wv5KjOzBJINWmzuhrmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 395/480] block: ensure discard_granularity is zero when discard is not supported
Date: Tue, 12 Aug 2025 19:50:03 +0200
Message-ID: <20250812174413.721767189@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit fad6551fcf537375702b9af012508156a16a1ff7 ]

Documentation/ABI/stable/sysfs-block states:

  What: /sys/block/<disk>/queue/discard_granularity
  [...]
  A discard_granularity of 0 means that the device does not support
  discard functionality.

but this got broken when sorting out the block limits updates.  Fix this
by setting the discard_granularity limit to zero when the combined
max_discard_sectors is zero.

Fixes: 3c407dc723bb ("block: default the discard granularity to sector size")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250731152228.873923-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d8c79e5112b4..47a31e1c0909 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -347,12 +347,19 @@ int blk_validate_limits(struct queue_limits *lim)
 	lim->max_discard_sectors =
 		min(lim->max_hw_discard_sectors, lim->max_user_discard_sectors);
 
+	/*
+	 * When discard is not supported, discard_granularity should be reported
+	 * as 0 to userspace.
+	 */
+	if (lim->max_discard_sectors)
+		lim->discard_granularity =
+			max(lim->discard_granularity, lim->physical_block_size);
+	else
+		lim->discard_granularity = 0;
+
 	if (!lim->max_discard_segments)
 		lim->max_discard_segments = 1;
 
-	if (lim->discard_granularity < lim->physical_block_size)
-		lim->discard_granularity = lim->physical_block_size;
-
 	/*
 	 * By default there is no limit on the segment boundary alignment,
 	 * but if there is one it can't be smaller than the page size as
-- 
2.39.5



