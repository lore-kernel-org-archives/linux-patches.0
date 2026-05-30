Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185F4267B05;
	Sat, 30 May 2026 17:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162976; cv=none; b=qBdJWnxk/n/LPpN35/Bq0ByCJL0/Wa1bZM2IcW+YDGhnALKDYJpEQOvcuu2/igxQwsGMue4KQkt6RvQS6roXF9jtlGc2LFj/z1kCRKXUINzY67+c5db+5DcPwMxEOylrqmgKuFR3PKeoHQNIPyQ47MAKM1RpOXSm71IsRgIO+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162976; c=relaxed/simple;
	bh=/IsN+Lya1VgmvakCH77gQTlk2lNwvUw8gHd1/etr7H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ59S22/Z2WEe3WoS0Blnzl4EbA/bqQjB+uGasIlPZEE/VrEFfiac2SObs2K0MEV0Adio9nHZ9qB+O0eY3zEoV0illwsD6u8y4tlz0GQ+x5fEGh69k6lUOsIn+MQhjiJHAxfDyVfpIe2ndQK1DCxTFWeQWJSQJsNlISGuD2QWCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktTw9s4M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktTw9s4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354231F00893;
	Sat, 30 May 2026 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162974;
	bh=tREsLL1/RPNF9miUVnY/Wyl4pLVOp3TLEZcF+NQFfA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktTw9s4MsjgO3+j4Nzo8IAlCsIKqrCtWQXtqnaAxARpZmzNAfUVGDqV1d8/yR+Lsb
	 UYZvyFfbflBgeM8MhZh33CcMtAD2X/yoBwar349ValJ/3yDhU5QkBh4OHg4ZdosHjC
	 zNtpBIfVaUY3B3vws7g1yTlMlwimMQl4Za1zNIzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e7919b09c67ffd198ae@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 120/776] ALSA: control: Avoid WARN() for symlink errors
Date: Sat, 30 May 2026 17:57:14 +0200
Message-ID: <20260530160243.475302395@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
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

commit b2e538a9827dd04ab5273bf4be8eb2edb84357b0 upstream.

Using WARN() for showing the error of symlink creations don't give
more information than telling that something goes wrong, since the
usual code path is a lregister callback from each control element
creation.  More badly, the use of WARN() rather confuses fuzzer as if
it were serious issues.

This patch downgrades the warning messages to use the normal dev_err()
instead of WARN().  For making it clearer, add the function name to
the prefix, too.

Fixes: a135dfb5de15 ("ALSA: led control - add sysfs kcontrol LED marking layer")
Reported-by: syzbot+4e7919b09c67ffd198ae@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/675664c7.050a0220.a30f1.018c.GAE@google.com
Link: https://patch.msgid.link/20241209095614.4273-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ Use card->ctl_dev.kobj to keep struct consistent. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control_led.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -693,10 +693,16 @@ static void snd_ctl_led_sysfs_add(struct
 			goto cerr;
 		led->cards[card->number] = led_card;
 		snprintf(link_name, sizeof(link_name), "led-%s", led->name);
-		WARN(sysfs_create_link(&card->ctl_dev.kobj, &led_card->dev.kobj, link_name),
-			"can't create symlink to controlC%i device\n", card->number);
-		WARN(sysfs_create_link(&led_card->dev.kobj, &card->card_dev.kobj, "card"),
-			"can't create symlink to card%i\n", card->number);
+		if (sysfs_create_link(&card->ctl_dev.kobj, &led_card->dev.kobj,
+				      link_name))
+			dev_err(card->dev,
+				"%s: can't create symlink to controlC%i device\n",
+				 __func__, card->number);
+		if (sysfs_create_link(&led_card->dev.kobj, &card->card_dev.kobj,
+				      "card"))
+			dev_err(card->dev,
+				"%s: can't create symlink to card%i\n",
+				__func__, card->number);
 
 		continue;
 cerr:


