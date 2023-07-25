Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8EE1ED4D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F358AC433C8;
	Tue, 25 Jul 2023 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285395;
	bh=0Jm4zx8cDj7Rrq7616P1VosLIs8lMzFLzQhk6QmwGuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MiPLF0LQP2Xm04ZS72A8aXin/bSNPU4vQ21y57M+rv9l7LGYLfZMXsVllirljtEKs
	 A/6LgBfkMbDR7CHVfsxabOLr3pUc+mVS9wQPAZTF1kbaRuu9p9fLGg9Oup0YH+/+H0
	 KUdzSVwbRMgQmpSA73VAiH0+xmV1SZmARFlK+OcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/313] ALSA: jack: Fix mutex call in snd_jack_report()
Date: Tue, 25 Jul 2023 12:45:14 +0200
Message-ID: <20230725104527.921712273@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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

[ Upstream commit 89dbb335cb6a627a4067bc42caa09c8bc3326d40 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/jack.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/sound/core/jack.c b/sound/core/jack.c
index e7ac82d468216..c2022b13fddc9 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -364,6 +364,7 @@ void snd_jack_report(struct snd_jack *jack, int status)
 {
 	struct snd_jack_kctl *jack_kctl;
 #ifdef CONFIG_SND_JACK_INPUT_DEV
+	struct input_dev *idev;
 	int i;
 #endif
 
@@ -375,30 +376,28 @@ void snd_jack_report(struct snd_jack *jack, int status)
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
 		int testbit = SND_JACK_BTN_0 >> i;
 
 		if (jack->type & testbit)
-			input_report_key(jack->input_dev, jack->key[i],
+			input_report_key(idev, jack->key[i],
 					 status & testbit);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(jack_switch_types); i++) {
 		int testbit = 1 << i;
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
-- 
2.39.2



