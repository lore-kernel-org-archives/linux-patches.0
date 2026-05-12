Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FD9366548;
	Tue, 12 May 2026 18:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609298; cv=none; b=Q9+Pfbjk9Ew6k8t+D0yrcwOsY23v7cXOHqT98l79wJtBpWr+BjUrA95mnebzdATF7GIxxhhZvkaAW4LZk3ukvtc6hYCx/xfE+0AIloHyNzCHp34Rc4yAOENFvp/5OAE8HwPEPGIISHeGwVJlPZW+fqI0iwXl1i+QuQbWiM7O9yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609298; c=relaxed/simple;
	bh=p2SLF3r7DNx3cwcKeuFwnj/5H3LkEiCwvCEtH/jlKbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI8YjcsWSDEueUwATteYUuS1Ewxe6KckAsZHvKWLAN1Zv4+YTI+IVhJjW0ja0sirEkcTypsATKm8CuAAaOwrljxSUd+5lks/Xj6qq2pgths2qtQ2we4nwGj+7/S4XAznoBezSerHFc/JL9Y28x0ZHULlInY5CKzvHTtiKWu7dF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKH+g21u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKH+g21u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D89CC2BCB0;
	Tue, 12 May 2026 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609297;
	bh=p2SLF3r7DNx3cwcKeuFwnj/5H3LkEiCwvCEtH/jlKbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKH+g21uWEMz04FvdBrAUPzYmpbICQ7SPGfhcF+ql5EB2JvHEGgkIwnGhXQjS1UuX
	 gspekUMuRZg758tzORgRm3xb8aFT85OiaFkb6XBp2OZkv37V1eXr5CMJq7lhH5+uqr
	 UC+2Mvi1Jeh/47vNSt6eqSMFZDLD5Qgv9YpXzFPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.0 141/307] gpio: of: clear OF_POPULATED on hog nodes in remove path
Date: Tue, 12 May 2026 19:38:56 +0200
Message-ID: <20260512173943.102715217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit bbee90e750262bfb406d66dc65c46d616d2b6673 upstream.

The previously set OF_POPULATED flag should be cleared on the hog nodes
when removing the chip.

Cc: stable@vger.kernel.org
Fixes: 63636d956c455 ("gpio: of: Add DT overlay support for GPIO hogs")
Acked-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260309-gpio-hog-fwnode-v2-1-4e61f3dbf06a@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-of.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -1210,7 +1210,14 @@ int of_gpiochip_add(struct gpio_chip *ch
 
 void of_gpiochip_remove(struct gpio_chip *chip)
 {
-	of_node_put(dev_of_node(&chip->gpiodev->dev));
+	struct device_node *np = dev_of_node(&chip->gpiodev->dev);
+
+	for_each_child_of_node_scoped(np, child) {
+		if (of_property_present(child, "gpio-hog"))
+			of_node_clear_flag(child, OF_POPULATED);
+	}
+
+	of_node_put(np);
 }
 
 bool of_gpiochip_instance_match(struct gpio_chip *gc, unsigned int index)


