Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042349;
	b=J4KnWJ6io0Yiat5LkzvhYIZTBkZe/zPusA6lijBI2zvc8D+cJenKNSwTwlaNTonD83Kj
	 geK1H2i8o5yCI5kgXFv2U69fXAYOwUSa9wRrhFzd4bsVRlOu0rl8AmefxDVqTHww9IqMX
	 05JsekAR5MlZUwwzGvuWf0kYerJ7OJUa4ndqeGC9C94veBvpS7K4sgEykuxJQtLUaDR7Y
	 S/0/m8gQdH7k4WwRl2Mq/fasUwxU9Xri4a1Cyo9Db6H699B1d/1N/s4P4qRM2bRCz+KFR
	 I330JWWM0S8cdGIbhU/abo1CaiQIKMAGOKFm9dQwyxbD1VxGA+CE86a9QM6nqP5KLSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g+/KTrb/qqf3dyl2msmqb0rv9thyIJENlAlDnlvhXDY=;
	b=q5uG91KRu/zkH/krpVQc3XZmxkLpMZ12CayGWh69C31PnhJcZtsveoKUaeHUf3b7B969
	 Fc6OJ0rcI/YYpkaSjhaw7YSiVgYM8DSTDiMdfj/0Gs3cFF998WQ6XGO2qRcN2lC5mHYfh
	 FRGXbOHfqO1PBS666KBRqNsjWWI8m2fej8YiYQih/1Rk0V5IdxjSUypv5LOXeJG4Tpnbs
	 qyIUQ9k/Zm6BGIP1f244C5OPcbjx9mJ2dmGAMmIATZQO9gh744EQUNURG9l/ogFvlOexs
	 vs12R87svyEHvZTX/KC3dj5HGMcAK22uuRvCgSIIJqd14gk0jofnL30NHyfAbckDnnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqRTR3IH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907EE606A325;
	Wed, 18 Nov 2026 22:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uqRTR3IH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FF61F000C4;
	Wed, 18 Nov 2026 22:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042349;
	bh=g+/KTrb/qqf3dyl2msmqb0rv9thyIJENlAlDnlvhXDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uqRTR3IH6Zbg1MOzxSpeIekMr3L1KO7GdKsssQt1fND1sbTCCrWnUrVOBYg22rfqo
	 wrOgljXXzppHtFCzXIvLbtJmMwHxl5vFV8N5v9g9CaSXOqIEKKPNsfY7y3xoBojVXI
	 vI2Ac9jbx0jfQRvrThnP0V22K1lAP8moq9aAPJj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-reviews <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3139/3318] ASoC: amd: raven: Fix memory leak in acp3x_dma_close()
Date: Wed, 18 Nov 2026 16:02:41 +0100
Message-ID: <20261118150454.050347887@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit e0b17f84f6e3fa1201b8e2857094023c42ce5636 ]

acp3x_dma_open() allocates a struct i2s_stream_instance for
each substream, but acp3x_dma_close() never frees it, leaking
it on every open/close cycle.

Free it in acp3x_dma_close().

Fixes: 9f7041b71a2f ("ASoC: amd: closing specific instance.")
Reported-by: sashiko-reviews <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-173760@kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261016085047.535265-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index bf916ec557767..88090dd32d374 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -354,6 +354,8 @@ static int acp3x_dma_close(struct snd_soc_component *component,
 		}
 	}
 
+	kfree(ins);
+
 	return 0;
 }
 
-- 
2.53.0



