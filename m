Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2FA274FE3;
	Tue, 21 Oct 2025 19:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076629; cv=none; b=E3SM16hqVpedBWMCdq3JAwjAAAm+fAKQdd6VHRdlN5n/2fm9M7E0GOxoZa98EC58niLEE4gpnZ98AbHqhH8sItbi3tEv2n0P4pZyAgRD/zw1tXwqlnELTo8ib+xsJVaWd2ndMbYc9uXXj9IvD7BLNLu3KpbftMq8HT1D7Bn3IWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076629; c=relaxed/simple;
	bh=mj0Y7Q16SISSP1y9yv3GLQ/5sK6PSup2SPHtkLCk4D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vacz+o/ibn83jN0oZYim5v8nH1abTKNNtiYeVAYpo0X6jPBVZNL75KujLExnbRu6n0dpb8joPT7dDA9Y4c8/sGvI7VtNLI6C3PfC/0Zv4EGudaCFhxhZBuuSvWgMWn7sWXiSlf3dZKkZjum1wabTMdcsBeVIDl3E9aDesVPsDsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmtwZzg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmtwZzg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B7FC4CEF5;
	Tue, 21 Oct 2025 19:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076629;
	bh=mj0Y7Q16SISSP1y9yv3GLQ/5sK6PSup2SPHtkLCk4D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmtwZzg/hxhOTljFBKJ15ffdDrZ44OXs/SUvZOIPhdl9t09P6mrL91dSqTqHnQaWJ
	 IkKFkS1e6WeSJtHw2Kbjy+oFADjE3qeTOuFdoqwDOfyUtZMD0qe8iKsLloSahPzxkX
	 XJHr0s9inabUsw0ku6EmOrYfNyeeWVkOElKUOyr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/105] ASoC: nau8821: Generalize helper to clear IRQ status
Date: Tue, 21 Oct 2025 21:51:06 +0200
Message-ID: <20251021195023.031063244@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9273aa85b35cc02d0953a1ba3b7bd694e5a2c10e ]

Instead of adding yet another utility function for dealing with the
interrupt clearing register, generalize nau8821_int_status_clear_all()
by renaming it to nau8821_irq_status_clear(), whilst introducing a
second parameter to allow restricting the operation scope to a single
interrupt instead of the whole range of active IRQs.

While at it, also fix a spelling typo in the comment block.

Note this is mainly a prerequisite for subsequent patches aiming to
address some deficiencies in the implementation of the interrupt
handler.  Thus the presence of the Fixes tag below is intentional, to
facilitate backporting.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251003-nau8821-jdet-fixes-v1-2-f7b0e2543f09@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index ee65707a7827e..432b47340dbc7 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1030,12 +1030,17 @@ static bool nau8821_is_jack_inserted(struct regmap *regmap)
 	return active_high == is_high;
 }
 
-static void nau8821_int_status_clear_all(struct regmap *regmap)
+static void nau8821_irq_status_clear(struct regmap *regmap, int active_irq)
 {
-	int active_irq, clear_irq, i;
+	int clear_irq, i;
 
-	/* Reset the intrruption status from rightmost bit if the corres-
-	 * ponding irq event occurs.
+	if (active_irq) {
+		regmap_write(regmap, NAU8821_R11_INT_CLR_KEY_STATUS, active_irq);
+		return;
+	}
+
+	/* Reset the interruption status from rightmost bit if the
+	 * corresponding irq event occurs.
 	 */
 	regmap_read(regmap, NAU8821_R10_IRQ_STATUS, &active_irq);
 	for (i = 0; i < NAU8821_REG_DATA_LEN; i++) {
@@ -1062,7 +1067,7 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
 	snd_soc_dapm_sync(dapm);
 
 	/* Clear all interruption status */
-	nau8821_int_status_clear_all(regmap);
+	nau8821_irq_status_clear(regmap, 0);
 
 	/* Enable the insertion interruption, disable the ejection inter-
 	 * ruption, and then bypass de-bounce circuit.
@@ -1528,7 +1533,7 @@ static int nau8821_resume_setup(struct nau8821 *nau8821)
 	nau8821_configure_sysclk(nau8821, NAU8821_CLK_DIS, 0);
 	if (nau8821->irq) {
 		/* Clear all interruption status */
-		nau8821_int_status_clear_all(regmap);
+		nau8821_irq_status_clear(regmap, 0);
 
 		/* Enable both insertion and ejection interruptions, and then
 		 * bypass de-bounce circuit.
-- 
2.51.0



