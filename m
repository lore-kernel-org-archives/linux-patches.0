Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33B31E525;
	Mon,  1 Apr 2024 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989058; cv=none; b=mkEzu380njHA2s7gzRyBAvI+Ry7N5OzP7G2dKH3zM61xnBMn5+k1pcCZBmu7Uekd4maWHN+9VL0G0DWTYa2nF931exUf2CWSFqMU3RqO4jSoST1qNw13hRups+QtBhMSmLTAVsKi5035WhNnXc0gkitjMFgLJMNCjt7AO88XfyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989058; c=relaxed/simple;
	bh=OWiEs2Ovn6dY6q++WfLzlTWU5nTNpNnDeuVk1/Qk/ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgtQN8CoGv9mzP8RtV4s371HxekO7eE1P6Ydhe7fVMDT+Exj1HqggfJ1nO4fjZSP76n7tR7M+1k37hquzAC+amh042wSlpx02Sr3bsrIrHonj8rfzqhkmUHhb29fXYV0gae6PjTnElL9JB3cFpFlhAEbdAJZYrpK7ST2mnUNcWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9OBywQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9OBywQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F22C433F1;
	Mon,  1 Apr 2024 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989057;
	bh=OWiEs2Ovn6dY6q++WfLzlTWU5nTNpNnDeuVk1/Qk/ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9OBywQbEEghnVD5PVpO54lyru4RUPPIyTFCc4PHjNeqGTB3fqe253rOZ221Pu78E
	 mRjD3DhlP8fsoWo1o2esyPcaMJgi44as11t3cXgnDTiczfxArFzJ7nnKlcBsfY3WIS
	 4Wi/CHik15j6daFq1zXfHMg2AYkIRQ5kue9tbUmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Kent Gibson <warthog618@gmail.com>
Subject: [PATCH 6.7 351/432] gpio: cdev: sanitize the label before requesting the interrupt
Date: Mon,  1 Apr 2024 17:45:38 +0200
Message-ID: <20240401152603.718423432@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit b34490879baa847d16fc529c8ea6e6d34f004b38 upstream.

When an interrupt is requested, a procfs directory is created under
"/proc/irq/<irqnum>/<label>" where <label> is the string passed to one of
the request_irq() variants.

What follows is that the string must not contain the "/" character or
the procfs mkdir operation will fail. We don't have such constraints for
GPIO consumer labels which are used verbatim as interrupt labels for
GPIO irqs. We must therefore sanitize the consumer string before
requesting the interrupt.

Let's replace all "/" with ":".

Cc: stable@vger.kernel.org
Reported-by: Stefan Wahren <wahrenst@gmx.net>
Closes: https://lore.kernel.org/linux-gpio/39fe95cb-aa83-4b8b-8cab-63947a726754@gmx.net/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-cdev.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -1010,10 +1010,20 @@ static u32 gpio_v2_line_config_debounce_
 	return 0;
 }
 
+static inline char *make_irq_label(const char *orig)
+{
+	return kstrdup_and_replace(orig, '/', ':', GFP_KERNEL);
+}
+
+static inline void free_irq_label(const char *label)
+{
+	kfree(label);
+}
+
 static void edge_detector_stop(struct line *line)
 {
 	if (line->irq) {
-		free_irq(line->irq, line);
+		free_irq_label(free_irq(line->irq, line));
 		line->irq = 0;
 	}
 
@@ -1038,6 +1048,7 @@ static int edge_detector_setup(struct li
 	unsigned long irqflags = 0;
 	u64 eflags;
 	int irq, ret;
+	char *label;
 
 	eflags = edflags & GPIO_V2_LINE_EDGE_FLAGS;
 	if (eflags && !kfifo_initialized(&line->req->events)) {
@@ -1074,11 +1085,17 @@ static int edge_detector_setup(struct li
 			IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
 	irqflags |= IRQF_ONESHOT;
 
+	label = make_irq_label(line->req->label);
+	if (!label)
+		return -ENOMEM;
+
 	/* Request a thread to read the events */
 	ret = request_threaded_irq(irq, edge_irq_handler, edge_irq_thread,
-				   irqflags, line->req->label, line);
-	if (ret)
+				   irqflags, label, line);
+	if (ret) {
+		free_irq_label(label);
 		return ret;
+	}
 
 	line->irq = irq;
 	return 0;
@@ -1943,7 +1960,7 @@ static void lineevent_free(struct lineev
 		blocking_notifier_chain_unregister(&le->gdev->device_notifier,
 						   &le->device_unregistered_nb);
 	if (le->irq)
-		free_irq(le->irq, le);
+		free_irq_label(free_irq(le->irq, le));
 	if (le->desc)
 		gpiod_free(le->desc);
 	kfree(le->label);
@@ -2091,6 +2108,7 @@ static int lineevent_create(struct gpio_
 	int fd;
 	int ret;
 	int irq, irqflags = 0;
+	char *label;
 
 	if (copy_from_user(&eventreq, ip, sizeof(eventreq)))
 		return -EFAULT;
@@ -2175,15 +2193,23 @@ static int lineevent_create(struct gpio_
 	if (ret)
 		goto out_free_le;
 
+	label = make_irq_label(le->label);
+	if (!label) {
+		ret = -ENOMEM;
+		goto out_free_le;
+	}
+
 	/* Request a thread to read the events */
 	ret = request_threaded_irq(irq,
 				   lineevent_irq_handler,
 				   lineevent_irq_thread,
 				   irqflags,
-				   le->label,
+				   label,
 				   le);
-	if (ret)
+	if (ret) {
+		free_irq_label(label);
 		goto out_free_le;
+	}
 
 	le->irq = irq;
 


