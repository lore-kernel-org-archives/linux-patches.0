Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034741;
	b=mb0hs7FppdND2exXgFvlqMFwRW3eOCaCjkeysAi9lEBdZCTuZmbQJl3U/bco0YxADGkF
	 6qrKvbkxM18Udb25uii60RVyRQwD4bgrmkSiZA/AyCv+SWhecnFawHXhs/Q4HUpwIpB7U
	 aZonLBqFmz7QARnjBLnfE71+gXtpE5Q/I/XhzFna9fxaoEiD/pyKFuKNs03uNU3f856ex
	 m4L3CnZ3avD5eMl2IO2Qgi1d4Tl/cRizqBUwzvXaQg3T94pBKaC6sJTYgPKOkv2g+eFuy
	 mfGwdnG+kku4szt1m8ZLEuBTPEh0Su0iWJPgfXzoSrCNaaCbua5fOnIkleaDexyNS9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mHnucWacw43zCddrUIHVPjrNpKafGM9GHd/u/y80WbM=;
	b=4EAx7sgecmwcjDLN0IlEUNV8VdizGiji13cYEFmUPH8IaVc37dK4f8vmfzlplbD6tOjc
	 hZMS7XK0o1U7ELEpWLDIEfNFShe72h0OPmC2EevPocYFwr+h1Rlwuoq2VriTrwHz/hwcb
	 xGYzE/TFACwOiS2yC8HsBwCr45FOo5DNUpxIN2ohvOZwt9dyhkZ+DN3FgvOmHsmdRZtNi
	 a7vU9mtGm3U1BRPT4iRNkckzACXuOBAbEdN5QHqMwvWaWiZoFVWtMhA2wwcZkuG0vKM6W
	 msuzKhuJmwK7AjgpLBFchETlQLA8wZhv9KcahA9X/K+weNEqz+dCm+sC4zbH+lqRxlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XVQXn/e6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97F6606A31C;
	Wed, 18 Nov 2026 20:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVQXn/e6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ECF1F000C4;
	Wed, 18 Nov 2026 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034741;
	bh=mHnucWacw43zCddrUIHVPjrNpKafGM9GHd/u/y80WbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVQXn/e6FzoGAOuFVXjBHlW8zLf3F2D+qzzfCYhVQ9m/rvYErweIvudJ3C3Fo6kbT
	 I7kDtyNtio7fvPv6xJfPRlq2tgTDqONpiSDXXLQYS6+DzwnMdPlw8Ch9kFcfgZoaDB
	 wBw9SCa2OiSOV01qwmTYjVK3dSnN4OJWYgXpfLro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0475/3318] ALSA: core: Fix potential UAF after asynchronous card release
Date: Wed, 18 Nov 2026 15:18:17 +0100
Message-ID: <20261118150331.171382574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fd95e68df6fe66344161a1329cbe5e5805e7b704 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 9b718f7b381d3..afb02fce36780 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -309,7 +309,7 @@ static int snd_card_init(struct snd_card *card, struct device *parent,
 			kfree(card); /* manually free here, as no destructor called */
 		return err;
 	}
-	card->dev = parent;
+	card->dev = get_device(parent);
 	card->number = idx;
 #ifdef MODULE
 	WARN_ON(!module);
@@ -597,6 +597,7 @@ static int snd_card_do_free(struct snd_card *card)
 		dev_warn(card->dev, "unable to free card info\n");
 		/* Not fatal error */
 	}
+	put_device(card->dev);
 	if (card->release_completion)
 		complete(card->release_completion);
 	if (!managed)
-- 
2.53.0



