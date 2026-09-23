Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1216B305687;
	Wed, 23 Sep 2026 14:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175067; cv=none; b=u8WfMTvt7UPQK/uIdj2O9wgVS5Qv6Bf5jjk/M/mx6R5E8I2PW700SiK/1YyzFqqBOvmrOufuvo5RFRPP9MLbNrqhRRV9Q3jO++YqZgsMeCCQG+v1f7H+eU+7Pdkrk1D102CaGawLy3QFsgL562JuDEMzVCPGsdlZNUt4EAJv8N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175067; c=relaxed/simple;
	bh=pCIC4u8h/dNZQSnE2En8r6pKpudRGR2SGjCvXvNwdGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7qhq1StnVIhpfadlz2YoXuDdFPaOk3EKjMBpvzxH2KqFiYYUohOyQcUOk0NHhOVfltXSRTFzh+/F5VmjtgnkHw+LQRbFwl7NzSzAW4k62BCPywr72jmGsaixWxRsDemlgBzsRkuyE9vpVOMK3jYw7qLviGuC8AkpVC7jCE+WsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StqGAp9C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StqGAp9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BF91F000FF;
	Wed, 23 Sep 2026 14:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175065;
	bh=P7BWeJ4IeuvN0xFXNWngvV+sLyqYVC7sqy/M63JbzWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StqGAp9Cv2q+X+M/+6MeOWVXcGHSJpS20J/je2cG8lr6HUiOZp2USyax1Y9AwODWd
	 umi0PscmSNNYbpqonCd9bX3+rUbAwLLV7NB0VL7qPG8zeG0G4PA5y8RfZIAAlUQ1+Z
	 7Gofllt2D2pbl9P2UbkuO6pDgAPi4QUt/1ljjve8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 310/398] hwmon: (pwm-fan) Stop RPM timer before freeing tach data
Date: Wed, 23 Sep 2026 16:06:24 +0200
Message-ID: <20260923140651.463104825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yibo Tan <lhfff@tju.edu.cn>

commit 26d5ff79768548efb1e604bb6e8697c101e06269 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pwm-fan.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -484,7 +484,6 @@ static void pwm_fan_cleanup(void *__ctx)
 {
 	struct pwm_fan_ctx *ctx = __ctx;
 
-	timer_delete_sync(&ctx->rpm_timer);
 	if (ctx->pwm_shutdown) {
 		ctx->enable_mode = pwm_enable_reg_enable;
 		__set_pwm(ctx, ctx->pwm_shutdown);
@@ -495,6 +494,13 @@ static void pwm_fan_cleanup(void *__ctx)
 	}
 }
 
+static void pwm_fan_timer_cleanup(void *__ctx)
+{
+	struct pwm_fan_ctx *ctx = __ctx;
+
+	timer_shutdown_sync(&ctx->rpm_timer);
+}
+
 static int pwm_fan_probe(struct platform_device *pdev)
 {
 	struct thermal_cooling_device *cdev;
@@ -649,6 +655,10 @@ static int pwm_fan_probe(struct platform
 	}
 
 	if (ctx->tach_count > 0) {
+		ret = devm_add_action_or_reset(dev, pwm_fan_timer_cleanup, ctx);
+		if (ret)
+			return ret;
+
 		ctx->sample_start = ktime_get();
 		mod_timer(&ctx->rpm_timer, jiffies + HZ);
 
@@ -704,6 +714,7 @@ static void pwm_fan_shutdown(struct plat
 {
 	struct pwm_fan_ctx *ctx = platform_get_drvdata(pdev);
 
+	pwm_fan_timer_cleanup(ctx);
 	pwm_fan_cleanup(ctx);
 }
 


