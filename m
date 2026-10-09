Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7E11A682B;
	Fri,  9 Oct 2026 14:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556330; cv=none; b=BsC6WW9/Tq9cbabGcM/j6gl4VDf26OMU6vNPcUBi7LsbuAEtYeiNUmGlgD4hV4q8xtthKplQKiOXFFIxSAJAGAOLoTQpXZdEiWmUBsRWye+6MLRwFCZHVf0hj8lINe+qzLnYjCuw4OV90nzs7Tmq07uEWyj3gOeklV6Xp2uGs6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556330; c=relaxed/simple;
	bh=iNhghfWRmFSiZo7KxSbAFauf5XJsoxJmJRdx1toDikI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkZf4X88fGDdoqTA+5nPD/M7SmQNHIvNtDiDPTT0U5j01hxSKEr95lE3GVkdm/P2xYlGpmAMKftQdbeGKGJ0nXZzb2GRGuMrTtiUVCUhxlNWDPe5P7SBod9rs1uaTKg5D2fZTkJoiVI5yT7HIQ7TnxwxENk3xj4dZumV4gMZJzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShnkY99Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShnkY99Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299061F000FF;
	Fri,  9 Oct 2026 14:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556328;
	bh=02blKnNcdn3ig9ymNnmQ6Ok9/gle7JwNop/8YreZ8Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShnkY99YgOi3iyVz4lXk7TbSvNKaR69gW28rem661hnjzvhnG7ZeCqs40B0/v2cpK
	 kH4x0ilGAVItiJCMbJ33i3Cp6KrCV/CTw1raOosdi8JCRfaRe//5Lj1n63YncjKGuJ
	 o8dyuYOqZN/Hw73NyIwHL2IOIInqyhkQGVf9ryPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 159/428] ALSA: core: Define auto-cleanup for snd_card_free()
Date: Fri,  9 Oct 2026 16:08:16 +0200
Message-ID: <20261009140949.655606295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f1d565dc92955f05383794e0fa27e61ee0555027 ]

For the errors at the probe time, we'd need to call rather
snd_card_free() instead of the snd_card_unref() -- the former calls
explicitly snd_card_disconnect() that cleans up the registered
devices, etc, while the latter may leak in corner cases.

For convenience, define a new auto-clean with snd_card_free.

Link: https://patch.msgid.link/20261001151039.592033-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e6229c0402ea ("ALSA: ice1712: Fix the error handling via auto-cleanup at probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/core.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/sound/core.h b/include/sound/core.h
index 404785b7d885e..373a91ac3dfdc 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -340,6 +340,15 @@ static inline void snd_card_unref(struct snd_card *card)
 
 DEFINE_FREE(snd_card_unref, struct snd_card *, if (_T) snd_card_unref(_T))
 
+/*
+ * For automatic error handling at probe time, assign the card like:
+ *	struct snd_card *card __free(snd_card_free) = NULL;
+ * then create and process as usual.
+ * But, don't forget to clear to NULL at successful return for avoiding
+ * the unexpected cleanup!
+ */
+DEFINE_FREE(snd_card_free, struct snd_card *, if (_T) snd_card_free(_T))
+
 #define snd_card_set_dev(card, devptr) ((card)->dev = (devptr))
 
 /* device.c */
-- 
2.53.0



