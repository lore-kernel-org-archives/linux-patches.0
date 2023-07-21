Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D60200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BC4C433C7;
	Fri, 21 Jul 2023 19:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966301;
	bh=Bd5CoCKczjRO00xeFgfrFr+s6KuMMawai1TfAHFy19s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mYWRHwmvNIh0n0CExznJcMft2KVA9C2BJYBKuzAUTIMgqzBS03ElOa/J4c78r3wfX
	 r93hzLOX+W4CznwPrDcZBWMM5XZKmN6mIjwLJcnsmsnCTS6Hu/mXQlNUNkaGitEa/X
	 O4DrPLFn+2IEY+C4G1/1i88VWtdLtZONRVInelTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/532] usb: dwc3-meson-g12a: Fix an error handling path in dwc3_meson_g12a_probe()
Date: Fri, 21 Jul 2023 18:03:20 +0200
Message-ID: <20230721160630.449209392@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 01052b91c9808e3c3b068ae2721cb728ec9aa4c0 ]

If dwc3_meson_g12a_otg_init() fails, resources allocated by the previous
of_platform_populate() call should be released, as already done in the
error handling path.

Fixes: 1e355f21d3fb ("usb: dwc3: Add Amlogic A1 DWC3 glue")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Message-ID: <9d28466de1808ccc756b4cc25fc72c482d133d13.1686403934.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-meson-g12a.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-meson-g12a.c b/drivers/usb/dwc3/dwc3-meson-g12a.c
index bd814df3bf8b8..8f94bc4a82cf2 100644
--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -805,7 +805,7 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 
 	ret = dwc3_meson_g12a_otg_init(pdev, priv);
 	if (ret)
-		goto err_phys_power;
+		goto err_plat_depopulate;
 
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
@@ -813,6 +813,9 @@ static int dwc3_meson_g12a_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_plat_depopulate:
+	of_platform_depopulate(dev);
+
 err_phys_power:
 	for (i = 0 ; i < PHY_COUNT ; ++i)
 		phy_power_off(priv->phys[i]);
-- 
2.39.2



