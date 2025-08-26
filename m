Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24D51D47B4;
	Tue, 26 Aug 2025 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213424; cv=none; b=bjY40pxAlQVLvnUtYeyWUborxiuuN6E7kpnR/vlKO5Q3KzdTM8l8OH5+KqnZD0ZGQunm5b8ekNByFxk4EMfhZzjQWvzG/8sYNH9Xpu8kKyNGh69IsbrZrQLGjhZTONMLSJguTs+5XIPhNJDunmsV38zN40K80yFiezfLCm8OHgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213424; c=relaxed/simple;
	bh=IIyAdOgumXDoBNYRx7Rbk11z3gHacO2FvJyQ8pbVD68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=endylX+oLGo9BEyAg8qPSaMM9ngdWaoRoVZNB/wu7GoTx9x6P5C6fYJngTn4V1YL3Fz6ioisumxuDpE7Mg+y932i88jMl6Lm+r39czv0qldm63dpRkU5ukk9nujQnWsn8Xu1LnAVk3uKC50Pmnj1bn9JgdyM8a7YWANAX//JbvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEUip+Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEUip+Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2232AC4CEF4;
	Tue, 26 Aug 2025 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213422;
	bh=IIyAdOgumXDoBNYRx7Rbk11z3gHacO2FvJyQ8pbVD68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEUip+Zdox/meWXax+E1MaMJikicsqvlTIvBkgmtCMLOhWm9jcnks8AYJoGtyKCbO
	 WBOM2hdSJZJwkTFDCzmaTtlZBge+JIy6a/DomtX+Fnz6FnKyBvWJuhG6uN4lKObBEo
	 LUDfc5Wt0JNHShugOn6VIKcTqb2eu90vnFXOSrXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 335/587] usb: musb: omap2430: fix device leak at unbind
Date: Tue, 26 Aug 2025 13:08:04 +0200
Message-ID: <20250826111001.440911956@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johan Hovold <johan@kernel.org>

commit 1473e9e7679bd4f5a62d1abccae894fb86de280f upstream.

Make sure to drop the reference to the control device taken by
of_find_device_by_node() during probe when the driver is unbound.

Fixes: 8934d3e4d0e7 ("usb: musb: omap2430: Don't use omap_get_control_dev()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20250724091910.21092-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -400,7 +400,7 @@ static int omap2430_probe(struct platfor
 	ret = platform_device_add_resources(musb, pdev->resource, pdev->num_resources);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err2;
+		goto err_put_control_otghs;
 	}
 
 	if (populate_irqs) {
@@ -413,7 +413,7 @@ static int omap2430_probe(struct platfor
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 		if (!res) {
 			ret = -EINVAL;
-			goto err2;
+			goto err_put_control_otghs;
 		}
 
 		musb_res[i].start = res->start;
@@ -441,14 +441,14 @@ static int omap2430_probe(struct platfor
 		ret = platform_device_add_resources(musb, musb_res, i);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to add IRQ resources\n");
-			goto err2;
+			goto err_put_control_otghs;
 		}
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err2;
+		goto err_put_control_otghs;
 	}
 
 	pm_runtime_enable(glue->dev);
@@ -463,7 +463,9 @@ static int omap2430_probe(struct platfor
 
 err3:
 	pm_runtime_disable(glue->dev);
-
+err_put_control_otghs:
+	if (!IS_ERR(glue->control_otghs))
+		put_device(glue->control_otghs);
 err2:
 	platform_device_put(musb);
 
@@ -477,6 +479,8 @@ static void omap2430_remove(struct platf
 
 	platform_device_unregister(glue->musb);
 	pm_runtime_disable(glue->dev);
+	if (!IS_ERR(glue->control_otghs))
+		put_device(glue->control_otghs);
 }
 
 #ifdef CONFIG_PM


