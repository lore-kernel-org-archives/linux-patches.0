Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A6B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D58C433D2;
	Wed, 28 Dec 2022 15:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242283;
	bh=DKJRdtPNrTkiw0/j7ZSX+2H5Pv6CQ1nLG9LHau3f/eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAfvIzIX4kQqZlZ12+3WFbe1xw9Rgub9mpwe1YkylQPKilLvZVwFG3E8US8Qkm7qY
	 LtXuz8YUjhN1DlJOhP6pWwfHM8jpPfedf6J8UxleaB7eUh9PkFiUiqnVN47C91txoq
	 89LjKLtqrKFTvJrIslfZLAQXM/1xIHXbsR8zWwZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0350/1146] ASoC: amd: acp: Fix possible UAF in acp_dma_open
Date: Wed, 28 Dec 2022 15:31:29 +0100
Message-Id: <20221228144339.670673301@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 3420fdb8ae99f0a08d78d2b80f42a71971cf478d ]

Smatch report warning as follows:

sound/soc/amd/acp/acp-platform.c:199 acp_dma_open() warn:
  '&stream->list' not removed from list

If snd_pcm_hw_constraint_integer() fails in acp_dma_open(),
stream will be freed, but stream->list will not be removed from
adata->stream_list, then list traversal may cause UAF.

Fix by adding the newly allocated stream to the list once it's fully
initialised.

Fixes: 7929985cfe36 ("ASoC: amd: acp: Initialize list to store acp_stream during pcm_open")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221118030056.3135960-1-cuigaosheng1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-platform.c b/sound/soc/amd/acp/acp-platform.c
index 85a81add4ef9..447612a7a762 100644
--- a/sound/soc/amd/acp/acp-platform.c
+++ b/sound/soc/amd/acp/acp-platform.c
@@ -184,10 +184,6 @@ static int acp_dma_open(struct snd_soc_component *component, struct snd_pcm_subs
 
 	stream->substream = substream;
 
-	spin_lock_irq(&adata->acp_lock);
-	list_add_tail(&stream->list, &adata->stream_list);
-	spin_unlock_irq(&adata->acp_lock);
-
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		runtime->hw = acp_pcm_hardware_playback;
 	else
@@ -203,6 +199,10 @@ static int acp_dma_open(struct snd_soc_component *component, struct snd_pcm_subs
 
 	writel(1, ACP_EXTERNAL_INTR_ENB(adata));
 
+	spin_lock_irq(&adata->acp_lock);
+	list_add_tail(&stream->list, &adata->stream_list);
+	spin_unlock_irq(&adata->acp_lock);
+
 	return ret;
 }
 
-- 
2.35.1



