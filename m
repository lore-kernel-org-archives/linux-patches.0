Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736C9DF4F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE064C4339B;
	Mon, 12 Jun 2023 10:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566600;
	bh=Nnmq1FdupaK3oCUEruE6Z/tC53tzjwhYvvXkCVc0Br4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+gF/trEtcxlO8URcqwQZbJrv2ahrQV5NQ3yb+snjhyxuY6fSIIjz81CIpRPl5EbT
	 s0gpBv+1DRg560YHi5AoCyCzHW3b7Ms7ByfuzaajwJXHFF4SInrFm4wpSVqN63aHjQ
	 kXvaMftJAe100juPRsZtf1v5gktC7+qebn2Y1lII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 064/132] ALSA: gus: Fix kctl->id initialization
Date: Mon, 12 Jun 2023 12:26:38 +0200
Message-ID: <20230612101713.181897469@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit c5ae57b1bb99bd6f50b90428fabde397c2aeba0f upstream.

GUS driver replaces the kctl->id.index after assigning the kctl via
snd_ctl_add().  This doesn't work any longer with the new Xarray
lookup change.  It has to be set before snd_ctl_add() call instead.

Fixes: c27e1efb61c5 ("ALSA: control: Use xarray for faster lookups")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20230606093855.14685-4-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/gus/gus_pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/isa/gus/gus_pcm.c
+++ b/sound/isa/gus/gus_pcm.c
@@ -892,10 +892,10 @@ int snd_gf1_pcm_new(struct snd_gus_card
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control1, gus);
 	else
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control, gus);
+	kctl->id.index = control_index;
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)
 		return err;
-	kctl->id.index = control_index;
 
 	return 0;
 }


