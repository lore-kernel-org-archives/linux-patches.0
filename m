Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B79B18B48A;
	Tue, 10 Sep 2024 09:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962084; cv=none; b=OIq3VZaQjp9xZW8dHqghzHcGkKvMZsE5+tY2uyXBFk2I/O/knF7wFwq59zzXpKNBmUAQhHfS5TDfqlpMFy3IY39PL7z7wx2H3RIPfa/xE1P7votdotIvpfTIAF+cIOehDanKjkRrbzak6myM9zn10Ig35Gfpr8t/OK33lAcdtEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962084; c=relaxed/simple;
	bh=lobsw704lsCjqHGl9qujPZBnasEcR0YJJP0TSFaoqyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zeni5kO/C4V8VdvJZDeBTlM1GD55M5n65E8JWwtKveQW+CtpmMp/qkLrBs2H4uGoycSkVqeB7eL1TcOCnP7UgZn8SC8vaaL4ktkE+1wBGb2gF/uVRBXwh0tjXjt8Zcy7mXKj5szXXGVRxeToB2BLAoglO6THm0o7Si/BYtFpNbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yrswbbb+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yrswbbb+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F9C4CEC3;
	Tue, 10 Sep 2024 09:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962084;
	bh=lobsw704lsCjqHGl9qujPZBnasEcR0YJJP0TSFaoqyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yrswbbb+mxXIvV7WzX0Jp7CK1E9MiAA0hSs2yiHTpYHh7gGetiXB81fk12m0L4IPs
	 iXAoMmJ6NAOpGz1bN4uZbySQVMIm433M5q0yCXpWnt4kme6FOuWeOOal8mbugpplNq
	 tKYhzR9mTinxxlE0C6UjjrUYdccLn7ddXkl8phRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.10 290/375] iio: adc: ad_sigma_delta: fix irq_flags on irq request
Date: Tue, 10 Sep 2024 11:31:27 +0200
Message-ID: <20240910092632.310240423@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit e81bb580ec08d7503c14c92157d810d306290003 upstream.

With commit 7b0c9f8fa3d2 ("iio: adc: ad_sigma_delta: Add optional irq
selection"), we can get the irq line from struct ad_sigma_delta_info
instead of the spi device. However, in devm_ad_sd_probe_trigger(), when
getting the irq_flags with irq_get_trigger_type() we are still using
the spi device irq instead of the one used for devm_request_irq().

Fixes: 7b0c9f8fa3d2 ("iio: adc: ad_sigma_delta: Add optional irq selection")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240806-dev-fix-ad-sigma-delta-v1-1-aa25b173c063@analog.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -568,7 +568,7 @@ EXPORT_SYMBOL_NS_GPL(ad_sd_validate_trig
 static int devm_ad_sd_probe_trigger(struct device *dev, struct iio_dev *indio_dev)
 {
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
-	unsigned long irq_flags = irq_get_trigger_type(sigma_delta->spi->irq);
+	unsigned long irq_flags = irq_get_trigger_type(sigma_delta->irq_line);
 	int ret;
 
 	if (dev != &sigma_delta->spi->dev) {


