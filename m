Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B05C7D062;
	Mon,  8 Apr 2024 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583690; cv=none; b=ftVu8OyYVZnY6sR4TMkrHS9YTnnXc+6hNm6gfuS0pZA2mSrVO7pe6krWRVdPy2ak6KlWuzi5MyYix0YcQcFQPLKZzE3olcHiAQX9CmjbhJ0VGeX3xaQZOhLe6Yvc2gWIu/qgvDOIat5B4B9ZeSZEhX8/OLuxN4XUmL+LJFE8xbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583690; c=relaxed/simple;
	bh=7hmlePcG9MfJoFctW1QEBO37HyJXQ01+JE2ggWx3V6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhd7rvH55qjcSg3yBKkKByg6wWV3J6Z5cKOWOFqBcVONETtMo+hokGRi+rG37g7RtEj9sJQNuQk4dLgEKeWIOfMgVOh7utpHk1TJzsxxN23xrw2nXSrytol0aIdwdZF1EkMiIwn+dlwk5BFkykMzQI0dQVKCO6hrKWyq0jfC4b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9WyhlPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9WyhlPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9687FC43390;
	Mon,  8 Apr 2024 13:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583690;
	bh=7hmlePcG9MfJoFctW1QEBO37HyJXQ01+JE2ggWx3V6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9WyhlPeAF+68yy/3KfNblyvIe8pGHu80bade5QWS1x26ucEU8l474Wep6NKbXbyQ
	 YXz0mUXTn8aR1MU4JEckbgy0aqkrTSpBzVkp6SAK79/4Efe4M13JUk3hGHFV5YQaiy
	 gLPy3vE7yEg7Zi5mM0HinwQWUxBOee5mvtRMD/JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.8 197/273] gpio: cdev: fix missed label sanitizing in debounce_setup()
Date: Mon,  8 Apr 2024 14:57:52 +0200
Message-ID: <20240408125315.442587814@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Gibson <warthog618@gmail.com>

commit 83092341e15d0dfee1caa8dc502f66c815ccd78a upstream.

When adding sanitization of the label, the path through
edge_detector_setup() that leads to debounce_setup() was overlooked.
A request taking this path does not allocate a new label and the
request label is freed twice when the request is released, resulting
in memory corruption.

Add label sanitization to debounce_setup().

Cc: stable@vger.kernel.org
Fixes: b34490879baa ("gpio: cdev: sanitize the label before requesting the interrupt")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
[Bartosz: rebased on top of the fix for empty GPIO labels]
Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |   49 +++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -734,6 +734,25 @@ static u32 line_event_id(int level)
 		       GPIO_V2_LINE_EVENT_FALLING_EDGE;
 }
 
+static inline char *make_irq_label(const char *orig)
+{
+	char *new;
+
+	if (!orig)
+		return NULL;
+
+	new = kstrdup_and_replace(orig, '/', ':', GFP_KERNEL);
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	return new;
+}
+
+static inline void free_irq_label(const char *label)
+{
+	kfree(label);
+}
+
 #ifdef CONFIG_HTE
 
 static enum hte_return process_hw_ts_thread(void *p)
@@ -1021,6 +1040,7 @@ static int debounce_setup(struct line *l
 {
 	unsigned long irqflags;
 	int ret, level, irq;
+	char *label;
 
 	/* try hardware */
 	ret = gpiod_set_debounce(line->desc, debounce_period_us);
@@ -1043,11 +1063,17 @@ static int debounce_setup(struct line *l
 			if (irq < 0)
 				return -ENXIO;
 
+			label = make_irq_label(line->req->label);
+			if (IS_ERR(label))
+				return -ENOMEM;
+
 			irqflags = IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING;
 			ret = request_irq(irq, debounce_irq_handler, irqflags,
-					  line->req->label, line);
-			if (ret)
+					  label, line);
+			if (ret) {
+				free_irq_label(label);
 				return ret;
+			}
 			line->irq = irq;
 		} else {
 			ret = hte_edge_setup(line, GPIO_V2_LINE_FLAG_EDGE_BOTH);
@@ -1089,25 +1115,6 @@ static u32 gpio_v2_line_config_debounce_
 	return 0;
 }
 
-static inline char *make_irq_label(const char *orig)
-{
-	char *new;
-
-	if (!orig)
-		return NULL;
-
-	new = kstrdup_and_replace(orig, '/', ':', GFP_KERNEL);
-	if (!new)
-		return ERR_PTR(-ENOMEM);
-
-	return new;
-}
-
-static inline void free_irq_label(const char *label)
-{
-	kfree(label);
-}
-
 static void edge_detector_stop(struct line *line)
 {
 	if (line->irq) {


