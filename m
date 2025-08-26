Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840A9343D63;
	Tue, 26 Aug 2025 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217266; cv=none; b=KlaiBlanw+fva5Q6JRQgQaFEJvMQCz+IXrHCYANoeBD0GbTLCBhf57GcZhwhm63hwcxuc2KP/lsfQpt+skIQvyb3oZbA3hL/k6wm4/AayijcK6N4dshhOVMXXLfPhLFotNXZ24KU+oMiybCd+CxGvLO5QYj0V2jiIAlDHe6BWfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217266; c=relaxed/simple;
	bh=GAzUYi3HOpu1X6Hyeh70oMk1L5/t0tJqcieAouwoP2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LnkyEVvU8W0ih2h/XZnetyoAtelgZm4lVsF7Wfg70Se7qw9UnoiHXQD8Q45zUj/Tm8dUBmC9c2y6N3FjqVGvcLY+9RmLrQO097P4vEjkSUI7V2kNCBkZpj3NoyOo+WAE5rZiJ2sFDcWqG5itBAuWXqBy5xewY1xG0O8CvD/BNfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQ2a6A2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQ2a6A2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CECC113D0;
	Tue, 26 Aug 2025 14:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217266;
	bh=GAzUYi3HOpu1X6Hyeh70oMk1L5/t0tJqcieAouwoP2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQ2a6A2R+9HiS63gJWBxnBCAhab1+9kmESNOOjbv+/5MUg+dlIVdTtG6Me5n31TQr
	 igmY3p1vegE7HEejejU4My9X8hpNmHOQXD3KZ1qEzIRiIFxES/qd+rUI4A7kD/KUCw
	 XuWNr6vxDxPsppDdOCMmaehoKIH7UMyEBBq7kxXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Giedrius=20Trainavi=C4=8Dius?= <giedrius@blokas.io>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/523] ASoC: soc-dai: tidyup return value of snd_soc_xlate_tdm_slot_mask()
Date: Tue, 26 Aug 2025 13:04:49 +0200
Message-ID: <20250826110926.515355919@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f9aba413e495..e2db2ad219b8 100644
--- a/sound/soc/soc-dai.c
+++ b/sound/soc/soc-dai.c
@@ -206,13 +206,15 @@ int snd_soc_dai_set_tdm_slot(struct snd_soc_dai *dai,
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



