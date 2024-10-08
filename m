Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED121DE2AD;
	Tue,  8 Oct 2024 12:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391258; cv=none; b=ZA9mMxCqc1Y1mbL+q92uR4Ly/L1+0hyDa75l/4APOUGL29Xw7+CCMxdbV9erj0LP4wH11RBQH/3pmbvfgaRvZvHnON0XWq7hNtr+P7l+u2/as98zNS91LE9TSQJm9RcEbyYmRXcNAILo3KTfBZZFNVTYiA+6FBCKTMdGJxfovis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391258; c=relaxed/simple;
	bh=K8hYv2vcgO3wjlL7xogyOsmrPoYUFUB+rgGRlEL9eXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9oRkl2bv3uYE/WyK74cL1Hp33wzyPaMvL399apF7kxV1w0dhdjNaq4EYl6BOoc1MXqRx3QfrI+qEVSV2tda6uEwXTyILHPJE5IFzNEPc1fHEIlF/s/JvCliVhv/icH61qRHmMg0/c3kBSn+GEGdtXG8+GuiUOCD+FZwhgQ/KSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A1s6BuoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A1s6BuoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59667C4CEC7;
	Tue,  8 Oct 2024 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391257;
	bh=K8hYv2vcgO3wjlL7xogyOsmrPoYUFUB+rgGRlEL9eXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1s6BuoGXHQalMM4YtNstdyjc0VP9oSEyk6PJlfEFbXgL81LWik5cGzYCApJIw/pw
	 T+blr+JODS6hY/mAkN3Ao+C67ytSBmXRC6J32BLaZ6t+Jm2OHnDVKdmiyc+y/c0+oa
	 TnpNM05ZVx8k1rroqL0ar0iKabeAquWhXPqKNozE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Simion <andrei.simion@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 057/558] ASoC: atmel: mchp-pdmc: Skip ALSA restoration if substream runtime is uninitialized
Date: Tue,  8 Oct 2024 14:01:27 +0200
Message-ID: <20241008115704.463918032@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



