Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DE27E105;
	Mon,  8 Apr 2024 13:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583511; cv=none; b=UBRklVLJ/BK1P2t4gfOaT9GpummCHutwL4J43KADuJYjJOOpOyyPqjvoz7TB0obREgKkoeJeIR2mvpBBS22zMNCOPTWJisnI9VotFVPmNod3FJdyjJ2x8nLfGrLJElQrgl4R/v+EjxsWcFITndSPNr1ComjJUVfGYKUXOJcnfGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583511; c=relaxed/simple;
	bh=GCEFmvzDdQnJ+1Dyc6q3p8S8Y/rVYbA/ed+Ou9YWRQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IN9xI/MI7bxIMnB8/bSyndGmXkYKStN78O3qDKIefkdbndpeSjRucPvFscUxZhBKe3gf/V8yQLdCRhEILYR0iiW6Bs+MhUKzVC5ek65FfxHuBxH1dunKVDKN20EgJYCelLi12C0GLuAvX0vOVxjZ92m2by+k1FHgQTBO5vsDTzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVTqUTfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVTqUTfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7A3C433F1;
	Mon,  8 Apr 2024 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583511;
	bh=GCEFmvzDdQnJ+1Dyc6q3p8S8Y/rVYbA/ed+Ou9YWRQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVTqUTfiHq+Yl+YxQ9B1FedPFQHUH+I46KA2aXFb6kWu4gh+jqmS8U9jsLHSe2cvN
	 JMOn1gkFX8otIWN56kvYTRE0rP8IMSKYy39JLBDaXcii/jNG/9ejyZ7TkXF1n13Kxx
	 XL6T6W+Cagk6s7Fp4Mv/3hM4gRSOnPmT7h0w9DN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Gibson <warthog618@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 203/252] gpio: cdev: fix missed label sanitizing in debounce_setup()
Date: Mon,  8 Apr 2024 14:58:22 +0200
Message-ID: <20240408125312.953768473@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
@@ -655,6 +655,25 @@ static u32 line_event_id(int level)
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
@@ -942,6 +961,7 @@ static int debounce_setup(struct line *l
 {
 	unsigned long irqflags;
 	int ret, level, irq;
+	char *label;
 
 	/* try hardware */
 	ret = gpiod_set_debounce(line->desc, debounce_period_us);
@@ -964,11 +984,17 @@ static int debounce_setup(struct line *l
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
@@ -1010,25 +1036,6 @@ static u32 gpio_v2_line_config_debounce_
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


