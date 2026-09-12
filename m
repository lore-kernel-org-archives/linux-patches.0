Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869FA41B8C6;
	Sat, 12 Sep 2026 09:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205452; cv=none; b=tUXtbIfDKrsR1+JDN7Tb8k3Sd0E2sGCvoL81BR7+kOH0GYJBB2CENS4+QuVxBPImpjuibEGA/u4hu/RpI8ey3AsufPn/unTbb5D35Xp83gP0TZrFE44aDX3GVjqK0tIaLhEd3Rt2HM/tpBh50axJl4jMds0ZtrZNBA7XUgn3tXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205452; c=relaxed/simple;
	bh=TOVTc1zUt38SV1any0c7qbfLGWTvC43kGwz9V4CDZAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXL9Bx6sGExIqhjLtq/Yyom+ZkGtSCTycQqFJp70vXRRYCENXkNFLR5akpecN0WuCcb5FIzDjjuSrNUz7vO++ibfeGRXvRvdgnb1VvuNoPA/UacWzzl7FbgK+Imhua+bkpn/65GWyzMcnFCxugIYDwxkNW9qvycPZy5TGmrlsJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPvf6s32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPvf6s32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55881F000FF;
	Sat, 12 Sep 2026 09:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205449;
	bh=T8GqScxKRfv0INsbTQyxQbbILc9iVbf2bUJooP8J9NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPvf6s32wHgRbG/S4qUvf1b2NN7CqgBJLQlJfZmIa6IZQyzpCWDu86PJfJb5ploDF
	 uigE7+mkEbNjniyL34z8ZSW6G6l5VWvGq3k+58IWReTaL0CkDpdpIIiRZeGBri2Cag
	 dqq6jjJba8cRljRd8DBps2t5+I6YG/40LVWjGhWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b7fe2760ea6f1ee44b4d@syzkaller.appspotmail.com,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1789/1815] ALSA: control: Dont add invalid kcontrols to LED layer
Date: Sat, 12 Sep 2026 08:58:59 +0200
Message-ID: <20260912065731.033471045@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8cbacee57ce70..3d13bbec1c544 100644
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



