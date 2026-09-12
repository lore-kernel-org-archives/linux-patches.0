Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3365B3A782D;
	Sat, 12 Sep 2026 20:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243414; cv=none; b=T+Y4gXFtnJfUWbo745OQL+RYV3bzxkXJw6KiJiX+SZtc7xokMuQHlVMXPiFTrerLMSlonkT3vcoDNvjFDXr4CfOPFCJqhi9ykBxDgkDC/oDCSDae9f3XT4i7CWq3NRH9BLqsOx66R25qNGaeYhZbf2LohWIsdu9pTiEPGdZwEC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243414; c=relaxed/simple;
	bh=hKvJtgKxzmR27/7CxoFdOapRcEW6UOTYl8SYXpWNOOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDediMC0BHKtjlAv2h6KjAlonY4YvMy1KtaihuHJW2c7YvSFuUhg38/5VHBsgzLr3UGj6R4fgt2vAxdU0HWDhDYANS/ZgCdqhoItcSSKWrC3jQqL7W4F6b/Ab6unwz2Zsuxsm9db0NsVeK2qOfC0yG+SRKXBgbRTeMsAJSqqVaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSu4SVx/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSu4SVx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE341F000FF;
	Sat, 12 Sep 2026 20:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243413;
	bh=x3H0Mub9HIuWKSjvorZeuOsHoCdtZf6dY36I5MSBfRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SSu4SVx/zlsVhxnSOKU+SwraA6DNBv+gtyejC7wz1rOeyA+XbsMMN96NgBGhjn8jm
	 9jF5wkU2bJ4VjyDZyB0gmw+GEAw+6lozC9MaXCuRhkgmUOKXkyZmtYC89WOKDWmamW
	 X89ecaMS6CfUZtGWp7FI7RQYZsJUQKfQumc6IiRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 694/798] ASoC: xilinx: formatter_pcm: fix stream_data leak on open error
Date: Sat, 12 Sep 2026 09:05:22 +0200
Message-ID: <20260912065533.002434306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit b992511180e126150c6ad3580a6fd568c385f4c6 ]

In xlnx_formatter_pcm_open(), stream_data is allocated and
adata->play_stream or adata->capture_stream is assigned early.  If a
later step, such as snd_pcm_hw_constraint_step() or
snd_pcm_hw_constraint_integer(), fails, the function returns the error
immediately.  ALSA does not call the close callback when open fails, so
stream_data is leaked and the stream pointer is left dangling, pointing
to a substream that ALSA frees.  A later interrupt would then call
snd_pcm_period_elapsed() on the freed substream.

Free stream_data and clear the stream pointer on the error paths.

Fixes: 6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20260811185140.27149-1-rosenp@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index dccc056e0e0a6..74a7c8e5998df 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -384,7 +384,7 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	if (err) {
 		dev_err(component->dev,
 			"Unable to set constraint on period bytes\n");
-		return err;
+		goto error;
 	}
 
 	/* Resize the buffer bytes as divisible by 64 */
@@ -394,7 +394,7 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	if (err) {
 		dev_err(component->dev,
 			"Unable to set constraint on buffer bytes\n");
-		return err;
+		goto error;
 	}
 
 	/* Set periods as integer multiple */
@@ -403,7 +403,7 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	if (err < 0) {
 		dev_err(component->dev,
 			"Unable to set constraint on periods to be integer\n");
-		return err;
+		goto error;
 	}
 
 	/* enable DMA IOC irq */
@@ -412,6 +412,14 @@ static int xlnx_formatter_pcm_open(struct snd_soc_component *component,
 	writel(val, stream_data->mmio + XLNX_AUD_CTRL);
 
 	return 0;
+
+error:
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		adata->play_stream = NULL;
+	else
+		adata->capture_stream = NULL;
+	kfree(stream_data);
+	return err;
 }
 
 static int xlnx_formatter_pcm_close(struct snd_soc_component *component,
-- 
2.53.0



