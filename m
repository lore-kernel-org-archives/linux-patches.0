Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3611CEEAF;
	Wed,  2 Oct 2024 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879156; cv=none; b=BQPgaKkwGfHrG9YM4lPwL+vWE/05JAcpknonE6W4KTrlAtABmZ1LMhS8ZU41d+0J4/PxiWUgyJwlYxikWV1eLwHMCm10pEBPIL42kJCkdSUyBeNJ4sdWFwNbJkGsmk699gyMOL14KNadwU6MxAOtJurH+tv//1LWRNFAJbhJbew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879156; c=relaxed/simple;
	bh=K0vJ5fIXDR24nLQ8oDG01vcSJHJsubETK4M3kOxQ/Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXZW31q0Q8EDy49iP0zx7UonAkMJrRTl+jYC/AJ3L1TWhi3bqC9d9DypoHA8EVs2nP5I3+hWKe/SjmBXLLhgZKCCaZhN9n6zYb+RaqfS500oggBkpCYo07H9ERxIxjniPB9msmhnn+Hslcu9eYTtKPUC7xeLyaoOXUBArtHmyn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynzSC9SX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynzSC9SX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE7C4CECD;
	Wed,  2 Oct 2024 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879156;
	bh=K0vJ5fIXDR24nLQ8oDG01vcSJHJsubETK4M3kOxQ/Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynzSC9SXiBC5kcpwyGqybZsN9w0qD83Dzm8NEF2d+JxfsH/YW45IKr8nWum8Y0GQC
	 R4Ii+v2FMNUGIEx+VtLAGIrICnW0RXfMQ784c4SfO/HSuhf3+f9HN+kgMA9P2y93fJ
	 10mseb/oCwAxNAz/4swRo46fC9CaOiGFrGj1izXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/538] drivers/perf: Fix ali_drw_pmu driver interrupt status clearing
Date: Wed,  2 Oct 2024 14:54:21 +0200
Message-ID: <20241002125752.889351792@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 19d459a36be55..818ce4424d34d 100644
--- a/drivers/perf/alibaba_uncore_drw_pmu.c
+++ b/drivers/perf/alibaba_uncore_drw_pmu.c
@@ -408,7 +408,7 @@ static irqreturn_t ali_drw_pmu_isr(int irq_num, void *data)
 			}
 
 			/* clear common counter intr status */
-			clr_status = FIELD_PREP(ALI_DRW_PMCOM_CNT_OV_INTR_MASK, 1);
+			clr_status = FIELD_PREP(ALI_DRW_PMCOM_CNT_OV_INTR_MASK, status);
 			writel(clr_status,
 			       drw_pmu->cfg_base + ALI_DRW_PMU_OV_INTR_CLR);
 		}
-- 
2.43.0



