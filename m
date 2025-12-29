Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88B523C39A;
	Mon, 29 Dec 2025 16:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025406; cv=none; b=Er7kxoqIARueoU0tT2NME/LiyNl5FjbhGYIEWo4SJSeaGSDu26AWlpS1UFmbkPtQq7h0scWAvLEaBcH1emmqiLkx8xroqHlB/LOORaOhMUBQiBEpCNl+jR+zeiHTY9ly+Ly+4MeyNmxjOh4orq0/wyQhz+PGJeUfoQnXMwVMirc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025406; c=relaxed/simple;
	bh=8exTCQPgDgepvB7kAw1BqJ/PcKKWt62WpQtar4mr1hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k18JmQqh8LnfmUZaX19ZSbFD9Na6A9UykOCOK+61cIeQGUEO89a2bdaB41q6kN74qCg0HEJCBMg9OG0Z9cfwg/Gz5UU+6fMjBfYpsOYZ/7ebAAKAk5o+afucQRtHMdWvjZL6uXh+3TlMu3FUeCKiCoBvwuMbyyNegMMGxotqJMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akGNo6kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akGNo6kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE55C4CEF7;
	Mon, 29 Dec 2025 16:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025406;
	bh=8exTCQPgDgepvB7kAw1BqJ/PcKKWt62WpQtar4mr1hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akGNo6kPYgvtjSPNS2ZNeNslhyj/Nt6pPwXW35ixfJUKayKyvrpRtEKXd52v/991C
	 si6YtsAILABcBJh1bXMI83c6D37eGBRe2v4zyWHm6B9xdwFMp7k+lmXGDPH/UOybcF
	 knbis9sOh7X0oJgySAQgaXe6MZTocwA7qFpvBOHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/430] ALSA: vxpocket: Fix resource leak in vxpocket_probe error path
Date: Mon, 29 Dec 2025 17:09:31 +0100
Message-ID: <20251229160730.582241633@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2e09f2a513a6..9a5c9aa8eec4 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -284,7 +284,13 @@ static int vxpocket_probe(struct pcmcia_device *p_dev)
 
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



