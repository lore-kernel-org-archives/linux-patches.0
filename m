Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B3F26D4F2;
	Tue, 15 Jul 2025 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587759; cv=none; b=GsXZSXAem5Jb0gTCtZxofOInA1wh0ZyCW+ATachXVK2rsX4hI0d70Gw7XFT8s7V71Wgau3wu1MLkmL676ZsxST46UMKFAzH9+XeaExWVsDZ5OoiK5BmeRR4ytOm6tvG1cS20hNsiV8k5xspK+ZKCvIW0eobpwCf52aOdFaLK0Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587759; c=relaxed/simple;
	bh=DcEWBCange9VNDLruRKZqWQN+ukuH89//JKwxz6MR0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5VHZidNIr4wcmBK7lGZaKYvra1hAK6Rfuf2ItIZQ+oJ6HR5EsoLjNqzjIgkp9xjAXGzgXx91gPi9V0S6uNxQ85wQe5YgMGpbn7fgeBCQwqd6SP/HgUdmoSWQDAJxa71e9wt62diqjx8tzIf3vDJIFugEHaNUZNhyg2JkxGJPp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csjX3xiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csjX3xiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AB0C4CEE3;
	Tue, 15 Jul 2025 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587759;
	bh=DcEWBCange9VNDLruRKZqWQN+ukuH89//JKwxz6MR0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csjX3xiVq9XXzKHPxlXERbXYUFrgI9JTf3k9vXVMifmlxLbzBmRD0S1SgUoayChBs
	 Zak19rKklxyf+8Fb1hTc9sbsiMRxuyLZBVhdZ9ol7SNc1ddQAUvu0hPlvmL4sqXiQD
	 zfvjVXlE5cuvhoCa/zwXv6GWmsW2oIo/mqyQjmKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/208] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue, 15 Jul 2025 15:13:30 +0200
Message-ID: <20250715130814.994752134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index aa48705310231..19804d3fd98c4 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -710,6 +710,10 @@ static int snd_sb16_dma_control_put(struct snd_kcontrol *kcontrol, struct snd_ct
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



