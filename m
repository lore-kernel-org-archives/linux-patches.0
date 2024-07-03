Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A78174EF3;
	Wed,  3 Jul 2024 10:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004330; cv=none; b=lgUnHZfyKUioma/8c7YjaeF3GjMBHwUghp/W2dd9HCYK+Y7hsyz5/GCgoNMj4qBwV7Gxt9UtLWezaxJp4XAaoRa0FL15swWzwHapWHdiC6P57VkRK985h6BuIvS8hwrz57qjhQLH0cr+/il/t68Ag0k13i5JuMH/QRNRITLqBBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004330; c=relaxed/simple;
	bh=vKZoFLo98YZQdYGwGUIcQdkQjaXRXbY9fl10wEgnJSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMBfaObgD9VrbV8dz3i9Vwf5lC8mNW/DVj0pmlry2a6lpi9CY/BxH/UdQKqQtbVtWa6+ReSTCpbrrAsm2HI9/I8JNyMdVV7LkgiNjTSitif2T0sdzu/oVGVw4k/0NQF82kwdhoOYUlpQ3YGlJm7UJT+iMWktu37Lt80Xfcd6i3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UV9ZkTCy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UV9ZkTCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A43FC32781;
	Wed,  3 Jul 2024 10:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004330;
	bh=vKZoFLo98YZQdYGwGUIcQdkQjaXRXbY9fl10wEgnJSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV9ZkTCyL99eYNiE9Gi8yWxVPYzmQFh5VwyGXtri8W0oZ4dl1nNQ//mQ3/clnCZQT
	 Cz6lSrXfCppnpDg6UmuduPLvQwHd7fWi24Qg2zcZ2Vj4JXDHhevToLxI/lt8Prpw3V
	 Wu4Pk2506L1B+x0Gg648RyBT57hr4P1pP60J1Xwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5.4 167/189] usb: musb: da8xx: fix a resource leak in probe()
Date: Wed,  3 Jul 2024 12:40:28 +0200
Message-ID: <20240703102847.770869601@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


