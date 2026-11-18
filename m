Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049674;
	b=mqtq0wdJmjihgFcKDK7jH/99JugzJHFbOtSSKZTZo730ApM1wMhLZb2WLYea/kua5NN/
	 bdL7AQAfdbOGXM1uCwE0sVoy5rsdNq6wH9GPjMZk0pHgrRE6rdTz5mv4MGwalZ1wF1g3G
	 48uNu2xJSfNXPngLh+pnMz04DNx8Pf2fil/4p3OTrjnH5EjKz8Qosg6IVYGR3Hxw7phN9
	 lRbwaHYr1wzCcERj2taJ8C8hYszRK2OIb4GryJ0r2ZAYPJt7IiHUsi4XppWAMBPIcACrO
	 8tlYkyz30PR5AV2RJXL252TdzfYoxO8Dc8jkFtB8XtsN2SSOs18DMR7D51SOEu6ff4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wz7AyMY3WqcWMt+B3i0kDhZOGWh4dnU+wl2OR+ZTQmA=;
	b=mO12GgyPqYatQa6NF7TU31NYaF95fvMMBKYSpkb+lqVCA/bZKwnZQay6dOOz8K968RJL
	 i2zRhgkkS1Vb9r5zGL3n1Nh4V1jDEovg4xCInsEHMeYz/QHo1lUc/YQTzJaEa83r9t42k
	 wnajrfS/0cYybOQUCYJBBVYRw4gFkXRGfT4qazx1mRYd9exStngk+8xgEsCizRYID5x6a
	 8FABu7xmUjVqImivH/yXnxbmv6ca8P1qszouKn3EK6DMs4rde8GYmPJlIssE9sw2hHyQi
	 LoRVj+u0uVjzIsk1/bXEQOSr4U2slVyqPXGndr50a4HW4FWJ64QhAGk49voxUH7MyPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="awVvF14/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87363606A31C;
	Thu, 19 Nov 2026 00:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awVvF14/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCAFE1F000C4;
	Thu, 19 Nov 2026 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049674;
	bh=Wz7AyMY3WqcWMt+B3i0kDhZOGWh4dnU+wl2OR+ZTQmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awVvF14/pYdBP89Q1jYbtbpGF8n0YATrFyP6oCgdbfFBwxNZXtQ45DPSRTQjeVIWR
	 Y7ZYiJnoCwJh3Qv2s6vA0OURTnbVJKGkq8deCgjTXlHV6OjQK0GStAdTgwCY9pGaPV
	 GvitiVSEvbhyWxdryDLmqD2+OvngurT3EH0VWdkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2435/2857] ASoC: amd: acp: Fix .close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:57:49 +0100
Message-ID: <20261118150329.245344690@linuxfoundation.org>
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

[ Upstream commit 2c3400aa9f397da48a6760f5e84438973e01a00c ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from acp_dma_open(). ASoC only marks the component as opened when
.open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 623621a9f9e1 ("ASoC: amd: Add common framework to support I2S on ACP SOC")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-platform.c b/sound/soc/amd/acp/acp-platform.c
index 447612a7a7627..9137a1f1c99cc 100644
--- a/sound/soc/amd/acp/acp-platform.c
+++ b/sound/soc/amd/acp/acp-platform.c
@@ -203,7 +203,7 @@ static int acp_dma_open(struct snd_soc_component *component, struct snd_pcm_subs
 	list_add_tail(&stream->list, &adata->stream_list);
 	spin_unlock_irq(&adata->acp_lock);
 
-	return ret;
+	return 0;
 }
 
 static int acp_dma_hw_params(struct snd_soc_component *component,
-- 
2.53.0



