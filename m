Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C742045B5;
	Tue,  8 Jul 2025 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993587; cv=none; b=ivn1E51r/26SV6Z5JN0VGPTOfseKLUYsqav0kpg4xKlQSW+Lh0eeIMa/g+tZCaHZQKhGlGl9slkKp4OPW86pRr8Qws0+/xZ5AdXpOCQJASS0ZF/q3k8h1zdVCctsXV5esbj609PP3z1gi4XWQGoJ5sl6OKC40mYyRGlUTjWqwYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993587; c=relaxed/simple;
	bh=zNFWjew4JuBeeV+xxv2e1mXnZl+6EjakaeTg6BJfo6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqZV5Ng+dEG0WjLlOVZl0LMBe0BAucr3WRGpdvtZKuYNGgNqADHU+AK3iKd4qXNEUCQr+qxXgXvpKvdk1gfxwdFgKSKjmujhuwZMXP8qM5Q22v6kxn4LDy29ZrSooGHtWdb+9/a6lHh8Wri5isAePFPGOP0GyxvZ0pMyfrtGyi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSIS+o0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSIS+o0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EF6C4CEED;
	Tue,  8 Jul 2025 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993587;
	bh=zNFWjew4JuBeeV+xxv2e1mXnZl+6EjakaeTg6BJfo6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSIS+o0fDJaiX5EQMN7pnjVpRRNbm5U+paOtfHnK3olG7rdUW0STQfMiP1xotyLUW
	 rykQEgNFzk/A9eQA+Kf2NKmEu9oWr3geHKQhHAJyTyljAPxqfHpVe4qtNl79LxEFju
	 jPlndbtejP9Vth6ci1qlZTKcG0xBVEtmkRB8s1UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 125/178] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue,  8 Jul 2025 18:22:42 +0200
Message-ID: <20250708162239.850151143@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



