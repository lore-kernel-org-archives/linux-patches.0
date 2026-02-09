Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C857637C103;
	Mon,  9 Feb 2026 14:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648989; cv=none; b=ABtpEMWIWHwrR+N09H1nlwtQdUWUEKrZGBNye+vcbTMXa0/MhivE8DHc3tsM75ilHp8zN0nS6CdsX9kdnxxqCh1gbK2KPAE03cvK5A5yxWIJc/YjqcGKK8fCxajwxPXfy8YXgH1Ek7TqVwpgNOBCoRDg8ZRWo5uhQsj2fysr+v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648989; c=relaxed/simple;
	bh=EEiYSYwZOqF5oegiXhhuSdB9P3veA+S0CGIV+78zbs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjJ+rU1zNgzishhGbj87z4jt5tR1b3gymDV4s0Cwvqnfjg9tuCBcPoP0V8vPgnv1ohyMunlup6LgcZuvPNNt6/UnqMNdmtzzRySFCc2dK+Ii6UUOfM4bCBrHDQEhixvnYNfX6XqGlGjiUMXLCa+wuA6xqiEguVfCbZRo6uyhJW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LrUaaB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LrUaaB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F38BC16AAE;
	Mon,  9 Feb 2026 14:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648989;
	bh=EEiYSYwZOqF5oegiXhhuSdB9P3veA+S0CGIV+78zbs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LrUaaB3gW+jagTmaCKlBhN55Vz4yXTe4TmlclQqOuJx7C6swT8z4Oif/brNbdVIP
	 nptao6qWuUuDRnWwk0J+W9eZDihdFzTbs/vIAU7PEAHvemYhxAI/rab6+deKdOGWWB
	 ERmmenyKAYZm5rxKG/ySt/mGw+8jz8XTX2CLX+Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/75] ASoC: amd: fix memory leak in acp3x pdm dma ops
Date: Mon,  9 Feb 2026 15:24:57 +0100
Message-ID: <20260209142304.004534874@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9dd22a2fa2e5c..6b0f90e88a926 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -295,9 +295,11 @@ static int acp_pdm_dma_close(struct snd_soc_component *component,
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



