Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CF814A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2DZHQ5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94133C433C9;
	Mon, 23 Oct 2023 11:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059053;
	bh=QiFDHQklEurjHHjMQE5W/6tfBH7+s0cSVmOiwPHBy+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2DZHQ5CTDdtsAFQfjoRbOEB66014AnPeOElaWM/3qNtYB1KY3srIPrAyJPxBkRr4
	 SKcGLmhtM7nEEk+4dWBAbUKxvZUInSecnA25D1H9ZGPuKNgGW80GcsqipcnS83pMsl
	 VR9PFaLZkPc55jcpy8UOqVSS+XBzMS+67+GlMtYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 047/241] ASoC: codecs: wcd938x-sdw: fix runtime PM imbalance on probe errors
Date: Mon, 23 Oct 2023 12:53:53 +0200
Message-ID: <20231023104835.059547309@linuxfoundation.org>
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
@@ -1278,7 +1278,18 @@ static int wcd9380_probe(struct sdw_slav
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
@@ -1287,6 +1298,10 @@ static int wcd9380_remove(struct sdw_sla
 
 	component_del(dev, &wcd938x_sdw_component_ops);
 
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_dont_use_autosuspend(dev);
+
 	return 0;
 }
 


