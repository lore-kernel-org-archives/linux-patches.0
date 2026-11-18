Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031826;
	b=nWReUN44qPOpWTcXqKhr4h5ymQtkZe02p+XWChynIxUHSqBfoXrjpcp8FOfVPeR6cCgh
	 pK+oO7mMlOMH8SoSezq463RibVGgbEoO/tYxtfViuJ1/TLasHNaoe2304qL8jiNuPttaf
	 dQRfRm/cy3RaaUHZ3VxwoglmF+HQyDCBwb8Kv1c5PMyDiY6vQIN0TkBYm1LkdgarxuigK
	 IkhaTmeLn2hHOq71FBt39/Z1daJjpn3XkDeBdPRapnxCgDNXBU6Dl666fhC0iz2WAl/ls
	 a/2QGcpQVJHzqDRNbzJEIApoG5LHBABKbvd6JVHdq6eGwG4yowtl6IFM7rlowiFI4wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NJ4U68t8oAqby3Sb+kNp54aWEJvPjLdes9qCfTyLRT8=;
	b=leeqypE3I7p4ZjPluxOL20PuuJ7fW8bBwqOexJ+u783Fn+8xqxpuGn0uJj383HWbhOfz
	 R07YgaaarkiDxPtKo9Xcp68pHCyDDVu/+tgNFfKVT2j9gUBGPDX6bU2ea0zwR0MGBffhu
	 iAr6Kh4RUbZb6GTDOBizIH4puZ0kvRA7RgM8IMRn17It8G4Zgz2QCzoXJVUEr7+/Qecg8
	 dFJm62gJ8qzqx02ly17H0yAVXmguagBWrG4DsDak+Qx+P/NK5FdZDpxBj8FEYSiCkvI4H
	 JXLvWVifKytDrwU1Dax9GDAKI/33Gk688S8TIg8mjqMhM5+YxUCMz3uU+vzM3BIrH9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0oYc+5J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15837606A31C;
	Wed, 18 Nov 2026 19:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P0oYc+5J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3321F000C4;
	Wed, 18 Nov 2026 19:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031825;
	bh=NJ4U68t8oAqby3Sb+kNp54aWEJvPjLdes9qCfTyLRT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0oYc+5J+bPOkSUHFfTHaJpKu7wITwh97DTV7oQN31+bIVXn3hrlEeVtpD4aoYhaf
	 aH/h4R3EJ4N8xvwnC0TrwOSkYB+yqbXf5FAbkxdlcr3ZOD5kvfiZCiR8IWfnmVwAum
	 lITgqnG3IVD9dChOABNawjU5sEjzL52FNZB8m/2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1153/1756] ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:54:40 +0100
Message-ID: <20261118150055.933766760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index bb9ed52d744d3..3ba58a7795973 100644
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



