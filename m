Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8245C26F288;
	Sat, 30 May 2026 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159628; cv=none; b=V6nyMXPrzDYkODVV7j0uy1I2ZTMCol4K7ASCeKcWL41ZVxBIgQCQrq9GRTL/MLk8X0LZzxAL7efIs3aW8SUp9DIuiDtEWZG1eTqbhwnTc1ugVG36tbwQOYfmkfkEAJQP3rw0a0NVs5FCw4sS7Z/tfVPIaQVpHn3cB+yWzyf4ZYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159628; c=relaxed/simple;
	bh=M3J8IWEmV5mZGV8CyDrZ9FaOcI/gdAdUTz1hXsj2JOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NI8yhbinX9KYUo1v3K9VpKa+M+FtiRtuqpphHateDpmphvWUh803yy5VLtMttJ97mHHjrRTlUxOzvx55I92v8OpBWB56xlrzG5mJyHCdv8cWdIF+dM2Sbu2v+zMQn0G69XcJtpVxaOErxrNCcS0ASK/gN52HSrK9FMhPGWyPa5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzBtceoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzBtceoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEA71F00893;
	Sat, 30 May 2026 16:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159627;
	bh=B8VuMoZs7GQKiKGVJZpQIBdMhFezdHCCB0+ZfrBPdUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzBtceoJe9xMXPMjfzlt0MwDbIl16jF44dpryxIyOyHrBrFMKOAw+aK5VKox97CuN
	 nOm2ixlRah/PuQPFQpkcsQwtl1h/m0wqIMK3y7HSxOAm5I/raVLvgbLchuEWZe7EKT
	 V5vHzvsQN1y8AmlJv9upxxFFh59tLaWsksXtugUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e7919b09c67ffd198ae@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 136/969] ALSA: control: Avoid WARN() for symlink errors
Date: Sat, 30 May 2026 17:54:20 +0200
Message-ID: <20260530160304.322198915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -688,10 +688,16 @@ static void snd_ctl_led_sysfs_add(struct
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


