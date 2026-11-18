Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056166;
	b=aaENrDJ9UfGWnBgj18PoTDaJ8rwaP0zQSGWgKj8kaW/W4+Cm/0i5Z+9gzw+T23nHhGME
	 P0XFAbKgkD5N65kKWYwAtLpQHJ+1leLOzG/eCkrYK/1YcUpdoBtcMzE4z1p6rVvqaYsr1
	 eddaVE5gygysTLDETK9kyelweRTHfkK6dq0yzQu9VAKX4Cp9aVbWiqhh21hu2Dar/jYXH
	 1Y/fYZtOED4Xp/OhBe+Q1kZWWC0e1hC2z2guSD0in+AFSjiWXRvxRcSY6FQtJxkgBVRJO
	 /CK01j7/dUDsGcdQo8aZnjxs+Wa0lo7lyrJbtHcHxwnc/tgGb90quiXsqjAoQpXIdKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mDmhXGK8PvY496lMJFvXUvSJzro0G/atZ4/7F+zDaeE=;
	b=XMltUjAF8m5POxKoHq6bpcBWNhsRSEOzyLKWTSNEsSfK5le29xRoMWOX84u/MVrsih5X
	 Oank3sW6r9/unhXGqnRjmQlyso8QjVzWXQr4d2SUx1maXMQZsoA5vZfs8iXhQUxt4utcl
	 DhUvZse04oPgdmdDFlS5B6Gm/fYRpy10Bqo46nCEycsIH8DUGWWnqWm6RVVu34Gsy2XXY
	 oFsxfT3bXvBONXn1TpRYT6irP4A3ALK60CfTG9N3EYta8f8ELHEn4Pp6YVLqOBA/oe3ah
	 Y8lHyKDVYUjP0jPAX617Qwz3LFPqDxN9RlRmhCblalbWczGho43ET8YIzDkr7NR1KRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzn8ucTi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6035606A32A;
	Thu, 19 Nov 2026 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzn8ucTi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23351F000C4;
	Thu, 19 Nov 2026 02:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056166;
	bh=mDmhXGK8PvY496lMJFvXUvSJzro0G/atZ4/7F+zDaeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzn8ucTiG4R/wmQX1aId2actjuH9ey78sRzPOsYMcdP5lccRvQ0zkNYPLvcfU0eNG
	 vTJlQSRfzK+PY6ig8F+I0tKNA2hr09LEUZPCmtAGbkzKZNGEewZ9p/ciltFp2ilxw+
	 U3R7hDw9Q3ESqNYkg5Orq6TRAJhGN+26AenTquEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1890/2214] ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:59:26 +0100
Message-ID: <20261118150126.813326294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 75c06697fa092..57ba07d918eb3 100644
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



