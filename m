Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1EABA3F;
	Mon,  1 Apr 2024 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990782; cv=none; b=IYjLEs2gnPX0RRnRXWmjF2DYKlHr7D36bOrv4Wd9pEk4xMXAMRGPjGXhWM2/Q0bZsFve1dwzvSHMyeagFobTpW669Ix0nIcLN9M+N58+IgwuAOymdA2czqcehxAOJMLBJ2Ge4zWKFCvWVHfgpSf5zHTn0QqWA9tDn4PTw709CrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990782; c=relaxed/simple;
	bh=IU4Se+ckKuxOz8FOBruNrTJeVF/7DxoDefhS62/C1hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAXdsUbPoYQ8qHAu5NH+zDr2CEEI8stRep/KcQP2P13rFkRmqhuZMC5ID0D/A95SfSovZETndBg9CzXoCfkH2Fi1/ryxVEiE+xoROjpiC2MGw7gcRZq3oQtVh/nNVJr7C1PDukxHcv7kohtrKZWKbuyecJh/ejGk5AsPa2hTy68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DiuRZSW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DiuRZSW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81008C43390;
	Mon,  1 Apr 2024 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990782;
	bh=IU4Se+ckKuxOz8FOBruNrTJeVF/7DxoDefhS62/C1hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DiuRZSW4e0+8jAjVlV6omiDZXWgv/2y2WiD0tasrEUqRHdt5PiyCIvFAB5BYvOf8w
	 bdn9dvFAFLYxT6ZgoESg0TrAJreQhn/wmzMkyBTPu30k4RphgMhnLpXiZKiScPGyEP
	 kV4dD94l8aofj2n8ftWrlJngGjxu8X8HRzBGeotM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/272] PM: sleep: wakeirq: fix wake irq warning in system suspend
Date: Mon,  1 Apr 2024 17:44:15 +0200
Message-ID: <20240401152532.585061878@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index afd094dec5ca3..ca0c092ba47fb 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -362,8 +362,10 @@ void dev_pm_enable_wake_irq_complete(struct device *dev)
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



