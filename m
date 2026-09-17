Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957FB4EB845;
	Thu, 17 Sep 2026 15:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659153; cv=none; b=ADNQSPlIlsjqnKfVlXs6bwXjxnEiJh/qdXk5RraeD2aYDXtkWqvnGjktLOyCqFkQFdKU5wBe2H3T1pj8DIGDERl221S9JGFbLOUy49np9ai58bRg/vOon6XPAF2aRGnzCj6s4d8/dFnrrYPli5wQ6318lCJ9dy3ZGzKf01nILLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659153; c=relaxed/simple;
	bh=cz66Gu5+W3Rfu9xqyFWg3ZYXehcyGyR3huHppYDh7Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MF84oCvbj6tVk5ne/ySVLj66hbA3z6hJXcGvfLBw4WldbXj4VNZu9xP4CVxOdwqeCSkp4O8QwKkdJn6SMaJUZ4vUbREMYzByyRWBhkGTJXp4QeehF5+K/aQ9uHfsQBGFf6CN9Y+oLOdrCiMoZ8XDkr/4j+0bDekCpSgaOoQ4L/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRJVmJDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRJVmJDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8920B1F00893;
	Thu, 17 Sep 2026 15:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659144;
	bh=S8SFMT9E2W8L8lRboRrUqszL2xSM8kIQnTb2P8EXNp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRJVmJDdY2uQbabH/vVf3ZuyXj5hPXIbLLfo+Bj86bDnlUbCrJFI9pa9q6LredzkK
	 lzJTfMFyczMKPz6VuUiNixufqx7k1o1pkIjS1OHKLIARcC96LbX4KhX7aQwCDuBR14
	 SH+wtiJk661AhxOJGkQTSxNwH53GTluhM8O5xV+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 157/733] ASoC: amd: yc: fix memory leak in acp6x_pdm_dma_close()
Date: Thu, 17 Sep 2026 16:07:45 +0100
Message-ID: <20260917151354.979745964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 710db721ffa48..40c4d833f4ed3 100644
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



