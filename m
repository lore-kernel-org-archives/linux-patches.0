Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B859F23D291;
	Mon,  9 Feb 2026 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647691; cv=none; b=iIGXoqVj6ZTm6qzbmwcTE0hSJ7wNqtIfb80VKPs6ksFr+Q8pdS6r49JLA2eqEFNFdyXpAdZf1kf6lQNW8MSzlVXeWuFqmm37SffxCoS1xkySHv8p0D9x/8kUncRuDlkUMxOpp+otJhSHdmX3WrJ/1tmhBOge2tDuoKMhrYge0Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647691; c=relaxed/simple;
	bh=NMoFxctIa8GNtjcrHDky5S4C1vRA7m+qWgXib/NQsro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEP12825s9fXZ3TY80HuXsGB9zbn6FF8YWdHnXGMkO9IW5mKxoVYqHizw8HzBz/G+57fIr3FNG669c54rBtDmvyBC3uEn4pyV/BMy1Fem55kDcSzrrd10jxXrJiyptk6ydw3aA5ZRzdwwt2pXItks6Zpj3QiLv6saJAwr5zB6HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jc2qIHjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jc2qIHjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF8EC116C6;
	Mon,  9 Feb 2026 14:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647691;
	bh=NMoFxctIa8GNtjcrHDky5S4C1vRA7m+qWgXib/NQsro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jc2qIHjQmbkfvr4aWFCyhLNA9um3HDmlqQee72uzSNagU+iQfyz8JvYZ2tlifwsnJ
	 zkSy1p4N9QeqVRj7uQauz7fAtZWiYtmcyahNkrmqEH4GDJcRo/R37x0qZXsyHgJfLc
	 z1pcuwllkXVDiAiI5BRFMrhWF4KeI5rB3bmhQc8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/175] ASoC: amd: fix memory leak in acp3x pdm dma ops
Date: Mon,  9 Feb 2026 15:23:54 +0100
Message-ID: <20260209142326.282923449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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
index 95ac8c6800375..a560d06097d5e 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -301,9 +301,11 @@ static int acp_pdm_dma_close(struct snd_soc_component *component,
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



