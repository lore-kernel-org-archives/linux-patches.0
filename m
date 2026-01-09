Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DE1359F99;
	Fri,  9 Jan 2026 12:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960380; cv=none; b=g2TSGIUer48yjuRJ6/Izt6uNFMS244L2ryAvEdSgS56JxC9PG6u3UsUFZBv9rWrcGlM50ukd3FDW4eXOQMYhhSknvOvMkoMwZ/4UxQmr+Awcomx8wZZdfJ8a5V/19IxsF/JCPjS3sn+BAXoD+jP9mQm20+fJ9lupR5jzn2M+6Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960380; c=relaxed/simple;
	bh=AFfVFw6ybepoCeWUd+5NAukNv0ipACKLa5cRmpxgQJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1gCtKa6IOOSYsRCqiDkomqUSLJ1X4rrsLOYw4Grxe2FYJ5fIWgD7tMvzO8tKgyvz+RJ0dmNosF79QgJHbm+pY43IS2D9tElblXJmXKpyNYdVu65mQxb1IY5TNXRX3IYJ7QHSqqdFBNIeV8lYVCESSZviFuQ24gNJqv/bnszROA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5nP4vCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5nP4vCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4936C19421;
	Fri,  9 Jan 2026 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960380;
	bh=AFfVFw6ybepoCeWUd+5NAukNv0ipACKLa5cRmpxgQJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5nP4vCmie1VwL2tVV3XszL7MsUrarVMsqHjEoO/DIGZwuheXyYaiC1fWsYA/L2fp
	 aO14LrrZ7IDQ+YXZroHKBkXT7LjGNJx08k2jocelnwNvBeLEyYXqxElh4z4suvkLOx
	 cyVAAL4t5vXgMzLZeY+1y229btN+bUm4k9OiQXac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 382/737] ALSA: vxpocket: Fix resource leak in vxpocket_probe error path
Date: Fri,  9 Jan 2026 12:38:41 +0100
Message-ID: <20260109112148.371705494@linuxfoundation.org>
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
index 7a0f0e73ceb2..867a477d53ae 100644
--- a/sound/pcmcia/vx/vxpocket.c
+++ b/sound/pcmcia/vx/vxpocket.c
@@ -295,7 +295,13 @@ static int vxpocket_probe(struct pcmcia_device *p_dev)
 
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



