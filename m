Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737112A1BA;
	Tue,  8 Jul 2025 16:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992068; cv=none; b=dwAMruHJuoiRcqUQYHmjhSjVlEaqh5Q9mtnkwiIouKr88tJX1GJSe44hsQYl9/d0tMMgIAFbauld52KO0sJ/wY7NrbTXkM4H/OvP1NIGjmC5LI8Qmp4HmAEVgk4BZuSTaxxVtkXvawq/c5Zt5X6PgNvcU0efyhgb2pxG9ahjggM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992068; c=relaxed/simple;
	bh=3CTcfWyRN6nrr78LVYIfPTR1yn8YHdL8pt+KcpVcGEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hum0Kmx0dppfPISUKnbgcf0nXPCZxmMSJuHcogUK2zQnq5Tw/It/jHzrlRGQ9+Tw9ZTZylIzJt7Vuol6xuyvt0nioeCfI0IJepeRREgkgst1lT7x6x33iKj9VNYTLnzoxpkSdIIsyOoVTi8it/t8ddLESsEbGMh75RktvLP9f0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyU1HSQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyU1HSQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67CDC4CEF5;
	Tue,  8 Jul 2025 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992068;
	bh=3CTcfWyRN6nrr78LVYIfPTR1yn8YHdL8pt+KcpVcGEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyU1HSQbEzndTG2tC6lA+zT0vFyPw4Tx0xk6nN0M1+/8ZizRzlnj03xnrf8RJaERM
	 hjLhPtl7k/wvfZSkAKWitgbpt0lfuYzhKLxsnth81xJ4iKSfMtiLbwtP7sH5zQip0E
	 D5NZcEyDNz1AgM5oS1NaGSLrqKJP8W/9y17N0kJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/81] ALSA: sb: Force to disable DMAs once when DMA mode is changed
Date: Tue,  8 Jul 2025 18:23:39 +0200
Message-ID: <20250708162226.516312508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



