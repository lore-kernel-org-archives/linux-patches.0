Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F4E3C1982;
	Thu, 15 Jan 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499459; cv=none; b=IvQwx1pqpiJ8DlM2nMvE9SHE3q7Q3NEPW3erMzURFPXNeWIpiZAwPwfVUCDJWKHmxxs/SogWX6WZL6WB1Hj/ZadJTahj6Ugi/NqCJooobfcKbuORIF4NeMX6IuycODpHSpIFMEGnXgMP5w1pJ6xcFF8XL81dLpC7Oc6Ahm5X8r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499459; c=relaxed/simple;
	bh=DUhGOJUpJpoPh8xY9rgeDyZ3DVxewSmhAOLJK1tCqgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TU60fufl/c42S5aSkFNKF5XxRPhJevbFRgfwwjBY4fEeNp/jgS2aUXTjkKcWlnUwyAWTwBJ3svMDnaUdiLjCYfr5apIjOK27ft0zYQ3L06RkZbNewOKfwMIlDZ7na1AnNEIkncBlY193gJzHLvWH1MF39OGWA48n0AsfTNW9GhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiPJ0gRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiPJ0gRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05679C19425;
	Thu, 15 Jan 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499459;
	bh=DUhGOJUpJpoPh8xY9rgeDyZ3DVxewSmhAOLJK1tCqgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiPJ0gRjEy/Vp7MAOXgM8qe6blb+6IFPHZFL9dUVsyOuUFyzGZt86UJALMtR9n8hH
	 LhECWxwtdcoL4jnh+0ZmluURBhpJJaq/azpx0xLCSqkD8z0/KNB2BgUbvEh6luATxe
	 47tg27Ubv0GZzcScLN851u+lzlgHzJTnnsFrxigY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/451] ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path
Date: Thu, 15 Jan 2026 17:46:42 +0100
Message-ID: <20260115164238.171575912@linuxfoundation.org>
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
index 27d9da6d61e8..3a354616af19 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf.c
@@ -133,7 +133,13 @@ static int snd_pdacf_probe(struct pcmcia_device *link)
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



