Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573CF2EA748;
	Tue, 22 Jul 2025 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193412; cv=none; b=B41DSDyGNMYXVnIiZiT/PAgw80t/wP0mHd5uIvESkFRizJCn9r87emSLMJ1vVjpofXBRrRv03Wv7RwQQEjJgrY1bxwtwFFlIIz6PZqE6XBnXNFIIxVealPDISFygE6rHCCECa/ZmIYxYu2Hiwx+QCV1IJbkGMgg/GdWmpCRTpMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193412; c=relaxed/simple;
	bh=XJiPFi9XobWxO/oRCq5cK4vJqYbUbwP9A+Kys2LtcrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=It4/k0Z3MGNMZvgDkj6G0zklInI9DBoyUE7jZDoNk+DaW6Pdw47oLXbh4/FmrMkSl3Ouei3OxTI5zr70YowSPAvXJK7ZLvlvSPuZ1JdiAs8xJhjb+IBR0SoEtt4zs49DH0aN8vaZKLUOmfyRw+Is2W1yGR3OLQ5l8tGISSQLZz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyT5nG4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyT5nG4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D220CC4CEF7;
	Tue, 22 Jul 2025 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193412;
	bh=XJiPFi9XobWxO/oRCq5cK4vJqYbUbwP9A+Kys2LtcrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lyT5nG4mPtQYTfVEhi3pJHHySVPATSM2Hwqa3WXis5LT75x/28e2X1L/GgQmKZLFD
	 6UV4VO5aY8sGsPRhDG+Uat0HqdkYl0S0JcVDOboMx+MRLIVPT/5hLXcKgllqxFae3E
	 157ScXzcy0zGMJu1m57a6pr2CpvHxn72OmPBYzMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 085/187] iio: adc: stm32-adc: Fix race in installing chained IRQ handler
Date: Tue, 22 Jul 2025 15:44:15 +0200
Message-ID: <20250722134348.890050634@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit e8ad595064f6ebd5d2d1a5d5d7ebe0efce623091 upstream.

Fix a race where a pending interrupt could be received and the handler
called before the handler's data has been setup, by converting to
irq_set_chained_handler_and_data().

Fixes: 1add69880240 ("iio: adc: Add support for STM32 ADC core")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Tested-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://patch.msgid.link/20250515083101.3811350-1-nichen@iscas.ac.cn
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-adc-core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -429,10 +429,9 @@ static int stm32_adc_irq_probe(struct pl
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < priv->cfg->num_irqs; i++) {
-		irq_set_chained_handler(priv->irq[i], stm32_adc_irq_handler);
-		irq_set_handler_data(priv->irq[i], priv);
-	}
+	for (i = 0; i < priv->cfg->num_irqs; i++)
+		irq_set_chained_handler_and_data(priv->irq[i],
+						 stm32_adc_irq_handler, priv);
 
 	return 0;
 }


