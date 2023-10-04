Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BF71EA96
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AafG9d2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1D4C433C8;
	Wed,  4 Oct 2023 18:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444456;
	bh=IYwEGCDKxpKaSIthJtW1dM033FHB95zAKc4aXM1PeDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AafG9d2I2/gqTNEq3wY0Wu/0Cj1iWtmiL5NS4f1awUceBn8LHWz8JEalPCoyPtO9B
	 NhSILyAdtoL3tG1FmzNsEBjlfEeR0BAbXdvx/C/CmlpVkOaQKsjg1oBY2Yi13BWX/a
	 cc+yvgejZQUMXz14UqBTVMWpNScRJIOL1r3pmlaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Hills <mark@xwax.org>
Subject: [PATCH 6.5 257/321] ALSA: rawmidi: Fix NULL dereference at proc read
Date: Wed,  4 Oct 2023 19:56:42 +0200
Message-ID: <20231004175241.170886237@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b2ce0027d7b2905495021c5208f92043eb493146 upstream.

At the implementation of the optional proc fs in rawmidi, I forgot
that rmidi->ops itself is optional and can be NULL.
Add the proper NULL check for avoiding the Oops.

Fixes: fa030f666d24 ("ALSA: ump: Additional proc output")
Reported-and-tested-by: Mark Hills <mark@xwax.org>
Closes: https://lore.kernel.org/r/ef9118c3-a2eb-d0ff-1efa-cc5fb6416bde@xwax.org
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230916060725.11726-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/rawmidi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index ba06484ac4aa..1431cb997808 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -1770,7 +1770,7 @@ static void snd_rawmidi_proc_info_read(struct snd_info_entry *entry,
 	if (IS_ENABLED(CONFIG_SND_UMP))
 		snd_iprintf(buffer, "Type: %s\n",
 			    rawmidi_is_ump(rmidi) ? "UMP" : "Legacy");
-	if (rmidi->ops->proc_read)
+	if (rmidi->ops && rmidi->ops->proc_read)
 		rmidi->ops->proc_read(entry, buffer);
 	mutex_lock(&rmidi->open_mutex);
 	if (rmidi->info_flags & SNDRV_RAWMIDI_INFO_OUTPUT) {
-- 
2.42.0



