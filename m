Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863FC3803DC;
	Sat, 17 Oct 2026 17:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257552; cv=none; b=S8JAA9B2Bae0OKq2qKMAX9z03sc491Mp0LFI0diOkwWhILrsSugSSrPbh9MonEiedd7Yi/mIduaB/u0zBn+P4j9+2iL+zWvaHu0A2y9nBPI/dmO36JV6GvM5vEJoqnwg93qFeL0BTad84sYxOAKCI6nfcsP5EaSbZrMCPX7JN+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257552; c=relaxed/simple;
	bh=yNrCU7PtKyWtjkxkoTECJ+/f/FgMbWatf+uQrP58mcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAcezkswLQM/AIpFah+xuq+1zldTKVAGjvfxE7qZrJxTLY25Mg8Ccm1RL4uaI9+RiOs7l5mWD/KtwJF0dFFyCqevzzICb+E+wGNlCEhjOEGDedET+uQnkgUXFVo4WlgZuQY0SVll+pPyQgprlK9Hlpi6ttKvP1EU8BhQFdRI97Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHOpubks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHOpubks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB161F000C4;
	Sat, 17 Oct 2026 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257550;
	bh=g5392D8Zy9sfYUVgcQBHnSqb9GzTk/BRCcAYOYeUPWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHOpubks2JVoMU5Ch0wYJlFI4D1ejsNKi2Qu+zeDfsH9cyCt89aV9OLyVR0gOsx/r
	 ZpU5U9s/ZTrQx0oGWWuBxHFGKnCVFzpHgw/OXTnj95PC2FiF6i7i6aIJerY5HlBDse
	 /5aiVyuvYuXUZk61DCuWQLXBFgcnXW/AZ+pXr/gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b7fe2760ea6f1ee44b4d@syzkaller.appspotmail.com,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0595/1674] ALSA: control: Dont add invalid kcontrols to LED layer
Date: Sat, 17 Oct 2026 17:47:47 +0200
Message-ID: <20261017160446.354116823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Assisted-by: LLM
[ Backport to 6.6.y: After the target's locked control lookup, reject
  missing info/get callbacks via the existing unlock label so
  controls_rwsem and the card reference are released. ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control_led.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/control_led.c b/sound/core/control_led.c
index 15acb07c65150..639d86e4dd162 100644
--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -253,6 +253,10 @@ static int snd_ctl_led_set_id(int card_number, struct snd_ctl_elem_id *id,
 		down_write(&card->controls_rwsem);
 		kctl = snd_ctl_find_id_locked(card, id);
 		if (kctl) {
+			if (!kctl->info || !kctl->get) {
+				err = -EINVAL;
+				goto unlock;
+			}
 			ioff = snd_ctl_get_ioff(kctl, id);
 			vd = &kctl->vd[ioff];
 			access = vd->access & SNDRV_CTL_ELEM_ACCESS_LED_MASK;
-- 
2.53.0



