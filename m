Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E62205501;
	Thu, 12 Dec 2024 16:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021234; cv=none; b=RyrqAP4S7AuE/Cjy5ofVr2l9xpDAzhvyVCA9aZxLyvcYx8OKufjrNrMW9zvPqTZB3/oVCdqPgFqdLAbcm/skAuIQ7nCwLWUzzfgZqcOwLy6bh6b6mpoHlHvPaKoA1NnSbpgt4908lbUKY8HUtqylc6MGSF5XHUVq7Y430sBy0Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021234; c=relaxed/simple;
	bh=lkLoE4zVZW9XeO9QzMvQKBnJu9p3basbAEeuhBO9TAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5ShN+egtEKLK4eISfHjKpyicxjgtj3QrLIwnvgs/b3BvlcM1bHkpxw/PxPfYkh+Wc9dDCNZx+OcghUlNq3HIeVMci+99Tg1qbQqSGFqkbFOjBJeMFuzmNWXSSpEN1RuRxc8FP896JsV9aFxK9cBcnVWnN5AgWq/pmVFoUrtXOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynjmPUfN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynjmPUfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D66C4CECE;
	Thu, 12 Dec 2024 16:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021234;
	bh=lkLoE4zVZW9XeO9QzMvQKBnJu9p3basbAEeuhBO9TAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynjmPUfNVvcMp3sDh9eGoDNbmQ31mrB1WLNEBC6xJp/tKPrNrh62JT/I//md1U98+
	 c51o57ycOlQED+7TNyik1jqwBMFCeZ5fdiRJi8Xwo5wPLgUo6xu+AL/Ry3aBz42+rK
	 O03BtM/kVJ/xB1+wEWcmW386BH5tuHTvvKSaxdIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 653/772] drm/vc4: hdmi: Avoid log spam for audio start failure
Date: Thu, 12 Dec 2024 15:59:58 +0100
Message-ID: <20241212144416.900242192@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dom Cobley <popcornmix@gmail.com>

[ Upstream commit b4e5646178e86665f5caef2894578600f597098a ]

We regularly get dmesg error reports of:
[   18.184066] hdmi-audio-codec hdmi-audio-codec.3.auto: ASoC: error at snd_soc_dai_startup on i2s-hifi: -19
[   18.184098]  MAI: soc_pcm_open() failed (-19)

These are generated for any disconnected hdmi interface when pulseaudio
attempts to open the associated ALSA device (numerous times). Each open
generates a kernel error message, generating general log spam.

The error messages all come from _soc_pcm_ret in sound/soc/soc-pcm.c#L39
which suggests returning ENOTSUPP, rather that ENODEV will be quiet.
And indeed it is.

Signed-off-by: Dom Cobley <popcornmix@gmail.com>
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621152055.4180873-5-dave.stevenson@raspberrypi.com
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 649fd5c03f21d..3573db34a26b7 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2160,7 +2160,7 @@ static int vc4_hdmi_audio_startup(struct device *dev, void *data)
 	}
 
 	if (!vc4_hdmi_audio_can_stream(vc4_hdmi)) {
-		ret = -ENODEV;
+		ret = -ENOTSUPP;
 		goto out_dev_exit;
 	}
 
-- 
2.43.0



