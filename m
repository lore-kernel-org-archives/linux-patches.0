Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415251F8AD4;
	Tue, 17 Dec 2024 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456716; cv=none; b=mkMDmeamag9UOEoghDbm4FKJcIdOBvYTDIBKHumiA6NzbmBw2V7kvwZpJ3FjouZYIHO0i9s3dFMAuzfF/EAprDuELEs4ug68QYg4Vd/RitvDdpLKRPrV9yIkRNMIXCdX9xwwWV6oc/SsZ42W2djpDQwFE9WvEBs47q5HduolgOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456716; c=relaxed/simple;
	bh=CpqqMMH3x5iQxUnu5pQQHqkfFjEqG00xqUgPGBIHH+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfF0K3MPWF6Obfwk7M/AXsk+Pj8agPfsF+awkAOpEH0nofkLtZdfx9b/3uSnBbzEEYdML/pJEobmL1GShhQYigtcBsEE7UrOrIcCMfVJVscB4kqWhx3dJjqJwYY+93B/tWQHpVcDgoc0+34HKR9XtOVlAMIrTajbf72nVhKj5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQ3b0QeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQ3b0QeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D70C4CED7;
	Tue, 17 Dec 2024 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456716;
	bh=CpqqMMH3x5iQxUnu5pQQHqkfFjEqG00xqUgPGBIHH+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQ3b0QeGTWpnYDj6wnUoyEZBApJ2FjprLDNlQpubmj9HUgvK1EHULQaNhw+KnPI/+
	 YsSvfM2576RYZMoiubObtYY2ODcwyHWGdEJiOTVDTc5vEWo0P1juH5fq7QAR2lUWgw
	 YfBLR5qY3WKNkAICPv/QxGYvfoT2hcqHlRgQDhnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e7919b09c67ffd198ae@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/172] ALSA: control: Avoid WARN() for symlink errors
Date: Tue, 17 Dec 2024 18:07:52 +0100
Message-ID: <20241217170551.141353555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b2e538a9827dd04ab5273bf4be8eb2edb84357b0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_led.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index 65a1ebe87776..e33dfcf863cf 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -668,10 +668,16 @@ static void snd_ctl_led_sysfs_add(struct snd_card *card)
 			goto cerr;
 		led->cards[card->number] = led_card;
 		snprintf(link_name, sizeof(link_name), "led-%s", led->name);
-		WARN(sysfs_create_link(&card->ctl_dev->kobj, &led_card->dev.kobj, link_name),
-			"can't create symlink to controlC%i device\n", card->number);
-		WARN(sysfs_create_link(&led_card->dev.kobj, &card->card_dev.kobj, "card"),
-			"can't create symlink to card%i\n", card->number);
+		if (sysfs_create_link(&card->ctl_dev->kobj, &led_card->dev.kobj,
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
-- 
2.39.5



