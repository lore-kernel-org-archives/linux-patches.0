Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4D91DC9BE;
	Mon,  6 Jan 2025 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178854; cv=none; b=naDlixr7f+eEOARcqB7oPkYB5g5vxHCeAeQhMhZ5ASXhgs7L8CKKhLU4T2/T2H33ei9qn88GRrQon1FEfLCNd2m1PKkRCtfFT5C5tQ1UAYOfqM9G058NQyzokGhoC1ut5fiDF2S3ImVTFhONcLleBgRnA5gqGBV4RPbPpx2/LSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178854; c=relaxed/simple;
	bh=qcMNruf8EjI8KyKVsrAx5gBp9ikvLPLD1jSnL5+CI3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzLKSF7vuy/FVKO7xdz7RaWZKwvbZDUGDqIYNRWt7JDdpyj0eY9n9w5VPWqHQtAZgckhgzA6NIVI6ZtZaTOcjAFX+bNZn1V5al5we8F3iLUA8TCjlajOg0Tv0OvP0qzh8go90MIQIdhGf3L1PNC1kL8WpeckYABRNs3NecnLw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5QkkwpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5QkkwpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B8FC4CED2;
	Mon,  6 Jan 2025 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178853;
	bh=qcMNruf8EjI8KyKVsrAx5gBp9ikvLPLD1jSnL5+CI3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5QkkwpA/+uAXQZET4e/VgDI3mf77lcd6UPmOiiVomscIc5JxBO2I1aM1YmDuzbpC
	 w7Hsth5MHk7O9SIR94o5JSj17kpFcZ0pios/oHE+FWVIN91t7BevoQFP1LBF+1ZFng
	 0SgXrZVM7VJmE5QVqJ90eZobclpo7nZ0ktSpEVVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/168] drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
Date: Mon,  6 Jan 2025 16:17:03 +0100
Message-ID: <20250106151142.796038222@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 6d2453c3dbc5f70eafc1c866289a90a1fc57ce18 ]

We do all reset operations under write lock, so we don't need to save
->disksize and ->comp to stack variables.  Another thing is that ->comp is
freed during zram reset, but comp pointer is not NULL-ed, so zram keeps
the freed pointer value.

Link: https://lkml.kernel.org/r/20220824035100.971816-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 74363ec674cb ("zram: fix uninitialized ZRAM not releasing backing device")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a9f71b27d235..9eed579d02f0 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1695,9 +1695,6 @@ static int zram_rw_page(struct block_device *bdev, sector_t sector,
 
 static void zram_reset_device(struct zram *zram)
 {
-	struct zcomp *comp;
-	u64 disksize;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -1707,18 +1704,16 @@ static void zram_reset_device(struct zram *zram)
 		return;
 	}
 
-	comp = zram->comp;
-	disksize = zram->disksize;
-	zram->disksize = 0;
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 
 	up_write(&zram->init_lock);
 	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(zram, disksize);
+	zram_meta_free(zram, zram->disksize);
+	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(comp);
+	zcomp_destroy(zram->comp);
+	zram->comp = NULL;
 	reset_bdev(zram);
 }
 
-- 
2.39.5



