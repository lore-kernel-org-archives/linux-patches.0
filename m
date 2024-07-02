Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C5581F;
	Tue,  2 Jul 2024 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940600; cv=none; b=I2iQ/g1NMvBbSAdzo/RZ7hDqAyIcUKr3zqZAYBmSGvk8C0CxQ+Kse7NrVlh9cGJAc7ZWKMuVGfkxRhLYjWNUUmwxi9Lgp7HHFWM5BDjw12A6UapPaD9KJWn+ZheX6rEvjLP4P+qp9sVQEyhGbPz6CR31KZTvPKqYBHq4hIW6kkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940600; c=relaxed/simple;
	bh=0lqckJxqI8HDIuP+TlfVDgGqhaud15KaZATOkqvFwXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bBBAOQ/Acww94AzUsURtdPk/apBoiR6UnyUcKPj0i5QOZu/Z641LjeNXCgchT9XM9pfWF4OoOpKuLxQSTXY+SDgEozCNUw8qNnkhWAEWDsx0xN1Dqz9Kf7+9WH8rReHviIjuGmaq1r/ylyj/CyJNzi0mcJATYqi/59mcUVlcFU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skqkuxhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skqkuxhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910CDC4AF0A;
	Tue,  2 Jul 2024 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940600;
	bh=0lqckJxqI8HDIuP+TlfVDgGqhaud15KaZATOkqvFwXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skqkuxhvoqwHFY8ikSll1NWLpje5E3LRqcN+mf3OSPhxgs6KSlsXy0ihrAMoqCrJf
	 7v7ifm4fkr+SWo8Jv0Xqd5IvKDcv7Z+uoJiuPE3LG/ja+cwW5MdPZfiyzkhNLnQNlT
	 D994VJT3p40d7dvfwzxVZ0H8XGG5LNBuFyl63vyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.9 203/222] pwm: stm32: Fix calculation of prescaler
Date: Tue,  2 Jul 2024 19:04:01 +0200
Message-ID: <20240702170251.745545326@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit dab8f9f0fe3aada61c0eb013dcf7d3ff75a2c336 upstream.

A small prescaler is beneficial, as this improves the resolution of the
duty_cycle configuration. However if the prescaler is too small, the
maximal possible period becomes considerably smaller than the requested
value.

One situation where this goes wrong is the following: With a parent
clock rate of 208877930 Hz and max_arr = 0xffff = 65535, a request for
period = 941243 ns currently results in PSC = 1. The value for ARR is
then calculated to

	ARR = 941243 * 208877930 / (1000000000 * 2) - 1 = 98301

This value is bigger than 65535 however and so doesn't fit into the
respective register field. In this particular case the PWM was
configured for a period of 313733.4806027616 ns (with ARR = 98301 &
0xffff). Even if ARR was configured to its maximal value, only period =
627495.6861167669 ns would be achievable.

Fix the calculation accordingly and adapt the comment to match the new
algorithm.

With the calculation fixed the above case results in PSC = 2 and so an
actual period of 941229.1667195285 ns.

Fixes: 8002fbeef1e4 ("pwm: stm32: Calculate prescaler with a division instead of a loop")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b4d96b79917617434a540df45f20cb5de4142f88.1718979150.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-stm32.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -321,17 +321,23 @@ static int stm32_pwm_config(struct stm32
 	 * First we need to find the minimal value for prescaler such that
 	 *
 	 *        period_ns * clkrate
-	 *   ------------------------------
+	 *   ------------------------------ < max_arr + 1
 	 *   NSEC_PER_SEC * (prescaler + 1)
 	 *
-	 * isn't bigger than max_arr.
+	 * This equation is equivalent to
+	 *
+	 *        period_ns * clkrate
+	 *   ---------------------------- < prescaler + 1
+	 *   NSEC_PER_SEC * (max_arr + 1)
+	 *
+	 * Using integer division and knowing that the right hand side is
+	 * integer, this is further equivalent to
+	 *
+	 *   (period_ns * clkrate) // (NSEC_PER_SEC * (max_arr + 1)) ≤ prescaler
 	 */
 
 	prescaler = mul_u64_u64_div_u64(period_ns, clk_get_rate(priv->clk),
-					(u64)NSEC_PER_SEC * priv->max_arr);
-	if (prescaler > 0)
-		prescaler -= 1;
-
+					(u64)NSEC_PER_SEC * ((u64)priv->max_arr + 1));
 	if (prescaler > MAX_TIM_PSC)
 		return -EINVAL;
 


