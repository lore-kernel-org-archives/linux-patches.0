Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035110;
	b=VPX+nFJsRUBJ2dtUh81ehIHJO5PCAesGyD3t+I1IBsbaNsBns4y7B/iaPjDfrkxu3yDF
	 l2tablc3goTr3nn1zO3dcqvQNK7IhEn2h3NMM9KRo6Y8Upr6RbuhPgOozbqAwYp/FvvQ3
	 llYTADTskbjwYqKXnpNU3E9LafJXOt/OxkpAl42mtPlCSZDERMf2D4U/xp6LJxg9sxxcr
	 yf6Kdixlz0KwdZmCWeRWJFsBCU6R+y4dVAENwSn9rZA3eymEh0uqh3szoLXPSCD6zHj2U
	 /O3QL7fWeLziWuPs2lCS0kRRi23HtQ09/G9gyMtFFoHI4pWiX+aXyQQSFe6RHnyqUGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U0Hzh2cIN7FRITtoPCy7TgVmRSqn9yZceAO253Mot/c=;
	b=Jg4g0P0YLgQFwUMbZZWHdRTSRfQ4c4bVtMKJrh4+RU9Htb3pQKk9UHirLcr7ABwGNAOC
	 +jMnMCnUm7igEaDdVsP0G+L2iixmfva1DHk9soYCvA4wKNIkSxVQr7OvI0vyojQkiDpZA
	 yAj4wYxozZrEcXG0/1UFO4bna9wUdfGqtUqpRfncnJ09sSxNu5c1IMi9e6bCUCT0rbox6
	 YbE2rRiW6ETXTjjDzW+9vX5/0exP4VMhy2B82z/h9Hq/zrPwWncOIRCqbKCAQVmjWWYlZ
	 Ctf/9QQwMwUkSvGyZmXurP6GR2DRtWz0t2k1kAcHsORmG70XxpTyTsq4CrLZQYcwghw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p16oDlIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B98B606A31C;
	Wed, 18 Nov 2026 20:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p16oDlIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2FE21F000C4;
	Wed, 18 Nov 2026 20:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035110;
	bh=U0Hzh2cIN7FRITtoPCy7TgVmRSqn9yZceAO253Mot/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p16oDlIemDJdO50/UyP2tvEotYWuGOBwVxXVsl/vISP/9nUQB67BAKzqVFHC+YPiT
	 4SQmEFoblXIRRT+pqLeUAYkNrBJC7P/1oXdsgdZyU6p7tsPzXS1QkeNfryh/B7oNDK
	 naCwLFtbl1gyHadN4u68PgxsaioltRIvdoWTei3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0609/3318] ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect
Date: Wed, 18 Nov 2026 15:20:31 +0100
Message-ID: <20261118150336.008510825@linuxfoundation.org>
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

commit d4febca239be3c91498762dd0535a87d4af1eabc upstream.

A use-after-free can be triggered via SNDRV_CTL_IOCTL_ELEM_ADD when a
USB audio card is disconnected while an ELEM_ADD ioctl is in flight.

The reproducer parks the ioctl thread inside copy_from_user() using
userfaultfd, then tears down the USB device.  Unlike every other
ALSA control _user handler (ELEM_INFO, ELEM_READ, ELEM_WRITE, TLV_*),
snd_ctl_elem_add_user() never calls snd_power_ref_and_wait(), so the
parked thread holds no power reference.  snd_card_disconnect() therefore
cannot observe it via snd_power_sync_ref() and proceeds unimpeded:

  1. card->shutdown is set to 1
  2. device_del(&card->card_dev) drops the kobject reference on the
     parent USB interface device (card->dev = &intf->dev)
  3. The USB core drops its own reference and calls device_release(),
     freeing the struct usb_interface, including the embedded struct
     device that card->dev points to

When the userfaultfd is resolved and the thread resumes,
snd_ctl_elem_add() acquires controls_rwsem without checking
card->shutdown and calls __snd_ctl_add_replace().  Because the
reproducer pre-registered the same control, the CTL_ADD_EXCLUSIVE
path calls dev_err(card->dev, ...) on the freed USB interface:

  KASAN: slab-use-after-free Read in __dev_printk

Add a card->shutdown guard immediately after acquiring controls_rwsem
in snd_ctl_elem_add().  At that point card->shutdown is guaranteed to
be stable: snd_card_disconnect() sets it before freeing the parent
device, and it never transitions back to 0.  A thread that acquired
the lock before disconnect sees shutdown=0 and holds the write lock
through the rest of the operation, preventing concurrent disconnect
from proceeding past its own controls_rwsem-less shutdown=1 store
(which happened earlier, outside the lock) from racing with dev_err().

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260929125346.1478631-3-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1699,6 +1699,8 @@ static int snd_ctl_elem_add(struct snd_c
 	alloc_size = compute_user_elem_size(private_size, count);
 
 	guard(rwsem_write)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	if (check_user_elem_overflow(card, alloc_size))
 		return -ENOMEM;
 


