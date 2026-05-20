Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580BF342CBA;
	Wed, 20 May 2026 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295220; cv=none; b=Zi0t4gZR1uBWtcQEoB7jwcpYnEx43dpgbZ9+qxKubH1yjbPQp02aJ4TUqkemxm9vgg/1Mv8eXUbifrnQ+G1Ew7gyBRIEJ5AQJF6NhuXQ44/62JhC27QpBd3ifLEN/SEMLrAOq90XypYANdyEA7pIxBtt9JduXgAF9z3gVrE9TRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295220; c=relaxed/simple;
	bh=ONq+nB9xALGYRtZM0FT5oXAnyWuOx7h5nw78BTj7kSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CmzlBHmEwZoBN9oo+LllpH7THL8fqo5/2zDXVGq0wYCwvdh/WsD/lY2SWxXgmYDvL//A/wsx1gxb4sg/SnvdbgLcQPtD1wOlnjk/zMy1B+yLw5yOsjYXzgyeEsHaBPNN1gOt+r/XQQsZ+c0MMM93+OeORge48yu3CIQ/QDPpSr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNJufwnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNJufwnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BD91F000E9;
	Wed, 20 May 2026 16:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295219;
	bh=JaLcEumtCO1ALMvGivK2YW8Xmt5foIOIspK+XOVOCQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNJufwnvp6JBhIyTUiWghozPia1ygwGbzzPwCM2FFLddi37vOznnJw6XPN21KXgve
	 Xumn+sLn3V517LEEV5AFbInjUMVsqrUh/b9xgFkkqM1UtURjHBCvaXcM5oLd3yAOJX
	 85hIjXIpnz8WT86NA9P93Z1JrqTjLijHCGmx3r/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0335/1146] ALSA: core: Validate compress device numbers without dynamic minors
Date: Wed, 20 May 2026 18:09:45 +0200
Message-ID: <20260520162155.782792295@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index fdba6e4b25fdc..5a0308eb4e31d 100644
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
index 93436db24710b..8d05fe0d263b2 100644
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



