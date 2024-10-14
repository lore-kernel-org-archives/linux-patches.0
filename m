Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B911ABEC9;
	Mon, 14 Oct 2024 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917369; cv=none; b=Oenlmxhy02trqJPMw74IwEIk/usqj5C+4wx07hq1O2fEZR45Jvlxruif9qTHaicbqDivwEg8zl880YdQmSu5J8vQv/hVQ8YhB9/oGlfHpxMQElqVUfP0cin1n77cqXAv/Z+ABz95VCDAOPXxORSsPwsRCyEniN0xoeNGDVixfy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917369; c=relaxed/simple;
	bh=a+PxYfMQvK3F/BHaI4YHCXVnaafealW17VpQnaJ1TMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqYBYqkjl486RjrKI18VsCsUHi4mX0eE08bR+rKWpN5KNxjE1qQHdyO0WnxtW7933nJt4KxDmVaXJB3rJ4LcJN1MfSy/h+KbJq64YgqiaY7ZneLWjYT1XEiKAPtRh6jmaXRcos0yQCRS/8sOqWV6YK/5cCAkT4geqkMBlC7U3dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujMx9Dik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujMx9Dik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E57EC4CEC3;
	Mon, 14 Oct 2024 14:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917368;
	bh=a+PxYfMQvK3F/BHaI4YHCXVnaafealW17VpQnaJ1TMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujMx9Dik9OtN1F6FF+OrJhjWANalOiRzyPO9alN0T+p3suWO+ln1F8cejdxhZUZYi
	 l8qcUsVSy4XR/WDeukOp8ebLIm6tKXbTENGIyfDYU1ft2a2Iva1CNM8uOfjrgUnlTG
	 tDLFYR2G7szEkSdpRiyrdbcJdZaKeHJDrnqnhgtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/798] drivers/perf: Fix ali_drw_pmu driver interrupt status clearing
Date: Mon, 14 Oct 2024 16:09:31 +0200
Message-ID: <20241014141218.627312618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Zhang <renyu.zj@linux.alibaba.com>

[ Upstream commit a3dd920977dccc453c550260c4b7605b280b79c3 ]

The alibaba_uncore_pmu driver forgot to clear all interrupt status
in the interrupt processing function. After the PMU counter overflow
interrupt occurred, an interrupt storm occurred, causing the system
to hang.

Therefore, clear the correct interrupt status in the interrupt handling
function to fix it.

Fixes: cf7b61073e45 ("drivers/perf: add DDR Sub-System Driveway PMU driver for Yitian 710 SoC")
Signed-off-by: Jing Zhang <renyu.zj@linux.alibaba.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/1724297611-20686-1-git-send-email-renyu.zj@linux.alibaba.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/alibaba_uncore_drw_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/alibaba_uncore_drw_pmu.c b/drivers/perf/alibaba_uncore_drw_pmu.c
index a7689fecb49d9..0a57502de4284 100644
--- a/drivers/perf/alibaba_uncore_drw_pmu.c
+++ b/drivers/perf/alibaba_uncore_drw_pmu.c
@@ -381,7 +381,7 @@ static irqreturn_t ali_drw_pmu_isr(int irq_num, void *data)
 			}
 
 			/* clear common counter intr status */
-			clr_status = FIELD_PREP(ALI_DRW_PMCOM_CNT_OV_INTR_MASK, 1);
+			clr_status = FIELD_PREP(ALI_DRW_PMCOM_CNT_OV_INTR_MASK, status);
 			writel(clr_status,
 			       drw_pmu->cfg_base + ALI_DRW_PMU_OV_INTR_CLR);
 		}
-- 
2.43.0



