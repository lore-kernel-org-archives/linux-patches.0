Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019260;
	b=w+murFmnR9fZefaY3CfgFq7vSXyk3CdB2Wny+Pua359M9kYiarBu/keMuSPEclCN3tYs
	 DwZsLIG9sLspCeyD3g67geMi5eYG++H0B2o7QJyzHMtMC6JyfBD92IBXEzNQ2mhBGk0dg
	 LSZCJYDWR3UEBO+z5rdvfTnpUUn+UXp1CxhIXjCiewJ7ThmjAJvWm/HsaQeYQfvBeYqnr
	 iFYYYsQ61cJt6aq0SoLQvpNTMYnocI0HEp9cNvI57X4Zrw1ZCDRBdhhRX3N1FP4R9DPUR
	 8H90uC5ocUCnIFVzoVP68vMSUuvDKGjZ6aLIPYYLs3FLSqnLX90K5sys+EZN+V5W7gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QSdLv8IoIu5SKkios8824AeVKtgSE6oWrRJX8DrK/U=;
	b=rrrB3CtQa/WdGcAR81f5frRf/HNxh+YD9fk3T2FB2D+C6XbmcoBKCtPZ504GgsbKCgXw
	 +Si+eYamofyJ5uvDVICkPaKANfBEHqwLrSNtzS8OttOJTWjNvcPNdzNLbQrvbSp8Crau8
	 gVtjtqaX44Sqvpb91u1MAOQt3M4df7ppomKaU/vpX+dNiF1P3vfm14VAL8dxfd0+WjjG/
	 0ZOb+WxkPbXCOXAac3OIRRzAKl9YgIm3YYcbDslHC9fj24TNTv2QnBIn823AaLfq2LBks
	 Q4rdSZ0bmYhZgzCj4F+6MSznwXQr8cIVe/clQigfPeao2a9/OGzT2rdFN1eh1kEpG8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5yJeKXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16BC60A2612;
	Wed, 18 Nov 2026 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5yJeKXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FA41F000C4;
	Wed, 18 Nov 2026 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019260;
	bh=5QSdLv8IoIu5SKkios8824AeVKtgSE6oWrRJX8DrK/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5yJeKXh/rb7d/nI7Os54BdBk9ZVZMquZiP+K+C/RM/wLeurD9dv5EIDIl9zuuXqA
	 KtuDdbxvCQCmYRhpGY2Ddml5snEHDgM6QPx9hQHgZlTm4f18tJcd1dvfxstTg9yKwi
	 FJzFl/S0cf4cbiPwTTfjDwwc+K4HMqkVgmXmCjTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1526/2651] ALSA: aloop: Avoid a bad mixure of guard() and goto
Date: Wed, 18 Nov 2026 15:46:06 +0100
Message-ID: <20261118150342.926053621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f7faf5d9b5668919cae84a6247f8f7b4e2c0227c ]

The rewrite of aloop driver code using guard() leaded to a mixture of
guard() and some goto; although it currently works, it isn't really a
good match.

For avoiding the bad match, just move the code using goto into a
function and wrap it with guard().

Fixes: ebd9b6c91d4e ("ALSA: aloop: Use guard() for mutex locks")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-6-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/aloop.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/drivers/aloop.c b/sound/drivers/aloop.c
index 38fe3f4ce5d83..ba690bdd93736 100644
--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -1378,7 +1378,7 @@ static const struct loopback_ops loopback_snd_timer_ops = {
 	.dpcm_info = loopback_snd_timer_dpcm_info,
 };
 
-static int loopback_open(struct snd_pcm_substream *substream)
+static int __loopback_open(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct loopback *loopback = substream->private_data;
@@ -1387,7 +1387,6 @@ static int loopback_open(struct snd_pcm_substream *substream)
 	int err = 0;
 	int dev = get_cable_index(substream);
 
-	guard(mutex)(&loopback->cable_lock);
 	dpcm = kzalloc_obj(*dpcm);
 	if (!dpcm)
 		return -ENOMEM;
@@ -1482,6 +1481,14 @@ static int loopback_open(struct snd_pcm_substream *substream)
 	return err;
 }
 
+static int loopback_open(struct snd_pcm_substream *substream)
+{
+	struct loopback *loopback = substream->private_data;
+
+	guard(mutex)(&loopback->cable_lock);
+	return __loopback_open(substream);
+}
+
 static int loopback_close(struct snd_pcm_substream *substream)
 {
 	struct loopback *loopback = substream->private_data;
-- 
2.53.0



