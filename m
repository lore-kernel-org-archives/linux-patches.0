Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E096F612D7;
	Tue, 20 Feb 2024 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463919; cv=none; b=oznB+fZRe9tg+/EgvwE93ELD4Xlpe1pjk4qIjKgHm1T3ytxqPmlqk371mnTFb1f/80ixieKVbqmdfqFY+TMCmEqaMPRuLMYlZvIN2qAFj2ShYzoWdHo/NvwDU41CHgwZLnPcclEI41EW41vAXwInf3STZTFCT/U43ClH5YhdM7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463919; c=relaxed/simple;
	bh=lKmZMQrY96zjNcBPLHh2rEh4FraAVqu7qSeyVc9T2fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C51co0DQVc7G+yRce6Z5IWAFySmz7ndeneZgX7Ongj+PSaIzj1UNEdLVeYXTWrBgOJfiasDXFCSH6EvMOi2hkeapK1J8PPDEJdS1J4KgZd6fHz7mRi88dV1rUR069M0TegYDcrbiW4Xte9LPYza6oSxAomghaY7sxvLTzu3uIgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hVtRN2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hVtRN2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48186C43390;
	Tue, 20 Feb 2024 21:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463918;
	bh=lKmZMQrY96zjNcBPLHh2rEh4FraAVqu7qSeyVc9T2fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hVtRN2RNkAmBnrTa+iZI83W/GzmR+VWlEjHS3qb38sVoK3hRmlf5otlzj1EagraZ
	 l72wHuethv1Dl8Hmk5etOBlGLDbVcquhR5yUKsvrHfnxiVDKNIjfC3qcYxV1/3rqZp
	 Dez/1wtFCR/KzQIwZAB60tMkcGJi8mkJD8CUBwaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 195/331] mmc: slot-gpio: Allow non-sleeping GPIO ro
Date: Tue, 20 Feb 2024 21:55:11 +0100
Message-ID: <20240220205643.721149934@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -75,11 +75,15 @@ EXPORT_SYMBOL(mmc_gpio_set_cd_irq);
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
 


