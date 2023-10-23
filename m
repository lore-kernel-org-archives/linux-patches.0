Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DCE15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqP9Txq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74982C433C8;
	Mon, 23 Oct 2023 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060954;
	bh=gr+G6nB0J5bQ2q1CvZA7as76+jFKIWjze4gFrxcAEG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqP9Txq33Cauaglziy6fHky+xaruqD74ovq6gJ+IWYXhVJw3TDwxFV6m0R3OTc1o0
	 bWgGWoz4a+499Jg/jBFbYRvJRAMElPilW2MOpOy4Q5+61xw1MxbDFum4mFCoLLJnTU
	 ubKcXFeDv543ScY2mSy4fgOou85qwMBCw+j77CW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 025/137] ASoC: codecs: wcd938x-sdw: fix use after free on driver unbind
Date: Mon, 23 Oct 2023 12:56:22 +0200
Message-ID: <20231023104821.828267566@linuxfoundation.org>
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

commit f0dfdcbe706462495d47982eecd13a61aabd644d upstream.

Make sure to deregister the component when the driver is being unbound
and before the underlying device-managed resources are freed.

Fixes: 16572522aece ("ASoC: codecs: wcd938x-sdw: add SoundWire driver")
Cc: stable@vger.kernel.org      # 5.14
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231003155558.27079-7-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x-sdw.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/soc/codecs/wcd938x-sdw.c
+++ b/sound/soc/codecs/wcd938x-sdw.c
@@ -269,6 +269,15 @@ static int wcd9380_probe(struct sdw_slav
 	return component_add(dev, &wcd938x_sdw_component_ops);
 }
 
+static int wcd9380_remove(struct sdw_slave *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	component_del(dev, &wcd938x_sdw_component_ops);
+
+	return 0;
+}
+
 static const struct sdw_device_id wcd9380_slave_id[] = {
 	SDW_SLAVE_ENTRY(0x0217, 0x10d, 0),
 	{},
@@ -307,6 +316,7 @@ static const struct dev_pm_ops wcd938x_s
 
 static struct sdw_driver wcd9380_codec_driver = {
 	.probe	= wcd9380_probe,
+	.remove	= wcd9380_remove,
 	.ops = &wcd9380_slave_ops,
 	.id_table = wcd9380_slave_id,
 	.driver = {


