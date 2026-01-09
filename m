Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C6835B13F;
	Fri,  9 Jan 2026 12:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962234; cv=none; b=N2gz6XY1SH1Xvf+f8V4hwCPp37j/7MdlupVFa/4dFrd8sK66VbmKnNmTEhRr80vckG+pL+Zag8pPFQ0fmbxbXDEZgooQRlOQ/Qc+ZYHGLW07Y7HRMMh+egXd+4WK3Kp504xQEdN8S4UiGDjpqFH8MuYRpadQ+CWzensRku+neLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962234; c=relaxed/simple;
	bh=XjLFq8WDA1ikcwqyAffvFNiSCZlGALbp5yk8L9G2Pkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGrDVwCmiHISrCR7mzVilVZkaP4aq2OmwdQimOaUeBH1AdRi0I1nFs+RPBhO7OAXvLHEFaQ1IfNnza3V0RssbGKrOxC7PVzDsJj8obD3lZ/tpET8TmHT7ZBGey5y4E1MBLUc+rbfIVZND5CORZ6ytiWd/WgI79o1DtgsKwaY6lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UD25ZA7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UD25ZA7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DB1C4CEF1;
	Fri,  9 Jan 2026 12:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962233;
	bh=XjLFq8WDA1ikcwqyAffvFNiSCZlGALbp5yk8L9G2Pkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UD25ZA7HDjdKerRHZIXaT+Rl5po+7r7GWXNfu+kVareoKRpRqJxWQVUQ+w/LI3W8f
	 9ZLokmR2zUwHzlenFXz0KqISh2BVMBB0OdUi8IDYRddUeo3Vfh+cwRf5Cquc4iFuqE
	 09Yj7alZgXWnrZ69g69Qc+96rdZX0RCXjSuUGStw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 294/634] ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path
Date: Fri,  9 Jan 2026 12:39:32 +0100
Message-ID: <20260109112128.593321530@linuxfoundation.org>
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



