Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5B922576E;
	Mon,  2 Jun 2025 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873719; cv=none; b=blVhYIf+v+4LZVpd8qSSCtdCi0xzDCzd6AR6hmCn7mc+escwbD0527CHXy6XgzhTcOzX+7qAhAN3wRIUqY4FGuZYMUeUWuzbGVFspWdbxTfbhHtA1wf6xDvBBQDgTfZY8yajnq/7sLnWj8I1U4iOtzLkZCwaHq2xRZBHM7N9aX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873719; c=relaxed/simple;
	bh=Z7rs6pp/ZII1MGLGmdpgRguPAgFI1OuEJ1K+Opcn84s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU/YT8072xJT9BQ6Z9+6xQUkIKe5RvGkhwrw3hkAIj6/TCMw2jTBsd43n4HnA8zQ6MKvPUD0FuTTx4OfcaWp6KQi+lSYd/jEwBIA0NkAaHzHF0PrU4KhFQDRX9lyQxUNGiTF0ANIuClJA4oHxjr0UK1kvWFdjoJcGDlinHKcyO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8Hye/h7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8Hye/h7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F07EC4CEEB;
	Mon,  2 Jun 2025 14:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873718;
	bh=Z7rs6pp/ZII1MGLGmdpgRguPAgFI1OuEJ1K+Opcn84s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8Hye/h7/XNFjKMp2UODdjiD/p03UGqXINFgIWNWODLW0bRAt7WjMpjDOZqH88lpt
	 SPeJT6lBQTD4aKB66xtlUVxwu2hryUIX6mZbpnGXvvZHY5QeSBSAZKMM5RkJYkr2w2
	 IQFz+6IZ/Ba6R7SpGGTY+7O0+rtoFRXsLd1HSnaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/444] ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()
Date: Mon,  2 Jun 2025 15:44:52 +0200
Message-ID: <20250602134350.170106724@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a828e55c4f9e..507743c87e402 100644
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



