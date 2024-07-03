Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50471175555;
	Wed,  3 Jul 2024 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003719; cv=none; b=qI4SvrfZcfeCSdegvAZsHhJfFMHYW3yIJoCAwm8GjW0xdWAcjHLibEpP5WRayyOa7rbk3hUoMK0SlBFKra3sN2vXqlzqHleUJcG5oSTFOUoL4TtdQLONLTxP4jsOr+xfkDXxjYjxMuk/PAr4SMGW9EZ+pQU7eA7rrvE+s8/t8kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003719; c=relaxed/simple;
	bh=HA+nT+fZXbqImXhijAbXeRL9OHB/8w4B+BqSwVgZ2TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz6hDFPrXZbjo2VtNf7Lm43OLsP+GZbSSmcs1gS/LDs/FEJknTC6SV1PNhwlvXjjb1Wjc8loHjwROW20MgQo8Y0tdD6/Bi67vvtO7yqtpsDZoFBy6jfi+fvLQoj+8KkGnF0pGVtemhshxNSp7Uv28rzzDoK6ebsgFj8q5QV48I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/wzPOM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/wzPOM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B9EC2BD10;
	Wed,  3 Jul 2024 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003719;
	bh=HA+nT+fZXbqImXhijAbXeRL9OHB/8w4B+BqSwVgZ2TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/wzPOM9+QOfEHoQ5lgBf4M+67wQHhFeoZtsNIn0AHrJImBL8dzrzaKS5UP2okuqx
	 T0QCSYFlHtLWfWKsuu/41svfAEZ+NrXKS5O0EmOiTPwoKqHC7pGAPKeB8VzAwAySLV
	 aqQskCVx02pCkFJ+Ctmfb4oYN8bGW+Us1z00AxEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 4.19 125/139] usb: musb: da8xx: fix a resource leak in probe()
Date: Wed,  3 Jul 2024 12:40:22 +0200
Message-ID: <20240703102835.156313093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit de644a4a86be04ed8a43ef8267d0f7d021941c5e upstream.

Call usb_phy_generic_unregister() if of_platform_populate() fails.

Fixes: d6299b6efbf6 ("usb: musb: Add support of CPPI 4.1 DMA controller to DA8xx")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/69af1b1d-d3f4-492b-bcea-359ca5949f30@moroto.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/da8xx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -556,7 +556,7 @@ static int da8xx_probe(struct platform_d
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		return ret;
+		goto err_unregister_phy;
 
 	memset(musb_resources, 0x00, sizeof(*musb_resources) *
 			ARRAY_SIZE(musb_resources));
@@ -582,9 +582,13 @@ static int da8xx_probe(struct platform_d
 	ret = PTR_ERR_OR_ZERO(glue->musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
-		usb_phy_generic_unregister(glue->usb_phy);
+		goto err_unregister_phy;
 	}
 
+	return 0;
+
+err_unregister_phy:
+	usb_phy_generic_unregister(glue->usb_phy);
 	return ret;
 }
 


