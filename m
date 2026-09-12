Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D6447B405;
	Sat, 12 Sep 2026 12:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215577; cv=none; b=b2w5ngaYaWyaOce90hL2FGakLaMm67aLwxkQZmFITDLFJCFeWdCo6sX4JsN7FCTNNOOFLROFeqVoiw702EDZDAeTUnHiTJHfkZU6ftAUKpZJiPup1QiAlTgPs86k/lPoDMlBTgM1RhwWdrofpvUHwOgXQKGOnyGOdrsuHMzcAj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215577; c=relaxed/simple;
	bh=CsoX6RQPtQ9/B4aMIAH1+dXZBz8GIfyMS9OidjzJ2ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsM1zNcDol/mvSjrLni1441Rlapk2blMZ4b0ug0aIzQUIXQZiaOsEd4QZsLRhB0vlG2jSWz9rV6+FW1spnc/yotYlWNJjmwLTgkxz4NrUOmeVA0s+PspGt06DgNbGBjHzaprwIswOsfTcJuo7oND13rZVb6YY1Vt4LBMuE3/iXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psympWzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psympWzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045C21F000FF;
	Sat, 12 Sep 2026 12:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215576;
	bh=KzbCZLMWC+EOItWpRfh7d/n7CHnNGgzGclCO/Se47KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psympWzGL/UhwtN9VfJrzH6x+ECBsCCXKItYf/CLKePj5Va1nrT18v1o9s1uTfSAv
	 4EMHWkCkefIyTnLydYi6GNavGK61DnVrDTDOyHRRlDv+ajdRBqOhKtwCnicdY7mIUC
	 QMKexY3XVwc4luD3vG9EV7Z6M04fmSruJpBRrUR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0517/1376] ASoC: apple: mca: increase SERDES reset delay
Date: Sat, 12 Sep 2026 08:49:03 +0200
Message-ID: <20260912065619.058738241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Calligeros <jcalligeros99@gmail.com>

[ Upstream commit cccd721e5aab03e92234faee72b363c9ba60611c ]

The SERDES clusters in this peripheral take a long time to warm up.
We tried polling the reset bit until cleared, however this is not
a reliable signal of readiness to be configured. Only waiting
~25 us to give the cluster a chance to settle makes it work
reliably.

Increase the 2 us delay to 25 us and hope we never have to do this
again.

Fixes: d8b3e396088d ("ASoC: apple: mca: Fix SERDES reset sequence")
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20260711-apple-audio-redux-v4-1-2994d87c2f24@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/apple/mca.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index 4a4ec1c09e132..d89e57414a5da 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -210,10 +210,10 @@ static void mca_fe_early_trigger(struct snd_pcm_substream *substream, int cmd,
 			   SERDES_STATUS_EN | SERDES_STATUS_RST,
 			   SERDES_STATUS_RST);
 		/*
-		 * Experiments suggest that it takes at most ~1 us
-		 * for the bit to clear, so wait 2 us for good measure.
+		 * The SERDES cluster needs a bit of time to reset itself
+		 * and settle before we start poking it. This is... slow...
 		 */
-		udelay(2);
+		udelay(25);
 		WARN_ON(readl_relaxed(cl->base + serdes_unit + REG_SERDES_STATUS) &
 			SERDES_STATUS_RST);
 		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
-- 
2.53.0



