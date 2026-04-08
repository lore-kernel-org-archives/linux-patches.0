Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5C12F39C2;
	Wed,  8 Apr 2026 18:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674698; cv=none; b=GZpPRZKWZQ+jBiRjIl+6VcqtHDX8y7VeMgQpoydv/iyyR3PY1Cb+KKYGBRvAg0rdWce2GeR3ixiriSL5+si2KB0QbFC8FYzja9y+F/cK+Ppbvz2mtWBh4kAMRrRfRy8afY69bt41zXNYu/+MlRuwR5HcjIUXu9qHnecC8Rps/b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674698; c=relaxed/simple;
	bh=7dbb9eM6EUzeDM8AgIU9Lg0sp5baX2sNFEjDf3mHD0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3iogpqwBuQJejOEDtE8WmG7UyXcA06fYPsJlRMUurv1dI1/8Z81jxBimpWZ3eqsQ1iyZtStNdFWlvhEgIIFS2f6YhECbFvgb+g03DAHZ8NjfUgQ2+4R8exLtsaiiCIEi/8oo+oyPWKt8KgiPyLGx0NNEywkfW3Gvy6FbQJPi9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXGu8SXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXGu8SXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B4C2BC87;
	Wed,  8 Apr 2026 18:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674697;
	bh=7dbb9eM6EUzeDM8AgIU9Lg0sp5baX2sNFEjDf3mHD0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXGu8SXCRSxyrEJFbx6sYrFarWV39USsS6xMVVaNe8rPV1irErxyG+XZm+BwTYaPB
	 /5QyNWyuF19Lnkj54Fcp7pEKe/LcN9imx7276oWtQbTSVP5WGSzhXKOzzK96lPe6FQ
	 vd1pHY2LjJq4Q8KHdmXfWfVWYf+yqLFkhRXEyKek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 198/311] iio: adc: ti-ads1119: Replace IRQF_ONESHOT with IRQF_NO_THREAD
Date: Wed,  8 Apr 2026 20:03:18 +0200
Message-ID: <20260408175946.805555525@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 36f6d4db3c5cb0f58fb02b1f54f9e86522d2f918 upstream.

As there is no threaded handler, replace devm_request_threaded_irq()
with devm_request_irq(), and as the handler calls iio_trigger_poll()
which may not be called from a threaded handler replace IRQF_ONESHOT
with IRQF_NO_THREAD.

Since commit aef30c8d569c ("genirq: Warn about using IRQF_ONESHOT
without a threaded handler"), the IRQ core checks IRQF_ONESHOT flag
in IRQ request and gives a warning if there is no threaded handler.

Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -738,10 +738,8 @@ static int ads1119_probe(struct i2c_clie
 		return dev_err_probe(dev, ret, "Failed to setup IIO buffer\n");
 
 	if (client->irq > 0) {
-		ret = devm_request_threaded_irq(dev, client->irq,
-						ads1119_irq_handler,
-						NULL, IRQF_ONESHOT,
-						"ads1119", indio_dev);
+		ret = devm_request_irq(dev, client->irq, ads1119_irq_handler,
+				       IRQF_NO_THREAD, "ads1119", indio_dev);
 		if (ret)
 			return dev_err_probe(dev, ret,
 					     "Failed to allocate irq\n");


