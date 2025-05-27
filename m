Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FA5280023;
	Tue, 27 May 2025 17:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367738; cv=none; b=iz8Rr2oluObYeyj50X/WQejb9DYa3m5wQJNFZZiYSuWEhnCqnAGIq2MuVBaa2i3LV5UJd6cvHO4lBZMIozAEI973FcejZ73ii0hnCFU688RSv0E95ntgt4GZzfIs5RTKIkpcuNd1zKuj04+pNjKe9tgvtHR0qXTwYFOEIX9QyKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367738; c=relaxed/simple;
	bh=MbQR/bnPOCjkL81rKCdbZoE1ODNopmRXKduzouAFSFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AszZAeYgVl0zLO3sl1yCtZU8I6F22+hAQp++dQuncHS15eG9A/VUJRgrVaRZpk3k71/JUWEILfI56YnSDX9FoF6WHsX2sIapO1omvFiQ5+/DDIY9M8Twxs8h1wm+2dd23o2DTVI39gcniH8RzFSKaSybirJE0j05DeA7EZdZUUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qt4z9DfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qt4z9DfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C0CC4CEE9;
	Tue, 27 May 2025 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367738;
	bh=MbQR/bnPOCjkL81rKCdbZoE1ODNopmRXKduzouAFSFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qt4z9DfI5Guy/8bvuycLNBYfhKtC67T3/KlJRun10TtDxKGRxGHG511jhShACrHt3
	 ffaYmp3nhNJzVFNw7I9qvx9X5ViYSCxwNyi8GB1BdMu7S3BF/sw7bDpirqoFuWUeRr
	 yaaGaTUD3lN4yJm1L/b1ZFrcl6StIvOXixOOXJis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 443/783] ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()
Date: Tue, 27 May 2025 18:24:00 +0200
Message-ID: <20250527162531.177926704@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 7f1186a8d738661b941b298fd6d1d5725ed71428 ]

snd_soc_dai_set_tdm_slot() calls .xlate_tdm_slot_mask() or
snd_soc_xlate_tdm_slot_mask(), but didn't check its return value.
Let's check it.

This patch might break existing driver. In such case, let's makes
each func to void instead of int.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87o6z7yk61.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dai.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-dai.c b/sound/soc/soc-dai.c
index ca0308f6d41c1..dc7283ee4dfb0 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -275,10 +275,11 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 
 	if (dai->driver->ops &&
 	    dai->driver->ops->xlate_tdm_slot_mask)
-		dai->driver->ops->xlate_tdm_slot_mask(slots,
-						      &tx_mask, &rx_mask);
+		ret = dai->driver->ops->xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
 	else
-		snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+		ret = snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+	if (ret)
+		goto err;
 
 	for_each_pcm_streams(stream)
 		snd_soc_dai_tdm_mask_set(dai, stream, *tdm_mask[stream]);
@@ -287,6 +288,7 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 	    dai->driver->ops->set_tdm_slot)
 		ret = dai->driver->ops->set_tdm_slot(dai, tx_mask, rx_mask,
 						      slots, slot_width);
+err:
 	return soc_dai_ret(dai, ret);
 }
 EXPORT_SYMBOL_GPL(snd_soc_dai_set_tdm_slot);
-- 
2.39.5



