Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062887;
	b=kYPNscndQrlgX/yYZ8T2jCB52ficIplEeAOiQE7lrTu9/bP5EXEOAH81pLu67+JUg7hr
	 LrmwnMDnjeSpTFspxQ1lXq7Ej3KJ1aUajtoxDKtqgoU9X9nFvbN9Ab4sZXpK3tjFrsbko
	 qc3q3ySfoVgS7hcCyiLqMSJQZZVBJ5tfG4tUH1R+wzD651qka/uLn7MbuUBvU/mO1Qty0
	 Tt/WH0r8wsOFHLzjbAKcjGcd0sVDa7zHDcDYc4d+YmAX2ehoAqbUXL5IldAQV4dMJs05K
	 eOdD2eBIIaRI0mMZsui6wm70eGtVf5mU76j9AuXPMrswmcI9112MlA3HiFEnp4dErtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kzBVlFm9JqCYTuMIXUtaK5nSMjvlagyIAHumSSNQV9U=;
	b=T7M1TpfG77d7fBAU3XqfPkQvWFszTpkhiSWQmJKomVY9VBmZUV+M3xo+ZZo7qbBiEmyC
	 jbIU/BjUB7YjraENgi676Y+PGrDkMd/BRosb9m6a6T3HyhdvSDtK2kIYjVAgpNRmpvatm
	 qmgpvYz2cR2PfJdvmbr2VCRE4wPEBIf9K/e+h4eJ/j/w3qxVKZZk3fNiW5QGCua1JtE3q
	 9YkWQmNT6p/emc4bJjlbDhs1HqX9NXXOFCzjZaS7YcRAhkC41d8vKP6aQpnrlz++X2f1I
	 GSIsTG9ooubOWJou/DXw+zM9fxv654nD+b95LkIXPmZZleirKvqtND1fHSnfY5nGudw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsgtDGft;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A093A606A326;
	Sat,  7 Nov 2026 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zsgtDGft
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCCB1F008A2;
	Sat,  7 Nov 2026 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062887;
	bh=kzBVlFm9JqCYTuMIXUtaK5nSMjvlagyIAHumSSNQV9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsgtDGfteZRgIaDAaZoevgQBcfZnJziwNwBv1wKFSx2FVbGi/nnXgeD8MuR98HC8j
	 R+AUXi0MzuO19VgWgwls4ZgebNvTlmIJ1rHOEPwCJrBzDD0hQZJCYC8t1rkNzXqWYY
	 9JB295YJ6a+A2mKe+Qp+9s/triU/6UHcpqQF1I3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/869] ASoC: codecs: wm8994: Fix runtime PM leak in wm8994_mic_detect()
Date: Sat,  7 Nov 2026 08:47:28 -0500
Message-ID: <20261107134857.872845931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71e8dd18b57be..80b1bb7e17749 100644
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



