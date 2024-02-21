Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEA17BB1B;
	Wed, 21 Feb 2024 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523333; cv=none; b=a2jvm561HzHaSZ1tymq0/g8mDq+4xXYm+oEimk+8ueoiw7+Y3QijafMXUSyy9fLHQnHPe/tv8M4g8hmrxPJUAg/e02VpHj3Zvaa2o4qbnRO/fkMZR1XPBUr+CgrMPPtX5Ksv3OlUXRfOX19Hg1E+0JJ76apLZB/GMkcogFgpuTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523333; c=relaxed/simple;
	bh=ysisiLQFl+M7F/OKiGWKtcIsLaiWhgCUzOsGGqpEjD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tg33VP8TTrvPQmPVyMwSXWS1+aJZCbcekACeg2+ThEDiYFfAUGM4ahWxUldH5DF2Y34WRHUgkq3b7dGquD2dtTNqdhXl3sUJQ/HtdD9M0OspRXiizeOOU7Uwdpatb8W9aC57BJrxYUco+q4FQxQh0YDKwYnGy79Opmt3J+emIss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ve3b9qQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ve3b9qQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A19C43390;
	Wed, 21 Feb 2024 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523333;
	bh=ysisiLQFl+M7F/OKiGWKtcIsLaiWhgCUzOsGGqpEjD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ve3b9qQ2s2R47p9QGhe9HxTtKSANEPceI2mvGnDlIj7JI6hxk0pNTW+ggSvfr6TEM
	 BanoLMeiQy/D7EHcQVO+uLMe0fPhdJVsiqGjxKEC9aaN+Ltp0tcOA76qfDR4NAzzPG
	 36reo1tqC00xDoQ6BPfYIj6CO3LVYCS1U/f4Llf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 405/476] mmc: slot-gpio: Allow non-sleeping GPIO ro
Date: Wed, 21 Feb 2024 14:07:36 +0100
Message-ID: <20240221130022.968470154@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

commit cc9432c4fb159a3913e0ce3173b8218cd5bad2e0 upstream.

This change uses the appropriate _cansleep or non-sleeping API for
reading GPIO read-only state. This allows users with GPIOs that
never sleepbeing called in atomic context.

Implement the same mechanism as in commit 52af318c93e97 ("mmc: Allow
non-sleeping GPIO cd").

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240206083912.2543142-1-alexander.stein@ew.tq-group.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/slot-gpio.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -62,11 +62,15 @@ int mmc_gpio_alloc(struct mmc_host *host
 int mmc_gpio_get_ro(struct mmc_host *host)
 {
 	struct mmc_gpio *ctx = host->slot.handler_priv;
+	int cansleep;
 
 	if (!ctx || !ctx->ro_gpio)
 		return -ENOSYS;
 
-	return gpiod_get_value_cansleep(ctx->ro_gpio);
+	cansleep = gpiod_cansleep(ctx->ro_gpio);
+	return cansleep ?
+		gpiod_get_value_cansleep(ctx->ro_gpio) :
+		gpiod_get_value(ctx->ro_gpio);
 }
 EXPORT_SYMBOL(mmc_gpio_get_ro);
 


