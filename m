Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277422EAE5;
	Thu, 11 Apr 2024 10:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829676; cv=none; b=fxx4x836YB/4C+ZrQNGnTY1XRLAHYixAdHYtztp7iLbV2INTlmyfilD4nRcp65t42YneRtG5QKobf8pcianTt0kyUKzNc9WiBG+Ib2suuJw3Jhge5u+2GyD0D80MKEWzbIrEUNngfbmlWp8K7pDK85doo8adEzU63fjnpso6rpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829676; c=relaxed/simple;
	bh=9yV8KweV20qFNfXDLg8OulAdE1yn2tsbKgUYFTZ5UIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obVuqBGxjzGg9gD26aWHYZQjvP81y32PWOCH6pqh6uPGrXgAB+qRFg1/pmpghPyvNQg26ag3wLgwJbczXDBrpoBOiJ/IFcFmKg3IYSjrAqHqfBI1NxC+cVdon/0xiOnx8TTQphNnODCH3p4PJmNkzzGS1LNgMxJr4cg8/kskxPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJRcCpRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJRcCpRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A49C433C7;
	Thu, 11 Apr 2024 10:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829676;
	bh=9yV8KweV20qFNfXDLg8OulAdE1yn2tsbKgUYFTZ5UIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJRcCpRG37RTnrODjQ/If3mNL3JVJvsWVHsYAqgeJAs0H0swrOVhaKMGcYJ03xQoh
	 XwS2qN4o3u4y88aVd19f1NwEGSDJ0a6ffdGol6HzUKedqJGhbmp/Z4M7rwHt3qiCbC
	 AJEwXTDCgaOXjcEpI99/kh8nAfObZKasYqgTdKjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/175] PM: sleep: wakeirq: fix wake irq warning in system suspend
Date: Thu, 11 Apr 2024 11:54:23 +0200
Message-ID: <20240411095420.765959094@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e7ba514999163..bc3637b45cbf7 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -376,8 +376,10 @@ void dev_pm_enable_wake_irq_complete(struct device *dev)
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



