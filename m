Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059478;
	b=d6xJpLDB+y++EhDK7bS68Alghsh6WN/QWfPTmEdfvk4RXMnGoCAMNCUnb6yTCyl9zHWO
	 ngZfLF1tccoy2NNJYvy+CPe0it6oO4DbKDYYJ74zIIsLZMpeISRSw8hRv7o4ZsDray52Z
	 8A6mLdNUI3csEJPhzV3teufs/xQo6rKKBVTOB5/tB2Fi4Zsp+GpRpemrGm+fGFO1Jt+fA
	 cwOqIdnQeOcRu20ZBBeuaXiwJDuh8j8HibEg3sJS0JyscEC7ESpxE8Y8dOLLVLGCFOr0D
	 umvDBNz1d6qOeYSUVD3+37XaOFqmZ66Eogk+Jd+/YKLChOKNAk3N+MBCV08MKbluZ6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u0OuJoNXu0H37FXWGy2+rnKxWrHIcUWdjHxJNVCeY4U=;
	b=c2NGygFQbu2D8DR8Hp42S1Wdk06p3XV7m4/4q6SoF3ROzlCKGIQMlbDFRZ+nPBcf1Nx2
	 lof38kcaDO4H9t1mNDsW0ps8/VZU1o2xOL+sIyh110xNH70pD5zIw1hCbRDGUSvxUUjYf
	 QnBlAJeym8h32Lnfz33JdEIMjagKIeukKVx4kNzeQduxRjmOGtR6qW9AWU14FkLx/JAgs
	 57YFp0OramKbrydUMItjJzk9zKhL/8dR54NGPDI0DC/rCSReEovaPXHIUGt3EhUCmfuAH
	 EQkCaMhApEeX2hR5afec/LbQasQ/LEALqfa6IyzUloA5FCKK2M3LVFTH+kDV3jhz66g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRQcvyqQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A61F606A320;
	Thu, 19 Nov 2026 03:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRQcvyqQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8F31F000C4;
	Thu, 19 Nov 2026 03:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059478;
	bh=u0OuJoNXu0H37FXWGy2+rnKxWrHIcUWdjHxJNVCeY4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRQcvyqQKqBbJJYxdIcCQbHRT1yoZTo9+HbPUmx7HqMsYG9bkY+mqSUr5OWnrhc45
	 jEF1BZ4T9zFYrswRcWCpworo8j+g2TDGRNrxbQtC/BLpK0NNq/QQYpAPCHGK423UOb
	 QcjACmdfX8D6UU9UALIzH+qDm2JDt6eMrqjf9w4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0857/1848] ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect
Date: Wed, 18 Nov 2026 15:48:15 +0100
Message-ID: <20261118145952.404236672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d4febca239be3c91498762dd0535a87d4af1eabc ]

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
[ sashal: Adapted the early return to use the existing error path that frees the preallocated control and explicitly releases the lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 640bafb6605a5..4a9d13086f0b6 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1525,7 +1525,10 @@ static int snd_ctl_elem_add(struct snd_ctl_file *file,
 
 	/* This function manage to free the instance on failure. */
 	down_write(&card->controls_rwsem);
-	err = __snd_ctl_add_replace(card, kctl, CTL_ADD_EXCLUSIVE);
+	if (card->shutdown)
+		err = -ENODEV;
+	else
+		err = __snd_ctl_add_replace(card, kctl, CTL_ADD_EXCLUSIVE);
 	if (err < 0) {
 		snd_ctl_free_one(kctl);
 		goto unlock;
-- 
2.53.0



