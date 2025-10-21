Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D272749CF;
	Tue, 21 Oct 2025 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076594; cv=none; b=up1ePf8HGNV9rsRLrIaBktmY8MFwgJfqvMkBg8hEgj+kZCg8wzbW1W7nI6BaJHpg6SVZR0LOG4SFSmbkH+gxaSRb+BB7aTBkEfbtJUqNYo+/AHfRZBYb2q8davfo+IukJrprhY3jydoBc3nRkOy5KDr75Z+DK6bnBQQtKpQQng4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076594; c=relaxed/simple;
	bh=IC+l51huAlRtgCdvkLvKhMxLeMfybySEq/CYTlh/wUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BS7MIh7uDGUnPf2sHuj5XfL3kWr395jg8G2VYqH2bd4grAWUTaVcWgqgUKhsqboZg2u/xtUBPhPcvo6NYg5mbAQUXQT35SbBcN1IBHWEWIedUFAun8LTuJXhtbF91/mWg1wsm2yPRuzjfsL+6FiwyM4PL9LF0fhF17TGalT3JjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdPiuPu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdPiuPu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC713C4CEF1;
	Tue, 21 Oct 2025 19:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076594;
	bh=IC+l51huAlRtgCdvkLvKhMxLeMfybySEq/CYTlh/wUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdPiuPu6Gh1Pw+MqavLSwYpnYEVHks/1mpoSmUTF2lyVKbZMAegzjQ2XGfkuTm4Nw
	 cVBlD2bht1GQBB4WB6WKGXU+j4kmllWIIywtAXGUhTwmmf70RQNX9FuwX9FeFwrro5
	 PAwMIVZm7CqxFAh3c6kRh0tj6RSFJ3xFFxQs8wFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/105] ASoC: nau8821: Cancel jdet_work before handling jack ejection
Date: Tue, 21 Oct 2025 21:51:05 +0200
Message-ID: <20251021195023.008336348@linuxfoundation.org>
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
index f307374834b55..ee65707a7827e 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1191,6 +1191,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 
 	if ((active_irq & NAU8821_JACK_EJECT_IRQ_MASK) ==
 		NAU8821_JACK_EJECT_DETECTED) {
+		cancel_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
@@ -1205,11 +1206,11 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
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



