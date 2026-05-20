Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D022046BA;
	Wed, 20 May 2026 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298042; cv=none; b=j5tsmSLaT/a2zUw2mqFdQCqcpmOCu23/7augLdJ1TB+QB3eBTtV0uX0U2/HotSZ5dFXCdfcrOdSaGXIJLwbk3VtPOlF+CiCtUEOyZrJwW7CKRziiTA6RXHQKyUQ3w+NwKqUcsynTyF7OZt9RyTvtBrdfZqOZAc64LpVoyTxMR6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298042; c=relaxed/simple;
	bh=L6t2IXTevAwpLNbelWzXjLUtFXAyZn6BW0jYlmep/tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q+ms9GNwZGOZW+R00i/Y32ZMaPN+jcz9vxCAQLqGW2jlHUaXJwyGSfRWyUEno61Z/5uv2rbnlau0UedTVvWSb3ZFCF/Xk44aGMtXKojqTPdMcbSDX6UF/uoOZiZZPYYEn23aX7vZPW4b3h8oP3Ettn7E7kX1CntrbDnznCl5M84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFK7gAay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFK7gAay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10941F000E9;
	Wed, 20 May 2026 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298041;
	bh=Iw+EzM2wCrA7hdJj1qcRslhrRzj7sx34TiIBAh74VQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFK7gAay0a8wuKVI4cjy25TVyk9jYDZAZ7tWWP+LjLke3x5G1PzCtqN6psM6GjgLy
	 sYfOhRgncbleIOi/2HClsL4Wl5E6xoy5byKN9rmhQ0xx4Lqv+JZcEfHSpqI0Zi+tX8
	 IM4xybrwx01mH1DpdjVAhlNV9pxG8/AB45TaDbQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 258/957] ALSA: core: Validate compress device numbers without dynamic minors
Date: Wed, 20 May 2026 18:12:21 +0200
Message-ID: <20260520162140.139847011@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 796e119e9b14763be905ad0d023c71a14bc2e931 ]

Without CONFIG_SND_DYNAMIC_MINORS, ALSA reserves only two fixed minors
for compress devices on each card: comprD0 and comprD1.

snd_find_free_minor() currently computes the compress minor as
type + dev without validating dev first, so device numbers greater than
1 spill into the HWDEP minor range instead of failing registration.

ASoC passes rtd->id to snd_compress_new(), so this can happen on real
non-dynamic-minor builds.

Add a dedicated fixed-minor check for SNDRV_DEVICE_TYPE_COMPRESS in
snd_find_free_minor() and reject out-of-range device numbers with
-EINVAL before constructing the minor.

Also remove the stale TODO in compress_offload.c that still claims
multiple compress nodes are missing.

Fixes: 3eafc959b32f ("ALSA: core: add support for compressed devices")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260325-alsa-compress-static-minors-v1-1-0628573bee1c@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 7 -------
 sound/core/sound.c            | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index da514fef45bca..2181442e3a1da 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -41,13 +41,6 @@
 #define COMPR_CODEC_CAPS_OVERFLOW
 #endif
 
-/* TODO:
- * - add substream support for multiple devices in case of
- *	SND_DYNAMIC_MINORS is not used
- * - Multiple node representation
- *	driver should be able to register multiple nodes
- */
-
 struct snd_compr_file {
 	unsigned long caps;
 	struct snd_compr_stream stream;
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 6531a67f13b3e..7980b60f4ba0b 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -216,9 +216,16 @@ static int snd_find_free_minor(int type, struct snd_card *card, int dev)
 	case SNDRV_DEVICE_TYPE_RAWMIDI:
 	case SNDRV_DEVICE_TYPE_PCM_PLAYBACK:
 	case SNDRV_DEVICE_TYPE_PCM_CAPTURE:
+		if (snd_BUG_ON(!card))
+			return -EINVAL;
+		minor = SNDRV_MINOR(card->number, type + dev);
+		break;
 	case SNDRV_DEVICE_TYPE_COMPRESS:
 		if (snd_BUG_ON(!card))
 			return -EINVAL;
+		if (dev < 0 ||
+		    dev >= SNDRV_MINOR_HWDEP - SNDRV_MINOR_COMPRESS)
+			return -EINVAL;
 		minor = SNDRV_MINOR(card->number, type + dev);
 		break;
 	default:
-- 
2.53.0



