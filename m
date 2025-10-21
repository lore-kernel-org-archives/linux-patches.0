Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461B6350A0D;
	Tue, 21 Oct 2025 20:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077412; cv=none; b=Q8Sai6JCaUJvqXSpTmsiscdiF0M3Av7F4wydwLD7lYbA7dxpClaMF2cDUpvtd1EQfWFs66xXrJVIGpU6AYLdNAt9/eXGirauAxO33ncfGhjgMXM3oA5g7EggB1MRYOAQx274a0DiPFuJPKDx647NXI484pliwM1ERK6j3WbXs68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077412; c=relaxed/simple;
	bh=y9bDKodxjS1cbFJJFxu5v+UrxcKcTbeG20yZy5qybno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1bSusco2A7r50EEbsCMu/qXr1Cgmc2gdmxj27KQMXvqQMtNjrtsdFF4h9qMDHSPze4K3ih9ABSR0nD3fgo1zahDLlwPH2SchE7ojkZnwBfviQRv6pui08L3eLGRR1BASimVBlSZDZ2YSWsuENQV+WEaEwNAdTOZTj+dR0+tf5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVrg8PxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVrg8PxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF27C4CEF1;
	Tue, 21 Oct 2025 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077412;
	bh=y9bDKodxjS1cbFJJFxu5v+UrxcKcTbeG20yZy5qybno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HVrg8PxQFQ0tJuQb1aQA7T0UagxMCZ2my2lIech8q3Q+bP7zeSxt2CM8Y1PTAIdmi
	 arNIH6CuxKNMa2lhtG9RJghwYEMP1G+nEruue/tbnh/aLK3aFk9bo2WrWJwuEnm98I
	 tU1mQa24SXOeE8UgnriiknjUxLM/9sNzDL+eKaIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 098/159] ASoC: nau8821: Cancel jdet_work before handling jack ejection
Date: Tue, 21 Oct 2025 21:51:15 +0200
Message-ID: <20251021195045.538663104@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index edb95f869a4a6..fed5d51fa5c3b 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1185,6 +1185,7 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
 
 	if ((active_irq & NAU8821_JACK_EJECT_IRQ_MASK) ==
 		NAU8821_JACK_EJECT_DETECTED) {
+		cancel_work_sync(&nau8821->jdet_work);
 		regmap_update_bits(regmap, NAU8821_R71_ANALOG_ADC_1,
 			NAU8821_MICDET_MASK, NAU8821_MICDET_DIS);
 		nau8821_eject_jack(nau8821);
@@ -1199,11 +1200,11 @@ static irqreturn_t nau8821_interrupt(int irq, void *data)
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



