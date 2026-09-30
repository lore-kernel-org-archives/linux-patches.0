Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700AE3CAA41;
	Wed, 30 Sep 2026 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795079; cv=none; b=GKwcRs8aIfSWK5EtZFEIeekRvVCcsvgPA1OgoquwQ/YRR/DqIkzo/Q5e4g5wqNexxwd9fClFH69JLVxpY6x6kS+S3UtFLI9vSKTeNIp77k2R+Be+aT9lZrt2qOOVZtJMKsrbupFn0hfip5XxHTLwqHcUeLpMOXFKSYbBI8q976s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795079; c=relaxed/simple;
	bh=5HkdCo8UVMGaEZTZUzIX3ClKyAGkH+rqUsgo2qGTsnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/iVFMvtoHHU9Ix54hunbVQgn4bjq7682xp37l4xnd9b8r9lP1lLf7cdO8+keNBPPHAYkissODU8izTYXuqKlWRFAC9QTfzKJ4IqSe+47N8IxsrYE09efT4KnK5K0vmYaz/E+Q9mtF/gbU6IpmKA+SN9/saB3zlIqCCm5ayJu2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uC4E4baD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uC4E4baD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0821F00902;
	Wed, 30 Sep 2026 19:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795077;
	bh=jEjVBV0TcNd+flaCTLOu+HbsUMnVT2UzktmqDvGHric=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uC4E4baDOl5OqX1a2vTdr87X9ZFmI9n7cIQmpcdWSbAiOTeoJH5q2nFcBCajlIugi
	 FA7C36OgoRcUKIlCAAEBbrzL8wFt1hWghnkhrcW6l+15hLxfrThl2k+I/qM/hiSf02
	 8oI4KfiP8pVo+tu7Vi5zQbEXdvxun6+XUC4MAnP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0436/1193] ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()
Date: Wed, 30 Sep 2026 17:18:40 +0200
Message-ID: <20260930152443.875684437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 72c4591e451bd..f332bea36595a 100644
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



