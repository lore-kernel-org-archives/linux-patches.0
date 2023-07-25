Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734EE15AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC106C433C8;
	Tue, 25 Jul 2023 10:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282346;
	bh=PYZ24E6ZDFJRfuCgUGbQDtHOmvWNEBI5BdcBoLSRUWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOyLBOjyiPL2FYLfD2Vj1YOwbo3geW8/QKlR6iftHGY0XmAHTbmfuwI2M+OrnWYCj
	 ibKqjLy4bUD3JEaFI7uT/D/X2lfbWiwP2GG936eO5vp89qPaFjM/jo/PXE/Ujbcz5t
	 2gCCpt0BAMTQkYvbMZetaO4zt0VItWQPfUhB35oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.4 068/227] ASoC: codecs: wcd934x: fix resource leaks on component remove
Date: Tue, 25 Jul 2023 12:43:55 +0200
Message-ID: <20230725104517.580528681@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 798590cc7d3c2b5f3a7548d96dd4d8a081c1bc39 upstream.

Make sure to release allocated MBHC resources also on component remove.

This is specifically needed to allow probe deferrals of the sound card
which otherwise fails when reprobing the codec component.

Fixes: 9fb9b1690f0b ("ASoC: codecs: wcd934x: add mbhc support")
Cc: stable@vger.kernel.org      # 5.14
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230705123018.30903-6-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -3044,6 +3044,17 @@ static int wcd934x_mbhc_init(struct snd_
 
 	return 0;
 }
+
+static void wcd934x_mbhc_deinit(struct snd_soc_component *component)
+{
+	struct wcd934x_codec *wcd = snd_soc_component_get_drvdata(component);
+
+	if (!wcd->mbhc)
+		return;
+
+	wcd_mbhc_deinit(wcd->mbhc);
+}
+
 static int wcd934x_comp_probe(struct snd_soc_component *component)
 {
 	struct wcd934x_codec *wcd = dev_get_drvdata(component->dev);
@@ -3077,6 +3088,7 @@ static void wcd934x_comp_remove(struct s
 {
 	struct wcd934x_codec *wcd = dev_get_drvdata(comp->dev);
 
+	wcd934x_mbhc_deinit(comp);
 	wcd_clsh_ctrl_free(wcd->clsh_ctrl);
 }
 


