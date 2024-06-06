Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DC21A0AF0;
	Thu,  6 Jun 2024 14:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683154; cv=none; b=aA6rvwFqI2Oavsyj4uTKCZCWvOHvoTNi+rxq7om57AVDUPTwDm/Eq1mFe9ZJwkMe0QHW5GFtnXr/JLMitvmvfQELOdwETKgk1NqLVdikssI0rIhxsUSGH11zHeABpVXLvj7LRYJSW/h202A6orjdfT+xoN3VJLT5hHqTTC68HU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683154; c=relaxed/simple;
	bh=TbovFz0jm3j07+Yf6uUzF3tnONKmoxMAEOd5jjAfwcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZXHXiVoRiqpnQ7v4vFQVLLZmw8sPXIjnG6JlrmlATYJZhgkV4vwFP/RjG2t+wbiY5gdYsQN78qGAaW28gyhr2iRAik1Xy33NjBorzIKciX2be0QlMck+rgBSwwv6+iHDngteraIlro5FhO5TivKard5MnOYLVMxkl0tss2ByYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQX2n1Vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQX2n1Vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F85C2BD10;
	Thu,  6 Jun 2024 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683154;
	bh=TbovFz0jm3j07+Yf6uUzF3tnONKmoxMAEOd5jjAfwcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQX2n1VfaKF2cfRkvCdFz3gIYxmUnTixR/lC9r3/hE9oSiXvVpXpphQtqsfvoSk3y
	 WwkmcMPLFmJbIi5y0AJrfoaXjRQxm4b6nC+QxdT0qkvnhJ59ChtS+gmjU6MbS5UUn9
	 sxWc44AEvPYY5ahjB0UYPx30/OiLWCsAT9Mn+Uok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 025/473] ALSA: Fix deadlocks with kctl removals at disconnection
Date: Thu,  6 Jun 2024 15:59:14 +0200
Message-ID: <20240606131700.698086450@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
@@ -518,6 +518,14 @@ int snd_card_disconnect(struct snd_card
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
 
@@ -545,7 +553,6 @@ int snd_card_disconnect(struct snd_card
 	mutex_unlock(&snd_card_mutex);
 
 #ifdef CONFIG_PM
-	wake_up(&card->power_sleep);
 	snd_power_sync_ref(card);
 #endif
 	return 0;	


