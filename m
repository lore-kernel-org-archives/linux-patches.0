Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCCC1BE227;
	Tue,  2 Jul 2024 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941133; cv=none; b=hmLHwdpmV+mprtOeXqJpxQwzujAlPLxFEHNqaMo2G/7tB/XIhG2Q70chAMh62QwPbqAkW65lNMXpboDQp3SHdOsIL+Y0FxUQDAti6O35pGaNhKjzFvNwQa9VGvZo7xOa9W0jp6fsvfAE2tiG/0OoLIcbrQPGDzorPR833un+GYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941133; c=relaxed/simple;
	bh=vBP0bYHxVD0yIiGLDFC55AsKdjtBooTSaPrJq0QPXKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZupOg/PRfG85359gNz+hvN+9ufXtaGGE5bw8D6xjReGWvqifoerKn0TGKRFqtWToTLm6Pour2wNcMl341R3tK3PWS5ZY+wq9lJ6LaoTylPHvDU25Irig3mSmBA6hLJW9KTNrUg+ra29b70DXH/ZJT0kqlU4IS9W1EMcNLBOH6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sItZ5YqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sItZ5YqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF1FC116B1;
	Tue,  2 Jul 2024 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941133;
	bh=vBP0bYHxVD0yIiGLDFC55AsKdjtBooTSaPrJq0QPXKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sItZ5YqIsk0GwWYmru0QdcVjjlf/lZewc9QTKfe+YfBSwXJ0mYuWa2e1vuan8pvYi
	 Q5Hqj/k3EAtrmy/vGzapZ/nz0Dk/7jP2kJMdFcIAQ0C53n1PF04FSIXfIzGfot+tgL
	 CDVJToGW44XVYqJi42xSYRRHhaaTz/7ill7JclcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 6.6 107/163] usb: musb: da8xx: fix a resource leak in probe()
Date: Tue,  2 Jul 2024 19:03:41 +0200
Message-ID: <20240702170237.108596474@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
@@ -555,7 +555,7 @@ static int da8xx_probe(struct platform_d
 	ret = of_platform_populate(pdev->dev.of_node, NULL,
 				   da8xx_auxdata_lookup, &pdev->dev);
 	if (ret)
-		return ret;
+		goto err_unregister_phy;
 
 	pinfo = da8xx_dev_info;
 	pinfo.parent = &pdev->dev;
@@ -570,9 +570,13 @@ static int da8xx_probe(struct platform_d
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
 


