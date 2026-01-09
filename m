Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5BF33CE9A;
	Fri,  9 Jan 2026 12:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960383; cv=none; b=Y2USVf1Bga99wJ+7o2lrVkoJZG3wXnl9GjrNeYa/qAMVnFt5i0KCfygxUdj1+hrukRH/OdI2WDdNOktg9DdX4eWjbvhK3jbTFU9Z5CasmXW6DjqpvUTHAeD84aMIXseYzYNMoFw4dq9sQ8J0YD9QPQ1+pQagsx5DZ5//vgFlgw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960383; c=relaxed/simple;
	bh=xO3DxBlUOzqT/LA50nPClTEbsvpKS7h8SI92GuYAwg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHJlWFJgrHsFp2jgfQAcxDK7hi6bh9/GCSUPK+Vpm6/ehTxClRv9ae0QXPSEaadg7v6WWxHaAx6Ly36AZy9vZRUXoIWHUWh1QQ9f5ZX4RISGcUgz1Gvckh2P3lDzmGnhnGZs65HsZ0AdJCHny+P2L9r66qhnDfD+S9c0hIcdO8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omQ6w4CB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omQ6w4CB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD232C4CEF1;
	Fri,  9 Jan 2026 12:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960383;
	bh=xO3DxBlUOzqT/LA50nPClTEbsvpKS7h8SI92GuYAwg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omQ6w4CBRghGRYQctCH7wubGf6FgmG171ncjy4lDQMu3Pi2LYg/qlkwB8NjLLyJJH
	 oYG1q2lrESza9Lef3K6rYDlvV7wVcAxATcLgFF6AFh7AXIfQ2g9y7geQLO92wSftBb
	 3i/LlEmNPGvaaizR0LX1h3eVoUI/hnTAbov1L4ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/737] ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path
Date: Fri,  9 Jan 2026 12:38:42 +0100
Message-ID: <20260109112148.408738385@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 5032347c04ba7ff9ba878f262e075d745c06a2a8 ]

When pdacf_config() fails, snd_pdacf_probe() returns the error code
directly without freeing the sound card resources allocated by
snd_card_new(), which leads to a memory leak.

Add proper error handling to free the sound card and clear the card
list entry when pdacf_config() fails.

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251215090433.211-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pcmcia/pdaudiocf/pdaudiocf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf.c b/sound/pcmcia/pdaudiocf/pdaudiocf.c
index 8363ec08df5d..4468d81683ec 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -132,7 +132,13 @@ static int snd_pdacf_probe(struct pcmcia_device *link)
 	link->config_index = 1;
 	link->config_regs = PRESENT_OPTION;
 
-	return pdacf_config(link);
+	err = pdacf_config(link);
+	if (err < 0) {
+		card_list[i] = NULL;
+		snd_card_free(card);
+		return err;
+	}
+	return 0;
 }
 
 
-- 
2.51.0



