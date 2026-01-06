Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3450B34CFDC;
	Tue,  6 Jan 2026 17:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720024; cv=none; b=NQpHs5pCTv8WdwN8Mlonu0od1RETwQqIBv7EWXFsgo6RnR+OqFqmhpsm2aHjHsr7nRWoEhYQQg+uIkB6F1n8sqXRNZyG9WNeq8tOMtxzfIJzp5C7hobZuNA9KgL610bHb9RoDr5I5r006MqJqQi8XoaVGGcjBZH6W8BO78MdYO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720024; c=relaxed/simple;
	bh=CVYIoF8+wabA/BFK2n+AE3L+vFzk8N1BdOx8BIqgz48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXJD3Da5vXRkJKlblpEeV4PkCGKJD28KncMcIpoWb9ZRyRmPpRVxH8lo+SXw0RajssYQzfilLqugBxztM2ap1ZWc6+LYm8laUafXSyHt1AJcz7dFiUGn1b+mJJEciGgp3r6uSgvzmT8LI7k5VWDoBxFI2Ml/owHyB/LVWhKndxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPYswXqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPYswXqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D83C116C6;
	Tue,  6 Jan 2026 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720024;
	bh=CVYIoF8+wabA/BFK2n+AE3L+vFzk8N1BdOx8BIqgz48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPYswXqSrgs1yOmV8886M4ohYuZWPvLLQzh/qcL3B1glV4hHR0Yf/px9607LGo/a/
	 cNwPrMs9RZQucxyWPt61V9k5e7cCJT21QAaNtfRKqcKWFiDKnsyPaZUdCyrmp+xo8J
	 F7w7h1dpiEz5hZ0RY574aSpf/XCdA34DkQpONP1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/567] ALSA: vxpocket: Fix resource leak in vxpocket_probe error path
Date: Tue,  6 Jan 2026 17:58:14 +0100
Message-ID: <20260106170455.471903387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d2d5f64d63b4..e1f5b8cfeef0 100644
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



