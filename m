Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB2A29A2;
	Tue, 30 Jul 2024 15:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354859; cv=none; b=Q2+EQ5HbR9PczTjL0IaB4kIuQuP0Y65YmaG2Dhwsk1CFjxuhdtzEhfFuCpGUbQl6PEqB0yZpe8qnjHaM4xpo3qyREpWltDRNp8aLcCfzbezzLCC6OYKj8j/8ImRkpYPDEA9HT2lIsyOOb9We8KC3IQN8kZK3NynHBhM/lc6gcCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354859; c=relaxed/simple;
	bh=RenEk+FRNzjq/PmzDY2nZPKlgNXGkROhOHxu+kqzuqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IVepG+xzQVNYVLn1XrUzwBD74FhK+HrLe5t1ACp5rYOjAnOD4axpjNMbjQeDgSa6yZAXdBeHNZxzdR8JgqvKx4lcTPxERi57DQnnFCIlH8f3jTn0aIP1QYBZWbbw+j2ltDc+jfr80hoxwsQizXS/8bybSb57aY/OL6looSW3EOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFNNSAWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFNNSAWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D69C32782;
	Tue, 30 Jul 2024 15:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354858;
	bh=RenEk+FRNzjq/PmzDY2nZPKlgNXGkROhOHxu+kqzuqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFNNSAWQTMgIuY1q5nR6hUx08/W9GhyoaIv5YtIkvJJPqBTlZeS8g1WZqv2LDjIJu
	 gV1EBcXkX931nAyl48WFH4kNoPc0qq2jz+G+la/ivuCAtHHL6nQHFgF7+pwGMLt1Nm
	 JDxQxNjMBjCNmaUPR9Ddp1hwi6rpivx45sBCZ7zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/440] pwm: atmel-tcb: Unroll atmel_tcb_pwm_set_polarity() into only caller
Date: Tue, 30 Jul 2024 17:44:19 +0200
Message-ID: <20240730151616.788408987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 9a6ac822a2153d583b0da95b8693e954b5f4203a ]

atmel_tcb_pwm_set_polarity() is only called once and effectively wraps
an assignment only. Replace the function call by the respective
assignment.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 37f7707077f5 ("pwm: atmel-tcb: Fix race condition and convert to guards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-atmel-tcb.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index ae274bd7907dd..32a60d7f8ed2e 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -68,18 +68,6 @@ static inline struct atmel_tcb_pwm_chip *to_tcb_chip(struct pwm_chip *chip)
 	return container_of(chip, struct atmel_tcb_pwm_chip, chip);
 }
 
-static int atmel_tcb_pwm_set_polarity(struct pwm_chip *chip,
-				      struct pwm_device *pwm,
-				      enum pwm_polarity polarity)
-{
-	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
-	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
-
-	tcbpwm->polarity = polarity;
-
-	return 0;
-}
-
 static int atmel_tcb_pwm_request(struct pwm_chip *chip,
 				 struct pwm_device *pwm)
 {
@@ -357,11 +345,12 @@ static int atmel_tcb_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 static int atmel_tcb_pwm_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 			       const struct pwm_state *state)
 {
+	struct atmel_tcb_pwm_chip *tcbpwmc = to_tcb_chip(chip);
+	struct atmel_tcb_pwm_device *tcbpwm = &tcbpwmc->pwms[pwm->hwpwm];
 	int duty_cycle, period;
 	int ret;
 
-	/* This function only sets a flag in driver data */
-	atmel_tcb_pwm_set_polarity(chip, pwm, state->polarity);
+	tcbpwm->polarity = state->polarity;
 
 	if (!state->enabled) {
 		atmel_tcb_pwm_disable(chip, pwm);
-- 
2.43.0



