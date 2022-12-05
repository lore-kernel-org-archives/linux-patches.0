Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4140C15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB992C433D6;
	Mon,  5 Dec 2022 19:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268944;
	bh=zQRGm13V8YYZl7qcM1GYzlR/IIB9RxM5A8n9PAU8z38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inl+p9LoqLS2Ja1ga4z31MfajEE8L8a6f7d/MCios04tbr1Ce4Dr0deIhKqNcKT7s
	 6LWc3xUuYPKRXsLQsqI4OCzfs4mRi9OaA4CsQ45N7cO+s/Tzhrou7wOcv3GdVDcxxW
	 jKe6tAa0WhozhA0eG+piZvCboNlpfbRHCaQ1X8j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 068/120] ALSA: dice: fix regression for Lexicon I-ONIX FW810S
Date: Mon,  5 Dec 2022 20:10:08 +0100
Message-Id: <20221205190808.672087547@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 9b84f0f74d0d716e3fd18dc428ac111266ef5844 upstream.

For Lexicon I-ONIX FW810S, the call of ioctl(2) with
SNDRV_PCM_IOCTL_HW_PARAMS can returns -ETIMEDOUT. This is a regression due
to the commit 41319eb56e19 ("ALSA: dice: wait just for
NOTIFY_CLOCK_ACCEPTED after GLOBAL_CLOCK_SELECT operation"). The device
does not emit NOTIFY_CLOCK_ACCEPTED notification when accepting
GLOBAL_CLOCK_SELECT operation with the same parameters as current ones.

This commit fixes the regression. When receiving no notification, return
-ETIMEDOUT as long as operating for any change.

Fixes: 41319eb56e19 ("ALSA: dice: wait just for NOTIFY_CLOCK_ACCEPTED after GLOBAL_CLOCK_SELECT operation")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20221130130604.29774-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/dice/dice-stream.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/firewire/dice/dice-stream.c b/sound/firewire/dice/dice-stream.c
index f99e00083141..4c677c8546c7 100644
--- a/sound/firewire/dice/dice-stream.c
+++ b/sound/firewire/dice/dice-stream.c
@@ -59,7 +59,7 @@ int snd_dice_stream_get_rate_mode(struct snd_dice *dice, unsigned int rate,
 
 static int select_clock(struct snd_dice *dice, unsigned int rate)
 {
-	__be32 reg;
+	__be32 reg, new;
 	u32 data;
 	int i;
 	int err;
@@ -83,15 +83,17 @@ static int select_clock(struct snd_dice *dice, unsigned int rate)
 	if (completion_done(&dice->clock_accepted))
 		reinit_completion(&dice->clock_accepted);
 
-	reg = cpu_to_be32(data);
+	new = cpu_to_be32(data);
 	err = snd_dice_transaction_write_global(dice, GLOBAL_CLOCK_SELECT,
-						&reg, sizeof(reg));
+						&new, sizeof(new));
 	if (err < 0)
 		return err;
 
 	if (wait_for_completion_timeout(&dice->clock_accepted,
-			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0)
-		return -ETIMEDOUT;
+			msecs_to_jiffies(NOTIFICATION_TIMEOUT_MS)) == 0) {
+		if (reg != new)
+			return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.38.1



