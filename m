Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCD32E5B2C;
	Tue,  8 Jul 2025 17:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994109; cv=none; b=lzPk+5T45jQ7Un0UfzyoDTyJe2GNb2XTYtQ5nglwrgVKlV6dmQf4hZ+1f2t0OOC7WXSZ7Dr+BmL3AX2kcafk/nl4mzlPWnoiKTqb476INdjeTrnuu5vIkycsrmoYN9g2hgUh+m0yom4FYNFyOxIOcB18e3n+Sf2OTKKATvkZqrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994109; c=relaxed/simple;
	bh=zSOIrGZiMZMY/JWWwqBaJjb5WhSzUhEVJDlBFmKcgBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5hJKo6owKCD02/qbpWpiYu0z9ZS2ej1/5o4AibWk9xlJd81NhhFD6Dw0lJlUV3zROb2Jzdja6HC4+hYsB/pyHMk6FQ9pDYTHWf6AJhJ4VA+ULG7RBaEQYebEwBwoqcIRHO2+LsbTr8HZtc/aZWCRXlzBO31CGFsBFq2EsmkXUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvxSUxvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvxSUxvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DB3C4CEF6;
	Tue,  8 Jul 2025 17:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994109;
	bh=zSOIrGZiMZMY/JWWwqBaJjb5WhSzUhEVJDlBFmKcgBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvxSUxvzwZehCMo3TSupJk+9nHPra1LFn9atlPyLv7MLDAcTXfZMZGtnL1rzS0mYv
	 JyWIUkI9hAI0v8S2V1WGqr0R76kJMsA3Vfue+EAcVSjWkmteK7yhGk9yBoQ+ffUDip
	 3+ViosPeTPQg8/dgFoRtdQ+UCopeO+RKT+C/AfnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/160] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue,  8 Jul 2025 18:22:45 +0200
Message-ID: <20250708162234.958433879@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



