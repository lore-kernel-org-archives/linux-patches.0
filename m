Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC32917E900;
	Sun,  1 Sep 2024 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209345; cv=none; b=M7Lp3BRjWQQAkwGVpoWSP/7BeQSewN236KSd7QWcRQIIXFHNBT/VJMgilaWEBIO7yMdUblcMLKzlXM/dnqkdJw6FUq8IaNlBf6DkH+PDm0ftzNM+7CT8JaqRLSAzo7l0lfqkFxPB2P2lI59glnBHFwYvQqSDvMuDP2CUi4NXzRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209345; c=relaxed/simple;
	bh=jhNaDcjOOXDfSv9K3T3magz4B6J+Wa9txVZExDW7q8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+puDbqepN+17WYrMmjghS+Ubfy2t9ieTvsrOtFQh0pJ4WI0S8g0H2r1QQ1n4FkVwtYcs3HsBIppKyQTwSzP3yUYDHUhfdi+BYO2/zJwGn8I97RJluYF7DRguTxvVZv9Aja9tCbCQ2LrCYRbyy63WfehdM5Np7qodWCR7ZmD3aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7xl9CfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7xl9CfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E40DC4CEC3;
	Sun,  1 Sep 2024 16:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209345;
	bh=jhNaDcjOOXDfSv9K3T3magz4B6J+Wa9txVZExDW7q8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7xl9CfDsfZ/U/ZXpltMxk1VqiGfLo6DZ72kBTddsfgSvbEHwvQOsv4Us1dWtKB9K
	 1sIHK/zh34rb6rbIgyo2nE9I9swGX4NlJ73OXmedfrPOP14mYLvbnxL5hzBWcNAKz6
	 +e3TNNZz9xy4Bo5l0wIL8Ffi7U+Ygfe52r82p/TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 6.1 59/71] usb: dwc3: omap: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:18:04 +0200
Message-ID: <20240901160804.115773535@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -522,11 +522,13 @@ static int dwc3_omap_probe(struct platfo
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


