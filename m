Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EC450B40B;
	Thu, 17 Sep 2026 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665534; cv=none; b=h8M28/CGYIzn5ZrM/w6ZLFhgnqvaCGBg0jidAppOtjMCmRUT6qnevsuAiWkE0ygoycQWXz6oOm8+IDceurpGlUtYAwjtTe5rpzgwN9xCy+DBCZpm9GIZUyed4XgCAzp+0y7uuydH6diJAVS5FO4w555sE+8X7aua1f741HOnm/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665534; c=relaxed/simple;
	bh=L+REDC0VbtlO1MPD93NHoc678LlYWS+HSlAtu1eSfbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSg1U/fg1qmPTZL+K5WPCKVJ+G0fwYTxQ+bP35SR6HOydQQrI84hGORGeIi86ipZPd2VOIbotRg90RxZ6qC/FTXoTOTk/Sto6tjX0bdXSszlQORHp3o2UVo/By4uSld9MpLYzlPxaiygMyOkUKg82TJbaTzXFmLnW9QxrpNwH9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKRm3gFF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKRm3gFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742931F000FF;
	Thu, 17 Sep 2026 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665533;
	bh=EijfYWtE4TwwgBd3R7wKKxZ8CcWGnYeP2zN31b4gOnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKRm3gFF9dtj2Q3XHDX2vrQUTzUroGAkpKOTdH3e/UrWbPG5tQF2vB19KXNKWlqHc
	 E41lgIzZCfW8oEWf5kzXHCcPDmBnsmt0q267mZXOJhshU1/95BX/Nqvcvuat473jP2
	 bRG9ucp20mefK32uF97QiQpmNqOnrMB9Fi/V9RTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0697/1250] ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()
Date: Thu, 17 Sep 2026 16:08:12 +0100
Message-ID: <20260917151610.783674272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac758b90f441d..167cd792d33da 100644
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



