Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027909;
	b=BmvUepH7Va/IhuW/JDanRH5q2ZrDi74B91DtH/A5khnoNKLLFeAZWrASwDSWuR+e29tN
	 1QtBGOlBK8Jv012sBvc+NbjyoX8xpgicbT3Uv3GXoCGh4Wm0Q9td4emXdCdTOPPh6GC83
	 g8OoWuGssX0D9GI8V822GvK7d15R2//j2l8jXSMLFeO6wOulDJ+QATOitjw/BBldOvqf+
	 bqac0UeoWH6ysnWWosTpcJFJ8caJuCzydsYFL1at8FWVoERIYLHaMg9+WDin6vp2f8wXn
	 uzW9V0Q5XNUem9q6y80q2rK1MWTT5RsLqx2sTSTRYv5nZkaXNOKEi/VK82StQ4fetJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1m2dolovSltNKv8rD8JT7pVD3+rqobGv6YPC231Sebs=;
	b=b6A4Koo5kTxl0FOZynkQGDg0m3hhoi0ReX0KHzCdsb5RKiYOMjx5HXaVg9sHxsbMfe9h
	 1fYzN7j5dXSIE4rnHc9jCH4xqHEWlyXFv18PpIWA3JBIXzTJ0rLckz/Fde2cbB1GA4cnQ
	 //byslC6nThIqO5lnZk3UW2SVX9LAZKPdslMYidAue2+xpI2f3c/7xpdAoXtqlWazUeMq
	 IGxjhRluaNpLwqTSp/M2HkHzIIPC3S/T2eFbj0X6gL39/6a+RmPRRjeBmegg/V4itFA5v
	 YExMhi/pL8gAbur9RJohDr3MG+8kGYk+mj6Yib5HMDqA2/J3eH7Kl3AWaH33igNtgbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2jOr1Tkn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0463606A325;
	Wed, 18 Nov 2026 18:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2jOr1Tkn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415A41F000C6;
	Wed, 18 Nov 2026 18:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027908;
	bh=1m2dolovSltNKv8rD8JT7pVD3+rqobGv6YPC231Sebs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jOr1Tknmxn9Tu9AqZPfWbLAQzADSpu7AaluhhJxacaOyHMybYNze5daLuOuKhoS6
	 G4HBE5KhVQxUR3nOG9bmm3Av5gRxZIMgOxtrSxDFEvQTTZqvRzmgMGM3OxvPb6/wYd
	 3lwnx8e2ZE7Zahp0PvhCsECL//27sAggxrwxUd/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1914/2151] regulator: irq: freeze deferred hardware access during suspend
Date: Wed, 18 Nov 2026 16:00:49 +0100
Message-ID: <20261118150231.506340615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 8a6d73e316f95e398a1de1d1f58314b6d3e7f641 ]

The regulator IRQ helper delays status checks and recovery callbacks on
non-freezable workqueues. Those callbacks may access regulator hardware
after the backing bus has been suspended.

Use system_freezable_wq for normal-priority callbacks. Allocate a
freezable high-priority workqueue when requested so the high_prio
contract is preserved while hardware access is frozen across suspend.

Signed-off-by: Jiale Yao <yaojiale02@163.com>
Fixes: 7111c6d1b31b ("regulator: IRQ based event/error notification helpers")
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20261016100522.2582557-3-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/irq_helpers.c | 38 +++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/irq_helpers.c b/drivers/regulator/irq_helpers.c
index 5b3cfac286676..cdbd170d2b150 100644
--- a/drivers/regulator/irq_helpers.c
+++ b/drivers/regulator/irq_helpers.c
@@ -15,6 +15,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/regulator/driver.h>
 
 #include "internal.h"
@@ -27,6 +28,7 @@ struct regulator_irq {
 	int irq;
 	int retry_cnt;
 	struct delayed_work isr_work;
+	struct workqueue_struct *wq;
 };
 
 /*
@@ -145,12 +147,7 @@ static void regulator_notifier_isr_work(struct work_struct *work)
 	return;
 
 reschedule:
-	if (!d->high_prio)
-		mod_delayed_work(system_dfl_wq, &h->isr_work,
-				 msecs_to_jiffies(tmo));
-	else
-		mod_delayed_work(system_highpri_wq, &h->isr_work,
-				 msecs_to_jiffies(tmo));
+	mod_delayed_work(h->wq, &h->isr_work, msecs_to_jiffies(tmo));
 }
 
 static irqreturn_t regulator_notifier_isr(int irq, void *data)
@@ -248,13 +245,8 @@ static irqreturn_t regulator_notifier_isr(int irq, void *data)
 	}
 
 	if (d->irq_off_ms) {
-		if (!d->high_prio)
-			schedule_delayed_work(&h->isr_work,
-					      msecs_to_jiffies(d->irq_off_ms));
-		else
-			mod_delayed_work(system_highpri_wq,
-					 &h->isr_work,
-					 msecs_to_jiffies(d->irq_off_ms));
+		mod_delayed_work(h->wq, &h->isr_work,
+				 msecs_to_jiffies(d->irq_off_ms));
 	}
 
 	return IRQ_HANDLED;
@@ -363,13 +355,25 @@ void *regulator_irq_helper(struct device *dev,
 
 	init_rdev_errors(h);
 
-	if (h->desc.irq_off_ms)
+	if (h->desc.irq_off_ms) {
+		if (h->desc.high_prio) {
+			h->wq = alloc_workqueue("regulator_irq_highpri",
+						WQ_FREEZABLE | WQ_HIGHPRI, 0);
+			if (!h->wq)
+				return ERR_PTR(-ENOMEM);
+		} else {
+			h->wq = system_freezable_wq;
+		}
+
 		INIT_DELAYED_WORK(&h->isr_work, regulator_notifier_isr_work);
+	}
 
 	ret = request_threaded_irq(h->irq, NULL, regulator_notifier_isr,
 				   IRQF_ONESHOT | irq_flags, h->desc.name, h);
 	if (ret) {
 		dev_err(dev, "Failed to request IRQ %d\n", irq);
+		if (h->desc.irq_off_ms && h->desc.high_prio)
+			destroy_workqueue(h->wq);
 
 		return ERR_PTR(ret);
 	}
@@ -393,8 +397,11 @@ void regulator_irq_helper_cancel(void **handle)
 		struct regulator_irq *h = *handle;
 
 		free_irq(h->irq, h);
-		if (h->desc.irq_off_ms)
+		if (h->desc.irq_off_ms) {
 			cancel_delayed_work_sync(&h->isr_work);
+			if (h->desc.high_prio)
+				destroy_workqueue(h->wq);
+		}
 
 		h = NULL;
 	}
@@ -441,4 +448,3 @@ int regulator_irq_map_event_simple(int irq, struct regulator_irq_data *rid,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(regulator_irq_map_event_simple);
-
-- 
2.53.0



