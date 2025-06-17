Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4422E8DEF;
	Tue, 17 Jun 2025 16:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177360; cv=none; b=MYvows+ebEDjcj4I3j7Oof3/yepmGE0K7aNeFu1aPK1IJW5xs2CqOTAWVF4gSCbPY12GJawSihXzKWyO8HnEGWvZlFQoxlgnC3AFOe1W05CTJdSGoA5Dcuibo8y+jLSQ+RokdwLQBtqeSRXeEMuxgD8mBDd8pWBeJPfbK40Pfsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177360; c=relaxed/simple;
	bh=JxuogJNZ9XWerLU9GfzOjfbvehVSSeRmAU31+8ihJcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQBPCopgcOd7U2xw6BNV6p8HcB5DX8StkfvYRGIDyxfeVr/Rg49um5Mk+10GCqDecTslhncgcAGpzwJN7k3X2xIxylDZjS8uS1ECJzJv7+rIT+hKoxFaAxxRiTChFC2u5erjngs+yzjfwZiRNAU3+kCiZ4uM92YiINNNIJPbqbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeYLMn9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeYLMn9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68518C4CEE7;
	Tue, 17 Jun 2025 16:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177359;
	bh=JxuogJNZ9XWerLU9GfzOjfbvehVSSeRmAU31+8ihJcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeYLMn9CSKcMfR9T0cqvOJ0QPqmPm2/g2AF1MNpPu2Ipt6rD3rGtwQhPsKtDkKdNj
	 umI8N8Y3jmhX3nng4goN0rcq1kb+CCe7UOwiA1NP9eL5E8K0Kzw/4fihKrqTW/7w52
	 NL3BIPh32y4zB4T5SIgmSWND24AyUXLZrkqXP4Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/512] coresight: catu: Introduce refcount and spinlock for enabling/disabling
Date: Tue, 17 Jun 2025 17:24:58 +0200
Message-ID: <20250617152433.064526609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yabin Cui <yabinc@google.com>

[ Upstream commit a03a0a08c6fe5e50c1b12ea41b9e228e7f649c22 ]

When tracing ETM data on multiple CPUs concurrently via the
perf interface, the CATU device is shared across different CPU
paths. This can lead to race conditions when multiple CPUs attempt
to enable or disable the CATU device simultaneously.

To address these race conditions, this patch introduces the
following changes:

1. The enable and disable operations for the CATU device are not
   reentrant. Therefore, a spinlock is added to ensure that only
   one CPU can enable or disable a given CATU device at any point
   in time.

2. A reference counter is used to manage the enable/disable state
   of the CATU device. The device is enabled when the first CPU
   requires it and is only disabled when the last CPU finishes
   using it. This ensures the device remains active as long as at
   least one CPU needs it.

Fixes: fcacb5c154ba ("coresight: Introduce support for Coresight Address Translation Unit")
Signed-off-by: Yabin Cui <yabinc@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250429231301.1952246-2-yabinc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-catu.c | 25 +++++++++++++-------
 drivers/hwtracing/coresight/coresight-catu.h |  1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-catu.c b/drivers/hwtracing/coresight/coresight-catu.c
index 8cf85ff216bbe..25fd02955c38d 100644
--- a/drivers/hwtracing/coresight/coresight-catu.c
+++ b/drivers/hwtracing/coresight/coresight-catu.c
@@ -458,12 +458,17 @@ static int catu_enable_hw(struct catu_drvdata *drvdata, enum cs_mode cs_mode,
 static int catu_enable(struct coresight_device *csdev, enum cs_mode mode,
 		       void *data)
 {
-	int rc;
+	int rc = 0;
 	struct catu_drvdata *catu_drvdata = csdev_to_catu_drvdata(csdev);
 
-	CS_UNLOCK(catu_drvdata->base);
-	rc = catu_enable_hw(catu_drvdata, mode, data);
-	CS_LOCK(catu_drvdata->base);
+	guard(raw_spinlock_irqsave)(&catu_drvdata->spinlock);
+	if (csdev->refcnt == 0) {
+		CS_UNLOCK(catu_drvdata->base);
+		rc = catu_enable_hw(catu_drvdata, mode, data);
+		CS_LOCK(catu_drvdata->base);
+	}
+	if (!rc)
+		csdev->refcnt++;
 	return rc;
 }
 
@@ -486,12 +491,15 @@ static int catu_disable_hw(struct catu_drvdata *drvdata)
 
 static int catu_disable(struct coresight_device *csdev, void *__unused)
 {
-	int rc;
+	int rc = 0;
 	struct catu_drvdata *catu_drvdata = csdev_to_catu_drvdata(csdev);
 
-	CS_UNLOCK(catu_drvdata->base);
-	rc = catu_disable_hw(catu_drvdata);
-	CS_LOCK(catu_drvdata->base);
+	guard(raw_spinlock_irqsave)(&catu_drvdata->spinlock);
+	if (--csdev->refcnt == 0) {
+		CS_UNLOCK(catu_drvdata->base);
+		rc = catu_disable_hw(catu_drvdata);
+		CS_LOCK(catu_drvdata->base);
+	}
 	return rc;
 }
 
@@ -550,6 +558,7 @@ static int __catu_probe(struct device *dev, struct resource *res)
 	dev->platform_data = pdata;
 
 	drvdata->base = base;
+	raw_spin_lock_init(&drvdata->spinlock);
 	catu_desc.access = CSDEV_ACCESS_IOMEM(base);
 	catu_desc.pdata = pdata;
 	catu_desc.dev = dev;
diff --git a/drivers/hwtracing/coresight/coresight-catu.h b/drivers/hwtracing/coresight/coresight-catu.h
index 141feac1c14b0..755776cd19c5b 100644
--- a/drivers/hwtracing/coresight/coresight-catu.h
+++ b/drivers/hwtracing/coresight/coresight-catu.h
@@ -65,6 +65,7 @@ struct catu_drvdata {
 	void __iomem *base;
 	struct coresight_device *csdev;
 	int irq;
+	raw_spinlock_t spinlock;
 };
 
 #define CATU_REG32(name, offset)					\
-- 
2.39.5



