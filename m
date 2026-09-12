Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A9B47D922;
	Sat, 12 Sep 2026 13:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219310; cv=none; b=s07ITJ0hLfnIUFKcF3zF7m1YXZqrh+QTdSRLrIOUeyEhNqSj+G+IjOW2B20bx2zCtvq6pXamCCfEha+JFV2bAnnN8nRc6W9qCtCntqHHXMovKwfiIVpKHnkLUPD/0c3nR2Ihey1S6I3n6v3Q5c8MEc4gv1QyOrE6kZVeY1dogt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219310; c=relaxed/simple;
	bh=Zu2idmn89MAv+RUQKSw4/Jy5WsinicJG1hjeetvDIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ond4zefiWNZVNppoSRDjKuih8cEVEV8j7cd0tpOGgOFIps/JZwhv6275Lss70dW3PFakbRvhp63rzi8qprsFk4ewPeLYgsBacWnqlWpaDP3RUEKzGckznjzRisBSv1jpUDJI393nDnX7F3VZhMcbCYQzxA9bb5pODfdn5YUJNFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaN0wMdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaN0wMdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA591F000FF;
	Sat, 12 Sep 2026 13:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219307;
	bh=IYr3ralubLsMCR2baJVimPB6LXpGRpaW04a35VE5Itk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaN0wMdnpQQmq11kz/l/HocehNvmuuABjY5TMOhizPZK8fYnPhA52uy799vm0Zfmz
	 ODcjJPHazwlAKm1sWp8yqB+flDPVHX7UHAspsPip9JH/jaWyA2WbO1c8qlawZZSzZu
	 6IUFEBuXmkWQ5vcr0qG3gCeZbg7ib83cqn0OWnBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b7fe2760ea6f1ee44b4d@syzkaller.appspotmail.com,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1323/1376] ALSA: control: Dont add invalid kcontrols to LED layer
Date: Sat, 12 Sep 2026 09:02:29 +0200
Message-ID: <20260912065637.017431188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 74e3b979ce8b78a690f8b94ccf2e2c965f7f5c11 ]

The kcontrol LED state layer tries to track the all associated
kcontrol elements with naive assumptions that they are readable.
But one can create a write-only element that has no get callback (even
a user element can do it), and this may lead to a NULL dereference at
the call chain of snd_ctl_led_notify(), as found by syzkaller.

For avoiding the Oops, add a sanity check of the kcontrol's info and
get callbacks, and just skip the invalid kcontrols before assigning
the kctl to the LED layer.

Reported-by: syzbot+b7fe2760ea6f1ee44b4d@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/6a9007b3.1d9ded08.62e62.00cd.GAE@google.com
Fixes: 22d8de62f11b ("ALSA: control - add generic LED trigger module as the new control layer")
Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260827113951.893291-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_led.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index 007aba163236c..ae903af93dd32 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -255,6 +255,8 @@ static int snd_ctl_led_set_id(int card_number, struct snd_ctl_elem_id *id,
 	kctl = snd_ctl_find_id(card, id);
 	if (!kctl)
 		return -ENOENT;
+	if (!kctl->info || !kctl->get)
+		return -EINVAL;
 	ioff = snd_ctl_get_ioff(kctl, id);
 	vd = &kctl->vd[ioff];
 	access = vd->access & SNDRV_CTL_ELEM_ACCESS_LED_MASK;
-- 
2.53.0



