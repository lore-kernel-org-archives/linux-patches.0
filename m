Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26493F23C5;
	Wed, 20 May 2026 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300436; cv=none; b=D4SKNG/rolVBiOY0s9yOJulPqD6Czoa/9ZpARAzrSX5k1AIFHSwnomVXMjJJazvS3rct8aDfHsPfamVPrBAF3k0vhPdMruhybJAeLqu4a+WITLXEujY/JHBQ6AlUjUIIDHFWh2BcjyHVFMv/UTqm+UgUZ5jf+qFvGIYNWsVP7W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300436; c=relaxed/simple;
	bh=axIWt2sX+mmFY7frHW+WXiwsKyFxA8zZfk55utMOsvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dmeNO2glyR/jf7aQs0YgpLKf6e5t/TXEy4g7i5GdmDoBHq+LOUaPAGpaZa0oHjxkP0Kgx/LmcP6nhp37rUqa7hLyGFTVzC4m4J8ms+wvRY9IPtkq2hueLEvFWCkTxLY1xxo1hJqc6oVrLQt+AjHcMNIaFdQtxK0jh/jJih2VPho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCl6Q2RX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCl6Q2RX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241AC1F000E9;
	Wed, 20 May 2026 18:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300435;
	bh=/e51j/eX5Rj9KLnzNhBkMiMGeyaMc2I5GCuk3EqDVbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zCl6Q2RXLG59dNbonWKNTWJoVpLp0mBIH6xNkXFvDQ0d4thchUq2NSyneXQtV4Vrf
	 vpXdCQnvoqq/O+GGjR6mbjZvg1EtPO0MqYsyHfOVDQSjCyxhj3x/3SqG7V/X0AEloI
	 DJXZDzJKl1ADKdrh7cQOwyIIlgXGX3GxcrAH4LQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/666] ALSA: core: Validate compress device numbers without dynamic minors
Date: Wed, 20 May 2026 18:16:26 +0200
Message-ID: <20260520162114.996125911@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bdf1d78de8338..d81a890b60c65 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -40,13 +40,6 @@
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



