Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F80A1DB34C;
	Tue, 27 May 2025 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366923; cv=none; b=oN5fR0iOz09gUT6Xoi1TEsSVimoVUAlpsgI+EW0OD1utosuFaay49/q7tVf5/wJDiml1uTs0izvBLUG7kUlRY/5EL4t/qLkUEUvnLwNmCbzN0iAjyMcRrOyfINnkXr6tB+PHkDGoKOGJfSptiDMPwNC6Zb96JoHlnrMGEjpdPes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366923; c=relaxed/simple;
	bh=VDD9HjxaHKIzuO1txBWeYvDgCVIsBU0VYvL+gTpYsHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9t3xxDhTV1aIkP8YxuL9sQ37Ef0o52HeDPDFWLL7W7tLkrTFE+1IOsofQqLyNurLMAg6H3JJHOzKn1rqFj+V8LO93UGUUOY38/acnTBwEqX0C+sOvIuTj/ubYYM0POSFVX2m/JS/EXEN4Z10vYQJhlY1FVc1K8b/122TJmRyBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRLbCJOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRLbCJOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB638C4CEE9;
	Tue, 27 May 2025 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366923;
	bh=VDD9HjxaHKIzuO1txBWeYvDgCVIsBU0VYvL+gTpYsHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRLbCJOIFOjJwWGYk4cHbRVywNoY0FmhpLO19LZOGK/s0uFqVdGr5Q3rqzhR6jbtM
	 9ZiUn27nqR74pEWp4lDLWtThlzmKBiFoYphxYJjp0WjdRVD+tmidHOH1pTNbkvnGpU
	 CGtM6gSb7Yl2aEQyKD66hwEgF5bYGhV5fbRr75Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Ryan Walklin <ryan@testtoast.com>,
	Philippe Simons <simons.philippe@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 190/783] ASoC: sun4i-codec: correct dapm widgets and controls for h616
Date: Tue, 27 May 2025 18:19:47 +0200
Message-ID: <20250527162520.887891691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Walklin <ryan@testtoast.com>

[ Upstream commit ae5f76d4044d1580849316c49290678605e0889d ]

The previous H616 support patch added a single LINEOUT DAPM pin switch
to the card controls. As the codec in this SoC only has a single route,
this seemed reasonable at the time, however is redundant given the
existing DAPM codec widget definitions controlling the digital and
analog sides of the codec.

It is also insufficient to describe the scenario where separate
components (muxes, jack detection etc) are used to modify the audio
route external to the SoC. For example the Anbernic RG(##)XX series of
devices uses a headphone jack detection switch, GPIO-controlled speaker
amplifier and a passive external mux chip to route audio.

Remove the redundant LINEOUT card control, and add a Speaker pin switch
control and Headphone DAPM widget to allow control of the above
hardware.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Signed-off-by: Ryan Walklin <ryan@testtoast.com>
Tested-by: Philippe Simons <simons.philippe@gmail.com>
Link: https://patch.msgid.link/20250214220247.10810-3-ryan@testtoast.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-codec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sunxi/sun4i-codec.c b/sound/soc/sunxi/sun4i-codec.c
index 06e85b34fdf68..3701f56c72756 100644
--- a/sound/soc/sunxi/sun4i-codec.c
+++ b/sound/soc/sunxi/sun4i-codec.c
@@ -1962,10 +1962,11 @@ static const struct snd_soc_component_driver sun50i_h616_codec_codec = {
 };
 
 static const struct snd_kcontrol_new sun50i_h616_card_controls[] = {
-	SOC_DAPM_PIN_SWITCH("LINEOUT"),
+	SOC_DAPM_PIN_SWITCH("Speaker"),
 };
 
 static const struct snd_soc_dapm_widget sun50i_h616_codec_card_dapm_widgets[] = {
+	SND_SOC_DAPM_HP("Headphone", NULL),
 	SND_SOC_DAPM_LINE("Line Out", NULL),
 	SND_SOC_DAPM_SPK("Speaker", sun4i_codec_spk_event),
 };
-- 
2.39.5



