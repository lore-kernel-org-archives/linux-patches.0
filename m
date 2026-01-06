Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAD034CFC8;
	Tue,  6 Jan 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720027; cv=none; b=Y+xViMgc11P3K4Tde1pDtYH5StZAVnF0ygvcxSYbF/XDuUieF79scyZLGb4TeboFKfu8QPQ/RsuewG5z3EDl8gQ7rF/HBqG20AjkSTopVM7sCkvZBDE9EH6hZWl8q09oCLokxncwDbwuaC/pq48KS0h7Ds/+YYEMGCUE4jZYbtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720027; c=relaxed/simple;
	bh=Y7TJsESkqZVpEJduGoBDEDtNKO+NyPNNTT6CQcKstOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhbRLrbulyduNcEfPdrFILH9RTaMdoHcDPBjsUEpa0Aubei57jR5/y98I5Pj8JuaXL6/Te5P0UqxbCI3ckzTr3hVmpNU3Xcm/ZIJVH/7hhY5GdTpbBQ2IE6R9BdzaChD2lA0oEU304ML7OiGjjtOfgDwMGEpLoVB23nK8sc76JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIDKUsY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIDKUsY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D804CC116C6;
	Tue,  6 Jan 2026 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720027;
	bh=Y7TJsESkqZVpEJduGoBDEDtNKO+NyPNNTT6CQcKstOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIDKUsY6utx9cRrghWDa/RaIc64/3LMl4Yew8cUipk8fAtGKj5+2YyP6ETnO+WEs5
	 sQNaBgOHzKoyUsdZ5wIlBq/ofSc57P2DKzV+dz/hnuRvNgpnT4BoHLxTAvDKot7Vfb
	 mJ2pSitZUYg5kIPyTVISwLfM+M4fGySvyrsN25N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/567] ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path
Date: Tue,  6 Jan 2026 17:58:15 +0100
Message-ID: <20260106170455.509892359@linuxfoundation.org>
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
index 494460746614..7531e89e35da 100644
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



