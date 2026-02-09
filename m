Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F11337997A;
	Mon,  9 Feb 2026 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648716; cv=none; b=YmkwfKt9En2twmWJoFDewEFtas9ikzzhfn08a6vaq3SeXbPNsYimvmUDGg+CNmZXVYdQesbOdqDC2LPC0ydMx7FjbkSTQ6vlPCL3QCxXvzz1MB+hx05/sWmgyggxrsmAVigUKKZMfe3DIYH4+Uns/TebgfWNeisMDqkaQeQ+wn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648716; c=relaxed/simple;
	bh=t/r4CmpDD6jCxK6YNN4DvzESYSj6tFHXqnGH2JeMHTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AS7ws33ZqqPDLsU4Bj72WLAkh6swVODdFMOk1kXl3dmLacjanrm3LGz8OMymACgYwa8C0ZdFVMuYhuBHyVAiYdolSWDF0PLmtWPLaSoP5Kjb9O1GWwBzGyE6NcAHCN9Lnc+1NWwNj6f9s+dfPlKbRz0u73Mb0RnvunOpGwSA3qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCTBcHIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCTBcHIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F5CC19423;
	Mon,  9 Feb 2026 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648716;
	bh=t/r4CmpDD6jCxK6YNN4DvzESYSj6tFHXqnGH2JeMHTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCTBcHIXjcbmD3S6DQwqlrgTi4b2yW6e4nvQK+J+wh7abhr5br/n4xKMUfPq2gqnh
	 V84bHcBlWOI3PS95KTJUROJjhRrtSk0i9PodUhrHPrxQqhyeQSogQ5JtMUbeQEQTUd
	 NgwXftYkso43E8iiY75HP8moFxHpc2AXQ//OGY+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 36/41] ASoC: amd: fix memory leak in acp3x pdm dma ops
Date: Mon,  9 Feb 2026 15:24:57 +0100
Message-ID: <20260209142258.117721436@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

From: Chris Bainbridge <chris.bainbridge@gmail.com>

[ Upstream commit 7f67ba5413f98d93116a756e7f17cd2c1d6c2bd6 ]

Fixes: 4a767b1d039a8 ("ASoC: amd: add acp3x pdm driver dma ops")
Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Link: https://patch.msgid.link/20260202205034.7697-1-chris.bainbridge@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index 7dcca3674295e..ca794c2b272d6 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -308,9 +308,11 @@ static int acp_pdm_dma_close(struct snd_soc_component *component,
 			     struct snd_pcm_substream *substream)
 {
 	struct pdm_dev_data *adata = dev_get_drvdata(component->dev);
+	struct pdm_stream_instance *rtd = substream->runtime->private_data;
 
 	disable_pdm_interrupts(adata->acp_base);
 	adata->capture_stream = NULL;
+	kfree(rtd);
 	return 0;
 }
 
-- 
2.51.0



