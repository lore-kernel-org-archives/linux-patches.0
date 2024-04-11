Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BBA13D24D;
	Thu, 11 Apr 2024 10:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831568; cv=none; b=umv6INsdsKCGTlfZs9fikdGX84xnsrZEavWaHrMgqe/Mp6e0Ntk191jfrmCTUBZr4G0Fh6VO/m3FnL6UIlv2GluuRW+yjaT+XixDalaSf/At9Z0T1K7O56Dr8TWTzGHoy8bdByzYdakJ1lwl+x8SzmTP82ZOxgAd79UdXwiYFgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831568; c=relaxed/simple;
	bh=CQclx6BzZ+iM88NJvzaiim0Aq+wQgRKjUMI2BX9KZ78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/MkEJlEkVD+5h5W7vlyzG0fqhVNZgAVfpyQFvppznIPEpIOWYQoiJK+Ej8rSHh2TBqdRmvTxg9+LPMFKRctGBigV28Y8TsB+eZZ60ACnh4yFa/9HqRULVAJKYDQ+pr+jWLH2eGHqY/Pez1FBP/NGRlzX4Xs7q7Avp1Tgad+w0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbIfsvS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbIfsvS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03F2C433F1;
	Thu, 11 Apr 2024 10:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831568;
	bh=CQclx6BzZ+iM88NJvzaiim0Aq+wQgRKjUMI2BX9KZ78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbIfsvS6xwqP37LYIX3xjucb+bUVL86wWejS7dd3tGdNG16+mdOgWdh12g+bHxoCt
	 akI1NbZzEgn9N2D1KqvNyvuBbkQjEWhnXNoRmlK2wdFFzZtiNq08DIegUioHY6sdje
	 DDLv07N4LXs3Hy0edcCcEI/8cZwZ7HlsCfZz8yN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/294] PM: sleep: wakeirq: fix wake irq warning in system suspend
Date: Thu, 11 Apr 2024 11:53:34 +0200
Message-ID: <20240411095437.177312159@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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
index aea690c64e394..4f4310724fee5 100644
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



