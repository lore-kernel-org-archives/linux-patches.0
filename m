Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047783;
	b=JwB2NBTNBUv8dvf4X6+Op+IxRolJV4LzoJtvB8lllHPQsGYednSCdHGzs7mIIWH6CT4k
	 8kluqkdkXmaxL9nnhmT6wy4mdI+4oQWxzie/wsnWhqxD1Y+LwzJDpHrDCe8AXdeGOpgdI
	 xpfoswdbNlXyilJeHNLZ9XDNSJB3qsdTpJbhfD+DiXa5zlQjas8tcPPFMmvuj885DAgtg
	 xe/CEG8hsSI/dGfdZeXn8F39QE+ZzWeHay0k70VM85bHGatepQV7G12cJ6PwW3WdCWiDS
	 ETGiMjqaDeatnRcIbL6KphBVDvkxfsVZgNzcz6hiamw0slnrfmccnwtfcUL5d8UpHIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tKR5dFlbhLNUBxidoo0XQjyDtFKTxcHFNxL89Ke0+f4=;
	b=aOf4VGLInLLMNAj7tFzeaQkNW+30e6TyT6t+JDWHYmKqBEHNjIprCCyL0IgVU9mqAQ86
	 SciZJzxHD4ECrjFkvXCZv56i+EVXnpNyoCUPZJmqs6MtOscVI5FIQHhTQ2bZTczKMe8+6
	 D1RKAbLfAWbQCq82ZCkdauW/N8uKwtRc8UZOX59oSoKUq0998rgx1ZpbPoEpf1J2trZBQ
	 uqT9Qzf8WuDAhBM7IwtuJjpm+ri722GoDbJgnGvkeerTr3WXy5G5FhXHG0ZihcpS5kLwn
	 iHObBdKPHkqYq01mbaVyVO8ZM+UUJbWq3qXEvssV8BJ/kK5dYQ29Okw+bZoud1cDSRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCc5NXxA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4406606A32C;
	Thu, 19 Nov 2026 00:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mCc5NXxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B771F000C4;
	Thu, 19 Nov 2026 00:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047783;
	bh=tKR5dFlbhLNUBxidoo0XQjyDtFKTxcHFNxL89Ke0+f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCc5NXxA73ZisRS/DU7vHZVasNKB2R7SwDxwTaPHKkXzTBIMWHi86ELXUKZaRbQhL
	 e1yK18ebF7uu7eifAYph8twQDBFSUuTmLt655S/Kt1Y+rEZgLZqXOb/93xnLP3Xel/
	 tc76suZi7rQ9hURaIcgy9zu3Hg3t5MZNB5zvxK0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1761/2857] pwm: renesas-tpu: Fix runtime PM reference leak
Date: Wed, 18 Nov 2026 15:46:35 +0100
Message-ID: <20261118150304.695355523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 62cff15fbf2b12ebbb0b01ca720030c2bc12aed1 ]

tpu_pwm_timer_start() used pm_runtime_get_sync() without checking its
return value before touching the TPU clock.  A failed runtime resume was
therefore ignored, and the callback continued into register access.

Use pm_runtime_resume_and_get() and propagate a failed resume.  Keep the
matching put when clock preparation fails after a successful resume.

tpu_pwm_disable() also needs to propagate a failed start so that the PWM
apply callback does not access registers while runtime PM is inactive.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 99b82abb0a35 ("pwm: Add Renesas TPU PWM driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260814134143.1388120-1-ruoyuw560@gmail.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-renesas-tpu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 613dd549edf8f..d67b1eecee990 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -148,10 +148,14 @@ static int tpu_pwm_timer_start(struct tpu_pwm_device *tpd)
 
 	if (!tpd->timer_on) {
 		/* Wake up device and enable clock. */
-		pm_runtime_get_sync(&tpd->tpu->pdev->dev);
+		ret = pm_runtime_resume_and_get(&tpd->tpu->pdev->dev);
+		if (ret < 0)
+			return ret;
+
 		ret = clk_prepare_enable(tpd->tpu->clk);
 		if (ret) {
 			dev_err(&tpd->tpu->pdev->dev, "cannot enable clock\n");
+			pm_runtime_put(&tpd->tpu->pdev->dev);
 			return ret;
 		}
 		tpd->timer_on = true;
@@ -381,15 +385,21 @@ static int tpu_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	return 0;
 }
 
-static void tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
+static int tpu_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct tpu_device *tpu = to_tpu_device(chip);
 	struct tpu_pwm_device *tpd = &tpu->tpd[pwm->hwpwm];
+	int ret;
 
 	/* The timer must be running to modify the pin output configuration. */
-	tpu_pwm_timer_start(tpd);
+	ret = tpu_pwm_timer_start(tpd);
+	if (ret < 0)
+		return ret;
+
 	tpu_pwm_set_pin(tpd, TPU_PIN_INACTIVE);
 	tpu_pwm_timer_stop(tpd);
+
+	return 0;
 }
 
 static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
@@ -400,7 +410,10 @@ static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	if (state->polarity != pwm->state.polarity) {
 		if (enabled) {
-			tpu_pwm_disable(chip, pwm);
+			err = tpu_pwm_disable(chip, pwm);
+			if (err)
+				return err;
+
 			enabled = false;
 		}
 
@@ -411,7 +424,7 @@ static int tpu_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	if (!state->enabled) {
 		if (enabled)
-			tpu_pwm_disable(chip, pwm);
+			return tpu_pwm_disable(chip, pwm);
 
 		return 0;
 	}
-- 
2.53.0



