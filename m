Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF9122A7E7;
	Mon,  2 Jun 2025 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876268; cv=none; b=FAi6kOrt1mEXCrrQkGrO9hMt/Q/cqoqGUxOOF7Njk3Z61L1ElCpB7Fdg+7O4+HArbtIy/DBRqniyygZVuFHClOlEDvdISlCmbEzZiehQOrOK+ExKuuzeMBRqyhPZ0ySDB8y1R3EUgj/oEov2L9Vw5U6MO5TYlLyKeyKwQ/hs/vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876268; c=relaxed/simple;
	bh=vHdqaLieYETDPTbIRgxiLbUFyeX70+a6BWWiXCgd1GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnHLWXHP9VcxA9XYOEu14uvWRvwKyJzgPB5fFKqpSAnBJuC9DMwya3sqr+Y1Fn6tuGZoAbOgdrLU4cA7858pSX1c0qkNuVY4e56fB4NtAjLrt4QsEqRWAP4P9QVigPp9dn89NrXmtbwdh4o6tX/+5Hc4p00pgwFD47MruDY0iBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFJy/yz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFJy/yz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12D9C4CEF0;
	Mon,  2 Jun 2025 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876268;
	bh=vHdqaLieYETDPTbIRgxiLbUFyeX70+a6BWWiXCgd1GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFJy/yz+lmiCNbW9ux8tKq4BN3hlxJyjClcSYjbX+o8XoGcYcYRqDmFKzOm1iO1vc
	 xUsBqQfndENZv/cY7JUIkuqUkrxw7VK9vsdGEZtj1xiFuwHsnHtEuiJMNfLoNifIr/
	 nEbS6Oz0eMmWBZ8meCVR+I9e4r278BCSW2t6M4a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/207] ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()
Date: Mon,  2 Jun 2025 15:48:09 +0200
Message-ID: <20250602134303.305098669@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3db0fcf24385a..05a9404544de9 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -271,10 +271,11 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 
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
 
 	dai->tx_mask = tx_mask;
 	dai->rx_mask = rx_mask;
@@ -283,6 +284,7 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 	    dai->driver->ops->set_tdm_slot)
 		ret = dai->driver->ops->set_tdm_slot(dai, tx_mask, rx_mask,
 						      slots, slot_width);
+err:
 	return soc_dai_ret(dai, ret);
 }
 EXPORT_SYMBOL_GPL(snd_soc_dai_set_tdm_slot);
-- 
2.39.5



