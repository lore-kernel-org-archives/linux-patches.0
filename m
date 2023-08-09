Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F95317AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F06C433C8;
	Wed,  9 Aug 2023 11:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580348;
	bh=hVVao+3uHAgTLzd5Oj3YmgPuqcrubzUBNGWiwhXd840=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmhJQI1CTMZjP7OLsxubjrSw/OWhrU+qyrLy6ZrgdRm/zTMY420U1NvV6jvdJlDp7
	 Z1Kev/sz15Pv5zIUsT0PLdOGbBFFDscCeaxVmFNX3XWPka+TaM3EchlvhUxfePIs9O
	 Cm5C2RL/JwJEcQSiTLa7Zs+pXrWMqWFkOGf1vEps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 317/323] PM: sleep: wakeirq: fix wake irq arming
Date: Wed,  9 Aug 2023 12:42:35 +0200
Message-ID: <20230809103712.577932024@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 8527beb12087238d4387607597b4020bc393c4b4 ]

The decision whether to enable a wake irq during suspend can not be done
based on the runtime PM state directly as a driver may use wake irqs
without implementing runtime PM. Such drivers specifically leave the
state set to the default 'suspended' and the wake irq is thus never
enabled at suspend.

Add a new wake irq flag to track whether a dedicated wake irq has been
enabled at runtime suspend and therefore must not be enabled at system
suspend.

Note that pm_runtime_enabled() can not be used as runtime PM is always
disabled during late suspend.

Fixes: 69728051f5bf ("PM / wakeirq: Fix unbalanced IRQ enable for wakeirq")
Cc: 4.16+ <stable@vger.kernel.org> # 4.16+
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/power.h   |  1 +
 drivers/base/power/wakeirq.c | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 55f32bd390007..3f9934bd6137d 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -28,6 +28,7 @@ extern void pm_runtime_remove(struct device *dev);
 #define WAKE_IRQ_DEDICATED_MASK		(WAKE_IRQ_DEDICATED_ALLOCATED | \
 					 WAKE_IRQ_DEDICATED_MANAGED | \
 					 WAKE_IRQ_DEDICATED_REVERSE)
+#define WAKE_IRQ_DEDICATED_ENABLED	BIT(3)
 
 struct wake_irq {
 	struct device *dev;
diff --git a/drivers/base/power/wakeirq.c b/drivers/base/power/wakeirq.c
index fa69e4ce47527..e7ba514999163 100644
--- a/drivers/base/power/wakeirq.c
+++ b/drivers/base/power/wakeirq.c
@@ -328,8 +328,10 @@ void dev_pm_enable_wake_irq_check(struct device *dev,
 	return;
 
 enable:
-	if (!can_change_status || !(wirq->status & WAKE_IRQ_DEDICATED_REVERSE))
+	if (!can_change_status || !(wirq->status & WAKE_IRQ_DEDICATED_REVERSE)) {
 		enable_irq(wirq->irq);
+		wirq->status |= WAKE_IRQ_DEDICATED_ENABLED;
+	}
 }
 
 /**
@@ -350,8 +352,10 @@ void dev_pm_disable_wake_irq_check(struct device *dev, bool cond_disable)
 	if (cond_disable && (wirq->status & WAKE_IRQ_DEDICATED_REVERSE))
 		return;
 
-	if (wirq->status & WAKE_IRQ_DEDICATED_MANAGED)
+	if (wirq->status & WAKE_IRQ_DEDICATED_MANAGED) {
+		wirq->status &= ~WAKE_IRQ_DEDICATED_ENABLED;
 		disable_irq_nosync(wirq->irq);
+	}
 }
 
 /**
@@ -390,7 +394,7 @@ void dev_pm_arm_wake_irq(struct wake_irq *wirq)
 
 	if (device_may_wakeup(wirq->dev)) {
 		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED &&
-		    !pm_runtime_status_suspended(wirq->dev))
+		    !(wirq->status & WAKE_IRQ_DEDICATED_ENABLED))
 			enable_irq(wirq->irq);
 
 		enable_irq_wake(wirq->irq);
@@ -413,7 +417,7 @@ void dev_pm_disarm_wake_irq(struct wake_irq *wirq)
 		disable_irq_wake(wirq->irq);
 
 		if (wirq->status & WAKE_IRQ_DEDICATED_ALLOCATED &&
-		    !pm_runtime_status_suspended(wirq->dev))
+		    !(wirq->status & WAKE_IRQ_DEDICATED_ENABLED))
 			disable_irq_nosync(wirq->irq);
 	}
 }
-- 
2.40.1



