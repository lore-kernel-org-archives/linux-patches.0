Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515D02D8790;
	Tue, 15 Jul 2025 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586539; cv=none; b=Q40MuaUNSJ9giYaH9opxu6Ubf+/WvEqBaquESmjrrb13GmP+oXRGAy5TvyQiuVshsgslXOqSBGA0nI1NEozXZVM7SHsLEZvUxU9h881a5veJyG5rRX3Qh0649iKRHoP0lOSNY/rdD3VGVX4WUvqfKWP1bpG1uSEiC7cQ5+eK4OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586539; c=relaxed/simple;
	bh=+89/RM/5SrpSZobRxx9xaGVClXcYF9aty+d/SQj7nwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzDi+qeNySKHZCUJbVCSi9oBAG/RPWeJXaahcnLIRD4YaIzeVb4KSezFaLwAt9JJb6k3EFl8RjAoYBU4K/khH2mCemT3StvEzNtkxThgQSqKewzgMHCTIXwqxyLv5LEtN2yNUTQv3Zrns0Va3RczhOHBFM1OYZf6+9gTJPS+wFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AF1xm1Bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AF1xm1Bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FFEC4CEE3;
	Tue, 15 Jul 2025 13:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586539;
	bh=+89/RM/5SrpSZobRxx9xaGVClXcYF9aty+d/SQj7nwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AF1xm1BzkADYxFcziNu0ECb4hWR3NMYZaf3v8ob06cwvAOPyIVa0YCgqXAn/HG3DX
	 wN3nhDKVopHuxCu9NZSRfFxN70Fah8m+B6e712y9X5jmLShz+GxYJnM11C5EUprcWH
	 +nwrVj8CXq++Wcg5ApOvz//bVGKD52LQCGCvLT+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/148] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue, 15 Jul 2025 15:13:14 +0200
Message-ID: <20250715130803.207883525@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 679f9f48370ff..b69bc83c103c3 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -722,6 +722,10 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
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



