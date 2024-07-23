Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6B113D896;
	Tue, 23 Jul 2024 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760119; cv=none; b=ibghSNPHlQKdna2Q9v5/uyElrVZbHpkhrXq5yj6MNd+0nqHTrwVTDWCDYen3ew12BDUdzav5gMzlMyIVxTlbpgW57+ogH+8f15ATJQtNGhYBsO4APHwo52vtmKGIHXaqpbHTGfy2cIf89myXK1ro+Z3roE+ce4Hz8EGRFbllf+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760119; c=relaxed/simple;
	bh=9YGCwCbwaRakJjLLMCmvfSS9d6m51xSUpBb0clOG7/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9HF00iAWz8/Jq1Ek7rVkgBcqaG/E3pWG42FEIIxle3q7nPp+eUi2fIShjZ4Pl6CMIGIcJZEYRFW0CpgqN/uYLNdEu5aZfqbLBTVypjIFik/aB3bbqEjfPLZaHU/+uOVRZ00ylOjMak7eatpUsDhZLQzJpeHLaLmT1zDwEy6/3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJnDH9Or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJnDH9Or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D84C4AF0A;
	Tue, 23 Jul 2024 18:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760119;
	bh=9YGCwCbwaRakJjLLMCmvfSS9d6m51xSUpBb0clOG7/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJnDH9Or69FzNMgYxuyUh8uTVqC49+E4m6LorGYUwvue7ILwfT5UWC/+2N64YaG+M
	 p6dnyVd0cVs1uN8pY9eP5f+hrUqGCiLZ2ZcpbKYm6uggfZ2K8hEzJmh2+HpFkoDxZ3
	 YUlah44W4DF2zibbPsMomAFRrSByN+wHQCBLdTP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 101/163] ASoC: cs35l56: Disconnect ASP1 TX sources when ASP1 DAI is hooked up
Date: Tue, 23 Jul 2024 20:23:50 +0200
Message-ID: <20240723180147.379633251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 8af49868e51ed1ba117b74728af12abe1eda82e5 ]

If the ASP1 DAI is hooked up by the machine driver the ASP TX mixer
sources should be initialized to disconnected. There aren't currently
any available products using the ASP so this doesn't affect any
existing systems.

The cs35l56 does not have any fixed default for the mixer source
registers. When the cs35l56 boots, its firmware patches these registers
to setup a system-specific routing; this is so that Windows can use
generic SDCA drivers instead of needing knowledge of chip-specific
registers. The setup varies between end-products, which each have
customized firmware, and so the default register state varies between
end-products. It can also change if the firmware on an end-product is
upgraded - for example if a change was needed to the routing for Windows
use-cases. It must be emphasized that the settings applied by the
firmware are not internal magic tuning; they are statically implementing
use-case setup that on Linux would be done via ALSA controls.

The driver is currently syncing the mixer controls with whatever
initial state the firmware wrote to the registers, so that they report
the actual audio routing. But if the ASP DAI is hooked up this can create
a powered-up DAPM graph without anything intentionally setting up a path.
This can lead to parts of the audio system powering up unexpectedly.

For example when cs35l56 is connected to cs42l43 using a codec-codec link,
this can create a complete DAPM graph which then powers-up cs42l43. But
the cs42l43 can only be clocked from its SoundWire bus so this causes a
bunch of errors in the kernel log where cs42l43 is unexpectedly powered-up
without a clock.

If the host is taking ownership of the ASP (either directly or as a
codec-to-codec link) there is no need to keep the mixer settings that the
firmware wrote. The driver has ALSA controls for setting these using
standard Linux mechanisms. So if the machine driver hooks up the ASP the
ASP mixers are initialized to "None" (no input). This prevents unintended
DAPM-graph power-ups, and means the initial state of the mixers is
always going to be None.

Since the initial state of the mixers can vary from system to system and
potentially between firmware upgrades, no use-case manager can currently
assume that cs35l56 has a known initial state. The firmware could just as
easily default them to "None" as to any input source. So defaulting them
to "None" in the driver is not increasing the entropy of the system.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20240613132527.46537-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index fd02b621da52c..d29878af2a80d 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -214,6 +214,10 @@ static const struct reg_sequence cs35l56_asp1_defaults[] = {
 	REG_SEQ0(CS35L56_ASP1_FRAME_CONTROL5,	0x00020100),
 	REG_SEQ0(CS35L56_ASP1_DATA_CONTROL1,	0x00000018),
 	REG_SEQ0(CS35L56_ASP1_DATA_CONTROL5,	0x00000018),
+	REG_SEQ0(CS35L56_ASP1TX1_INPUT,		0x00000000),
+	REG_SEQ0(CS35L56_ASP1TX2_INPUT,		0x00000000),
+	REG_SEQ0(CS35L56_ASP1TX3_INPUT,		0x00000000),
+	REG_SEQ0(CS35L56_ASP1TX4_INPUT,		0x00000000),
 };
 
 /*
-- 
2.43.0



