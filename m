Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870E944C97;
	Sun,  1 Sep 2024 16:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207862; cv=none; b=DlKROgIFGQ1PiFpT8f3v3NVXLwlJpn2LCO8Ht8QAuap7C9jX8JOKwU7m3dz0sloY7RdagPRVC1Y8wuiqVijND1iTHgdAFYNH/AaCSbdhqRYFHfz4S63fH7hbVVJ/+XYdf7kqtqL/hzZ5hcgzWigX3nMdL81l3JHAzOtU4Bpo0w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207862; c=relaxed/simple;
	bh=I4DcNgIsYOnkrmjIjNQxl2B43x3JJR+SefB0WwDGcTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIg/xlLJ0ohmkrIIVfKJT7uplsDl24ZiKyMnSj+OUOi7j6zX0U+ZCAytEg4RzBsE/Iac4gNiwQBZchybVeQ8xtEUmORHXsL8R7X6kuTvDw8/u+4olE/YZgqEMo256VW/JcHmc2zjdOlvAt5fbkSn9YTu4CouZU/buLXHVRq+xDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dxo0ZH++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dxo0ZH++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4C7C4CEC3;
	Sun,  1 Sep 2024 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207862;
	bh=I4DcNgIsYOnkrmjIjNQxl2B43x3JJR+SefB0WwDGcTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dxo0ZH++rPebtiWBEZAJndjHKU7LcQ+YGzU46uIm+EIgo5su/U6cgMgg9d9NPz7Kq
	 StQcZCCQOHRP3bz+6RcD8O5qwDndTQF5Vc4LMNV5dSIHoESJWHWieuR5VYv0BD2HdP
	 5h+OLU+ByFlXhVcUc0PpXKTB/TOmf8TXjeat9Po0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 4.19 92/98] usb: dwc3: omap: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:17:02 +0200
Message-ID: <20240901160807.166843148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 2aa765a43817ec8add990f83c8e54a9a5d87aa9c upstream.

Depopulate device in probe error paths to fix leak of children
resources.

Fixes: ee249b455494 ("usb: dwc3: omap: remove IRQ_NOAUTOEN used with shared irq")
Cc: stable@vger.kernel.org
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/20240816075409.23080-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-omap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -526,11 +526,13 @@ static int dwc3_omap_probe(struct platfo
 	if (ret) {
 		dev_err(dev, "failed to request IRQ #%d --> %d\n",
 			omap->irq, ret);
-		goto err1;
+		goto err2;
 	}
 	dwc3_omap_enable_irqs(omap);
 	return 0;
 
+err2:
+	of_platform_depopulate(dev);
 err1:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);


