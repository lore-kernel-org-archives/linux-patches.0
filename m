Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C41A3AB286;
	Sat, 17 Oct 2026 16:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255472; cv=none; b=YMneZddB7Sp7br+BhF1GX0IxkLD4ZdQEmz8ng/gIT8TkSQuZn7FbdEZ9tZiN0CKE8ULGb/onCIALXRVInj6QXWj/ERiHQLksIk6L9ktD1BRny3BYpNzNCLu9brDL65lsPaFV4PPkexD5uFXlgojXKSvLE6zl9c5eNjQTCPQN0W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255472; c=relaxed/simple;
	bh=qKYVAQEe4aJKPqCsZyjFXrBPWyabE2RFxT4mBPaH9Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UBZXYSWx9VeBDva4fVrH4yQurmcHBYmZCmrSDXig7EysP8lVtP+vUOwwdLJ5QIZFnjwaoz5pa6zHhOSXq7q4euJOalHRdP5hwJM3czVGmzWtyxMJqfj+At+UTLv0wIaYGDqte3bBleX3EIARzz+TUnYdpSvHz3YJF6tM3ynNuDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdZIc5F/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdZIc5F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332A61F000C4;
	Sat, 17 Oct 2026 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255470;
	bh=YAgUP4fiuKPuCcI5xDckgWBnWADVWLiySz7Wzh0NSWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdZIc5F/SXIutDmESd7QTct1MBS3OlVzTlxhL11WRCXSDuqVAblihWBXMUjCj9rrm
	 +Sy68HVmzaVJ8QRUK82Xs4cyBHlPcCgyDBUMwBdjI9xPO9T+PP3dvwenxjnQafDpnj
	 rijWU99zkKgkJ5M31/me3I/eQkqtoq7Ib2PM9joM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 750/869] gpiolib: rework the wrapper around gpio_chip::set_multiple()
Date: Sat, 17 Oct 2026 17:59:51 +0200
Message-ID: <20261017160056.165793333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 9b407312755fd5db012413ca005f0f3a661db8dd ]

Make the existing wrapper around gpio_chip::set_multiple() consistent
with the one for gpio_chip::set(): make it return int, add a lockdep
assertion, warn on missing set callback and move the code a bit for
better readability.

Add return value checks in all call places.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/20250220-gpio-set-retval-v2-4-bc4cfd38dae3@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: c87c9046c4e0 ("pinctrl: mediatek: paris: bypass pinctrl GPIO layer in set GPIO direction")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 68fa92b79137c..5f23da5ef8c93 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -3415,21 +3415,33 @@ static int gpiod_set_raw_value_commit(struct gpio_desc *desc, bool value)
  *        defines which outputs are to be changed
  * @bits: bit value array; one bit per output; BITS_PER_LONG bits per word
  *        defines the values the outputs specified by mask are to be set to
+ *
+ * Returns: 0 on success, negative error number on failure.
  */
-static void gpio_chip_set_multiple(struct gpio_chip *gc,
-				   unsigned long *mask, unsigned long *bits)
+static int gpiochip_set_multiple(struct gpio_chip *gc,
+				 unsigned long *mask, unsigned long *bits)
 {
+	unsigned int i;
+	int ret;
+
 	lockdep_assert_held(&gc->gpiodev->srcu);
 
+	if (WARN_ON(unlikely(!gc->set_multiple && !gc->set)))
+		return -EOPNOTSUPP;
+
 	if (gc->set_multiple) {
 		gc->set_multiple(gc, mask, bits);
-	} else {
-		unsigned int i;
+		return 0;
+	}
 
-		/* set outputs if the corresponding mask bit is set */
-		for_each_set_bit(i, mask, gc->ngpio)
-			gpiochip_set(gc, i, test_bit(i, bits));
+	/* set outputs if the corresponding mask bit is set */
+	for_each_set_bit(i, mask, gc->ngpio) {
+		ret = gpiochip_set(gc, i, test_bit(i, bits));
+		if (ret)
+			break;
 	}
+
+	return ret;
 }
 
 int gpiod_set_array_value_complex(bool raw, bool can_sleep,
@@ -3439,7 +3451,7 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 				  unsigned long *value_bitmap)
 {
 	struct gpio_chip *gc;
-	int i = 0;
+	int i = 0, ret;
 
 	/*
 	 * Validate array_info against desc_array and its size.
@@ -3462,7 +3474,10 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 			bitmap_xor(value_bitmap, value_bitmap,
 				   array_info->invert_mask, array_size);
 
-		gpio_chip_set_multiple(gc, array_info->set_mask, value_bitmap);
+		ret = gpiochip_set_multiple(gc, array_info->set_mask,
+					    value_bitmap);
+		if (ret)
+			return ret;
 
 		i = find_first_zero_bit(array_info->set_mask, array_size);
 		if (i == array_size)
@@ -3539,8 +3554,11 @@ int gpiod_set_array_value_complex(bool raw, bool can_sleep,
 		} while ((i < array_size) &&
 			 gpio_device_chip_cmp(desc_array[i]->gdev, guard.gc));
 		/* push collected bits to outputs */
-		if (count != 0)
-			gpio_chip_set_multiple(guard.gc, mask, bits);
+		if (count != 0) {
+			ret = gpiochip_set_multiple(guard.gc, mask, bits);
+			if (ret)
+				return ret;
+		}
 
 		if (mask != fastpath_mask)
 			bitmap_free(mask);
-- 
2.53.0



