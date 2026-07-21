Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD213264FF;
	Tue, 21 Jul 2026 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659171; cv=none; b=HATGU54jUoIIzK9IGZGSuTEQA2XLlyZGEVqMsCLynsz2EGrWtdwoW65yPWaZl0SJBkVdZdI6OZ4ifwyT63xei2rQWwNe8AaTasGQ1b7A8O4M+SjAc35e/Fa3jO2MPibSBe3j8LpQUz9sc2uoy0gxN7aJbLDZiGG7NKyTrRybkHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659171; c=relaxed/simple;
	bh=PCMPPYS7W9meGJALDdsV3xREBD8jX/Jk5NosfoUnqUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDJ+0f6R/OUMMvIVdQFH9yrCmlEtjq14mrAq6WtZYwfYLcQYPQucQvejsgr2Jdyl+2m9jLEi9KbhNaF6iP3FOmQBDkaBKbUym6vahOAB07FBTeJi8mvavjVe9vTK6ELY9+tqsAyYeh9b+Mkf6SAiKRnG2AfojjAJWwk7r1k5D7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mX3JMQDi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mX3JMQDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C631F000E9;
	Tue, 21 Jul 2026 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659170;
	bh=k4DCtzEdu7oSPW5U5M0kx8U80wxOW8uC40KGgwPPrH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mX3JMQDi0ppN/ZybVFXyKqXsMUG4xS666zC6othchQTVk435+oPl/xjhcEyFaxAd/
	 VQtT7WAkGN0bHBIw2oEJGyTua4lq2kmkxZlNcM4HDEfcT3Fo+zayRLaPOjpdm4KD5B
	 aGp2iSEzFAxQCPeX6iZrZY1lNttObZjb2RMOLqgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 1393/1611] gpio: mt7621: more robust management of IRQ domain teardown
Date: Tue, 21 Jul 2026 17:25:09 +0200
Message-ID: <20260721152546.776582449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit 839738536adabae1a7e98ed3fc332ce9cc991d27 upstream.

The driver uses devm_gpiochip_add_data() to register the GPIO chips which
means the devres subsystem will unregister them only after the function
'mt7621_gpio_remove()' returns. During the window between domain destruction
and devres unregistering the GPIO chips, the chips are still fully active.
If a consumer or userspace invokes gpiod_to_irq() during this window,
'mt7621_gpio_to_irq()' can dereference the already-freed irq domain pointer.
Thus, manage the IRQ domain teardown using 'devm_add_action_or_reset()' to
guarantee it is destroyed strictly after the GPIO chips are removed.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a46f2e5720f5 ("gpio: mt7621: fix interrupt banks mapping on gpio chips")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://patch.msgid.link/20260626060112.2498324-3-sergio.paracuellos@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mt7621.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/gpio/gpio-mt7621.c
+++ b/drivers/gpio/gpio-mt7621.c
@@ -270,9 +270,9 @@ static const struct irq_chip mt7621_irq_
 };
 
 static void
-mt7621_gpio_remove(struct platform_device *pdev)
+mt7621_gpio_remove(void *data)
 {
-	struct mtk *priv = platform_get_drvdata(pdev);
+	struct mtk *priv = data;
 	int offset, virq;
 
 	if (priv->gpio_irq > 0)
@@ -473,14 +473,14 @@ mediatek_gpio_probe(struct platform_devi
 	if (mtk->gpio_irq > 0) {
 		ret = mt7621_gpio_irq_setup(pdev, mtk);
 		if (ret)
-			goto fail;
+			return ret;
 	}
 
-	return 0;
+	ret = devm_add_action_or_reset(dev, mt7621_gpio_remove, mtk);
+	if (ret)
+		return ret;
 
-fail:
-	mt7621_gpio_remove(pdev);
-	return ret;
+	return 0;
 }
 
 static const struct of_device_id mediatek_gpio_match[] = {
@@ -491,7 +491,6 @@ MODULE_DEVICE_TABLE(of, mediatek_gpio_ma
 
 static struct platform_driver mediatek_gpio_driver = {
 	.probe = mediatek_gpio_probe,
-	.remove = mt7621_gpio_remove,
 	.driver = {
 		.name = "mt7621_gpio",
 		.of_match_table = mediatek_gpio_match,


