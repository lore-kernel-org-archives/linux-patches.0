Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039482;
	b=e3Yfz/vTirTUr3pNBOn504ITc97TZHRwg0LNI/47aqfwNs+HVE0blaxh9VPSW4rGroIq
	 BnXGOrzqVFH6JYu0tunm2FOkn7ksKjdeomT/pqdIg9QY1LGK/Zp2Qwk5QHJZgNgu89Mu1
	 cPfVrXi6ZEZ4jAPJ3g9DAr+OrJ9hf5k0xpHTWkHFuM3SmCZhUDmHUh/Wciaap+RjCcio1
	 isfWoC3D7ya50xcOeugeTy9UtXXmORCm1CyWjqEy0oKvKGbdWFdAjUzUc0SFPhCp+5B7Q
	 y1kEFP65Rnjsmd4TgCh5k7b3vT74jT0aWeeLKaTVpdp9u00tpMLQQ8Szsuy1NzNlwdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BD8ViNB+MfjWQyn6eRzbIQLV9sqc691JctYQ8rpZuVc=;
	b=I3FZz/s6ZvyBVLlGVPFcRdab3Ks3MrLuxS6YZKwDp39V+/uNQ9UD6YSdpKOahZcxzD9Y
	 bqz9J6zqVOF/RCky8GQHc989O8ElNo/iHZ7xzM6fyWhbHi3D7krGlV+Nh516U+wwmT2EZ
	 ECQAJRqqD2TMNBl5Uyc85w+aobd+LOYttWkdX9iI0Q4em68UenztyYxmu5kg7QiLcAkyS
	 jZAQuTAFGOKvfMRrL8MtiPYA97+LDe3CfAEsAbln9EL4OumRn+zY+96+7k4acvtAzOMdF
	 1jBt19Fu5707BIKWcz0jey1vchOFoRAdvAWDoMoU6CYd+XLBbIMhzW1J18z3yTaQ6GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGrFEg3L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8071A606A320;
	Wed, 18 Nov 2026 22:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IGrFEg3L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B6E1F000C4;
	Wed, 18 Nov 2026 22:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039482;
	bh=BD8ViNB+MfjWQyn6eRzbIQLV9sqc691JctYQ8rpZuVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGrFEg3LbnX67ibX4eH/ABI5vexhugqrchYondjFXcy22JAO/uPiQ8yNz5BtMg9UC
	 sc1Pl6J7lIOJdsQvz/IQ2IW7tRD4fYowkF9eQGyNesEBL1Rhuk4fo91KDAyU9oET/B
	 5HTCyz4BoJmGQ5wcYBu4WQ9s56NdAG8+nUh8ysWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Brue <ryanbrue.dev@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2116/3318] power: supply: bq24190_charger: use the wake irq API
Date: Wed, 18 Nov 2026 15:45:38 +0100
Message-ID: <20261118150425.544805619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Brue <ryanbrue.dev@gmail.com>

[ Upstream commit ece9baab2a6e79224d3f591893be23b540b1625f ]

bq24190_probe() calls enable_irq_wake() on the charger interrupt and
never calls disable_irq_wake(). That is wrong in three ways.

It is unbalanced. free_irq() does not touch desc->wake_depth -- only
irq_set_irq_wake() does -- so after the driver is unbound the descriptor
is still one wake reference deep and the irqchip is still configured for
wake, forever, for an interrupt nobody owns any more.

It ignores the device's wakeup policy. The chip is made a system wake
source whether or not anyone asked for it, and because
device_init_wakeup() is never called there is no power/wakeup attribute
for userspace to say otherwise. A board that would rather not be woken
by its charger has no way to express that.

And it arms the interrupt for wake permanently, from probe onwards,
rather than for the sleep it is meant to cover.

Use the wake irq API instead: devm_device_init_wakeup() to make the
device wakeup-capable and enabled -- preserving today's behaviour -- and
devm_pm_set_wake_irq() to hand the interrupt to the PM core, which arms
it in dpm_suspend_noirq() (only if device_may_wakeup(), immediately
before suspend_device_irqs()) and disarms it on resume. Both are unwound
by devm, so the reference is balanced on unbind, and userspace gets the
power/wakeup control it should have had.

No intended change in behaviour: charger events still wake the system by
default.

The same conversion was made to another charger driver for the same
reason, in commit 6c5393771c50 ("power: supply: qcom_pmi8998_charger: fix
wakeirq").

Fixes: f385e6e2a153 ("power: bq24190_charger: Use PM runtime autosuspend")
Assisted-by: LLM
Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
Link: https://patch.msgid.link/20260908-rbrue-suez-upstreaming-bq24190_charger-use-wake-irq-api-v1-1-c3f10ae2a34a@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 3f99cb9590ba2..159546d9cac41 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -10,6 +10,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/power_supply.h>
 #include <linux/power/bq24190_charger.h>
 #include <linux/regulator/driver.h>
@@ -1896,7 +1897,13 @@ static int bq24190_probe(struct i2c_client *client)
 	if (ret < 0)
 		goto out_charger;
 
-	enable_irq_wake(client->irq);
+	ret = devm_device_init_wakeup(dev);
+	if (ret < 0)
+		goto out_charger;
+
+	ret = devm_pm_set_wake_irq(dev, client->irq);
+	if (ret < 0)
+		goto out_charger;
 
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
-- 
2.53.0



