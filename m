Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA4A190664;
	Wed, 21 Jan 2026 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019543; cv=none; b=uUHZu8WorEdfLBFUoUMh9+SJwarg64kEIA2dJoJMMeXF5e3CIfCjSuACUIg39TR+oCQoZ6JjYgVI8yeUMnuODFK9hUNfnFNpkbEZRliIViBSjl3GHpDZ3eyhKLz/uouKbK72Un/Xs5RJOcBdXeh25yg+uW7Mtz+lkI/ZHkX7tDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019543; c=relaxed/simple;
	bh=WdnbjcKfnI8j164Jju6s6srJBYwd0tndnmA1IwHY8AM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS5J9Qh5XM1Sn1qI81SzrEVRq3Di9lKtggOv1Yn/YfBA6qLaGRPGMAnZkYnjs1FtHfFU3Pq0LwDj7GB4PIp0v8waK7V1jKACWc9Gkq3ALzjw8frAf5degUeqhTyGaV7s75aJd+ALzjqTxck5wImACqWUG+D+5S/Mab/9SGJmUL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV1lTsaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV1lTsaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C330FC4CEF1;
	Wed, 21 Jan 2026 18:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019543;
	bh=WdnbjcKfnI8j164Jju6s6srJBYwd0tndnmA1IwHY8AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vV1lTsaB9vHhTr+4E7g8p/Gye207M/vDtTuljgqeW14mpM7f5V1lk9LHw9qO6VqCD
	 uQi3vxSjTg44LCoMEOLiNSqQ2oP9FPtfmSdH9KDPd+Yzu4xz1oFhTzUAZnjl6p08NY
	 BE2ZIKRcuw0no9GAy9jy7W3+1DK+baCvTLNnpilU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Cole Leavitt <cole@unwrap.rs>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/139] ASoC: sdw_utils: cs42l43: Enable Headphone pin for LINEOUT jack type
Date: Wed, 21 Jan 2026 19:14:45 +0100
Message-ID: <20260121181412.789953445@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Cole Leavitt <cole@unwrap.rs>

[ Upstream commit 390caeed0897fcac75f3c414dbdd85d593183d9c ]

The CS42L43 codec's load detection can return different impedance values
that map to either HEADPHONE or LINEOUT jack types. However, the
soc_jack_pins array only maps SND_JACK_HEADPHONE to the "Headphone" DAPM
pin, not SND_JACK_LINEOUT.

When headphones are detected with an impedance that maps to LINEOUT
(such as impedance value 0x2), the driver reports SND_JACK_LINEOUT.
Since this doesn't match the jack pin mask, the "Headphone" DAPM pin
is not activated, and no audio is routed to the headphone outputs.

Fix by adding SND_JACK_LINEOUT to the Headphone pin mask, so that both
headphone and line-out detection properly enable the headphone output
path.

This fixes no audio output on devices like the Lenovo ThinkPad P16 Gen 3
where headphones are detected with LINEOUT impedance.

Fixes: d74bad3b7452 ("ASoC: intel: sof_sdw_cs42l43: Create separate jacks for hp and mic")
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Cole Leavitt <cole@unwrap.rs>
Link: https://patch.msgid.link/20260114025518.28519-1-cole@unwrap.rs
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_cs42l43.c b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
index 2dc7787234c36..dacd050439439 100644
--- a/sound/soc/sdw_utils/soc_sdw_cs42l43.c
+++ b/sound/soc/sdw_utils/soc_sdw_cs42l43.c
@@ -44,7 +44,7 @@ static const struct snd_soc_dapm_route cs42l43_dmic_map[] = {
 static struct snd_soc_jack_pin soc_jack_pins[] = {
 	{
 		.pin    = "Headphone",
-		.mask   = SND_JACK_HEADPHONE,
+		.mask   = SND_JACK_HEADPHONE | SND_JACK_LINEOUT,
 	},
 	{
 		.pin    = "Headset Mic",
-- 
2.51.0



