Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225CF168C4;
	Mon, 27 May 2024 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837506; cv=none; b=j/UcUSN6p3AL20axg9qHHEVBW3/bLgL82RkZn8hQQLsGGs64X/G0xs8xVB1Hbgdct+46EVJg4grkKnlcOxKUWQ61FyjX+DJKEOZ9IXEngOK3bUu0MIUsXIKdKF3GlLxscYRw9m+X2hHd4PX+5n5SsoDv0SA+T/I94ZhdmoTsSEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837506; c=relaxed/simple;
	bh=ZwvjSHNpcG4RpIdQnd3gI40mMy978hxgL3tzd/GSDR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0q4kmDLQJ4rms2aHPufH6Mndvb+TebXHVtf9iRQJUNOJ9ncDma1RFgqlIi2/6xGVim99V/eWuSL7W2p+r3fXOSlK9eZxuplaE+f+rC5x5b+8Lbq+B5G5FWPMwoJm9PsUXjr+Xn0VEzfKd/pvPTQeRriLgahe/pjnu2A7jsCJYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbTjRxMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbTjRxMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D99C32781;
	Mon, 27 May 2024 19:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837506;
	bh=ZwvjSHNpcG4RpIdQnd3gI40mMy978hxgL3tzd/GSDR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbTjRxMSeuH0u8eHEwGUqYkf80sOzdbJsQ//CgLicQcy+8dGvLeprNz2fu/aQVjSr
	 JbN2FnNvwIX2/66FAgwODY4nkfdLUAgbJFdrW69LU7eAGUz0lWAkuYh5opYwQ32M15
	 fmuZcgokWaZKQKO+dCpkdNJbQLU0IIPMGvslzipE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 036/493] ALSA: Fix deadlocks with kctl removals at disconnection
Date: Mon, 27 May 2024 20:50:38 +0200
Message-ID: <20240527185629.789625137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 87988a534d8e12f2e6fc01fe63e6c1925dc5307c upstream.

In snd_card_disconnect(), we set card->shutdown flag at the beginning,
call callbacks and do sync for card->power_ref_sleep waiters at the
end.  The callback may delete a kctl element, and this can lead to a
deadlock when the device was in the suspended state.  Namely:

* A process waits for the power up at snd_power_ref_and_wait() in
  snd_ctl_info() or read/write() inside card->controls_rwsem.

* The system gets disconnected meanwhile, and the driver tries to
  delete a kctl via snd_ctl_remove*(); it tries to take
  card->controls_rwsem again, but this is already locked by the
  above.  Since the sleeper isn't woken up, this deadlocks.

An easy fix is to wake up sleepers before processing the driver
disconnect callbacks but right after setting the card->shutdown flag.
Then all sleepers will abort immediately, and the code flows again.

So, basically this patch moves the wait_event() call at the right
timing.  While we're at it, just to be sure, call wait_event_all()
instead of wait_event(), although we don't use exclusive events on
this queue for now.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218816
Cc: <stable@vger.kernel.org>
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20240510101424.6279-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/init.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -523,6 +523,14 @@ void snd_card_disconnect(struct snd_card
 	}
 	spin_unlock(&card->files_lock);	
 
+#ifdef CONFIG_PM
+	/* wake up sleepers here before other callbacks for avoiding potential
+	 * deadlocks with other locks (e.g. in kctls);
+	 * then this notifies the shutdown and sleepers would abort immediately
+	 */
+	wake_up_all(&card->power_sleep);
+#endif
+
 	/* notify all connected devices about disconnection */
 	/* at this point, they cannot respond to any calls except release() */
 
@@ -550,7 +558,6 @@ void snd_card_disconnect(struct snd_card
 	mutex_unlock(&snd_card_mutex);
 
 #ifdef CONFIG_PM
-	wake_up(&card->power_sleep);
 	snd_power_sync_ref(card);
 #endif
 }


