Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23FF52F62;
	Wed,  7 Aug 2024 15:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043713; cv=none; b=Pfp7iC54N77gJ/VD/5T1Nqx7OeYyBx+ALeTCwi3nbhi/dDtLAEpaDVEsPDW1tOdc2d7Xwa9AeIAlN7NBcIsanwoc8DrpwwuZ8bVXL8j/q1ZZA0nh08dg00jRQysNYVqP1aoY730bp3CnJOrdZbiwuRtmRikJjN30fWuQccYTiUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043713; c=relaxed/simple;
	bh=Wr0Rh+AycZhSOmzMhoy6+OctnJCRYzaLOexGPPDgP34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPMB5sxdwX2KXiBscLR3VLTjd1Tzg5meTcrpzhHdA4T8jXUVhboAp9Ew/Y0zZ7Vvy2lsWs1+fw9dfa5WHzcS+ajjp1oh2yGCSNOjueN7UlZV4QZsEnNCBaPQNXfwQbLE6z1lP2diyDTzT5pB/n614GZcOJkD4oR10Wp8iX9s62U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGBrxGPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGBrxGPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59961C32781;
	Wed,  7 Aug 2024 15:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043713;
	bh=Wr0Rh+AycZhSOmzMhoy6+OctnJCRYzaLOexGPPDgP34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGBrxGPA+c8j0bsA16vGFBoSvbgO6L4VUfWPriSJp/K5sYsKugCAaPZrMMrqSBaxO
	 XUSuwEWM7DmpL+54enEoyQPaeuGFWykrJ2ZstrwKNAbBp7VBvpnEsYqtNtwIDqkbVt
	 CgRD/UjTUl+ywFSQjjnGAbp+NJ3dExiU+qQIl64Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sylvain BERTRAND <sylvain.bertrand@legeek.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 72/86] ALSA: usb-audio: Correct surround channels in UAC1 channel map
Date: Wed,  7 Aug 2024 17:00:51 +0200
Message-ID: <20240807150041.649209214@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Takashi Iwai <tiwai@suse.de>

commit b7b7e1ab7619deb3b299b5e5c619c3e6f183a12d upstream.

USB-audio driver puts SNDRV_CHMAP_SL and _SR as left and right
surround channels for UAC1 channel map, respectively.  But they should
have been SNDRV_CHMAP_RL and _RR; the current value *_SL and _SR are
rather "side" channels, not "surround".  I guess I took those
mistakenly when I read the spec mentioning "surround left".

This patch corrects those entries to be the right channels.

Suggested-by: Sylvain BERTRAND <sylvain.bertrand@legeek.net>
Closes: https://lore.kernel.orgZ/qIyJD8lhd8hFhlC@freedom
Fixes: 04324ccc75f9 ("ALSA: usb-audio: add channel map support")
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240731142018.24750-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/stream.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -244,8 +244,8 @@ static struct snd_pcm_chmap_elem *conver
 		SNDRV_CHMAP_FR,		/* right front */
 		SNDRV_CHMAP_FC,		/* center front */
 		SNDRV_CHMAP_LFE,	/* LFE */
-		SNDRV_CHMAP_SL,		/* left surround */
-		SNDRV_CHMAP_SR,		/* right surround */
+		SNDRV_CHMAP_RL,		/* left surround */
+		SNDRV_CHMAP_RR,		/* right surround */
 		SNDRV_CHMAP_FLC,	/* left of center */
 		SNDRV_CHMAP_FRC,	/* right of center */
 		SNDRV_CHMAP_RC,		/* surround */


