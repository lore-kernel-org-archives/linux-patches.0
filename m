Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041458;
	b=3UtsbU9sKhNTxYKUrQ2BlPx81tDxYR8clGUaR2iHfQPNY7nUHCB6RRTRqFBRnqd86EDj
	 hSXOtPmV1m3vNj2SmCvuO6J2g9YV03Oav6YUHIlBXzUDLz5nP8VYeQSVIROsae7T7iNJt
	 BWgtJEU38wpoLdo5tb4rZL+zmvQamCLt4U0HEeMR8dm7swH5bLuXlGwcSAN+eOT7Jwyap
	 HXi4ZN0E/A5Vhq1v8+VXpXEGK7sqvxN7ZKNazc4ErOK9VgFZtS0Eqmn4HfcCoC08bYoPa
	 8OuQm5ixcbW92d54clUto7zAN+b18p5/uE53vqgTRZZxR8Zxj61ZVy+qaUrmTIWieYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AlJEW0NDpCv8hCDhsuJzgIHrtX2okvOpnu0KhVK0dLY=;
	b=hrtt5ohGPfuWV+1wmvj3oF7TnbCQkPAPWcnyOvPJzlk5VYLzHzQ7+E8ScRm1VPenc14Y
	 khRa23cNDk/7anFWdGmETvDHlb/Mw6XWywHc/kWG7tgO5FwxQywOeo2oXIz7goviYTl2y
	 LvJxCPtpsBoTtHCDBr4FADSN6+58O5XffzoL0RvCullWjXzNQOcq2ohE5kMtkkxegh6J0
	 yMLdlfrxTzuwNMh62XskUoGAAFvfHhEdCzplOWmw5xzoTcOqnJ224P1iYN9wMG+2pyeyZ
	 Kgg98vcaD4pL/FQWd5y7IUCbQie6CzkSyKEcJIDvDyZf3AJGzVy6U5XESNRvtahbkDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wA6GfJQH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AB160A263C;
	Wed, 18 Nov 2026 22:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wA6GfJQH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7CF1F000C6;
	Wed, 18 Nov 2026 22:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041458;
	bh=AlJEW0NDpCv8hCDhsuJzgIHrtX2okvOpnu0KhVK0dLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wA6GfJQHI1UXwqGxXxKckyY/SR2tdPAaS8/RE4gv9af6YVgof6/5C1CwlQyG/0wrl
	 5oAbW5M0ghWYt6HvBjYHs9RDo16YyH0yay4whpjzmz5Aa49Ue+fv6EsO4jvUCBXyBL
	 Z/QQ+7zrCZmc73ybmN29vPtaA+EidzQkVbO3OrrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2821/3318] ASoC: amd: raven: Fix acp3x_dma_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:23 +0100
Message-ID: <20261118150445.273823649@linuxfoundation.org>
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
index 9538f3ffc5d90..bf916ec557767 100644
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



