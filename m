Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB1514A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/mcQW9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A556C433C9;
	Mon, 23 Oct 2023 11:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059068;
	bh=ivrtI1ZHLYv3wsCwrZOws0rK4BN3OBIaxiGXab1wUS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/mcQW9ARtkIw7YL9gYid9fVRM3mjhWcXrF8GMUxj08J3u8zdwMlShus9d7RgfN0b
	 2z3OzL9VZ4SlgOfZbCbkhzFWxADAQBPWY2tmb61dYxddEyXWR550Zo5HVCKYf86U8j
	 6O773cNYrKYA7puRuT1RKCUMOZ9TPJSgnNLa8OqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 052/241] ASoC: codecs: wcd938x: fix runtime PM imbalance on remove
Date: Mon, 23 Oct 2023 12:53:58 +0200
Message-ID: <20231023104835.177710411@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 3ebebb2c1eca92a15107b2d7aeff34196fd9e217 upstream.

Make sure to balance the runtime PM operations, including the disable
count, on driver unbind.

Fixes: 16572522aece ("ASoC: codecs: wcd938x-sdw: add SoundWire driver")
Cc: stable@vger.kernel.org      # 5.14
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231003155558.27079-6-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -3620,9 +3620,15 @@ err_disable_regulators:
 
 static void wcd938x_remove(struct platform_device *pdev)
 {
-	struct wcd938x_priv *wcd938x = dev_get_drvdata(&pdev->dev);
+	struct device *dev = &pdev->dev;
+	struct wcd938x_priv *wcd938x = dev_get_drvdata(dev);
+
+	component_master_del(dev, &wcd938x_comp_ops);
+
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_dont_use_autosuspend(dev);
 
-	component_master_del(&pdev->dev, &wcd938x_comp_ops);
 	regulator_bulk_disable(WCD938X_MAX_SUPPLY, wcd938x->supplies);
 	regulator_bulk_free(WCD938X_MAX_SUPPLY, wcd938x->supplies);
 }


