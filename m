Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD50734B1A6;
	Tue, 21 Jul 2026 22:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672082; cv=none; b=GcO63/6WK6qXnQ2v8PN26wUbzmWpNYi92nkbHGGh1b7ttmnN6uNPPCEfqAg0sfMlnRBGDSDplIMCPZr/gvGgUHhYn6zSdqL4XA/RuiLprQ7aO7VnqH+D0rWXTJRWwkS3soHZT+1LIfh+eMkUUgadYvnH41+eLS6J01himujokKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672082; c=relaxed/simple;
	bh=wIT+PoFB9xx8NF3s3zdC++rpWIWKimFTQpYmlKO5qXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvTTpx/VKNy+0VZKKpZQxEnnaoTPmJgBW7DPnAIqVnO8ZCtTfDqFhsJYjQfKKyFgdNKql7dZDktQvjkuq7GuVELCzkxw63tx2aGeRb+w6k3aMeijn4Jzkob8tsdVqX3iE/P3ZTPZh86+3UYXOTuB0yRtVjqlNgvf6NpOFx3ZMi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKvd5LhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKvd5LhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F72A1F000E9;
	Tue, 21 Jul 2026 22:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672081;
	bh=S9QdeBY4DPcve6am8G4hYiyNnqvNNRcazYtTMojvSWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKvd5LhRi6Ni/A8dNAGSHMBU+JaxhUm6DhDTFo3f2RUtZxeCHGy0UMz7bArtUv5lx
	 Z3IdBSpt+BCUwS40f/9iXnJAaUS19v2l9HhCiFj2TCFG1MIs2P0lj+gR84bMnd61sm
	 smjmMdBVYYn4iImR6frfdNrrCuH199CvijeboTZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 488/843] gpio: htc-egpio: use managed gpiochip registration
Date: Tue, 21 Jul 2026 17:22:03 +0200
Message-ID: <20260721152417.007398024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 17326db5f0ab4ec1901e75d052b5ebef486b467f ]

egpio_probe() registers each nested gpio_chip with gpiochip_add_data()
but ignores the return value. If one registration fails, probe still
returns success even though one of the chips was not published to
gpiolib.

Use devm_gpiochip_add_data() and fail probe if any chip registration
fails. This lets devres unwind already registered chips and prevents
the driver from publishing a partially initialized device.

Fixes: a1635b8fe59d ("[ARM] 4947/1: htc-egpio, a driver for GPIO/IRQ expanders with fixed input/output pins")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624131828.94139-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-htc-egpio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-htc-egpio.c b/drivers/gpio/gpio-htc-egpio.c
index a40bd56673fe36..5f12ce9ac28caf 100644
--- a/drivers/gpio/gpio-htc-egpio.c
+++ b/drivers/gpio/gpio-htc-egpio.c
@@ -268,6 +268,7 @@ static int __init egpio_probe(struct platform_device *pdev)
 	struct gpio_chip  *chip;
 	unsigned int      irq, irq_end;
 	int               i;
+	int               ret;
 
 	/* Initialize ei data structure. */
 	ei = devm_kzalloc(&pdev->dev, sizeof(*ei), GFP_KERNEL);
@@ -331,7 +332,10 @@ static int __init egpio_probe(struct platform_device *pdev)
 		chip->base            = pdata->chip[i].gpio_base;
 		chip->ngpio           = pdata->chip[i].num_gpios;
 
-		gpiochip_add_data(chip, &ei->chip[i]);
+		ret = devm_gpiochip_add_data(&pdev->dev, chip, &ei->chip[i]);
+		if (ret)
+			return dev_err_probe(&pdev->dev, ret,
+					     "failed to register gpiochip %d\n", i);
 	}
 
 	/* Set initial pin values */
-- 
2.53.0



