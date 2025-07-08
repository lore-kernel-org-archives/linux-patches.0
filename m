Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D736289E2C;
	Tue,  8 Jul 2025 16:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993059; cv=none; b=d4PoJj13LpK45ztg59n6WxCayrEc7Nlsn+ZPVDax+o+O303iZtkHbn4pusOH3UKwKEGMqxR65/H+i8eb/MBp/9EQKCdKkbycGWxOm4sXJ3VafKCWOXr3jv46fX5DWThUVygarB4KHpdcdVQ5TUiKtqlvHoDqoBxJicEMLIlmS8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993059; c=relaxed/simple;
	bh=1vZACHQnAny7Z0bFw5KgbHRlG1Ksj9xTG87YcD2knAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfffaoBebQAsNXYx7LADn6xCOPdSgc/ZyoZ8EGfKXh+xYQaN3hpZZjxZEetXEU47X3d08KD0h4r4GfKJ1W6l9F1nyDMvsvtk4MAz+E2/E8SXOi/uQ+Ur9a4zOYtqPoaquZdpt06Y2NdnYO0msOIWKjXT06l9BtPoll7Otzs1m1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrGHMowW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrGHMowW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE619C4CEF5;
	Tue,  8 Jul 2025 16:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993059;
	bh=1vZACHQnAny7Z0bFw5KgbHRlG1Ksj9xTG87YcD2knAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrGHMowW5iK9ZPeGqOpr/EUj5AhS05Jkl6C26yRv6WPAtU43ntXc5ss32367BGHlK
	 di4M8BZup20bqpZPnfBFV62dw9mHSTFsawu85ZcmsOfFhzL1OYu6mhjf8sa4GYdlPp
	 Q38IquO7bsuWwYHw1LaGYqbCCNAaQr8MOHPrQXMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/232] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue,  8 Jul 2025 18:22:50 +0200
Message-ID: <20250708162245.992414343@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 4c267ae2ef349639b4d9ebf00dd28586a82fdbe6 ]

When the DMA mode is changed on the (still real!) SB AWE32 after
playing a stream and closing, the previous DMA setup was still
silently kept, and it can confuse the hardware, resulting in the
unexpected noises.  As a workaround, enforce the disablement of DMA
setups when the DMA setup is changed by the kcontrol.

https://bugzilla.kernel.org/show_bug.cgi?id=218185
Link: https://patch.msgid.link/20250610064322.26787-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/sb/sb16_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index c4930efd44e3a..5a083eecaa6b9 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -714,6 +714,10 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
 	change = nval != oval;
 	snd_sb16_set_dma_mode(chip, nval);
 	spin_unlock_irqrestore(&chip->reg_lock, flags);
+	if (change) {
+		snd_dma_disable(chip->dma8);
+		snd_dma_disable(chip->dma16);
+	}
 	return change;
 }
 
-- 
2.39.5



