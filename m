Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BB634D916;
	Wed, 30 Sep 2026 16:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785029; cv=none; b=KauqVnyiXXX8NugAmLCFEry5LDjHq6RQmtehb/8IRjogB2VnBB4h86Zf50pOSC3P5qzj0gNmWi94rKyr64fhbhq+kCK+XZaOpJm/7jFZJgmhMWpsGNn0bpEYH2f6KSE0hPrl1azLIXUXb23ndbmigKo6+Jjx8m+GAXrHqKSb8qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785029; c=relaxed/simple;
	bh=GIl+CV6E3xMRO+UU3Etm9Y1ErwfL4EdkUMQGsx/+ACU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMpn1h9B8JODjlcHxps4OkMdV49vNMGcwWIGM7L0LPpyYaxo0wpHsg/FOLK8GeUmF9IZ6RUY1rpYc7U9T+i4lyOksOmcqcvuKyjE9I4g6UU2RqB2/33Kvkara93Uip4wIg8EJIuDY3U8Sx7zOe3V0RkWd0ZNnsBCHqsw8PAsdgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fhc/gyfo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fhc/gyfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632321F0089B;
	Wed, 30 Sep 2026 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785019;
	bh=M5wiicNXEzbiVTZqVC1m/yQJMGOiD62PoQE1O0Fr7G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhc/gyfo5MpKTcLemlaqq6qAcBQDde/X7az4ZTNQ4W+ajNnZoxt8vi5mzWEyvbXGQ
	 WGVnSSA3kt7DYBWpJJXHTsMSJI0G/ZlDL34yLrlkmTyVWV1jZur7lFv8JD5DwvqAwE
	 aybMFUFrPca/+R0+Q/tTmkDs0BDHAvGOfHoAA8VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 362/982] ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()
Date: Wed, 30 Sep 2026 17:18:18 +0200
Message-ID: <20260930152424.588318047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index acecd6a4ec4b1..efdd5c088b883 100644
--- a/sound/soc/amd/yc/acp6x-pdm-dma.c
+++ b/sound/soc/amd/yc/acp6x-pdm-dma.c
@@ -269,9 +269,11 @@ static int acp6x_pdm_dma_close(struct snd_soc_component *component,
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



