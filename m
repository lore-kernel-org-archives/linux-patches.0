Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055948;
	b=eCrcIcbXpf6XfTXnynAb38cSslpYVgxJ1O9tHooQrC3XuRu3FhkOV6cIN2jrpfME5t15
	 942uyIlisZWJrn25Yl7vyjwhN0YG79UE0HBs0FQvJ66/im28DmdkJHj/9e0Q47Ar71sXs
	 lvXJ3BPZId6+w4LtTbrYtCXJd4EOX3NosTXmy5mPUJC7ZXQ7RQR0G+qaxvct8d66CTEvE
	 qOhRm1qS0B/mLR5snFSNdkwSbkEXT8FJCHVmus7VHjkzCIvSyp5NJCVuxs1y5eMc0YX1Z
	 7i5+WiEKCo7oT/Opu2e2nAkbQ6TNAXkhDEkfX7gtLkbrYax4xh6A7gndCDUDQdqoM9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87t6HtPOYPFb+70NMIXKsza5xvi/Hw0fSmRDSMltezs=;
	b=rQHW56s1CNCWf05IkmxypqQMUR+wMh/Tj5YXJtM6M67X6dlkTeuIMu6qDfoeCsydP5mg
	 xyFT5cnOcxvPaGoSXY8X0QMhsOCQBzokYW31bvNPm7EkOI5YYXA5iu+bfXfi0zZhXoGOw
	 5oyrDxWJkXJzvwf2p+m7O0NsF7kiPEFcQJLTt9sPo/GZK25+i103x6M2uWCs8YucvcxtU
	 XA5hN2RntfOzgKCAOsCzen9DICELqTadmzm1GP0fHtG+shl2SnQImTzJBqlzWzbPSJgWV
	 dnTfbIXoKG54EEzHCYupC0gQdZR/Ag1FifhoQ6bwGbUlavB4JwVrq5yIhh3ja7UV4bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="loX1XE/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6EE606A320;
	Thu, 19 Nov 2026 02:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loX1XE/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A1E1F000C4;
	Thu, 19 Nov 2026 02:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055948;
	bh=87t6HtPOYPFb+70NMIXKsza5xvi/Hw0fSmRDSMltezs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loX1XE/L9FMtdxezqptYce1wautbFniAAu2hJfz32JoFonSRkELLPC0SCVyFcI0mv
	 t8cea5ewgNg40fCARCXYHbNtFUVeCXxqGNScEQ6fFwUkr8FgCjuZaYjcRzy59cZuoI
	 ljmaot+hsfhOVY1B8nA8gSYKyG+9BhL2qkocj6o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1811/2214] ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()
Date: Wed, 18 Nov 2026 15:58:07 +0100
Message-ID: <20261118150123.928813703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b113a891252c3fa4fab11ec8c2894a22ecaf278c ]

snd_power_ref_and_wait() takes the power refcount and doesn't leave it
no matter whether it returns an error or not.  However, the majority
of callers don't expect but just returns without unreferencing in the
caller side upon errors.

For addressing the potential refcount unbalance, rather correct the
behavior of snd_power_ref_wait() to unreference upon returning an
error.

Note that the problem above is likely negligible; the function returns
an error only when the sound card is being shutdown, hence it doesn't
matter about the power refcount any longer at such a state.

Fixes: e94fdbd7b25d ("ALSA: control: Track in-flight control read/write/tlv accesses")
Reported-by: WenTao Liang <vulab@iscas.ac.cn>
Closes: https://lore.kernel.org/20260612022121.14329-1-vulab@iscas.ac.cn
Link: https://patch.msgid.link/20260614090507.772540-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a69138357354 ("ALSA: core: Add missing barriers for power_ref vs card->shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 29d7a9082352d..b3c70ffa295bf 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1138,7 +1138,7 @@ EXPORT_SYMBOL(snd_card_file_remove);
  * typically around calling control ops.
  *
  * The caller needs to pull down the refcount via snd_power_unref() later
- * no matter whether the error is returned from this function or not.
+ * when this function returns 0.
  *
  * Return: Zero if successful, or a negative error code.
  */
@@ -1151,7 +1151,11 @@ int snd_power_ref_and_wait(struct snd_card *card)
 		       card->shutdown ||
 		       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
 		       snd_power_unref(card), snd_power_ref(card));
-	return card->shutdown ? -ENODEV : 0;
+	if (card->shutdown) {
+		snd_power_unref(card);
+		return  -ENODEV;
+	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_power_ref_and_wait);
 
@@ -1168,7 +1172,8 @@ int snd_power_wait(struct snd_card *card)
 	int ret;
 
 	ret = snd_power_ref_and_wait(card);
-	snd_power_unref(card);
+	if (!ret)
+		snd_power_unref(card);
 	return ret;
 }
 EXPORT_SYMBOL(snd_power_wait);
-- 
2.53.0



