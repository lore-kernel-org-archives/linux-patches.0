Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC253ED10B;
	Thu, 15 Jan 2026 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499457; cv=none; b=XBNJ6jNwf3UKtKAFdXHyx9h/UcFMACfmjbrEHZZ55ozyWjl7VOmXuA8KWMzqvu60F3HYxac5oHIIBcJVxe8LbE0Fk7uJXjbHN4BzYuSAfYF0b3E0GL6rSCfrY721p+wa4tj2qgwOkIgVnYCCSAb+ju7GmM59uYG6JLl1e/efx5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499457; c=relaxed/simple;
	bh=5TUFtGb9oocDGWp0/YZ9m+goDCC88jauqpDslRpK6fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBHHQZuy81KfAMYU+PjnXE1P1oRFPz3u5xsRm++xF9REibNRBID7yheet+fEbLxNfLg0u46grqV+XTspNU0OiOjDmH3k6yCiyf0ESp19u+nTYH1WOizKKx7rdDc5paEU5tF64fl0oMYpeVbkSey9yiWneWq8/0kJePXw6Qepu24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJmkM/ML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJmkM/ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F611C16AAE;
	Thu, 15 Jan 2026 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499456;
	bh=5TUFtGb9oocDGWp0/YZ9m+goDCC88jauqpDslRpK6fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJmkM/MLa1AjOvp7P5DLampd8hdsE6gkG2tBTaxLFRNHdRxYD3vTmEaNpsUWQObxR
	 p8QQfm76MciZIrYzqDx4zXTOrShU5XKyf3+ZVC3MudGx6b65JZpGyRESNrABy48TXR
	 kKffAyh6oLUpUZpQ0GSQn5glVFA3JvzmhQ0rmQ6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/451] ALSA: vxpocket: Fix resource leak in vxpocket_probe error path
Date: Thu, 15 Jan 2026 17:46:41 +0100
Message-ID: <20260115164238.135693066@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 2a03b40deacbd293ac9aed0f9b11197dad54fe5f ]

When vxpocket_config() fails, vxpocket_probe() returns the error code
directly without freeing the sound card resources allocated by
snd_card_new(), which leads to a memory leak.

Add proper error handling to free the sound card and clear the
allocation bit when vxpocket_config() fails.

Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251215042652.695-1-vulab@iscas.ac.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pcmcia/vx/vxpocket.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pcmcia/vx/vxpocket.c b/sound/pcmcia/vx/vxpocket.c
index afd30a90c807..16081c51b938 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -320,7 +320,13 @@ static int vxpocket_probe(struct pcmcia_device *p_dev)
 
 	vxp->p_dev = p_dev;
 
-	return vxpocket_config(p_dev);
+	err = vxpocket_config(p_dev);
+	if (err < 0) {
+		card_alloc &= ~(1 << i);
+		snd_card_free(card);
+		return err;
+	}
+	return 0;
 }
 
 static void vxpocket_detach(struct pcmcia_device *link)
-- 
2.51.0



