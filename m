Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74151BE223;
	Tue,  2 Jul 2024 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941176; cv=none; b=iiPwO1tGahwlN8gYu3zwJ65n7KdSp0gZlUBw2U16+pNDZjKkoNDNuoBdBttRVO/Bt6i9CUilNMEZLM2bGZN+U2uvhomoI9cukGliXDlNKo0eYkrkNlgUz566ovDqhar6bWffcqH//6pIIFqoQPxLHZj01jFf2rtzgNO9c7UtFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941176; c=relaxed/simple;
	bh=nY0X2K5NZcoCXMH3I4H9r1PMC5Y22lBKyxmKeYwAlzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8q34OyP2XwZQ0BGjOgH4WoWOnZYdn9DcxTmQNSKL6FRDyF1h9fPKWWfQGQ7+YPEH2lH140E8NqdjTr9nP8e39bSxTep9vUApUKJf21g1L0D4pV57hIUkA90Y3GNheBOd8v0F5lI8VtgcpM2z73gp5t0WUbeZFmcBX1ijzjQAvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qV3YQMue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qV3YQMue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBC0C4AF0A;
	Tue,  2 Jul 2024 17:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941176;
	bh=nY0X2K5NZcoCXMH3I4H9r1PMC5Y22lBKyxmKeYwAlzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qV3YQMuerVQBcPhth9NqgfaZqa2sQKjxOnzs6kWMSjJW6bITg6Wdeo5y6xhIcY7Sq
	 K0g6q3+HjWIU6mBI3mpWAPTtIJKe8h2lyKtVrcKSnxNR14hV+uLtEjjYroX5fiuT+a
	 c0iqIFHTWzIiB/KKCrJy2p23tmxTP+erKoEw3VMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.6 151/163] pwm: stm32: Refuse too small period requests
Date: Tue,  2 Jul 2024 19:04:25 +0200
Message-ID: <20240702170238.778033678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit c45fcf46ca2368dafe7e5c513a711a6f0f974308 upstream.

If period_ns is small, prd might well become 0. Catch that case because
otherwise with

	regmap_write(priv->regmap, TIM_ARR, prd - 1);

a few lines down quite a big period is configured.

Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Cc: stable@vger.kernel.org
Reviewed-by: Trevor Gamblin <tgamblin@baylibre.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/b86f62f099983646f97eeb6bfc0117bb2d0c340d.1718979150.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pwm/pwm-stm32.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -344,6 +344,9 @@ static int stm32_pwm_config(struct stm32
 
 	prd = div;
 
+	if (!prd)
+		return -EINVAL;
+
 	if (prescaler > MAX_TIM_PSC)
 		return -EINVAL;
 


