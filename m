Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF714286;
	Tue, 21 Oct 2025 20:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076897; cv=none; b=uLq02zfJxBbN5mMTAaTFxOf3zPrd8lGdoPKK+GC19KAZF4sGVY6MeSPfbPE1OaYfQzI7DzFpXT8T0QrvxjfrFK6raoB2pVUH+XNSnCmly8sEUq0X/nMDUhVLciztiWoACYtweTa8hpW+Ym6KVE1lrW4xfTW8nhjhYZli+k/bK8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076897; c=relaxed/simple;
	bh=uO6Pdxt6Moaf2jVTw+OxMOOOVpuTx/JUsU1y8gItuA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2lCVrrLgb/KvPgNx2tL/TQ80mbEYMb/1J+YnertG6LTv99HeTKai5lFKuAoKtGN2Ga3AuZ8okvXwVdaxmnMUH22G4Onv01lvx/5vPJCk9CLeCLyXE3YN6tAevdblr/v0M+DVS+PMS6CAmjgEMkZSYYa9dKOlokaiDvMMERxsUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJibNcJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJibNcJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C19C4CEF1;
	Tue, 21 Oct 2025 20:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076897;
	bh=uO6Pdxt6Moaf2jVTw+OxMOOOVpuTx/JUsU1y8gItuA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJibNcJoFNamTaoRNuIcDHAkzEc+DVzhHr2xpH/GyC36VNOJ0joOypwZvpJLC/1Xs
	 bWFiBdd0NgFJ29xO6Mi6kj4sWCYYFEGv84vBxotoOjcM8N8lt6G1f0TfEXzB0SQ81W
	 oitEYbtpneO0/WwBqZMrCpMVUEP+EVJEW+ty1c34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/136] ASoC: nau8821: Cancel jdet_work before handling jack ejection
Date: Tue, 21 Oct 2025 21:51:00 +0200
Message-ID: <20251021195037.703783607@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 6e54919cb541fdf1063b16f3254c28d01bc9e5ff ]

The microphone detection work scheduled by a prior jack insertion
interrupt may still be in a pending state or under execution when a jack
ejection interrupt has been fired.

This might lead to a racing condition or nau8821_jdet_work() completing
after nau8821_eject_jack(), which will override the currently
disconnected state of the jack and incorrectly report the headphone or
the headset as being connected.

Cancel any pending jdet_work or wait for its execution to finish before
attempting to handle the ejection interrupt.

Proceed similarly before launching the eject handler as a consequence of
detecting an invalid insert interrupt.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251003-nau8821-jdet-fixes-v1-1-f7b0e2543f09@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index de5c4db05c8f8..23ee515db9bdd 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1186,6 +1186,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 
 	if ((active_irq & NAU8821_JACK_EJECT_IRQ_MASK) ==
 		NAU8821_JACK_EJECT_DETECTED) {
+		cancel_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
@@ -1200,11 +1201,11 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 		clear_irq = NAU8821_KEY_RELEASE_IRQ;
 	} else if ((active_irq & NAU8821_JACK_INSERT_IRQ_MASK) ==
 		NAU8821_JACK_INSERT_DETECTED) {
+		cancel_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_EN);
 		if (nau8821_is_jack_inserted(regmap)) {
 			/* detect microphone and jack type */
-			cancel_work_sync(&nau8821->jdet_work);
 			schedule_work(&nau8821->jdet_work);
 			/* Turn off insertion interruption at manual mode */
 			regmap_update_bits(regmap,
-- 
2.51.0



