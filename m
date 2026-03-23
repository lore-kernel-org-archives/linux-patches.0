Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6203BBA14;
	Mon, 23 Mar 2026 16:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282475; cv=none; b=IYropjJ57rmGJiQEdLR4cODDh1Ujb2ofhV6usBBqiCQT30vAp1Ot9O3ZsD5ZvYc4budlrN/L3lJJ6hV0MdiJcIx+HGgn7DSjCtbaywjsrPyA618z4L6Vyh3iOgUqfAxIQHKK8KDONfP4WREW4WEKcdPckcTmQkNSFuljxP/a3OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282475; c=relaxed/simple;
	bh=eBfVvYwN+mkjrxMosNz3MIXnz4yYgnmYdpCFxSaarmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R57aOjphu/Asq4IM/Bx/HMc96ucwoxdG+mEo9O6OxduqPYrOyPsDWX1aaw5bmZKuBdilbKywraQe6OCSwIM8bd360nIwehL5h20NPi6wLMtYoxQ5c/oxjHfjiC8S8u8Be+3zqICO0XsDhV3KBwZ412SoE3dqLhmVpKuqoykkqCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grRiSmzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grRiSmzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998ADC4CEF7;
	Mon, 23 Mar 2026 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282475;
	bh=eBfVvYwN+mkjrxMosNz3MIXnz4yYgnmYdpCFxSaarmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grRiSmzHec5cxb4SpgVNCX0SnbbMcutsbYqPcwHNEFqG+9QvyfPFn/NIZQF8Hpmhi
	 9Dgs3jzvZh162lEL770rhq27LRkOUMI/6qdIdtlKQtZr/XsKhxlaYz6Smou5/oduYe
	 stgmScyI7nL21d7XFNPAKGgajBTuIQUpDuPOykFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/481] ASoC: core: Exit all links before removing their components
Date: Mon, 23 Mar 2026 14:42:31 +0100
Message-ID: <20260323134529.343627355@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit c7eb967d70446971413061effca3226578cb4dab ]

Flows leading to link->init() and link->exit() are not symmetric.
Currently the relevant part of card probe sequence goes as:

	for_each_card_rtds(card, rtd)
		for_each_rtd_components(rtd, i, component)
			component->probe()
	for_each_card_rtds(card, rtd)
		for_each_rtd_dais(rtd, i, dai)
			dai->probe()
	for_each_card_rtds(card, rtd)
		rtd->init()

On the other side, equivalent remove sequence goes as:

	for_each_card_rtds(card, rtd)
		for_each_rtd_dais(rtd, i, dai)
			dai->remove()
	for_each_card_rtds(card, rtd)
		for_each_rtd_components(rtd, i, component)
			component->remove()
	for_each_card_rtds(card, rtd)
		rtd->exit()

what can lead to errors as link->exit() may still operate on resources
owned by its components despite the probability of them being freed
during the component->remove().

This change modifies the remove sequence to:

	for_each_card_rtds(card, rtd)
		rtd->exit()
	for_each_card_rtds(card, rtd)
		for_each_rtd_dais(rtd, i, dai)
			dai->remove()
	for_each_card_rtds(card, rtd)
		for_each_rtd_components(rtd, i, component)
			component->remove()

so code found in link->exit() is safe to touch any component stuff as
component->remove() has not been called yet.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20221027085840.1562698-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 95bc5c225513 ("ASoC: soc-core: flush delayed work before removing DAIs and widgets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index cb95a9293343f..d42cba7de0a3b 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -941,9 +941,6 @@ void snd_soc_remove_pcm_runtime(struct snd_soc_card *card,
 
 	lockdep_assert_held(&client_mutex);
 
-	/* release machine specific resources */
-	snd_soc_link_exit(rtd);
-
 	/*
 	 * Notify the machine driver for extra destruction
 	 */
@@ -1895,6 +1892,9 @@ static void soc_cleanup_card_resources(struct snd_soc_card *card)
 
 	snd_soc_dapm_shutdown(card);
 
+	/* release machine specific resources */
+	for_each_card_rtds(card, rtd)
+		snd_soc_link_exit(rtd);
 	/* remove and free each DAI */
 	soc_remove_link_dais(card);
 	soc_remove_link_components(card);
-- 
2.51.0



