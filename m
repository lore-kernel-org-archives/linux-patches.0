Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103F72FABE3;
	Tue, 12 Aug 2025 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020392; cv=none; b=OMw5pPfpbyjILDB1KBYKkuqZfLHWiBVTn2PgTEsuEbLm5JYbHvaR7XI4kw+CfPey6Zc8D25RM16qZn2E0GTzypSVXVpoooIh+G9jdpXleH7dJg2q8tM+PLhIo50geEmcjy2fdkFWCFvqSVUEMkb7skEra9mMoqjtKHslKTLUwbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020392; c=relaxed/simple;
	bh=UdoFW+h9V3mYba8VT1cA7vuQVGJMlrpZlO8pvgJ/1FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pD8FPwD0Lmf0KsbioH6B7gQeeXMKMOw3KWKEjPgOHvzpbEqeXhh7TL5A0/QA2+JQo/sVXmUVNw4rKVLj8sYxBkTl1bF3/IYvBnYFOcg32kMN776+hAX6MAvz25lirY6J3xiG5cc49RiYBl5KXNFo9vkOKNoGLi1ldp9eHj+85Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fXeX4aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fXeX4aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B15C4CEF0;
	Tue, 12 Aug 2025 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020391;
	bh=UdoFW+h9V3mYba8VT1cA7vuQVGJMlrpZlO8pvgJ/1FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fXeX4awAIfyxWoNuO0I/JjZVYnwynTZzldDu5Yk40OB2IMwbRWPAR2kjH4LvypxF
	 micBOEvf/ZgNTb22XdFuuNYv7HCxNBoxoe/7zaxW4NtwHiDOJFWDbIxDbW6dbboSBI
	 323GIVF/EGMWiCFXA9/C4fdK9cFiJkxDV+kxghis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Giedrius=20Trainavi=C4=8Dius?= <giedrius@blokas.io>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/253] ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()
Date: Tue, 12 Aug 2025 19:27:36 +0200
Message-ID: <20250812172951.621950757@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit f4c77d5af0a9cd0ee22617baa8b49d0e151fbda7 ]

commit 7f1186a8d738661 ("ASoC: soc-dai: check return value at
snd_soc_dai_set_tdm_slot()") checks return value of
xlate_tdm_slot_mask() (A1)(A2).

	/*
	 * ...
(Y)	 * TDM mode can be disabled by passing 0 for @slots. In this case @tx_mask,
	 * @rx_mask and @slot_width will be ignored.
	 * ...
	 */
	int snd_soc_dai_set_tdm_slot(...)
	{
		...
		if (...)
(A1)			ret = dai->driver->ops->xlate_tdm_slot_mask(...);
		else
(A2)			ret = snd_soc_xlate_tdm_slot_mask(...);
		if (ret)
			goto err;
		...
	}

snd_soc_xlate_tdm_slot_mask() (A2) will return -EINVAL if slots was 0 (X),
but snd_soc_dai_set_tdm_slot() allow to use it (Y).

(A)	static int snd_soc_xlate_tdm_slot_mask(...)
	{
		...
		if (!slots)
(X)			return -EINVAL;
		...
	}

Call xlate_tdm_slot_mask() only if slots was non zero.

Reported-by: Giedrius Trainavičius <giedrius@blokas.io>
Closes: https://lore.kernel.org/r/CAMONXLtSL7iKyvH6w=CzPTxQdBECf++hn8RKL6Y4=M_ou2YHow@mail.gmail.com
Fixes: 7f1186a8d738661 ("ASoC: soc-dai: check return value at snd_soc_dai_set_tdm_slot()")
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/8734cdfx59.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dai.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/soc/soc-dai.c b/sound/soc/soc-dai.c
index ba38b6e6b264..ba8a99124869 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -268,13 +268,15 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
 {
 	int ret = -ENOTSUPP;
 
-	if (dai->driver->ops &&
-	    dai->driver->ops->xlate_tdm_slot_mask)
-		ret = dai->driver->ops->xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
-	else
-		ret = snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
-	if (ret)
-		goto err;
+	if (slots) {
+		if (dai->driver->ops &&
+		    dai->driver->ops->xlate_tdm_slot_mask)
+			ret = dai->driver->ops->xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+		else
+			ret = snd_soc_xlate_tdm_slot_mask(slots, &tx_mask, &rx_mask);
+		if (ret)
+			goto err;
+	}
 
 	dai->tx_mask = tx_mask;
 	dai->rx_mask = rx_mask;
-- 
2.39.5



