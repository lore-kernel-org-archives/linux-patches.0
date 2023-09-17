Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A31153B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FF9C43391;
	Sun, 17 Sep 2023 19:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979150;
	bh=SqrDov9Q7tkzefnPG0KKC3Hnt+1BNSVyD5AL4rkWak8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxO6JY7Tti0uSxmwdVemEdKR32aTyrN6Cs8FAFqRAxeee+JKgB8y6T6WR66o4w4nW
	 3T/4WGxCTss0clyAIiRh3rizLfPQ69dlqGJZVre2wtqmPIP7qXxV0ro4pcmoyDvr/m
	 hctIo9i+5YcrgdRsWkGqKT6ZgEw7+q0rFu0TNbEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruidong Tian <tianruidong@linux.alibaba.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/406] coresight: tmc: Explicit type conversions to prevent integer overflow
Date: Sun, 17 Sep 2023 21:11:23 +0200
Message-ID: <20230917191107.219890392@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

From: Ruidong Tian <tianruidong@linux.alibaba.com>

[ Upstream commit fd380097cdb305582b7a1f9476391330299d2c59 ]

Perf cs_etm session executed unexpectedly when AUX buffer > 1G.

  perf record -C 0 -m ,2G -e cs_etm// -- <workload>
  [ perf record: Captured and wrote 2.615 MB perf.data ]

Perf only collect about 2M perf data rather than 2G. This is becasuse
the operation, "nr_pages << PAGE_SHIFT", in coresight tmc driver, will
overflow when nr_pages >= 0x80000(correspond to 1G AUX buffer). The
overflow cause buffer allocation to fail, and TMC driver will alloc
minimal buffer size(1M). You can just get about 2M perf data(1M AUX
buffer + perf data header) at least.

Explicit convert nr_pages to 64 bit to avoid overflow.

Fixes: 22f429f19c41 ("coresight: etm-perf: Add support for ETR backend")
Fixes: 99443ea19e8b ("coresight: Add generic TMC sg table framework")
Fixes: 2e499bbc1a92 ("coresight: tmc: implementing TMC-ETF AUX space API")
Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230804081514.120171-2-tianruidong@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etf.c | 2 +-
 drivers/hwtracing/coresight/coresight-tmc-etr.c | 5 +++--
 drivers/hwtracing/coresight/coresight-tmc.h     | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index 8978f3410bee5..eee069e95b9f6 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -426,7 +426,7 @@ static int tmc_set_etf_buffer(struct coresight_device *csdev,
 		return -EINVAL;
 
 	/* wrap head around to the amount of space we have */
-	head = handle->head & ((buf->nr_pages << PAGE_SHIFT) - 1);
+	head = handle->head & (((unsigned long)buf->nr_pages << PAGE_SHIFT) - 1);
 
 	/* find the page to write to */
 	buf->cur = head / PAGE_SIZE;
diff --git a/drivers/hwtracing/coresight/coresight-tmc-etr.c b/drivers/hwtracing/coresight/coresight-tmc-etr.c
index 3e74f5aed20d7..ae2dd0c88f4eb 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etr.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etr.c
@@ -47,7 +47,8 @@ struct etr_perf_buffer {
 };
 
 /* Convert the perf index to an offset within the ETR buffer */
-#define PERF_IDX2OFF(idx, buf)	((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf)		\
+		((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /* Lower limit for ETR hardware buffer */
 #define TMC_ETR_PERF_MIN_BUF_SIZE	SZ_1M
@@ -1232,7 +1233,7 @@ alloc_etr_buf(struct tmc_drvdata *drvdata, struct perf_event *event,
 	 * than the size requested via sysfs.
 	 */
 	if ((nr_pages << PAGE_SHIFT) > drvdata->size) {
-		etr_buf = tmc_alloc_etr_buf(drvdata, (nr_pages << PAGE_SHIFT),
+		etr_buf = tmc_alloc_etr_buf(drvdata, ((ssize_t)nr_pages << PAGE_SHIFT),
 					    0, node, NULL);
 		if (!IS_ERR(etr_buf))
 			goto done;
diff --git a/drivers/hwtracing/coresight/coresight-tmc.h b/drivers/hwtracing/coresight/coresight-tmc.h
index b91ec7dde7bc9..3655b3bfb2e32 100644
--- a/drivers/hwtracing/coresight/coresight-tmc.h
+++ b/drivers/hwtracing/coresight/coresight-tmc.h
@@ -321,7 +321,7 @@ ssize_t tmc_sg_table_get_data(struct tmc_sg_table *sg_table,
 static inline unsigned long
 tmc_sg_table_buf_size(struct tmc_sg_table *sg_table)
 {
-	return sg_table->data_pages.nr_pages << PAGE_SHIFT;
+	return (unsigned long)sg_table->data_pages.nr_pages << PAGE_SHIFT;
 }
 
 struct coresight_device *tmc_etr_get_catu_device(struct tmc_drvdata *drvdata);
-- 
2.40.1



