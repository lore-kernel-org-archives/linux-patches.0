Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C950778B60;
	Wed, 21 Feb 2024 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525703; cv=none; b=AFhTDUSIXH3Zm9FjkCgMSNyL7DZiuqnEgPPaq0vI1X15qR6f8la1WJJtVBkArhp/GWqg5ZMNFHa+/EcP8gl0ZV2EJjOtDZyLqJczbqwhZtkWx4plA/qj+fpdNpjm4TN7H4opOGITShRogdzWimgtOoMFZ2hVk6B9Th1uulb2d1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525703; c=relaxed/simple;
	bh=PsWx67MgcIOWraVCNN8DeCUtfNER5L0oWqWwSOuPDMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUks4d/+ba5KXk66a6Y9WlHxSoD3Jo6dQctOJMHmr258xJTIxfR47QFjydYaB62V40umw42U9gw4++IAzdtT2mqphXazxmTorBk8uISm4dSc6n4cP5uok32k0GJ+eSArlLZNWa7HvjcztPYfGdxpSWJrh+TlxlWc0yX0OrV8AOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b82T4Fo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b82T4Fo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389A8C433F1;
	Wed, 21 Feb 2024 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525703;
	bh=PsWx67MgcIOWraVCNN8DeCUtfNER5L0oWqWwSOuPDMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b82T4Fo3t9Hpg0yTwUaFpOWPrxakK7Uoup2VIEs7PkhspLQYeZDKiF8JsF9NGnh3P
	 oIG21jO537SVaID/yOTKrcmjezIxeUGHAmYZimq96ZTaesVfXmAjNi+ZDAyJc1mwNG
	 lo1Z/5eel+CJ7B0XaQT3T1ce4SxYdfvRTESZyxgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 238/267] mmc: slot-gpio: Allow non-sleeping GPIO ro
Date: Wed, 21 Feb 2024 14:09:39 +0100
Message-ID: <20240221125947.727852825@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -63,11 +63,15 @@ int mmc_gpio_alloc(struct mmc_host *host
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
 


