Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FBB4E0B68;
	Thu, 17 Sep 2026 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668938; cv=none; b=ILYC6iDADadud5BJT+KfuPYEU1SzpNUC7OO7nb3RA/h3T2hKk5SrymS2JTsAVN+oW5pOFkvwx8NNn1/p32/jRs/0M2xtxaBYP/0Q4HT1QcK8OrZA1VsTfqf/1fMgOMyKuh3uhWB3tT6QZ1t6oqbOni3QYegfJs36wXYRwZcJJVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668938; c=relaxed/simple;
	bh=pRC4H+MdhiT7KpDjiCzxYdcTzVZo6/UKyxfQBk5XnPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBAJA0RTGOc1E+UoEgHqd1CPFtlK5LrWcla3Zpz/tiC2OY8I23rSPOhbUjPmVKHuyUPep96xB7nX7Vra856Ag7bqEymPVwg3xpvTDzIEGuX7RceaxwITRNzFWNpC/wOcjDpTm1RN4xCQn96TgOy1Otd8BLiDIVRgTvxBI2PAVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pYpjXjP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pYpjXjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E51F000FF;
	Thu, 17 Sep 2026 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668937;
	bh=YRkUdsQYDBg5m2orY5KRswIcgbl81Jmye73JuQACFO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0pYpjXjPud5cXWqvV6KrkQb1XDRP+Cnc0WKEex0RKRI5QPTb6OmVwqZoUQcGnd+w+
	 /kIB9kGjGHnWSHS9ywRV6hOaWicXGg8W6GyQYnJ5h6xoJ414UZA4Ml4HtOzUpUmKi2
	 CfXmlFeVmEff3iUIm5xliH8MdM/pN/BuQJJ+hZQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0589/1102] ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()
Date: Thu, 17 Sep 2026 16:08:52 +0100
Message-ID: <20260917151554.752140451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 1b67e0d3b9691d7b6b74e18960ddd2be24f9dc9d ]

acp6x_pdm_dma_close() does not free the runtime->private_data buffer
allocated in acp6x_pdm_dma_open(). Add the missing kfree.

Fixes: 7610174a5bfe ("ASoC: amd: add acp6x pdm platform driver")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260824063507.483784-2-wangdich9700@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-pdm-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-pdm-dma.c b/sound/soc/amd/yc/acp6x-pdm-dma.c
index 3eb3e82efb103..be81d80e81420 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -275,9 +275,11 @@ static int acp6x_pdm_dma_close(struct snd_soc_component *component,
 			       struct snd_pcm_substream *substream)
 {
 	struct pdm_dev_data *adata = dev_get_drvdata(component->dev);
+	struct snd_pcm_runtime *runtime = substream->runtime;
 
 	acp6x_disable_pdm_interrupts(adata->acp6x_base);
 	adata->capture_stream = NULL;
+	kfree(runtime->private_data);
 	return 0;
 }
 
-- 
2.53.0



