Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6388530E848;
	Mon, 13 Oct 2025 15:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369310; cv=none; b=pVQvvGIM2//dlhG+5xP2HI3KvgznSQcggVATBi4E1o9P/2qiDOwFcc1rIpWpJmFlJx/c9eIeu9gkxe16v8Su24YsCldO0rYSkGxi6fCRtDsz6FK7hiA4ynpSaQMSMohJbZ1y+RW3Nscevdge50P5gXlhPRabsHA7Kvk2dRAiNqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369310; c=relaxed/simple;
	bh=Ks5VbF96nc/X94wqruLln8mbGCN12whp6CJRNgxAQFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvHpnfLN7+jToO3GUo6NbA5fLaTHwtEooSzjB8sGMfVgJ7tfcC+BWC+qlrH+UhcGiZ21liTQlKS44TnhABSBQaab+OgyaJghVs1s5HFEZZTJ+WYYBdHvXAysFo8LsO/Ba9Yt4EURo7uxcvBUDxZkGu0EQzNG/x/xuEmsd/VPUVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuvXSDAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuvXSDAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2203C4CEFE;
	Mon, 13 Oct 2025 15:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369310;
	bh=Ks5VbF96nc/X94wqruLln8mbGCN12whp6CJRNgxAQFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuvXSDABQQtIrqZTRp19kmqR5GbmiO++cUB692HWNRmW7NBFYJxxks1AEFr6Xw17J
	 k9gWoDyc56mbLF2VEd81c6cM2gsD7bIYuPzaveqcUb0O1NP3DRor9GfEYJwOSbsvn8
	 KLzZx9VcOPLHb4zcQgZ4ArgN0Z8pwPfX0c4GBeAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 168/563] block: update validation of atomic writes boundary for stacked devices
Date: Mon, 13 Oct 2025 16:40:29 +0200
Message-ID: <20251013144417.375831315@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit bfd4037296bd7e1f95394a2e3daf8e3c1796c3b3 ]

In commit 63d092d1c1b1 ("block: use chunk_sectors when evaluating stacked
atomic write limits"), it was missed to use a chunk sectors limit check
in blk_stack_atomic_writes_boundary_head(), so update that function to
do the proper check.

Fixes: 63d092d1c1b1 ("block: use chunk_sectors when evaluating stacked atomic write limits")
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 693bc8d20acf3..6760dbf130b24 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -643,18 +643,24 @@ static bool blk_stack_atomic_writes_tail(struct queue_limits *t,
 static bool blk_stack_atomic_writes_boundary_head(struct queue_limits *t,
 				struct queue_limits *b)
 {
+	unsigned int boundary_sectors;
+
+	if (!b->atomic_write_hw_boundary || !t->chunk_sectors)
+		return true;
+
+	boundary_sectors = b->atomic_write_hw_boundary >> SECTOR_SHIFT;
+
 	/*
 	 * Ensure atomic write boundary is aligned with chunk sectors. Stacked
-	 * devices store chunk sectors in t->io_min.
+	 * devices store any stripe size in t->chunk_sectors.
 	 */
-	if (b->atomic_write_hw_boundary > t->io_min &&
-	    b->atomic_write_hw_boundary % t->io_min)
+	if (boundary_sectors > t->chunk_sectors &&
+	    boundary_sectors % t->chunk_sectors)
 		return false;
-	if (t->io_min > b->atomic_write_hw_boundary &&
-	    t->io_min % b->atomic_write_hw_boundary)
+	if (t->chunk_sectors > boundary_sectors &&
+	    t->chunk_sectors % boundary_sectors)
 		return false;
 
-	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
 	return true;
 }
 
@@ -695,13 +701,13 @@ static void blk_stack_atomic_writes_chunk_sectors(struct queue_limits *t)
 static bool blk_stack_atomic_writes_head(struct queue_limits *t,
 				struct queue_limits *b)
 {
-	if (b->atomic_write_hw_boundary &&
-	    !blk_stack_atomic_writes_boundary_head(t, b))
+	if (!blk_stack_atomic_writes_boundary_head(t, b))
 		return false;
 
 	t->atomic_write_hw_unit_max = b->atomic_write_hw_unit_max;
 	t->atomic_write_hw_unit_min = b->atomic_write_hw_unit_min;
 	t->atomic_write_hw_max = b->atomic_write_hw_max;
+	t->atomic_write_hw_boundary = b->atomic_write_hw_boundary;
 	return true;
 }
 
-- 
2.51.0



