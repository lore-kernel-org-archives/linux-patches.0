Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2289A2E2F10;
	Tue, 22 Jul 2025 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192383; cv=none; b=eoig+aEMaYch+ZYmp7u67JU5egzAlZrwrEIYWgD7xdBW1f0Dwlu/X0f9zpQmnd0swnK2gvfREKkgpKbY9GQePyrqvVDAHWiL3uO0cpf98H4WXn/t/chTU3pA4x6NUp633FgPM5wmCE9nO/RLbIYxc1mYjnEP1UI+XAOfcN7Uryg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192383; c=relaxed/simple;
	bh=Tk0yMiG8PFCiEvpeJx2zLUJvPTP3WMFUp08yZ6ZdUwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mmA1tUDpx/yycyit/rebleysFeOV82DVhiGGbuoTfQDk/ZNRJnsAMZ8XHEbV7yOXGeUQK7vvbtttPka1QFpzxuIFDfvr/QKExhJPYHtGQY10kk8gbENmW3Ayoz+ZVTidvEV5rqnX9HiqpGve6dIXlJk3azSMEXNL579RYJg0vC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nt7ZkoWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nt7ZkoWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC4CC4CEEB;
	Tue, 22 Jul 2025 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192383;
	bh=Tk0yMiG8PFCiEvpeJx2zLUJvPTP3WMFUp08yZ6ZdUwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nt7ZkoWILF/7c0T5XGSYA1+DIO5eDDh+mP3twAkhTuzEK/5bMjUqmx1WstzFlmxAo
	 J7iQD6e0oau9Y9C2EGpeXw9eXCZkkxHZ2nOCsAvl4WDmhxNJOV89rdje1pxqet427x
	 mHvz356Alvq2swBm0J54SQ9BLa1oNuUT4fDMkM50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 050/111] iio: adc: stm32-adc: Fix race in installing chained IRQ handler
Date: Tue, 22 Jul 2025 15:44:25 +0200
Message-ID: <20250722134335.250718987@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -428,10 +428,9 @@ static int stm32_adc_irq_probe(struct pl
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


