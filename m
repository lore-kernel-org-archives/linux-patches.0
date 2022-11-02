Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369C9629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4077BC433D6;
	Wed,  2 Nov 2022 03:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359744;
	bh=zBfkaFvI5JWSbghU23CyT0em6cHrhP1RFQ2l0rr1BXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaVTinkhqw5OaZHWDLQPXX9xR3k0JT96Ir2mr2K3z0quUrjAyJSMwcHB7tuKTtk6+
	 dx2RZ9JjclQajnkdCC4Pk8UbKKF325oRaewBRuKzdsn2yDtd96k9OPAAk4kUY1cbKg
	 YM6kiBvakAx8d1U/C3d3LdhefNdQY0KEFPB4vc6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 27/78] ALSA: Use del_timer_sync() before freeing timer
Date: Wed,  2 Nov 2022 03:34:12 +0100
Message-Id: <20221102022053.797366716@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit f0a868788fcbf63cdab51f5adcf73b271ede8164 upstream.

The current code for freeing the emux timer is extremely dangerous:

  CPU0				CPU1
  ----				----
snd_emux_timer_callback()
			    snd_emux_free()
			      spin_lock(&emu->voice_lock)
			      del_timer(&emu->tlist); <-- returns immediately
			      spin_unlock(&emu->voice_lock);
			      [..]
			      kfree(emu);

  spin_lock(&emu->voice_lock);

 [BOOM!]

Instead just use del_timer_sync() which will wait for the timer to finish
before continuing. No need to check if the timer is active or not when
doing so.

This doesn't fix the race of a possible re-arming of the timer, but at
least it won't use the data that has just been freed.

[ Fixed unused variable warning by tiwai ]

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221026231236.6834b551@gandalf.local.home
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/synth/emux/emux.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -138,15 +138,10 @@ EXPORT_SYMBOL(snd_emux_register);
  */
 int snd_emux_free(struct snd_emux *emu)
 {
-	unsigned long flags;
-
 	if (! emu)
 		return -EINVAL;
 
-	spin_lock_irqsave(&emu->voice_lock, flags);
-	if (emu->timer_active)
-		del_timer(&emu->tlist);
-	spin_unlock_irqrestore(&emu->voice_lock, flags);
+	del_timer_sync(&emu->tlist);
 
 	snd_emux_proc_free(emu);
 	snd_emux_delete_virmidi(emu);


