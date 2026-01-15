Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4CD3BF309;
	Thu, 15 Jan 2026 17:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497930; cv=none; b=oCd2ZQSjTMmZEv3DrTYem/RuI2iHN4AxU7jBG8+npvL08dJs9KuwpiXgyNN1RrL+sK+eZvRRrCuw+5E7ak6BXzRgk+zBN/jSuhmZfmyXdb7wnvlbgPCzp09uXoPbITnM3tzmA57fpef7GeJ5ut6qUuM/+ocpa5mNEf89995j7so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497930; c=relaxed/simple;
	bh=fHGvNNpsP3cYFQmxwXKzYcjUkI6wvE0H3Ii8czu/ia4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME6z9y0t16Oqy17ndb7jtvWqbEQtrXdA/h7R1kRHp+QnX84FJJVzPNHsiL5XSwZBppFdcYaGJjtiowzQj7d/gckszzxHDle8dZ4URXh8wgVEBVqEQRDUNxorwWwY48xSpASGENqc8Mma9JkxLV0DxOlMK3ixlwE6oPQ+DYJMpOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rs+NAoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rs+NAoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAAB0C116D0;
	Thu, 15 Jan 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497930;
	bh=fHGvNNpsP3cYFQmxwXKzYcjUkI6wvE0H3Ii8czu/ia4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rs+NAoLeWyCqZkrf42wVyHPHyQb++vMAbXY5gGv2YqX5oTKvBNU0W3+hssVZdcpc
	 vFFHqjaFJkjrz2ztzX3FI2GlzsNzmDp8P3yRfHpRQ40cga3v8ieIdaIFgWTFEu9Czb
	 K5TTowDUFt1OMimSbthVhhpetEuqU4uDbXJ3zHyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/554] ALSA: pcmcia: Fix resource leak in snd_pdacf_probe error path
Date: Thu, 15 Jan 2026 17:45:20 +0100
Message-ID: <20260115164255.429899529@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



