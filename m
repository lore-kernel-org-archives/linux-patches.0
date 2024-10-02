Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6927B1D0425;
	Wed,  2 Oct 2024 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875247; cv=none; b=QVSPUZDC90aPdGb4Wiwcq9ZR2waXPF25Vp7zofbrkSyvRrj7eQLZEhvWi3VWgp8NqnRrfDy4czAzAaZ1CfIAZZQ7vcaHD1GXYCATIpUagqUjTcGVS7wjXkwKT2+Ns0xGM2+01QqLAA/rPmQFKnlI6LuHrd94WCn0siJDermlYOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875247; c=relaxed/simple;
	bh=jRLZ3wcgNwMELJXzGVtDhmN4TIIY0io23A8RCEsswUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpDAJKOtynLGiDx6k2TZGhtQAI7dwTAQ90nzyoMs40cryOs351NDurT6MEdkgeqDZidv8f3IPO5trT5iyvj+fik1R1ny8oHFL7Jl5SyMGeLtUrj2CsABJVIy9Md16wJMAOM9DgD/81JLwVRRDY57SnQ3H+mq/TYp1lwkqf2DQLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpGl4llQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpGl4llQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801E8C4CEC5;
	Wed,  2 Oct 2024 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875246;
	bh=jRLZ3wcgNwMELJXzGVtDhmN4TIIY0io23A8RCEsswUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpGl4llQOCRs3JyO3eYkd7GXFmf1Beyc/azX4jsc1Y7CU/qsX2wxoU4U02fqAdsOx
	 DV16mWlZJen3Fnq+yGTcWepfg+2OcqWqH9mXHNNqtYtcrCu5tMK8XM/HwrCPur3Uog
	 t//J2aMQsD0DvN569M/FOd2JsYL4PT/bealYYQ5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 040/695] drivers/perf: Fix ali_drw_pmu driver interrupt status clearing
Date: Wed,  2 Oct 2024 14:50:38 +0200
Message-ID: <20241002125824.092262537@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 38a2947ae8130..c6ff1bc7d336b 100644
--- a/drivers/perf/alibaba_uncore_drw_pmu.c
+++ b/drivers/perf/alibaba_uncore_drw_pmu.c
@@ -400,7 +400,7 @@ static irqreturn_t ali_drw_pmu_isr(int irq_num, void *data)
 			}
 
 			/* clear common counter intr status */
-			clr_status = FIELD_PREP(ALI_DRW_PMCOM_CNT_OV_INTR_MASK, 1);
+			clr_status = FIELD_PREP(ALI_DRW_PMCOM_CNT_OV_INTR_MASK, status);
 			writel(clr_status,
 			       drw_pmu->cfg_base + ALI_DRW_PMU_OV_INTR_CLR);
 		}
-- 
2.43.0



