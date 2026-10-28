Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210655;
	b=cf4Y9hyr8kOxjfLwkdNaloUpkze7nW//8Gg5HMF9pbPTLdffanPqN3YexRKiSLLyPkny
	 1lRiml5CDrq4tNEP/UoWBtDyMd6FxfosQZluXymAEtJqsrBgN/WYY8kXCAyIoZE01Gv0f
	 ZiJxJJb01SPaLjdwkfCHIYvxf+r3nlbVe8+gLFtmyW86n4h93fw4wuvovS6uauDHdH8hs
	 eq07AQG6NKmycqp5E7oEw/Isiahi5eXB/b//rNieRzUszYRGRfV2FrmXbx3lNuvlb8yGQ
	 Ydk9ZtthzPybLTnXO91b5zaFVS7R57okWnWTtKuF9/uoGKnsV+KMyFrgVREbAk4/KwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1KjigWWW0JUZQl6zB1k+TI6frurFgmE15HrekJaQeKs=;
	b=EjnkKK8yD0dBxFSWsabytAPxEuF/iJfJiJJvMlj39fGA18SdsXL77S0cuCNys8rJPwqB
	 49jUNAfrYq7YN0H9yu8zJeU2/+yXOy7rxld4AoYpCDJj5CmjHj64TU3jFFk2aVvM/fXSG
	 mCUoQDWc9XNmpT5IWO5+NQCaOzUF/NZ1tWbJwOw0D7ITAF6QlJqKrZD7WfYcklPuvJVLr
	 rF5naJmPfbw0vdmD4f9veRk+femSda50pyrl6XLjpxS34VoINcPUN36vcb1f3FPcZJOBS
	 hKRpuTdGOWlM2kjJ/0PEzlwzuwVujvpvd1dFIXVP4B4/mKO9oxkOeNbf1CDD3I91zjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tere61lH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426C5606A31A;
	Wed, 28 Oct 2026 18:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tere61lH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925401F031E2;
	Wed, 28 Oct 2026 18:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210655;
	bh=1KjigWWW0JUZQl6zB1k+TI6frurFgmE15HrekJaQeKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tere61lHw0CjX/w+6FPGwu/4yCJdTy1/2/ccyqdA/qo7VhMbNrWwmajwbmf93ehnP
	 GHalrFqkz9yPf0a4T3bTwLjcfBwhYGraxLxsoE1ymi4Y2Kje6xcThNn651QgCUDuge
	 1KuxSnOcE/n0A4fAN4IH5L4eOv6C/2z9eGu2PYRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/571] hwmon: (pwm-fan) Stop RPM timer before freeing tach data
Date: Wed, 28 Oct 2026 17:54:09 +0100
Message-ID: <20261028170010.441293400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Yibo Tan <lhfff@tju.edu.cn>

[ Upstream commit 26d5ff79768548efb1e604bb6e8697c101e06269 ]

sample_timer() rearms the RPM timer and accesses the devm-managed
ctx->tachs and ctx->pulses_per_revolution arrays. The cleanup action
which stops the timer is registered before those arrays are allocated.

Since devres releases entries in reverse order, driver detach can free
the arrays before pwm_fan_cleanup() shuts down the timer. A timer expiry
in that window accesses the freed tach data.

With a KASAN kernel, a test-only kprobe delayed entry to
pwm_fan_cleanup() while normal sysfs unbind ran. Each of three runs
reported three four-byte reads and two four-byte writes in sample_timer()
after its backing devm allocations had been freed. The helper did not
invoke the timer callback, cleanup actions or free functions.

With the fix, three matching unbind runs completed without KASAN, BUG,
WARNING, Oops or panic. Instrumentation confirmed that timer retirement
completed before the first timer backing allocation was released.

Split timer retirement from the power cleanup and register its devres
action after the timer backing data and IRQ actions are installed. This
preserves the early power rollback action while ensuring the timer is
retired before its backing data is released. Use timer_shutdown_sync()
because the callback can rearm itself.

Fixes: 01695410d452 ("hwmon: (pwm-fan) Store tach data separately")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Link: https://patch.msgid.link/20260911071809.130151-1-lhfff@tju.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ adapted cleanup changes to the older pwm_fan_pwm_disable() and pwm_fan_shutdown() implementations. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pwm-fan.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index f12b9a28a232d..05ba32d44230e 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -291,7 +291,13 @@ static void pwm_fan_pwm_disable(void *__ctx)
 
 	ctx->pwm_state.enabled = false;
 	pwm_apply_state(ctx->pwm, &ctx->pwm_state);
-	del_timer_sync(&ctx->rpm_timer);
+}
+
+static void pwm_fan_timer_cleanup(void *__ctx)
+{
+	struct pwm_fan_ctx *ctx = __ctx;
+
+	timer_shutdown_sync(&ctx->rpm_timer);
 }
 
 static int pwm_fan_probe(struct platform_device *pdev)
@@ -424,6 +430,10 @@ static int pwm_fan_probe(struct platform_device *pdev)
 	}
 
 	if (ctx->tach_count > 0) {
+		ret = devm_add_action_or_reset(dev, pwm_fan_timer_cleanup, ctx);
+		if (ret)
+			return ret;
+
 		ctx->sample_start = ktime_get();
 		mod_timer(&ctx->rpm_timer, jiffies + HZ);
 
@@ -490,6 +500,9 @@ static int pwm_fan_disable(struct device *dev)
 
 static void pwm_fan_shutdown(struct platform_device *pdev)
 {
+	struct pwm_fan_ctx *ctx = platform_get_drvdata(pdev);
+
+	pwm_fan_timer_cleanup(ctx);
 	pwm_fan_disable(&pdev->dev);
 }
 
-- 
2.53.0



