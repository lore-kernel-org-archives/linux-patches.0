Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3F617DA3A;
	Wed,  3 Jul 2024 11:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005149; cv=none; b=j510Wc1gW5rK3ijV/2+uH/3kSDAVhb7WSFPNo8/rWAVodvWLF4/eixIV6f0HBBBD68lin38bdVAutggRVSQTHlUYmbUZbixpbV44mhpbomrI0LdT8YUXUuBeM5MnmrrMXAWJQ7WpzyLJahqxAHFnvU9fSF5QqBs0y5ycOnWL3qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005149; c=relaxed/simple;
	bh=6hF5HMxdwmf5NdWFJh17Jms3Rr8ycG4RGQiQKdAQ03o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJbhzctyiKFmkhRq5/PZmaNpCncijyy/uSPmkTblCIFFekUblOwJDIQAtjmapeYCfNcZEPAiBeh1RDyds/0eVl/xl3O0NI9meOVfFd4GseVpe6I8rSjIorw0V3X+/f1CVEOiYJ1AhYtlTM0b/XJLp8l+8cED9E8r07ACdyqTEDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McM0F/ly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McM0F/ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5576FC2BD10;
	Wed,  3 Jul 2024 11:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005149;
	bh=6hF5HMxdwmf5NdWFJh17Jms3Rr8ycG4RGQiQKdAQ03o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McM0F/lyvMGkmRb8v8errcCkfQ6YTE3Bh7as6dKhwWv5foCrWYY/tjXUdI+xo6x8X
	 uQPbyFLFXd+I4K6cK+TD9D35n5AVk3KvtORWgluGbyuU8DdkUblhN9wh09wSeIdL1a
	 IZnpJRQDTyNwwZ+8YL9ozC+gTNwDwk3Q9sDMG4kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gamblin <tgamblin@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 5.10 277/290] pwm: stm32: Refuse too small period requests
Date: Wed,  3 Jul 2024 12:40:58 +0200
Message-ID: <20240703102914.612127162@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


