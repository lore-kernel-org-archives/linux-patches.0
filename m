Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920308F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14637C433C8;
	Sun, 16 Jul 2023 20:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540546;
	bh=ivr2jvwgr3pYbhSlBA0UEb770Q7FFEKnE4JLEJI0p/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gX9iOh2rwg+J4YSM3sVIU++1hked2rkTjssNli4pJEwmvFWQy12KeuEcbgpA2IDZZ
	 UwUt4n1y+w+/yYLNBmEJOpbmKrL+v85tKIfO4ce6nhuxdd1e/7EmjCLiG+S++5N1hC
	 I0k5tloC1j+Ro8gAMWoMMnWsElYodEsXoUencZLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 374/591] ALSA: jack: Fix mutex call in snd_jack_report()
Date: Sun, 16 Jul 2023 21:48:33 +0200
Message-ID: <20230716194933.595504849@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

commit 89dbb335cb6a627a4067bc42caa09c8bc3326d40 upstream.

snd_jack_report() is supposed to be callable from an IRQ context, too,
and it's indeed used in that way from virtsnd driver.  The fix for
input_dev race in commit 1b6a6fc5280e ("ALSA: jack: Access input_dev
under mutex"), however, introduced a mutex lock in snd_jack_report(),
and this resulted in a potential sleep-in-atomic.

For addressing that problem, this patch changes the relevant code to
use the object get/put and removes the mutex usage.  That is,
snd_jack_report(), it takes input_get_device() and leaves with
input_put_device() for assuring the input_dev being assigned.

Although the whole mutex could be reduced, we keep it because it can
be still a protection for potential races between creation and
deletion.

Fixes: 1b6a6fc5280e ("ALSA: jack: Access input_dev under mutex")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/cf95f7fe-a748-4990-8378-000491b40329@moroto.mountain
Tested-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230706155357.3470-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/jack.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -654,6 +654,7 @@ void snd_jack_report(struct snd_jack *ja
 	struct snd_jack_kctl *jack_kctl;
 	unsigned int mask_bits = 0;
 #ifdef CONFIG_SND_JACK_INPUT_DEV
+	struct input_dev *idev;
 	int i;
 #endif
 
@@ -670,17 +671,15 @@ void snd_jack_report(struct snd_jack *ja
 					     status & jack_kctl->mask_bits);
 
 #ifdef CONFIG_SND_JACK_INPUT_DEV
-	mutex_lock(&jack->input_dev_lock);
-	if (!jack->input_dev) {
-		mutex_unlock(&jack->input_dev_lock);
+	idev = input_get_device(jack->input_dev);
+	if (!idev)
 		return;
-	}
 
 	for (i = 0; i < ARRAY_SIZE(jack->key); i++) {
 		int testbit = ((SND_JACK_BTN_0 >> i) & ~mask_bits);
 
 		if (jack->type & testbit)
-			input_report_key(jack->input_dev, jack->key[i],
+			input_report_key(idev, jack->key[i],
 					 status & testbit);
 	}
 
@@ -688,13 +687,13 @@ void snd_jack_report(struct snd_jack *ja
 		int testbit = ((1 << i) & ~mask_bits);
 
 		if (jack->type & testbit)
-			input_report_switch(jack->input_dev,
+			input_report_switch(idev,
 					    jack_switch_types[i],
 					    status & testbit);
 	}
 
-	input_sync(jack->input_dev);
-	mutex_unlock(&jack->input_dev_lock);
+	input_sync(idev);
+	input_put_device(idev);
 #endif /* CONFIG_SND_JACK_INPUT_DEV */
 }
 EXPORT_SYMBOL(snd_jack_report);


