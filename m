Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290713AA19B;
	Wed, 23 Sep 2026 14:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173407; cv=none; b=vFPRirh/huOfqs17G6ZIK2oadEiYaaGhlXyL2+/93i3nH58N/zTfP73D8v74qmOVMzKgdYCk4M0mxfJV3LlbFn5Rcm4IgXNiA+dnF0qqmpbQxwdvPKILzGG8KOmHB2qpr2NDd9XJm0muW+gT04NgxjiymezbL+q/fRtXtGL0m98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173407; c=relaxed/simple;
	bh=VchAHWNb47GJ/bsTDazoA10EgySshnYKAxFaBJft2L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASGfV8APqEB+t0+uzOyeBeqZf4DACG5dVu2UsplOrNzvqsk8oTn0Fed9KkpdLsSY1himSp7ch3N/cRz+FwnFJzhFfk/xnWlwgcqa2LLi6mL2F02SvoXSan5yF/Um0zWWNwY2NBFZ877EizLTIZk/T4cL08CQYPQ1SCqCXDuOONU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyX8ia0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyX8ia0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EC01F00893;
	Wed, 23 Sep 2026 14:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173406;
	bh=I2hhDBpp8dUN3IOfWyW/ktRmZjSw3V2SiT8b4ZdmcpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyX8ia0ww52HgRvJU1nicMjN3VnMgo3qA7WbsFGu23efei2+FcsIYsi8tqOuswObK
	 7f4mULlfmA8UAkJiLgjUmR75mQPYckMnsOCLwC0g5VFOaX8Azq9nDeynZVEAoCp1Jj
	 nWmXOUlpIkPjuqwsPYgeYql/2RXBdH0BFl/L64uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 237/438] ALSA: core: Fix potential UAF after asynchronous card release
Date: Wed, 23 Sep 2026 16:04:18 +0200
Message-ID: <20260923140650.914644684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

commit fd95e68df6fe66344161a1329cbe5e5805e7b704 upstream.

Usually a sound driver releases the resources assigned to the card via
snd_card_free(), and it synchronizes with the whole release procedure.
However, when the card is released asynchronously via
snd_card_free_when_closed() like USB-audio driver, the situation is
slightly different; although the snd_card_disconnect() call at the
disconnection guarantees that any newer accesses will be gated, the
in-flight tasks might be still accessing to the underlying card->dev
device even after the disconnection, which would cause a
use-after-free in the end, as reported by fuzzers.

For addressing the bug above, this patch takes the refcount of
card->dev at initialization of the card object, and releases at its
destructor.   This assures the availability of the card->dev in its
whole lifecycle.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/CA+0ovChexj4TrZL_2iG_P0WBEbZc5+73GfB3DkciQi=R8pZOnA@mail.gmail.com
Closes: https://lore.kernel.org/CA+0ovCgQUQNN=Z1tJTouiCsDaXR5M-3-SQEGk-cpPXQkM5Xh+w@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260912162150.455144-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -310,7 +310,7 @@ static int snd_card_init(struct snd_card
 			kfree(card); /* manually free here, as no destructor called */
 		return err;
 	}
-	card->dev = parent;
+	card->dev = get_device(parent);
 	card->number = idx;
 	WARN_ON(IS_MODULE(CONFIG_SND) && !module);
 	card->module = module;
@@ -601,6 +601,7 @@ static int snd_card_do_free(struct snd_c
 		dev_warn(card->dev, "unable to free card info\n");
 		/* Not fatal error */
 	}
+	put_device(card->dev);
 	if (card->release_completion)
 		complete(card->release_completion);
 	if (!managed)


