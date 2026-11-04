Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827131;
	b=SDkBAEw4Qe2kC2L3F5kCIjtS4VmEGgKAsv+JXd/eU27S1J4n7X97hav18m6/4TuWk/NG
	 bTIrg8demfC7w4EtPX01NBDEQktbZrPJn/MA86Q7vJpVUvUZzTaKMEfUGOSvRBlTModM/
	 1dJjeUSrnz0yxwhVdc1n6kHGVvIGY9UsOGAJjy4fukxdS8O7/LgE1H/7BIzXX5C6gQ/0p
	 yvzW6JcRa0TX1rpRbBE3RIvtiGJavXxET4NTkOGsdLsLxinoJ/d+bPT4nOrEtNrIz4Ppu
	 nrjPnq/dkg7CwU1z6QE32mDRb3kJtaumvK3R8lzQ1cEFdOYAyTNriYpBLkBc6UEJmWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=40iHttlyVIcBiWlXzqcKZaTsGcpla03zKBBZxbkPK/0=;
	b=V49q+zYwwOEircplyPiXPsI19A+BUyy+G4gwf2xEEOBmgRM7zghcDJl7u8eafC9/8AMR
	 5WYz2+flOdgshDqKK9KxjGF8TbKelmxCdZ4eglk/ze+Q/+P4w0a708JbtOCkZLcLmZQ8R
	 lStB48/0ugs0d4MT02eo2BzdKXapwJcNZfpecvsnYd7xXKE6w+qp7tyz6Lp3w0lEgTy40
	 8SqMN09VdBItx7DI88X7A+Pde25BP7TXH/+rIwv9oTNih89q3Q4vGHvyOZI5WW3qkup07
	 pJXe9N1Iig3eQokIO/JlpCiBxdq4fkxqCnfPa3JHNrvpZG1AvFnZp/3FXOJzGq8PaIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mq417Mvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E559606AB33;
	Wed,  4 Nov 2026 21:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mq417Mvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775151F000C1;
	Wed,  4 Nov 2026 21:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827130;
	bh=40iHttlyVIcBiWlXzqcKZaTsGcpla03zKBBZxbkPK/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mq417MvurPB3TSFM0zPtfrLqWl8dKhfJ3AIoxS+KttLb+5h4He4RcjWcZ2J4kpzsK
	 AERbE/ALMhmNadghp5D6tDpAE4fM8bxGwkvC7Rk1SiZbrClk7WEB5qizLpqop1kUX5
	 MlE5gqbmlftb4v7nzh9+wetJxws8EQWFJzUtmCuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 205/547] ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect
Date: Wed,  4 Nov 2026 16:06:29 -0500
Message-ID: <20261104211043.968377613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1802,6 +1802,8 @@ static int snd_ctl_elem_add(struct snd_c
 	alloc_size = compute_user_elem_size(private_size, count);
 
 	guard(rwsem_write)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	if (check_user_elem_overflow(card, alloc_size))
 		return -ENOMEM;
 


