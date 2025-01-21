Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FBF1F540C;
	Tue, 21 Jan 2025 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482866; cv=none; b=hORTK3ZZ8XjbmA5k3FDf5dhfKNlpHUvdpbVWPF6xiNoT4yvxYMX+/2+zLK9WxYaLmNvpPXoW9f2MQS4c34UYV8IGU8naMqHgHJKaWtHW3Zp22F8XtzjilHdMZ8lxCmA0JIEecrBjBHS4FTKJyMJL5ZYq7HoutJbGvoihyU0GJ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482866; c=relaxed/simple;
	bh=EpCy4vQ8k2J8q+fH98U+2+d+zaMsErQ4yez0J2L+TyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7Kz+0l27qHFGAwA+nUsZXAYYkMakOigm0U70x0IudF1CvbzOcSFMGL87bNym1YTtlGoLbDXq4M79/6jEPt2UAoYKSA+A8AW4z28uTvOY5lML86VJC38Bytc9R1VR58Cq6e/IahXudyp51Kds0U92A6PIe31TYY4Z1KqnKRmYy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GC9NYW1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC9NYW1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010E3C4CEDF;
	Tue, 21 Jan 2025 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482866;
	bh=EpCy4vQ8k2J8q+fH98U+2+d+zaMsErQ4yez0J2L+TyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GC9NYW1Ov+9dtV1JvWj+v86eXfJfXqo1NLjhcuXyY67SwBCbPEAyK24U2Rt9ZN+6k
	 JEP557Q5WzCMugml7tDMI5G0o8rk/fLoTZh/M6V9yOxQqQY+NbbsaPwYweh2ERY1O5
	 RHn8D1LeS/Z7624LNR0BP68jErGtEkXffmBL4yTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.15 034/127] drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
Date: Tue, 21 Jan 2025 18:51:46 +0100
Message-ID: <20250121174530.999716773@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

commit 6d2453c3dbc5f70eafc1c866289a90a1fc57ce18 upstream.

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
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1695,9 +1695,6 @@ out:
 
 static void zram_reset_device(struct zram *zram)
 {
-	struct zcomp *comp;
-	u64 disksize;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -1707,18 +1704,16 @@ static void zram_reset_device(struct zra
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
 


