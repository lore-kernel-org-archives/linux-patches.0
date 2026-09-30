Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D2E4E36D0;
	Wed, 30 Sep 2026 17:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788678; cv=none; b=M2bZvF8O0ipqFIX9N8ldb+fScCCbRcqO/NGh6C1exWn2ygJLViHOVYAEN1+sf7PlJj4N5Dkc1SG3540je9QhbyKpV6MJwFYJyNZOofNNoRdWN3MAzadyQYDiL0gkyt592rn4mZ4slPF1gq/LoHPDVqSqWTwR4bM0MNhbAAH5PKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788678; c=relaxed/simple;
	bh=d1SjxKZT67oWYRivIHuLxbPOfgcRCzqF9XRsoyRdQzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OM1RWh7rP282eqmr/9oAa50ygKHen8iALomyfHNrUi5fVFZXDyN0BMzXa7yCxmlYjAutZ4UzedIdzrq4ewH3Gygr2wmizLPfzcpVUDppzpJB4y3Js7VVSpTKUkw8wrws6DtDRE6BZNMcxS2hxjblvaR+PqFjvQZ0et9uLJHj/nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cm1Yguaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cm1Yguaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E9E1F000FF;
	Wed, 30 Sep 2026 17:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788676;
	bh=sFuo/4nVO+eKM2+IAHcoR/JC6XdC2NyZDqvyJ4VYcpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cm1YguafrRfSG8QD9Q9S281xZJeHiqvYzxSPNhndoGUWyFPREkDN+hf1zNEPqa9nz
	 1g+B2aGDdtG+gzE2C9Q0ceeNJT6AJ255dSds5EdsGO5KK6xqBpnoXKyJMMcw+KG3yb
	 JbcRSwy4tIVAnvD0oNCNR/i2JG5QFJroXgV/6Bwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 164/877] ALSA: core: Fix potential UAF after asynchronous card release
Date: Wed, 30 Sep 2026 17:17:55 +0200
Message-ID: <20260930152418.261895685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -309,7 +309,7 @@ static int snd_card_init(struct snd_card
 			kfree(card); /* manually free here, as no destructor called */
 		return err;
 	}
-	card->dev = parent;
+	card->dev = get_device(parent);
 	card->number = idx;
 	WARN_ON(IS_MODULE(CONFIG_SND) && !module);
 	card->module = module;
@@ -593,6 +593,7 @@ static int snd_card_do_free(struct snd_c
 		dev_warn(card->dev, "unable to free card info\n");
 		/* Not fatal error */
 	}
+	put_device(card->dev);
 	if (card->release_completion)
 		complete(card->release_completion);
 	if (!managed)


