Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063055;
	b=kmsBpQ7XpMg1uxCAvXv0RD36dhLMwEv2Z+XzPAXoPm4mqESBlrJmUE3jpBkLZRB09Nwz
	 XhBY1sQR1fLoVD2jVnKxEZdoV4Rnh7O3O3OigfUrhCKwwuhPfVZa6ifr0ex1oZO9sz03X
	 1srMCAcdAunx9jL0lcPZIGt9x9gsNB7Zz8VTilQ4HEv67Egc3gUgxrE5FNdokza9SeRs/
	 3VZWNZfnluhaeg9LA82Saha4pJx8M2nDOyK2+DPm6DMvVp15xbQT59ZlifOMV/KtlxkdH
	 4AJ/jw8/vYphILSj3DQb+HQewPPcG3Ff3cWv4m/ogmuoS9v2ctRnrDDRwP1X3YGPTWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CqutEqrpxfdv5zgiRO5VAzh/wTJXJ9YCNGdmZYoSEPU=;
	b=uJYj6cgtKX1LRfysI2tOq1KPK5bzNFMKxWpu901dVWU5YeAvSLNNCDSeuicvaSbKBrNi
	 9+T8Z9VhRNEeZPwenH/34USVlmKuu8AeYHZYWT9tSyMMsBURmoH1t0QCfVxvUZdcYEl2Z
	 tLwctf+XqyNfU4m1pglYd+sST2awJ/XCxC+DT3hSEcsw2l2RuSGC7vC7nUDpopYu/My2J
	 GNNWNZZHuEvCvHRiXojxxgfI4qNEUgwMnLpuSjhwuKy+v7Ler3KKjPUCZ+HU9PFqyMfC/
	 Sy867IIInNSsEfM+4H9xmC7ep8c2Cxx72cwrtAxvY3pgHvfBhJckdq3vxYICyBqZhuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRxA2c1Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4055D606A331;
	Sat,  7 Nov 2026 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRxA2c1Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BAB1F0089F;
	Sat,  7 Nov 2026 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063055;
	bh=CqutEqrpxfdv5zgiRO5VAzh/wTJXJ9YCNGdmZYoSEPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRxA2c1Yt3mtArqj/dveccwH28TQTJLkARDyNdaBK4nahPp8UK7lhDszfh7AqWnA3
	 76B9TWlAQgwX8jMCdclahzaYwJXEZHoXg77FzUF7fUxVAkQxo7CQZ2HAtFcbNmp2gp
	 0Q6egpIAhn0ThBDT56MOFs/s3FbuWEV2Ye4g2yT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 298/869] ASoC: pcm6240: do not free an unrequested IRQ
Date: Sat,  7 Nov 2026 08:49:40 -0500
Message-ID: <20261107134902.495472952@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 995b96380ba5d98131acc162608da3538e1395d8 ]

The driver obtains an IRQ number from device tree but never requests an
IRQ handler for the PCM6240 device.  Removing the device must not pass
that number to free_irq().

Leave IRQ ownership to a matching request path if one is added later.

Fixes: 1324eafd37aa ("ASoc: PCM6240: Create PCM6240 Family driver code")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929095920.2092147-1-runyu.xiao@seu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm6240.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/pcm6240.c b/sound/soc/codecs/pcm6240.c
index 08cc52b374a9a..0275fb420ef2b 100644
--- a/sound/soc/codecs/pcm6240.c
+++ b/sound/soc/codecs/pcm6240.c
@@ -2034,8 +2034,6 @@ static const struct regmap_config pcmdevice_i2c_regmap = {
 
 static void pcmdevice_remove(struct pcmdevice_priv *pcm_dev)
 {
-	if (pcm_dev->irq)
-		free_irq(pcm_dev->irq, pcm_dev);
 	mutex_destroy(&pcm_dev->codec_lock);
 }
 
-- 
2.53.0



