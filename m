Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056777;
	b=nnJ+bR5W2/nEREevvVNtjTzaHTBZduYKa4eg2bWY6aGuF5cCvk4QKrCTziRzIP4E2Lqh
	 XN9pu/JrIbZVwakRgtmJgySzjEWX5N5PaAQYUQpoiQx7M/IVPrMMhELX/3k9lLddX2MK3
	 dEW7MhXdH4UzcZbomuFQJUoKiJmhGpTe4518wzo8pBCGj05cIq3YruR26Jp/eLjH8mnOD
	 A35fxG54S0pDmT1HJeAHt2LH8ncwLyN9aKNvezTobnmh03cr0ZhhR42M5e6vcmdXMawpD
	 9OjJGqQYxGHcl2bz2P4i7nWp7SZ1wov+hPfvVKzKhJYnGgPzIeUFvjUtFxQ26Vo4tEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t21svqN9JmKBVfJBYoaRVNW16D7oxvZZw1KsFqFvzPg=;
	b=Olgnk36IKrsQg/wzhPSqz5DB8WURDQs1gkNPLGEXBRwU1k0Z6GUT6/4XRoiQTigOxyKn
	 mA6k6+qaFWABknJSawCFCwPlKv3Yhmc2DY5/IVZ//eR0RSe+xrnx1F9occ8Z89/mgsbaC
	 uQ3LIwMjswx1bx1CgOzJEGniwD/LToxGQoTQJySBZesn53cYO2T444RfVJbODawM0j6O5
	 ZJwPz+FUlQeOA00VB8HZuQqAo+rsiEdpbfGfIX2iqGG7eGvjoYSq8cF7qo30tQz/KcN1D
	 mnc/srDP8rtbIyPJB1rg7qL8GIPkV21PWZjJogCTEODVu2dLFnc/TRjwqw2EQKMVxbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axl9RSJV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DAD606A320;
	Thu, 19 Nov 2026 02:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axl9RSJV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47EC1F000C5;
	Thu, 19 Nov 2026 02:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056777;
	bh=t21svqN9JmKBVfJBYoaRVNW16D7oxvZZw1KsFqFvzPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axl9RSJVhguOms+SJ/p9EksW6e5roqgpthf1leV/Kd0k2VEm8fhUZ6qHyNfCXem8V
	 m4TlJOnZUvwOgCYn2YoGhQQDJKWS67+jjZLWSs+SA1u1wX7KXYnBhDcXptyPKPUvXt
	 dtmd8P/pudcH8uwkZIlNGeC3KgBMdqFiaazuGwGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2108/2214] regulator: irq: freeze deferred hardware access during suspend
Date: Wed, 18 Nov 2026 16:03:04 +0100
Message-ID: <20261118150134.954801248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 64be715a395fb..5dcd24c4e17c9 100644
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
@@ -436,4 +443,3 @@ int regulator_irq_map_event_simple(int irq, struct regulator_irq_data *rid,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(regulator_irq_map_event_simple);
-
-- 
2.53.0



