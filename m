Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0781DF25A;
	Tue,  8 Oct 2024 13:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393081; cv=none; b=WINpNGFPw3Ucnf8z3DT09eYOCCGrRSuNToJa8IbvS9UY4dsdzVrZOX5r/aMK9HcFjGgqwM/OAvzhRbeHgBhqRaZk6fH4LYq7NoWAm6zqAKmysqgrVRj8cUr84tVIQ2flq3uNqOKLjiXvaRndFxoB/7I2ZnmUQNVr6BW0yARCghY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393081; c=relaxed/simple;
	bh=odK5TkuBWv3gGvQcdti9LFvOzFwlinUBWJruBkm3rOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hls0XcT8PKR6mICtM5nl06QRxlbshiMGWVKP0tqKZ4lyxg987uXwDJJN8w9j0g3oVSrfU9mE7ElE9aJYShzOkIZDxtNYn1u+hFY3/yc0K60Iq/H1L/rQjE4FEHgwusFEChdcfPy2a92z/rkbgXqPsk4MxzmBBwcITHwpm7HW3jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+QYUb6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+QYUb6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584A9C4CEC7;
	Tue,  8 Oct 2024 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393080;
	bh=odK5TkuBWv3gGvQcdti9LFvOzFwlinUBWJruBkm3rOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+QYUb6RCvAFaJyu/YJE8bXh/1KGpcE1MfV+KiASiVlDc7f6jjnpTIfjyHtY2/cJl
	 uheZvAlZH6YNrUoQRta7uiJ4QJBEzgtc7McxCzZv/0ni1lm8KHixwPQvUKrkqO1Xk8
	 tKOCZSxovmjY5mQlv6HNK5IPCnK2Z4P1rcShKAwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/386] ASoC: atmel: mchp-pdmc: Skip ALSA restoration if substream runtime is uninitialized
Date: Tue,  8 Oct 2024 14:04:51 +0200
Message-ID: <20241008115631.284371950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Simion <andrei.simion@microchip.com>

[ Upstream commit 09cfc6a532d249a51d3af5022d37ebbe9c3d31f6 ]

Update the driver to prevent alsa-restore.service from failing when
reading data from /var/lib/alsa/asound.state at boot. Ensure that the
restoration of ALSA mixer configurations is skipped if substream->runtime
is NULL.

Fixes: 50291652af52 ("ASoC: atmel: mchp-pdmc: add PDMC driver")
Signed-off-by: Andrei Simion <andrei.simion@microchip.com>
Link: https://patch.msgid.link/20240924081237.50046-1-andrei.simion@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/mchp-pdmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/atmel/mchp-pdmc.c b/sound/soc/atmel/mchp-pdmc.c
index dcc4e14b3dde2..206bbb5aaab5d 100644
--- a/sound/soc/atmel/mchp-pdmc.c
+++ b/sound/soc/atmel/mchp-pdmc.c
@@ -285,6 +285,9 @@ static int mchp_pdmc_chmap_ctl_put(struct snd_kcontrol *kcontrol,
 	if (!substream)
 		return -ENODEV;
 
+	if (!substream->runtime)
+		return 0; /* just for avoiding error from alsactl restore */
+
 	map = mchp_pdmc_chmap_get(substream, info);
 	if (!map)
 		return -EINVAL;
-- 
2.43.0



