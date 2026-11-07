Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062017;
	b=sRzb7ti2HiUhxozpouRlKq5EqtBI1VKjkdRsUEwPlDFd9bgzZY+gESEel6ksXZ6MyvKb
	 WMRc6I2CM1jDzD+22tX3k2yACDoyaYeJWn0bjtlpa41QJCKDkmlI4ZOmnyew0iPa0SCJ4
	 N036L28fkVu0sWSlRcjQs4hm3EypOe03cdo7P4lRKPN94cxIfr8zbMKp5o43V1WXnH2ZX
	 XpN9H2GgO2+iOAUnsvvzns91hLmWY4TUtShxREeArl+pF9euloF3F7CBd61FOzZX++pSo
	 TVk61Wk1lNr2/aryPvvvFcLlyYjzz6cf0447sD0vnJoZbb8bNuSH+ua+2LbxZ/lPUDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LkEpF6veOzauqus78C8B3YO3uF4t71is0nUzUPwKzEA=;
	b=1qO/PasZzy7bH7+YOVHgvSMTN4PSKPxki8MFO439Oj7yEbR+UTfjraJ/0t1lAetYKaPi
	 fXZ+1ggoBIRqncOjKMmFM4P9pCX8xiO1FEF4MXCSj4gmScF3+yxy8M94rJDIVnPFrzqy7
	 fxoog0g2tonY4/DhHE9Sa4Vb3ZiICP39mEoGCUQ+9iqQht8gulEXfBJLxwC4cPscIKDrE
	 ZVP29Y+maQ1Sq9kI7gVrLSVAdDNeDzvcsj7de7qe5dmCp2K+MZ9tn+Z6i/qtZt4qahGXz
	 kyKGKlDUQA0Ah1O6d7NdCsJAPmKPFa06w4Ve/9lTK6a6nbdBqKcKdK+rzBDRbol4nAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nKwqXfgr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84BA606A334;
	Sat,  7 Nov 2026 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nKwqXfgr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562681F0089F;
	Sat,  7 Nov 2026 14:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062016;
	bh=LkEpF6veOzauqus78C8B3YO3uF4t71is0nUzUPwKzEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKwqXfgrZ1nyc+ga9itszz8clngA5D7tNZdTk1ciJnoMcycFS0MgqEoaY+9ooqO/a
	 UCoM4RhBTQFmGkOCpBV+1a1FgpLGAgzUzmFsQZCBV2w2M8mvRRYTYvWwXCiwFoAnzx
	 QRMsFJ48Rgbtmkp47q2Arb5svg7BujqzHGXplyEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1005/1536] ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()
Date: Sat,  7 Nov 2026 08:50:21 -0500
Message-ID: <20261107135025.896481575@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b2c0e5bf750e33b0e1dcdfbb2df8103a06c7caab ]

wm8994_mic_detect() resumes the component before configuring the MICBIAS
pins, but the default case of the micbias switch returns -EINVAL right
after taking that reference, skipping the pm_runtime_put() on the
success path. This leaks a runtime PM reference on every call with an
invalid micbias.

Release the reference before returning -EINVAL.

Fixes: f5a2cda4f1db ("ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260917165130.2163278-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 4f11b95c78834..e3f0c68b26782 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3533,6 +3533,7 @@ int wm8994_mic_detect(struct snd_soc_component *component, struct snd_soc_jack *
 		break;
 	default:
 		dev_warn(component->dev, "Invalid MICBIAS %d\n", micbias);
+		pm_runtime_put(component->dev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



