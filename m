Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049680;
	b=kPX+6R2i3F1SUQUQ9dd4s66Qd0KIpK6uPyx70pjP9PJEPlK2pIJz1FPzAEFGYpyCVl8b
	 Y28hL76EJsDASz0nPqFEiweTtLWQvCLBh6W/uSMleFPYtzzBZWXeLqU+jonUFnXDs0OjJ
	 80txnc0zVFx7Iat0hnrz3iVtq+7v3BKrnzgKZ9E8pbJmY+jihmNIeKTnsz+tPSQARPkP2
	 RCgAi9EzgHq8GG6PtTikAj2iaqVTC8SFQhoyJzLZp6vZj+ZhLko+Qn1DseASlnlW8Sfcc
	 ZMBsRrQDsZajvMUngubWjOyZQqd+n9fh0sLYIlQrU3eZiTR8pgbcTFZI7MIkbgG64nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kUdHDsjCkpoob9gXjr6WXCgq4eNB05N13uuLSGRu4Qc=;
	b=ceBFTmkuuyhXhibBOjSRFoecJoIyP/ZiaiPI1ndsCgdaU8L7RqsGk16zdMjTux6RFwia
	 hWT89oBKBBCX2H23vzQfAH7MBlhi7czOqtas8aqsCBWjXtHXGcMVPlR0KXYfwiyax/cPk
	 A0u4cy4WZy4qf5mrolJhPgz37EIxswF/Pg7GY5Vzk0Frjmm78eb/5UBRiTUZTA1aEV4Is
	 1OlMoL9AAhwBAjtaSVmqiERlZUJMnhSosN16HATCMmwvXzGgv2i4x4vQ7GcRBLutzR7AS
	 2njt8RK7hKGEQdR4gl/GUZiE5x5/IESE/++cxPRzJ35BC1UI3xR8iKrAOGvQPuEpxOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIf9genO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029B6606A333;
	Thu, 19 Nov 2026 00:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIf9genO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585E21F000C9;
	Thu, 19 Nov 2026 00:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049679;
	bh=kUdHDsjCkpoob9gXjr6WXCgq4eNB05N13uuLSGRu4Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIf9genOPIKeIfT0KBnyzGkH2lYkVbDbbVoEr/PnpzEobh/KRUhA1iYhCUNGxVUzY
	 KNzH0zmWt6BVS4UYMsyy57IG3TnloE13dNsFlyWvqwry7YXTrAgOsTfWV9fRBFcw4g
	 SuUkXlOWDg8URmk0fHiSSlu4IDPyLop3FzrVcggs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2437/2857] ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:51 +0100
Message-ID: <20261118150329.319043589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 37ceef26df57c4a86a5e984b1951995aa96d4342 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp3x_dma_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 703a6e22888b ("ASoC: amd: Enabling I2S instance in DMA and DAI")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/raven/acp3x-pcm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/raven/acp3x-pcm-dma.c b/sound/soc/amd/raven/acp3x-pcm-dma.c
index 6aec11cf0a6ae..1ad2e70704eb9 100644
--- a/sound/soc/amd/raven/acp3x-pcm-dma.c
+++ b/sound/soc/amd/raven/acp3x-pcm-dma.c
@@ -237,7 +237,7 @@ static int acp3x_dma_open(struct snd_soc_component *component,
 
 	i2s_data->acp3x_base = adata->acp3x_base;
 	runtime->private_data = i2s_data;
-	return ret;
+	return 0;
 }
 
 
-- 
2.53.0



