Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AD0335BCD;
	Fri,  9 Jan 2026 12:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962231; cv=none; b=OqqQgqyS1gLR+ffxUOCJl0QZaIyXrRqVZLv5V7JZNXrLBSPNK+MlGNdb7BRqlJQV99Mbws44MRu3L1eqgUuZMDxggi6NUjpeC4Lgb2QS7kZSC8SlYj9jw7UIaIBNE0zgtO105++UEQZXkUmrdC0S50KpquXFrqJOAWgQGn29cPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962231; c=relaxed/simple;
	bh=8iPQq1U7d/WZyfNLJqrICjCHMbItyhvpbRF1oGaQSFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoErchMVhqX36JVG4h2YREKVy1ChQCL4kTUnDrab/p5G8zvU/F854fzub8M6FKXYJx+C101WitE3y6N++bfk+P35g5xx6Sx1XJ2Qkg4XvNo++RqOF9oAttaihSahXG/1MkWul6cAhyW6CQXdtbLs+I9gvWvqKbtWJ/W5XffVgAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYKYhLr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYKYhLr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8F2C16AAE;
	Fri,  9 Jan 2026 12:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962231;
	bh=8iPQq1U7d/WZyfNLJqrICjCHMbItyhvpbRF1oGaQSFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYKYhLr4FDRASwD1zU1BhvhQZY3Zc0lpP1zdDAqMOtSovBVN76bbVlzQyyCP1yz05
	 KTckDTmrRK4plvSj8PyT0dc3piDsZNRO+EzjAXwY3jFutq9U/rHnFmOrpdoW90qL3E
	 Mi1xdWyoO4hBta30AFFVi8g19hN7/FrDV9nR7pIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 293/634] ALSA: vxpocket: Fix resource leak in vxpocket_probe error path
Date: Fri,  9 Jan 2026 12:39:31 +0100
Message-ID: <20260109112128.556171340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



