Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E4A44C97;
	Sun,  1 Sep 2024 16:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208124; cv=none; b=orskubQlVrAIsXu8gkTCL3hc0zlxo9NuTUfRj5JK/9edYR1k7AOOl5Bw73HPhmOdf75pSWumJpByvkzxwEX4LOD7j5HDX8Pi7tOqvcBQV3Fpuo9E6pUQxrzE2cxWLoOKWcmjP6DNZddcUyBK/kq8VV6/9r+rEY+DNnUEbso64Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208124; c=relaxed/simple;
	bh=rwpXXgCyd2lx8ET1B72ssMyivpxfZ5rlzLwPN8QJTPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxS08sOSp1IM7HuULgzhMv4cgjWTLR1uBV3c6yw8zVN/g2Vs9128gnPcyIIjqz/Wrng+kfB3EFmwJRPmLQoW4F24XM2WMMKRawN4lPv+T75hXRixTOlwRRxs3HWFvkGQlSP0Tb5JCsaip92uzx7nY+pvDTrk9Ia+LnyE2nluEt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnRl2nCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnRl2nCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB031C4CEC3;
	Sun,  1 Sep 2024 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208124;
	bh=rwpXXgCyd2lx8ET1B72ssMyivpxfZ5rlzLwPN8QJTPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnRl2nCmjNHXLTGrKOdzp6APMGQZumuYpljw6W1K1pukV2XjKbMIbYSkbv8Ck6K2c
	 1I2dqy0KyCifVdpDTd6wqVrVREaKZssiqnlXWR6hteBX4PqduGpnYc7s/bgkBQ5+3j
	 YXVLCJu8cvbwln7m3e2nCYEiX3FCM0L4M6CXjErc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 81/93] usb: dwc3: st: add missing depopulate in probe error path
Date: Sun,  1 Sep 2024 18:17:08 +0200
Message-ID: <20240901160810.784386244@linuxfoundation.org>
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

commit cd4897bfd14f6a5388b21ba45a066541a0425199 upstream.

Depopulate device in probe error paths to fix leak of children
resources.

Fixes: f83fca0707c6 ("usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240814093957.37940-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-st.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -266,7 +266,7 @@ static int st_dwc3_probe(struct platform
 	if (!child_pdev) {
 		dev_err(dev, "failed to find dwc3 core device\n");
 		ret = -ENODEV;
-		goto err_node_put;
+		goto depopulate;
 	}
 
 	dwc3_data->dr_mode = usb_get_dr_mode(&child_pdev->dev);
@@ -282,6 +282,7 @@ static int st_dwc3_probe(struct platform
 	ret = st_dwc3_drd_init(dwc3_data);
 	if (ret) {
 		dev_err(dev, "drd initialisation failed\n");
+		of_platform_depopulate(dev);
 		goto undo_softreset;
 	}
 
@@ -291,6 +292,8 @@ static int st_dwc3_probe(struct platform
 	platform_set_drvdata(pdev, dwc3_data);
 	return 0;
 
+depopulate:
+	of_platform_depopulate(dev);
 err_node_put:
 	of_node_put(child);
 undo_softreset:


