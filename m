Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888333E00A9;
	Fri, 15 May 2026 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862139; cv=none; b=J16tTmATqMvodxn4UYPeTweKQw0k4AKjnCwKSx1j5wHEY0fCDLrkL44mkix8woOQkzJTHD2OLJ6nc+1UXxC3P2NuqZCV9u2ww9bva6wX1JFupCJgrUkrQnBk6UpRzIetQRt69eeUZZ/f9S436et5gT5KQmvvOHAhqVLtX/AysNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862139; c=relaxed/simple;
	bh=5sYXYCHne60F/xJopyKF2upAs8GAnr5WaZkMOeouQhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ONe+kdospCAB3xkiZoJqeADrY1/G5e//jtrsdC7GEPmqVREuq4B9//wDn5m7fBP9Y7mChK4uScZ5qfQvDRGgJUePOCBMst1aUYTGvsG6eYVq2H5qEWMT39c5srwCeCaGzpMhNWPzcGSd168922demSPqPd3pbe60rftwinvEjEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ocktVwGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ocktVwGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8473C2BCB0;
	Fri, 15 May 2026 16:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862139;
	bh=5sYXYCHne60F/xJopyKF2upAs8GAnr5WaZkMOeouQhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocktVwGBV/wRD9HCRiCga+kQDPTWvXcxGwEbg1uLnpP6ulgkIzDt5RW9Gjdw3oDeY
	 5iQKQ2WPjrvZDJp+0J7LBdcwYeUgCSqAt7YqyCgeG15skiQcPzyR0/C2LvT4+gXFKv
	 PDjl1W/oWChkZrMMhXjSkvQW7ykd1CgJhwsY5EFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	=?UTF-8?q?Rapha=C3=ABl=20Gallais-Pou?= <rgallaispou@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.18 124/188] drm/exynos: remove bridge when component_add fails
Date: Fri, 15 May 2026 17:49:01 +0200
Message-ID: <20260515154700.020653204@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 26f6654a9a60eb4d241f42a0ec85412e8821480b upstream.

Use devm_drm_bridge_add() so the bridge is released if probe fails after
registration, and drop the manual drm_bridge_remove() in remove().

Check the return value of devm_drm_bridge_add().

Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Fixes: 576d72fbfb45 ("drm/exynos: mic: add a bridge at probe")
Cc: stable@vger.kernel.org
Reviewed-by: Raphaël Gallais-Pou <rgallaispou@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260423200622.325076-2-osama.abdelkader@gmail.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/exynos/exynos_drm_mic.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/exynos/exynos_drm_mic.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_mic.c
@@ -423,7 +423,9 @@ static int exynos_mic_probe(struct platf
 
 	mic->bridge.of_node = dev->of_node;
 
-	drm_bridge_add(&mic->bridge);
+	ret = devm_drm_bridge_add(dev, &mic->bridge);
+	if (ret)
+		goto err;
 
 	pm_runtime_enable(dev);
 
@@ -443,12 +445,8 @@ err:
 
 static void exynos_mic_remove(struct platform_device *pdev)
 {
-	struct exynos_mic *mic = platform_get_drvdata(pdev);
-
 	component_del(&pdev->dev, &exynos_mic_component_ops);
 	pm_runtime_disable(&pdev->dev);
-
-	drm_bridge_remove(&mic->bridge);
 }
 
 static const struct of_device_id exynos_mic_of_match[] = {


