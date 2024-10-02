Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176E61D04B4;
	Wed,  2 Oct 2024 13:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877341; cv=none; b=dVww0xd4GkOjsrF2ySRNMGAoNXIHZPwik3iSUcxQXyHxDW6kBRAqv1KrFEt1Mrn0Il50b/8C5hppKMy7g0J148/xA3iUis7tHDB5rfefX5zAs84K16Buw3RopWC0nTqxHUZqiKSObXyGRsijjK1giahhqK/yfdeqbSVfm6NcBJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877341; c=relaxed/simple;
	bh=+/b2/YnW5mMW+Q9N5DoBSU3euPxvtnZ5EZRKJ+i7mf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPKDA0gFU7w22swVsMfySzLoiWALVuV6cgD2ZIn7gXaJttAnGWeKDNfrdCerL+s3130gUVSPIKs7sR+snXUbKGDjPoxayygRUSFcdogXq0436PLcXQSPuptEWPjbrdcVJbB4Tsx+g4X8NzF0SaW3HKxRjIvVM7Gg74JrXUKuTCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sl4E601X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sl4E601X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E63C4CECE;
	Wed,  2 Oct 2024 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877341;
	bh=+/b2/YnW5mMW+Q9N5DoBSU3euPxvtnZ5EZRKJ+i7mf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sl4E601XXQmX3wIzcH+MD+nX4jz/mux0kHvqgXdkHv709hX+GJhpQ4daKB6RCjS2A
	 THqjk548Nn9s7q8AeDiCjRO4XNRvmVEtxEjGAAbSyf+I81j1ZCkMRbvLsYpZdj8gii
	 MMsCWSx0fjzuExgwicFRXT01zh6Zdz0jibPZw7fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 031/634] drivers/perf: Fix ali_drw_pmu driver interrupt status clearing
Date: Wed,  2 Oct 2024 14:52:11 +0200
Message-ID: <20241002125812.326146032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



