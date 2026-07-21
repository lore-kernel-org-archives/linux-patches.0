Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D968401A18;
	Tue, 21 Jul 2026 17:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654969; cv=none; b=IyLKagdGSVuY+y+nKOQiwdmwwbFc5cZan8C+5JAP1ycGmyNAwHGLSYdUSBPfsNwuI5ibMlbaUa3Q6cUdTgOOb+Z9dWq08A/wFiqntLppb7yzBDj5gOErDG5LZDxIJoQHxvzoLFvAGSA3pbwFguCZMr+qpJ5C427UlaYC5LRHkS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654969; c=relaxed/simple;
	bh=QRq00/6TUdP+uTz8zdFXvu7/Gc2oP/Dftl/8V8zb1YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSH97coZBF4hzY8e0gKEIxOjvLc4DnqKiYPXC2iXqm5Bmdods2aMhfhJdyTEU2C2ha+uCXpnIy0WCLRFRpOk8xNMrmOhpewn0nfIxB+QVfo5VPM9QOQcrxcbJVPYfnzOKvMzu0o5L7hZ8kTE7Mh/84DOf7nIdWdFad/8pxWyTYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QgscB6dZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QgscB6dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102A21F000E9;
	Tue, 21 Jul 2026 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654968;
	bh=Vz5JRyoHjcQWKOwS3G20h5UXc4VV3N4FjtwdPY37FIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QgscB6dZp/qtHCGM/Uwlet5pFqQDcIV82cHWgDs9/9Y/BDCpUMJkOR5Ov4rtmF17F
	 KTIyCaIXJGSVJvsWQNtRfpYimf3gklqi00sDO4HMmfXwjJLXdC9BA1JSt99ZywjEGt
	 SJoTkgsGFNS7+ftjuUR8uBi5KSWdJ5hqWMA+XByU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.1 1907/2077] gpio: mt7621: avoid corruption of shared interrupt trigger state
Date: Tue, 21 Jul 2026 17:26:20 +0200
Message-ID: <20260721152637.700550973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit 1781172526d1092323af443fa03f00e6de560401 upstream.

The bank-shared fields like 'rising' and 'falling' are modified using
non-atomic read-modify-write operations. Since every gpio chip instance
represents an entire bank of 32 pins, if 'mediatek_gpio_irq_type()' is
called concurrently for different IRQs on the same bank a possible overwrite
of each other's configuration is possible. Thus, protect this state with
'gpio_generic_lock_irqsave' lock in the same way it is handled in irp_chip
'mediatek_gpio_irq_mask()' and 'mediatek_gpio_irq_unmask()' callbacks.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4ba9c3afda41 ("gpio: mt7621: Add a driver for MT7621")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://patch.msgid.link/20260626060112.2498324-2-sergio.paracuellos@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mt7621.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpio/gpio-mt7621.c
+++ b/drivers/gpio/gpio-mt7621.c
@@ -187,6 +187,8 @@ mediatek_gpio_irq_type(struct irq_data *
 	struct mtk_gc *rg = gpiochip_get_data(gc);
 	u32 mask = BIT(mt7621_gpio_hwirq_to_offset(d->hwirq, rg));
 
+	guard(gpio_generic_lock_irqsave)(&rg->chip);
+
 	if (type == IRQ_TYPE_PROBE) {
 		if ((rg->rising | rg->falling |
 		     rg->hlevel | rg->llevel) & mask)


