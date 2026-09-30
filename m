Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18D24F4049;
	Wed, 30 Sep 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787660; cv=none; b=R39guU7K+zep+eAfaCI5Snxx6IbFW9cnQhNijN5Cs3ozpnQdO1fvwsK/+Q1lJKuhWIvqUxI52FAkKzD642K59EtiGkBGD+ya4GYbnr1mJ39mO5oX1GVzh3S8237lz/215Afo+yeZ+0UV0Yaly3q5DePXuuiSe3vhFNIxh2JNAzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787660; c=relaxed/simple;
	bh=eAGrV3427W8j5wWocyyUwTtQvrzKHQVjqW49feXiz6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WR84l4tBTLCG2I5nxiIIja4In2J0J7eRLNXaHqTu3YaSkWaKNF5g65iaG0T5CAONGMJ88bRZQux+cKYiIaRGzeoMRpW4JoYeSX4FFsaDLvc8WfpfWSFEdsUlR2zZDQEkFc+rNkww/nk7d2T5AnNq5elHI8Dl2vwRwbKOgUGHxo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkzV6mfa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkzV6mfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56F271F000FF;
	Wed, 30 Sep 2026 17:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787658;
	bh=3xKLFY/lG/NOntkOCTF4mhCiOZ434XAKTQ3aRiUWkTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkzV6mfaNYggi4z9KFbJ/ZG9bpMSEyRTNLlP9vcLxPBh/MXAQD5UyNC/1gw1GpDTc
	 9qcCR7aEAIMfI9UlDoxWW2bWrZgoA+wYJ5DUyoFYpgUHF5yD75bDjlJCRPblDQ+gQq
	 yhC9IqX6z/t/i6yP5mkl5u9EDcsyIVowpfKW2uGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 309/457] gpio: tps65219: Use the variant-specific direction callback
Date: Wed, 30 Sep 2026 17:26:54 +0200
Message-ID: <20260930152352.697278678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 93cf8cedeaaa05714f709b539cfb976e0b80c830 upstream.

The TPS65214 template installs its own get_direction callback because
its direction bit is in GENERAL_CONFIG. The shared get and direction
callbacks nevertheless call tps65219_gpio_get_direction() directly and
interpret the unrelated TPS65219 MFP bit.

On TPS65214 this can reject reads from an input and skip the change from
input to output. Call the callback selected by the gpio_chip template
instead.

Fixes: 1b6ab07c0c80 ("gpio: tps65219: Add support for TI TPS65214 PMIC")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260919171100.90430-3-kmehltretter@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tps65219.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-tps65219.c
+++ b/drivers/gpio/gpio-tps65219.c
@@ -87,7 +87,7 @@ static int tps65219_gpio_get(struct gpio
 	 * status bit.
 	 */
 
-	if (tps65219_gpio_get_direction(gc, offset) == GPIO_LINE_DIRECTION_OUT)
+	if (gc->get_direction(gc, offset) == GPIO_LINE_DIRECTION_OUT)
 		return -ENOTSUPP;
 
 	return ret;
@@ -176,7 +176,7 @@ static int tps65219_gpio_direction_input
 		return -ENOTSUPP;
 	}
 
-	if (tps65219_gpio_get_direction(gc, offset) == GPIO_LINE_DIRECTION_IN)
+	if (gc->get_direction(gc, offset) == GPIO_LINE_DIRECTION_IN)
 		return 0;
 
 	return gpio->change_dir(gc, offset, GPIO_LINE_DIRECTION_IN);
@@ -190,7 +190,7 @@ static int tps65219_gpio_direction_outpu
 	if (offset != TPS6521X_GPIO0_IDX)
 		return 0;
 
-	if (tps65219_gpio_get_direction(gc, offset) == GPIO_LINE_DIRECTION_OUT)
+	if (gc->get_direction(gc, offset) == GPIO_LINE_DIRECTION_OUT)
 		return 0;
 
 	return gpio->change_dir(gc, offset, GPIO_LINE_DIRECTION_OUT);


