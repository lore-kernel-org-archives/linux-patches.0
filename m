Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A1B13F452;
	Thu, 11 Apr 2024 10:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830566; cv=none; b=o0HbjFrS24hcG7ZB042awn6fiHDAjZEjTDrQmpU3kt0Rg5SrOeLOHj3PVx+Prbr5ITdSjDIChl/IPlAn9Nrjs00E/7bIj2tnH1IPrSiwHiR7V0J3IxLtCIoLQW/FcLfJYhgvyB+ggusro8F6eZn5jpmnjFa7mX0fXgbWsH2his8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830566; c=relaxed/simple;
	bh=prAjMazxOCCGNj8/Fbt5jGWYpIDbbgmMvtuJHaUNQuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3w8xIATV/lF44j5/OGiT7Yu0V7/vwYeeQ4GPY0J75LtavOYpEgaerdDqbITK/vN2SzNqP+g+ACzdbMW6gC9eVG5JbXHTcvvLBLPLoGe+NPzEDbnkrT9K90d2cx+VCT13V7oiXDVEI/SM6n3e7y0L9f/D48cXjI2RHzyi5Tic7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yN8o9XJG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yN8o9XJG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B59FC433C7;
	Thu, 11 Apr 2024 10:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830566;
	bh=prAjMazxOCCGNj8/Fbt5jGWYpIDbbgmMvtuJHaUNQuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yN8o9XJGqxSyipKaiZrDycdSv25cjQGHhnCsigRx8mWrAqEOjPuRY7xOQBFGqHLo2
	 kMPk9UIU1H5T72mQOwZCa/pJtuFPS2jr5W/s88TEoUkWIznUIEVmaVbzZJOyEIFQG5
	 olenF2oLpU2YxOqj+RG7uyF+gCDreWQZ/gdK3IDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/215] PM: sleep: wakeirq: fix wake irq warning in system suspend
Date: Thu, 11 Apr 2024 11:54:12 +0200
Message-ID: <20240411095426.188845956@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingliang Li <qingliang.li@mediatek.com>

[ Upstream commit e7a7681c859643f3f2476b2a28a494877fd89442 ]

When driver uses pm_runtime_force_suspend() as the system suspend callback
function and registers the wake irq with reverse enable ordering, the wake
irq will be re-enabled when entering system suspend, triggering an
'Unbalanced enable for IRQ xxx' warning. In this scenario, the call
sequence during system suspend is as follows:
  suspend_devices_and_enter()
    -> dpm_suspend_start()
      -> dpm_run_callback()
        -> pm_runtime_force_suspend()
          -> dev_pm_enable_wake_irq_check()
          -> dev_pm_enable_wake_irq_complete()

    -> suspend_enter()
      -> dpm_suspend_noirq()
        -> device_wakeup_arm_wake_irqs()
          -> dev_pm_arm_wake_irq()

To fix this issue, complete the setting of WAKE_IRQ_DEDICATED_ENABLED flag
in dev_pm_enable_wake_irq_complete() to avoid redundant irq enablement.

Fixes: 8527beb12087 ("PM: sleep: wakeirq: fix wake irq arming")
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Qingliang Li <qingliang.li@mediatek.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeirq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/wakeirq.c b/drivers/base/power/wakeirq.c
index 46654adf00a10..20b07fa2792ba 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -365,8 +365,10 @@ void dev_pm_enable_wake_irq_complete(struct device *dev)
 		return;
 
 	if (wirq->status & WAKE_IRQ_DEDICATED_MANAGED &&
-	    wirq->status & WAKE_IRQ_DEDICATED_REVERSE)
+	    wirq->status & WAKE_IRQ_DEDICATED_REVERSE) {
 		enable_irq(wirq->irq);
+		wirq->status |= WAKE_IRQ_DEDICATED_ENABLED;
+	}
 }
 
 /**
-- 
2.43.0



