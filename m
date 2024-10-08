Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04E61C9B99;
	Tue,  8 Oct 2024 13:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392677; cv=none; b=qtuYkrBH1nXZP/7OvYKWE0lYftGvRYftDXHl3yv/+dblVzK3Tw9mqD9hYCLkGlNVpcWnzMAZK6uVkFAXHaInPwTO3VpKyDmikYzaQmp4VQ6OfBggLVT29xc8H3Q5OBCGDVpywRS32hq4BLOZWzRzBepH0HunR3wqd3kw61PEtms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392677; c=relaxed/simple;
	bh=6Cfp7QJXPS2yB6HheS3e4uUqzpR+YTV6/RrV+OninCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtnWRb6ppm9/XITvUql8WLxGV/zuMTmQLZk0O7aWhE+7m9Ii8cMyWanKUXjVTR4OkAIPPxvqR1ZAiAI1STRkaJc/WSgwZc9O3cT1MMFtsDBkmH3252iDXs2Me8pQ8d3NI9hYQ4q25imsbM0xPOQO3RMDMrW/UfedLyqWcuL9wNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urU8DuKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urU8DuKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7D7C4CEC7;
	Tue,  8 Oct 2024 13:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392677;
	bh=6Cfp7QJXPS2yB6HheS3e4uUqzpR+YTV6/RrV+OninCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urU8DuKhT6HsbcQgoiaOX6A1RvPIyDfbcEbENe6SY+ya5KImMGxSgCXKIqdzUnpNc
	 qcz9btzseReO7ni+R7Gx4JLFgNS6wtHF9f9vmTVP9UjLOWOQCv97Cdv2+Rl5/vACRN
	 /6J2+uyVRbQNADRDgLxCBO6WgV0MOpDmI0bGKI7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.11 487/558] Input: adp5589-keys - fix adp5589_gpio_get_value()
Date: Tue,  8 Oct 2024 14:08:37 +0200
Message-ID: <20241008115721.398091232@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


