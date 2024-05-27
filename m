Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D9F1DFED;
	Mon, 27 May 2024 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836409; cv=none; b=dA9w/2/LaUadnu0lQ3uO/HfSAOwvt4HiAMxHnWbrnl5qgo4lYRnBP0U6eLNBhoTg35UdIg8uJNpGMWv11sufIRH2k/qCFC32BI3RapzrM010Zl4Y3TzctmZRe1YD166QYNdMHLmMR+CNUJUA8XMOy0QQMDnGUkYGQJL4vchXmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836409; c=relaxed/simple;
	bh=N3qkXrXahVFeZjpf2v1n1lNsgoCKoFQ8MSFhvEHuggA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CHN6ai3JU3i7/zlxAjXKv+kj5ELTaSkE42Hy4p5WSRhAcPN8veHdae0Q4Oag9w8Myyto1C4YJzWe91X/pEsRB1vqZw7Uoi5CjPv2xWVZSnc1DLa2lcYU4/mC19LjIqDI8VTAw99xiGh0xicsUloacXLh1kx+nCErPHHsGZ6e2uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glqEKiYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glqEKiYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCAAC2BBFC;
	Mon, 27 May 2024 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836408;
	bh=N3qkXrXahVFeZjpf2v1n1lNsgoCKoFQ8MSFhvEHuggA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glqEKiYk0J5xflMAWCmSPk/tMBFVAX2mqKzC9RtIFXASoHE7lb6IbyBHgqi8MKXQI
	 rapF83hnSPwAe8UtdNWkO+IWhz4LwuZNQeUlcuwDU1Nllcgqcor8UTsit3pbBmnGNG
	 8kN99ywf30TwXsVlYXMCO3bxbLZL/Dc3rbBOpA7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 040/427] ALSA: Fix deadlocks with kctl removals at disconnection
Date: Mon, 27 May 2024 20:51:27 +0200
Message-ID: <20240527185605.422855727@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -516,6 +516,14 @@ void snd_card_disconnect(struct snd_card
 		}
 	}
 
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
 
@@ -543,7 +551,6 @@ void snd_card_disconnect(struct snd_card
 	}
 
 #ifdef CONFIG_PM
-	wake_up(&card->power_sleep);
 	snd_power_sync_ref(card);
 #endif
 }


