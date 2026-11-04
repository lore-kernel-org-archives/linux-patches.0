Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831444;
	b=RZmr76v/9UWDbe302RCEp9sZ0tvmoaz7+iAzgJ1SjXvjKGs94m20c1iDH82lS0xpnZWo
	 MDRHCAG+mpTx+AI8xOVtj13yug2cu6ytPaoUgnIk1R577uYmaIYKsf13wrBq1Mji53Vkt
	 fbH3BaZQ4zs5dWmwXDFL56bQ8FKoihSiojl4jc92AYbSiWjsaBnL9mrh0xlTKU0XVHv45
	 g4X4OeVNm81IHBaZtxHAoOMwf7vieHaBevuAOH4ZrIw4UKspHVHJKC8EmCo2MUfL16O50
	 tyRzcDZ20G1IdqVfdc/dIPgH7D2lJ5H6y6VjyjGof8hrPBJYpSLUR/i4VBclPMWuziw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bDitczcch1iFeJclO4MLfvU4o1SG1FiJ+acvQiVX6SM=;
	b=G+6RPUxkKeggMEkoS9EtWU/3pxRsTixY5fQ1ppiSoY9Bdr6LmcwqHUBHN2/94wbPa+Bq
	 xtYwgH0r0X9Q5WgzYTSEXPW4MANnPl3QIO+KbrHZ27LfkSPtN7Gkc4AfNbMkUwOMMcr7N
	 K6CvZS5X3pxd/uSC4nbvVY4Un8hYbtCbYefEkZoU9olRlIijlznT5XZ5CBjl5OXlm5k1l
	 1ZNFZD8OmUC4Z3zz44ioqd1eis/zsBRXCPHBrJpqmO4m2o5inQ7FxjliD7/tjUlM5qVes
	 /mn2qDK+lJzM9zb9KP6oQhadJz7ZcqME77uWBUhHGID62y9UzjYjPrg34fabAeMgVqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PUYmKL2P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1F1606A328;
	Wed,  4 Nov 2026 22:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PUYmKL2P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5D71F000C1;
	Wed,  4 Nov 2026 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831444;
	bh=bDitczcch1iFeJclO4MLfvU4o1SG1FiJ+acvQiVX6SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PUYmKL2P5i+vsWk1a4IEP2E3uDt6dcklKuIxoF3XCMfJGbMTykVGNZcgtmVjifs38
	 R/jZY/Ax9XEDJtA0i30/lwUMXM1iOIpJkNxDRSy7mKhrQYsMzIwDjMav9D579LHxQA
	 6jSaT8OjTRTcuwB/1TO94i8E9AweL/HbRSaFPWMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 0705/1005] ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect
Date: Wed,  4 Nov 2026 16:07:18 -0500
Message-ID: <20261104211103.324795161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1676,6 +1676,8 @@ static int snd_ctl_elem_add(struct snd_c
 	alloc_size = compute_user_elem_size(private_size, count);
 
 	guard(rwsem_write)(&card->controls_rwsem);
+	if (card->shutdown)
+		return -ENODEV;
 	if (check_user_elem_overflow(card, alloc_size))
 		return -ENOMEM;
 


