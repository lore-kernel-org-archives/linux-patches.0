Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171CF16F8F5;
	Wed,  3 Jul 2024 11:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006232; cv=none; b=qyHQ4tTLuKAeJXCSHv30xHNKnx+YqP9G4g+0TMiTNGu4I7EEx+GsFQeROi2BDV07jyLiXu+HWz8SWRSOwrfuwHw8qOKRN2tDhnkFkQ8hpBvyB0uqIUkS6Wf2jtBnpTpNT2js2n+Qxe1/2DxtXpMwRmgI3gh47rmYPe/5yt7xmUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006232; c=relaxed/simple;
	bh=4/rif0SUItyAahyXQi9BZ+MM0SlJQ/XN5ZXpRKxDU3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nxePEoVGw6b7uqJScA+kWILM+NSXuygROE8oT5kKUK9o3HZ9h6nSiDsddEskH96XDDU299CPdok3TJgq3CO+ipeHXSb9c33msuP+KMh2/Nby9wsHU7dSrG9H/b+NSdB5jz6BQrLT0KvG4wqQfIz0zcIRHR5w+2kidTG/FVWr/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb3HDauG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb3HDauG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9188AC2BD10;
	Wed,  3 Jul 2024 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006232;
	bh=4/rif0SUItyAahyXQi9BZ+MM0SlJQ/XN5ZXpRKxDU3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tb3HDauGT5vOGWoGNnHCywiMC7tNtLLoxDsDWzeJvCDu73oNIk/HlGqBfWiUvvLNv
	 Pfy/7jMN9CvS3z+8C98JU07W/mhnpK4MlQBCBZil2e7Y2to8ZwBZhhiLDbmMJM8dqI
	 cGFB2oVKM2tB5eMZ4i1qLVdyWuYhY56TcKzTgFQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.15 343/356] pwm: stm32: Refuse too small period requests
Date: Wed,  3 Jul 2024 12:41:19 +0200
Message-ID: <20240703102926.088482987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -340,6 +340,9 @@ static int stm32_pwm_config(struct stm32
 
 	prd = div;
 
+	if (!prd)
+		return -EINVAL;
+
 	if (prescaler > MAX_TIM_PSC)
 		return -EINVAL;
 


