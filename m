Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3417183CC3;
	Sun,  1 Sep 2024 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208115; cv=none; b=IlLSu65IiIMibEIySjTW7HCBPbqivVMKmzvOiOCURWLhabhhDQOy30F4YzFAjozQr4+VnYuiYJNMkqnJR6hksM1yI/Kt2xPeK4zi2/7nBVylpAo4BfqrAW4t5xAMbvicHOZGtKMiar7TlKAzD2P9En1M2oHfQrpEzTxwyAt89Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208115; c=relaxed/simple;
	bh=3fFpSZ1vdASQmz/DN8EFx18NuYBvPqQIZ3+CTkaGR9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOZm0xdW8uzhLfywdeHCbqJd/AjkjMgklvmj1XQ/32tKRSx+LNhF6wip3Piqb8vCerVeAFHqC0PBbjThzjeXcJK7CHrra56tCHUZCcDaZDfNc3SHLCKg1yB4ZzNNQE4qN/WjfFkaoYERpc4SJVc3dTFLINzQ7klXMB92m40WP+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dshKwQcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dshKwQcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F338C4CEC3;
	Sun,  1 Sep 2024 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208114;
	bh=3fFpSZ1vdASQmz/DN8EFx18NuYBvPqQIZ3+CTkaGR9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dshKwQcX11yVW/i+AjbD+LO4gbEbsVLJvBOUiu8SvkdoWSwdQX90Wp15AMQfysmQS
	 2ObBLXyXPXPhMXbJD/n5uaE1gTrDW/lnxelYFc+jLbshS0C2qoCvaV3ufFzCtiH1z3
	 +1I9K76xLTgFQ9EPRAsay9HqFoM7TCt5Dx8u3Obc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 6.6 78/93] usb: dwc3: omap: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:17:05 +0200
Message-ID: <20240901160810.673075721@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


