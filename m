Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4380D3A1B6;
	Mon, 14 Oct 2024 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919527; cv=none; b=KY/+xCdLNe8PU1023tDaXtlZ1Cf6YYnOA9wDi4OE7AjjUDb3gn6OdDOkvUmX9rknl39jbn+DxnlF26gfaSvJhZA4u6t2GRASunVBKFqNIaFCZgsD26qLvdZbPd/VukadF1mJHJyoR7Af24yqb2i11CFGysgOjv6FQnsn8KosLX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919527; c=relaxed/simple;
	bh=19mGbdggNrfQOe1W1I3NvUGQpyj3/EZGAGRgCc1IuoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/QAReMcb24+C5HtZK0h+58oPWdLAG7jESDEkbIv5vKh+Qg1alNmvXi/lPiuiEtHeLW+3hWjGwuSNrBiKnbEHqZEK6oCjKEQSr6ntEN06AzP37VQcMRrXtaQcrjRD02bWDxbJQ3UkGWNncwTy45Exj71KiqJZJ9S39grHDyUTEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMOc5yhy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMOc5yhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69918C4CEC3;
	Mon, 14 Oct 2024 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919526;
	bh=19mGbdggNrfQOe1W1I3NvUGQpyj3/EZGAGRgCc1IuoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMOc5yhyfJuseVqQY2RXkSeuY3ryt0RBhpwX7sDv8GsiLDo/iaWexQd44CodYYh8t
	 oly6Ciql2NnrFhkEvqh+iQA/iJzh64QkcopLPcedaSkPlFa9rWL5vCOvb0OmxMJgmB
	 zUGY2BdfkVXWJ8eaai6sYBvvRv7SECnh+T7JSQ8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 600/798] Input: adp5589-keys - fix adp5589_gpio_get_value()
Date: Mon, 14 Oct 2024 16:19:14 +0200
Message-ID: <20241014141241.575182860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit c684771630e64bc39bddffeb65dd8a6612a6b249 upstream.

The adp5589 seems to have the same behavior as similar devices as
explained in commit 910a9f5636f5 ("Input: adp5588-keys - get value from
data out when dir is out").

Basically, when the gpio is set as output we need to get the value from
ADP5589_GPO_DATA_OUT_A register instead of ADP5589_GPI_STATUS_A.

Fixes: 9d2e173644bb ("Input: ADP5589 - new driver for I2C Keypad Decoder and I/O Expander")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20241001-b4-dev-adp5589-fw-conversion-v1-2-fca0149dfc47@analog.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/adp5589-keys.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -391,10 +391,17 @@ static int adp5589_gpio_get_value(struct
 	struct adp5589_kpad *kpad = gpiochip_get_data(chip);
 	unsigned int bank = kpad->var->bank(kpad->gpiomap[off]);
 	unsigned int bit = kpad->var->bit(kpad->gpiomap[off]);
+	int val;
 
-	return !!(adp5589_read(kpad->client,
-			       kpad->var->reg(ADP5589_GPI_STATUS_A) + bank) &
-			       bit);
+	mutex_lock(&kpad->gpio_lock);
+	if (kpad->dir[bank] & bit)
+		val = kpad->dat_out[bank];
+	else
+		val = adp5589_read(kpad->client,
+				   kpad->var->reg(ADP5589_GPI_STATUS_A) + bank);
+	mutex_unlock(&kpad->gpio_lock);
+
+	return !!(val & bit);
 }
 
 static void adp5589_gpio_set_value(struct gpio_chip *chip,


