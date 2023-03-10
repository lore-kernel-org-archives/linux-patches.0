Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F4B8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72470C433D2;
	Fri, 10 Mar 2023 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457348;
	bh=dX4rEmIFO27bO7AQOKWNI2F8gHXYOMoxqFMOzaz+fNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjrlTbcWAmTB6nQZvk1tLh4AucXMS0epQ5l7ZN3XY7YhbP8tHrHB5JuDL8SxrpUJL
	 Vl/GPuxELDzL6/TICi7TErA12fFivJnYvhyFYEnB2sgsIO6VWU2rbB6oSpDnBPDvFN
	 ixnPaxGGQgji7BG+5Ouu0HGBK6b9GPYB3TF2BVbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/200] ASoC: apple: mca: Improve handling of unavailable DMA channels
Date: Fri, 10 Mar 2023 14:38:34 +0100
Message-Id: <20230310133720.379127060@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit fb1847cc460c127b12720119eae5f438ffc62e85 ]

When we fail to obtain a DMA channel, don't return a blanket -EINVAL,
instead return the original error code if there's one. This makes
deferring work as it should. Also don't print an error message for
-EPROBE_DEFER.

Fixes: 4ec8179c212f ("ASoC: apple: mca: Postpone requesting of DMA channels")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Link: https://lore.kernel.org/r/20230224153302.45365-3-povik+lin@cutebit.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/apple/mca.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index aea08c7b2ee85..64750db9b9639 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -950,10 +950,17 @@ static int mca_pcm_new(struct snd_soc_component *component,
 		chan = mca_request_dma_channel(cl, i);
 
 		if (IS_ERR_OR_NULL(chan)) {
+			mca_pcm_free(component, rtd->pcm);
+
+			if (chan && PTR_ERR(chan) == -EPROBE_DEFER)
+				return PTR_ERR(chan);
+
 			dev_err(component->dev, "unable to obtain DMA channel (stream %d cluster %d): %pe\n",
 				i, cl->no, chan);
-			mca_pcm_free(component, rtd->pcm);
-			return -EINVAL;
+
+			if (!chan)
+				return -EINVAL;
+			return PTR_ERR(chan);
 		}
 
 		cl->dma_chans[i] = chan;
-- 
2.39.2



