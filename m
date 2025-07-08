Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB3B2E3385;
	Tue,  8 Jul 2025 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992509; cv=none; b=dtGSD0n1jL5Siqxuyyd2LPPw04j4i4CVbl1aL6sdxGLJBvHS/OV2n3TIQTJpxFOUQvJTUVTY+EvmfrA1Bk+lZXzz7WQ4SsPHwpRHK4Aw/xmb1mZraO2VJ22dOEXJhX4gz/kUNBSRLKHtqs1vu/BkYgVPKXjiOT3rPjmNgjgiweM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992509; c=relaxed/simple;
	bh=aSoQpzahLMbecdPEQ5Q6VCr3CrijxRnxKYVxHd9TWF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGFknhQdGVIWLLjcnGsxGSfV2Vz9jkC+fy5gNZUJeXpyCp2uddBu2E3qY8YE08PgQk+MMpaeognu05DHGcr94FdTV5DbxKFxQHG9vWynylApkS84X3k4aQ5w8OrOxTKYEGNEALKZzCNwIDdFjNz/LREZ3LKYCQU0xtxVV8MZysQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UH3wZhwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UH3wZhwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3E8C4CEED;
	Tue,  8 Jul 2025 16:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992509;
	bh=aSoQpzahLMbecdPEQ5Q6VCr3CrijxRnxKYVxHd9TWF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UH3wZhwRIZ/DY0dG+7jUR/Jj9T6U7swEiMLq3H0CMyRZ7+L2K4ekuTmlDDWe+v0eK
	 KNqM+lZIrV4JHWZmADW5WrSiG3GH6TvQqgRAf9Yh2RrHKZDGT07llYBpezKqpLYfWt
	 ifiOrMtGAsZRSXePcfZSzjPMIyyisjuQNlPe/cs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/132] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue,  8 Jul 2025 18:23:16 +0200
Message-ID: <20250708162233.121786921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5efbd0a41312b..1497a7822eee6 100644
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



