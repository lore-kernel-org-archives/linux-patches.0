Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89792EAE5;
	Thu, 12 Dec 2024 15:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016643; cv=none; b=ClCtzHcGnJucbkZgf2i9dThSu28C5A4cjGETubWzvORRAbJaVLrk5G42FiucYcoNS0OEzjnxDH52w4WReOpUb9YA0lGwXPkASWt8GCdCXAxroUI1NyqL4qrxOFDuudQSD0jn13673rCVSY+BBoIw7CNHnDmP1e09BE/pAt70L1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016643; c=relaxed/simple;
	bh=Td66NEbgNbDRkTMygdeZH9hjgDiLU13kkB4yaoxcS8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDZRhzmssfdw/tjW4dWasb4yBIVAkHWEjN079vSAkWd6qsiS5NnUvcM//GpqG9rGws6cFHSb+nd73QQQD+8GAtoE57r+oGmTKfNFGMS3w9hs1Pw4+bqC993JvAg8l8xZADs7HjoXDVdamkwxTy4+YHDh40srKmNJ7sO1dBJ3OQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5zeUQJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5zeUQJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82DDC4CEE7;
	Thu, 12 Dec 2024 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016643;
	bh=Td66NEbgNbDRkTMygdeZH9hjgDiLU13kkB4yaoxcS8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5zeUQJgoIe4JckaAAW+JRosijg2L7/+5ZepunvZ5FHCXBFitMYhrK59/bq2mGB4k
	 nFR2z7f2P5eTWhvMyiUcj0w09YippH4xO9geG6Cbz5ttZ3tRazA+v+n/WJNMFgb61U
	 28ixEgxhEOogJFRoGUdmRRj0jxB2KSNPsIf1AEr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dom Cobley <popcornmix@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 255/466] drm/vc4: hdmi: Avoid log spam for audio start failure
Date: Thu, 12 Dec 2024 15:57:04 +0100
Message-ID: <20241212144316.863963827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2d7d3e90f3be4..7e0a5ea7ab859 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1924,7 +1924,7 @@ static int vc4_hdmi_audio_startup(struct device *dev, void *data)
 	}
 
 	if (!vc4_hdmi_audio_can_stream(vc4_hdmi)) {
-		ret = -ENODEV;
+		ret = -ENOTSUPP;
 		goto out_dev_exit;
 	}
 
-- 
2.43.0



