Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDC49460;
	Mon, 29 Dec 2025 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025409; cv=none; b=SlvdQfIfYV8mPSFcjMb+3shVgHpIG5fB2rYRKVIlEfKeDKmyADrg2HP1ETzvJNw/KLwAMzP1jsfvDhZnWtlK4XtNLI+i9T8LL1+iI2mdv1JiIRKVuZhKqW3gp16LS8qt3rSZZSV9Cek19V+9wdfYV5CNrOsOmuSr+SEDgnxg+6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025409; c=relaxed/simple;
	bh=A2/dRXqrOg6ffbrwgSyIRY/ebQZMZ1YIplz0R8kLOBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTABPFQePVsWsTQKaluhACqKbPS+DICu1qw6xVP7C/Dwkdj0Q+Tnh03UP+ZiHsJylHAJhrBeNWqQNbKkRT73AR8oSw8/CZ6E8iscj0NWR1LWjzILNrD1wYMF4nPjOXxzFmF8DFWGOrSmaZgZhBfxmkqn8PlBmALpCsBzuOW0FxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY5nnKwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY5nnKwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCB7C4CEF7;
	Mon, 29 Dec 2025 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025409;
	bh=A2/dRXqrOg6ffbrwgSyIRY/ebQZMZ1YIplz0R8kLOBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DY5nnKwvDZB0U3M57xhjWknq34uiEP3tsLQ6BUCJDQM98KNLw6F8YM/vKHQQKrysr
	 oeOyHQhTBUwaSAvLemZdVxYaDbKuO6HY7FxDnfw8LPV6Uq4u6TiprucmMGtGghIsx5
	 SXoBHW+pZ9nPPwV9puMsb8a/rconZ7fZS3SLdxKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/430] ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path
Date: Mon, 29 Dec 2025 17:09:32 +0100
Message-ID: <20251229160730.618689667@linuxfoundation.org>
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
index 13419837dfb7..a3291e626440 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -131,7 +131,13 @@ static int snd_pdacf_probe(struct pcmcia_device *link)
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



