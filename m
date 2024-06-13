Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD50844C6F;
	Thu, 13 Jun 2024 12:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281769; cv=none; b=nTHiLEE7g8tkbFH+X9lN4AE1Y2AZxMINcsY085g1HBlsAj+Ri3wxcnOYSG78vgLooTzCSRi8GiRCflLLdV7dQCMbCUQ+uNodN8iAiyPP6oQ5EbCLkWXKHerOF1d/O7lYJeEXMrP1uIeyNoFxHK71OQj6SwcnGsQ8acdi/1hEiy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281769; c=relaxed/simple;
	bh=1DTbZrs1SxOpLe/gE2VgZTEYBL1v27Qd7RZmSVg+fAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr/MSROHr8eBWEIPRvi69aNrtNY50qK7dVRcPoEjRmMSUYvtIBDyhOM3YvwamgMrRi1xyDGdNa3sa1MAiZcmfy54TyN8NgqLqf81wnIS920Juj33pWFZL4C2+HT/AHkcg2ME0qzeZhtKfPimMOPU0zAhfK6vcyfMLX5qX63PHHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHXo1Zr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHXo1Zr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6392DC2BBFC;
	Thu, 13 Jun 2024 12:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281768;
	bh=1DTbZrs1SxOpLe/gE2VgZTEYBL1v27Qd7RZmSVg+fAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHXo1Zr1jMIU8CmcZnKIk3F7WM5BGaI+tOYjWP//RyUg+OwAJy0Iv+EL+9QAscMtX
	 NwBXemseyo+x5lYpZJ+vSL9LldjaWLRmcbd9dnZTTxMApFTJx1oaPLIQ+PrxkllG2O
	 Hb3eTl0ZlZPszy8jNTse/La4iIkoJLNQ0E+J1O7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 018/402] ALSA: Fix deadlocks with kctl removals at disconnection
Date: Thu, 13 Jun 2024 13:29:35 +0200
Message-ID: <20240613113302.849802280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -508,6 +508,14 @@ int snd_card_disconnect(struct snd_card
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
 
@@ -535,7 +543,6 @@ int snd_card_disconnect(struct snd_card
 	mutex_unlock(&snd_card_mutex);
 
 #ifdef CONFIG_PM
-	wake_up(&card->power_sleep);
 	snd_power_sync_ref(card);
 #endif
 	return 0;	


