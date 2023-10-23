Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2C15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEyy4ecC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62629C433CA;
	Mon, 23 Oct 2023 11:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060957;
	bh=Rd3nNFSurS5aBMiS36ox5AOV6zWQI2VUzTbY3dW2rxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEyy4ecCvuMw7BMpmIifPV5xx2NZD1rxq9ZoUOKLmne8qhOFRPAYYNGKwfzdAVvzK
	 8tFFMFVKtwbtLYwA3c4r73EBcpnSCDXTdDDvdHoh2myCeQd7oAWFdqO+03Rzpq4JnC
	 e5ia0rgO5cLFp302nh/cwQbwqAjMzhVb0Upsxeog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 026/137] ASoC: codecs: wcd938x-sdw: fix runtime PM imbalance on probe errors
Date: Mon, 23 Oct 2023 12:56:23 +0200
Message-ID: <20231023104821.864936309@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit c5c0383082eace13da2ffceeea154db2780165e7 upstream.

Make sure to balance the runtime PM operations, including the disable
count, on probe errors and on driver unbind.

Fixes: 16572522aece ("ASoC: codecs: wcd938x-sdw: add SoundWire driver")
Cc: stable@vger.kernel.org      # 5.14
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231003155558.27079-8-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x-sdw.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/wcd938x-sdw.c
+++ b/sound/soc/codecs/wcd938x-sdw.c
@@ -266,7 +266,18 @@ static int wcd9380_probe(struct sdw_slav
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	return component_add(dev, &wcd938x_sdw_component_ops);
+	ret = component_add(dev, &wcd938x_sdw_component_ops);
+	if (ret)
+		goto err_disable_rpm;
+
+	return 0;
+
+err_disable_rpm:
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+
+	return ret;
 }
 
 static int wcd9380_remove(struct sdw_slave *pdev)
@@ -275,6 +286,10 @@ static int wcd9380_remove(struct sdw_sla
 
 	component_del(dev, &wcd938x_sdw_component_ops);
 
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+
 	return 0;
 }
 


