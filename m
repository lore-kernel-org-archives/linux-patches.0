Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2342D3F44D0;
	Wed, 20 May 2026 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296605; cv=none; b=Zw4EBT/lgRTU4U6LwfTJRE0Mu/fCy3+UMk+ycAiVvRU664ZMiDkQGle2P9xcEPlWG/0JsRBI8Z+1MboGIARfe77V+FJX+ly8qBepqSew72Y9fJtELu1pB5idG90HB3J4wiTzjziPr9nYh0d5Fz15z+lydMnwu+SPL5FNb+T89Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296605; c=relaxed/simple;
	bh=YoZha9X8XhWC0pS4AkufhPjDCW6vI3mcQNHoiQGsUuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s3iJRfI7zzx5ImJE6vPBulrqGGsWjUeftNu4g2ciURwAkGF2QlpV7+fpUOr93VkgP3fbM4aoyGmVLpy7cJQLY7pvxA7xXJxLOwYWkxlwbJ2PF0I+/pIiBiwnjnsW764K9cYY24c3jJJZK3xEjL1SiSY7hC3ithtAVRIZp4vNnUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVzU65U/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVzU65U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D121F000E9;
	Wed, 20 May 2026 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296603;
	bh=zXXqCjRTo60HE97/8SHLZH+RjROAR32zyQHqwK5Mv1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jVzU65U/1xTau+e7UaAVfd0sKcUhNEIz7Yxw8oQSfd7a95saFhY6vLN5C4R4jd5zn
	 mPPpx5b9yvQfvDb+sqFL2ny2S6pAs5/Wr8ONXH3s5iWlKp8wwffWkZzrNjmnDw/3dV
	 FrbNL4HRPJlbrwysM83p4F64N7KXTeL1QGh0cCNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0825/1146] pwm: atmel-tcb: Cache clock rates and mark chip as atomic
Date: Wed, 20 May 2026 18:17:55 +0200
Message-ID: <20260520162206.902761026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sangyun Kim <sangyun.kim@snu.ac.kr>

[ Upstream commit 68637b68afcc3cb4d56aca14a3a1d1b47b879369 ]

atmel_tcb_pwm_apply() holds tcbpwmc->lock as a spinlock via
guard(spinlock)() and then calls atmel_tcb_pwm_config(), which calls
clk_get_rate() twice. clk_get_rate() acquires clk_prepare_lock (a
mutex), so this is a sleep-in-atomic-context violation.

On CONFIG_DEBUG_ATOMIC_SLEEP kernels every pwm_apply_state() that
enables or reconfigures the PWM triggers a "BUG: sleeping function
called from invalid context" warning.

Acquire exclusive control over the clock rates with
clk_rate_exclusive_get() at probe time and cache the rates in struct
atmel_tcb_pwm_chip, then read the cached rates from
atmel_tcb_pwm_config(). This keeps the spinlock-based mutual exclusion
introduced in commit 37f7707077f5 ("pwm: atmel-tcb: Fix race condition
and convert to guards") and removes the sleeping calls from the atomic
section.

With no sleeping calls left in .apply() and the regmap-mmio bus already
running with fast_io=true, also mark the chip as atomic so consumers
can use pwm_apply_atomic() from atomic context.

Fixes: 37f7707077f5 ("pwm: atmel-tcb: Fix race condition and convert to guards")
Signed-off-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Link: https://patch.msgid.link/20260419080838.3192357-1-sangyun.kim@snu.ac.kr
[ukleinek: Ensure .clk is enabled before calling clk_get_rate on it.]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 38 +++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index f9ff78ba122d4..3d30aeab507e0 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -50,6 +50,8 @@ struct atmel_tcb_pwm_chip {
 	spinlock_t lock;
 	u8 channel;
 	u8 width;
+	unsigned long rate;
+	unsigned long slow_rate;
 	struct regmap *regmap;
 	struct clk *clk;
 	struct clk *gclk;
@@ -266,7 +268,7 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	int slowclk = 0;
 	unsigned period;
 	unsigned duty;
-	unsigned rate = clk_get_rate(tcbpwmc->clk);
+	unsigned long rate = tcbpwmc->rate;
 	unsigned long long min;
 	unsigned long long max;
 
@@ -294,7 +296,7 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	 */
 	if (i == ARRAY_SIZE(atmel_tcb_divisors)) {
 		i = slowclk;
-		rate = clk_get_rate(tcbpwmc->slow_clk);
+		rate = tcbpwmc->slow_rate;
 		min = div_u64(NSEC_PER_SEC, rate);
 		max = min << tcbpwmc->width;
 
@@ -431,24 +433,49 @@ static int atmel_tcb_pwm_probe(struct platform_device *pdev)
 	}
 
 	chip->ops = &atmel_tcb_pwm_ops;
+	chip->atomic = true;
 	tcbpwmc->channel = channel;
 	tcbpwmc->width = config->counter_width;
 
-	err = clk_prepare_enable(tcbpwmc->slow_clk);
+	err = clk_prepare_enable(tcbpwmc->clk);
 	if (err)
 		goto err_gclk;
 
+	err = clk_prepare_enable(tcbpwmc->slow_clk);
+	if (err)
+		goto err_disable_clk;;
+
+	err = clk_rate_exclusive_get(tcbpwmc->clk);
+	if (err)
+		goto err_disable_slow_clk;
+
+	err = clk_rate_exclusive_get(tcbpwmc->slow_clk);
+	if (err)
+		goto err_clk_unlock;
+
+	tcbpwmc->rate = clk_get_rate(tcbpwmc->clk);
+	tcbpwmc->slow_rate = clk_get_rate(tcbpwmc->slow_clk);
+
 	spin_lock_init(&tcbpwmc->lock);
 
 	err = pwmchip_add(chip);
 	if (err < 0)
-		goto err_disable_clk;
+		goto err_slow_clk_unlock;
 
 	platform_set_drvdata(pdev, chip);
 
 	return 0;
 
+err_slow_clk_unlock:
+	clk_rate_exclusive_put(tcbpwmc->slow_clk);
+
+err_clk_unlock:
+	clk_rate_exclusive_put(tcbpwmc->clk);
+
 err_disable_clk:
+	clk_disable_unprepare(tcbpwmc->clk);
+
+err_disable_slow_clk:
 	clk_disable_unprepare(tcbpwmc->slow_clk);
 
 err_gclk:
@@ -470,6 +497,9 @@ static void atmel_tcb_pwm_remove(struct platform_device *pdev)
 
 	pwmchip_remove(chip);
 
+	clk_rate_exclusive_put(tcbpwmc->slow_clk);
+	clk_rate_exclusive_put(tcbpwmc->clk);
+	clk_disable_unprepare(tcbpwmc->clk);
 	clk_disable_unprepare(tcbpwmc->slow_clk);
 	clk_put(tcbpwmc->gclk);
 	clk_put(tcbpwmc->clk);
-- 
2.53.0



