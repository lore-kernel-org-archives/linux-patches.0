Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8ED403AFB;
	Tue, 21 Jul 2026 17:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654964; cv=none; b=IGxP69zhXrLHXnRhhXII9jxpHxj1kqKVXBBAGagBv691hSppHYJwHfrKV05sr9ZpEOHzL5cQrz/Ae1nFCHVOqTyCFQwSO4Z9s68xrvuSCPJxvKZcm64wo3WkErDLtA7MmGshmD2TxF/AAJLohw5tztrDeBKCuXKL2FuC1/LPlY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654964; c=relaxed/simple;
	bh=07eIsQMxcGrX3g/URoijN4KslilvvXUpJGp0I8DNJow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alpmBEVlo9Qrss2kMLICD8jVwe1S1h83ffxbQjdrV/8mbrzHxbSheIL63vB0GX+/rgMy7gL58MlBq5Fd4gLO63AYa5d7DCGPtH7X+ch7b9EMSA73fiO5mBUCwOWXVAVQ/GnNWJPcuGOmBz67ObOs8De/KbOeQa1DzCVbqlQETWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqhmWblm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqhmWblm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72321F000E9;
	Tue, 21 Jul 2026 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654963;
	bh=k4GgoeJvBpALzDvEriWeJcUfslUhQ/7iXI3kj7eRzZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqhmWblm9zoksXvgSeIFNO6Sml3xmiWi4cz8AqWDpwCK1erxB2l6emwGZ0PAuD5tx
	 zeHjleJthA5tvSDgdAoTb/jdyIMn0reUkctqD2nr1T9ky+BkAvxejewyk42GSTQKMO
	 ey8Fzg5pRoTt3YY3Mg9JZhh6F1udhPVvO1GTVVck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.1 1905/2077] gpio: mt7621: be sure IRQ domain is created before exposing GPIO chips
Date: Tue, 21 Jul 2026 17:26:18 +0200
Message-ID: <20260721152637.653493017@linuxfoundation.org>
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

commit 0e024f58291dfcb28d98c512002e1a80fad69798 upstream.

Function 'mediatek_gpio_bank_probe()' registers three GPIO chips using
'devm_gpiochip_add_data()'. At this point, the chips become live and visible
to consumers. However, the IRQ domain isn't allocated and set up until
'mt7621_gpio_irq_setup()' is called after the GPIO chips setup finishes.
If a consumer requests a GPIO IRQ concurrently 'mt7621_gpio_to_irq()' can
be called and pass a NULL irq domain pointer irq_create_mapping(), that can
corrupt the mappings or cause a crash. Fix this possible problem seting up
irq domain before GPIO chips setup is performed.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a46f2e5720f5 ("gpio: mt7621: fix interrupt banks mapping on gpio chips")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://patch.msgid.link/20260626060112.2498324-4-sergio.paracuellos@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mt7621.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpio/gpio-mt7621.c
+++ b/drivers/gpio/gpio-mt7621.c
@@ -464,12 +464,6 @@ mediatek_gpio_probe(struct platform_devi
 	mtk->num_gpios = MTK_BANK_WIDTH * MTK_BANK_CNT;
 	platform_set_drvdata(pdev, mtk);
 
-	for (i = 0; i < MTK_BANK_CNT; i++) {
-		ret = mediatek_gpio_bank_probe(dev, i);
-		if (ret)
-			return ret;
-	}
-
 	if (mtk->gpio_irq > 0) {
 		ret = mt7621_gpio_irq_setup(pdev, mtk);
 		if (ret)
@@ -480,6 +474,12 @@ mediatek_gpio_probe(struct platform_devi
 	if (ret)
 		return ret;
 
+	for (i = 0; i < MTK_BANK_CNT; i++) {
+		ret = mediatek_gpio_bank_probe(dev, i);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 


