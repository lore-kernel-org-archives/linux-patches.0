Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516E1141998;
	Tue, 23 Jan 2024 01:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972119; cv=none; b=QptmEYjy/yAgS6TdWdLobbUveg2mywo6dtOO3ly3pN2KIoUtRPVSPkrkZeBaCDAil2RGlBOu0Dt5ofdX2astBP5GxqKjl1vitUpvuWs44OtSuMZKbbnjgN15bsg6TUej42/QXfhzzNs9LCTqgYQFreDO/SY3R5eW5379v6bQqK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972119; c=relaxed/simple;
	bh=zFITtTF3GrnJ9MnT8yDizDmbpy9usNULeFAWxQtutLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNDmAAZvHxlhXe0JsjItPm8lHy9/TxqbousWartmpjCyj6fu7hPbaRq5xq2MlHDBmhkzTAAauEQdyu90k87QaeERmZZRt4fMPnGh2mm5jMbWNuNu9XZ+s6YlDkgY5CdPT1MfFK96O1IhD+eGwARTheYIoJ9Q55nqhT09KlQZ/s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=man0OByL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="man0OByL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15610C43390;
	Tue, 23 Jan 2024 01:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972119;
	bh=zFITtTF3GrnJ9MnT8yDizDmbpy9usNULeFAWxQtutLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=man0OByLHMT5xK4pLc4DhdOSRbKLkJTFgcUqxbA5FhyLrdcvc4Qrxyg4grAqZflEB
	 ZEcRUJILGwh2MeVG7ZbmJOshK2o5g33Goj/QzaI6QMzbvEcahA39LFG5GPee/JGf3t
	 lHqHQTkl6bZharwyG58mshD22VEp0eK70yxFrgEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/374] ASoC: ops: add correct range check for limiting volume
Date: Mon, 22 Jan 2024 15:54:35 -0800
Message-ID: <20240122235745.298265298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit fb9ad24485087e0f00d84bee7a5914640b2b9024 ]

Volume can have ranges that start with negative values, ex: -84dB to
+40dB. Apply correct range check in snd_soc_limit_volume before setting
the platform_max. Without this patch, for example setting a 0dB limit on
a volume range of -84dB to +40dB would fail.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231204124736.132185-2-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 12effaa59fdb..c56379fac927 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -644,7 +644,7 @@ int snd_soc_limit_volume(struct snd_soc_card *card,
 	kctl = snd_soc_card_get_kcontrol(card, name);
 	if (kctl) {
 		struct soc_mixer_control *mc = (struct soc_mixer_control *)kctl->private_value;
-		if (max <= mc->max) {
+		if (max <= mc->max - mc->min) {
 			mc->platform_max = max;
 			ret = 0;
 		}
-- 
2.43.0



