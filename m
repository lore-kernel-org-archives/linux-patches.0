Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A83140E38;
	Tue, 17 Dec 2024 17:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456171; cv=none; b=lAtv2oC6+Hp36GP9QTMs4FssIkd3uChl4QdYi5/ANWvCEvfSvVGnkS3dnGUscph/WPU6+d6XFS/xOK02iOpjKxlkgaaoG3n4fqcQwjZUXhVV3VPoMoK9ADcQftNFVORI+ulBgL30kPqckgKDbH9xZO84g71X/yTmngJxUKC3nQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456171; c=relaxed/simple;
	bh=+CTDQDRUeBNH5nB2R7meDKXfy0upCoIvT9mjYcSWmJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWGsDJ3JMNFDrYsIA7hCBSGevqaPCDo9MJULVf/vVdgKfh0jAahbrdwO42IPzx61qFsW5mIDb81uCDthSHn7AuOf/aVcJGjMmxF5ryxpRaw0pgeFJlLLbBeaE8DEkU5haWC0I79AAwqXhQxQgDvUEu3o5x7ZbNH/LCbQGLKcPsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iljz1/tc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iljz1/tc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCBBC4CED3;
	Tue, 17 Dec 2024 17:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456171;
	bh=+CTDQDRUeBNH5nB2R7meDKXfy0upCoIvT9mjYcSWmJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iljz1/tcMeQFtXjK7d3tmyorujTwQPl7248hW6IPQH4k/mZ1ieiauXY0XFORheXVq
	 ELKJ8A4modQ9Ekkr3hVkr73BNGZnrIeGpY+o9KoUnJSE1sER6rCPsWSu9opTZ1a6mT
	 7iL5i1bZR52dR22TA+b9rrBKQ4ErCX/+Z8VpiGZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4e7919b09c67ffd198ae@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/109] ALSA: control: Avoid WARN() for symlink errors
Date: Tue, 17 Dec 2024 18:07:49 +0100
Message-ID: <20241217170536.097839931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a78eb48927c7..ba984ed00972 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -688,10 +688,16 @@ static void snd_ctl_led_sysfs_add(struct snd_card *card)
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



