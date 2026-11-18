Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044044;
	b=1hqimWtWDvd4rD04UiDwzAU/Y6pfpgboSj5+mRdCH4ib4CcA0PZQB/mbRjN1lSNhZWOo
	 fav9IEdSctDnRSENIj16WuY2pHSxFA252tckktZs/7UyhQiVmoiE27pJDtRE1+GLF2QoZ
	 wUhgNY4+nTO75nv+uMiyxcGfbJa/dA+HMAkmBUa0ZNzVAUhVzPFYZCvyaZGqfBlHy4HU9
	 GFuCmwjX8iG1Olf2c39Dd1ETnygpbKhMa0CJUWb/Ro1fEqUnLMi6mOXiQbNrwj0XCfsgr
	 5PjnLPtIROESq434oam/GRnmx6aYwg+RzpqF2iFC9xh8i+WW4yNoRzwLNJe9OLGKlbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21o9egbKhhib1sEKJ6H5CXtW5AqB6sOotqy5yAMxppg=;
	b=s6LPqv73bhNRbNTYpvaYyS9xUseLPUkUBKl8xrmlNJXZ2z0lTBKgGuRgizUMvCbamqke
	 dBWHu4fNi1mvV6DFxNXjzypHQNIhQcriZzIXkfxc3p4j68PXhtLi4VYAlrrpMZS5nlYNx
	 WkmZzx8R5Mjyqwu2IUTsh+9niXgUu/gYhJH639ij+7Cmw0rvSin7tN7pcQEbcVOne9ybT
	 CYCI5+0bKF6XBzS+8RZtkE3zoZsQzfHTkY9P6dd9VYw3+6l97eMnTJpZBztJJ3XhLAgU0
	 NQj/Ht2S7NvLXiSaI4wMaGFJ4MpdGxIMXayl5ymGx23wan3DzeC2m0/aRwQjzE1TzJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoHrlymU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB5E606A334;
	Wed, 18 Nov 2026 23:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoHrlymU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125641F000C4;
	Wed, 18 Nov 2026 23:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044044;
	bh=21o9egbKhhib1sEKJ6H5CXtW5AqB6sOotqy5yAMxppg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoHrlymU7eQQ1nTW11cbxXZTvvh18WYzgJLkqkUqdzqfkmLRR+nqaYpVU7VIXBXRv
	 rwLCYMlHRTTH/8j1vzsk4DR5UHIf9AbwFc/ovJPnH1aloErwKGX6c4hSZPtKCgMgr5
	 XFlFGOavjkVXIjz3FTppPIqjfoxObdtJOtvduKPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0428/2857] ALSA: core: Fix potential UAF after asynchronous card release
Date: Wed, 18 Nov 2026 15:24:22 +0100
Message-ID: <20261118150216.794739109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ad7115f3af550..4d8c77deed185 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -304,7 +304,7 @@ static int snd_card_init(struct snd_card *card, struct device *parent,
 			kfree(card); /* manually free here, as no destructor called */
 		return err;
 	}
-	card->dev = parent;
+	card->dev = get_device(parent);
 	card->number = idx;
 #ifdef MODULE
 	WARN_ON(!module);
@@ -592,6 +592,7 @@ static int snd_card_do_free(struct snd_card *card)
 		dev_warn(card->dev, "unable to free card info\n");
 		/* Not fatal error */
 	}
+	put_device(card->dev);
 	if (card->release_completion)
 		complete(card->release_completion);
 	if (!managed)
-- 
2.53.0



