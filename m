Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046797;
	b=o3gD/vn1/RxUwLbrdLfN69T0VeqQ0jVyxlmX4hPifesaO/lng5XaN92YfPYGSEXgtzhJ
	 BqYy0HGcsUusR4tlRnK3qD9qxDlvGO6wMQHlEc9mPfJVHNUzKop8YRIr+IiA2mZDtx9ob
	 reQ1rbKMRI5M2SSSfsLEFdG0XgoXgbMiyVV2NsfSAlXLYCBJ391+ywSBCPQ5qRtepsx/I
	 PqKe/+UzhwRVJ3wgQtVVk3SvUZfVRPiMqQAkOgaCO3Km6u813WI2XMRzqrZUVyOadacxO
	 6DS22LFTbPl/KxEjllqji3hc3JaCZxtxoK97pN+G5aYYKV/nfPD/j5trd6pxfD2T5Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pdcVEil88ILrIK+FAX65hvKZ4Jsrgj/xSTbx63TrjuQ=;
	b=LP+bQ6XTaB5i6pk07d8RMfyMw3iyoopWYntyC4O3HiQd4nIVbJ7+jFdrI+UQX7fKr62o
	 bT3Ray9gDe57J2zvV1eiYGQsckwFonUtL/c0/w4MSzuCoQnrTTxJJCXPyGYrpUiNvxT1X
	 QlE3URCMlvHblnza+Gz2kmZkfahE05cRZNe72RANYYb36J9lo1YEGmlzS8fpCB2XtIlwA
	 dC6LkWmx3865ow5WPhh8RexHwSjS23NdEy80joEBrfMcYoQbTAV4YrDM7bm2Kyck2s4i7
	 92K1HDufZY37zsOYGyHRxrWaTpwPrrcAvYjgcEZ/y006vfSHD4ljb7EvZ+Fnarfe4fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8AYvkyP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2261A606A325;
	Thu, 19 Nov 2026 00:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8AYvkyP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DC01F000C4;
	Thu, 19 Nov 2026 00:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046797;
	bh=pdcVEil88ILrIK+FAX65hvKZ4Jsrgj/xSTbx63TrjuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8AYvkyP9M+hzbkvUrE68GZjNvo6Iu/TApB9gZWh4exa4yZSiXgClrvUKzxmfP/li
	 fKR8WXu9fxMfCEH/KOTcxU0DWWu03/n/0dXlSVtQRN2Mu3gYFD0KjOh57ZQjENz3Ak
	 RUaitH5CC9t+lpEjoaE+2QP/cF0qP1JyyrI5LHSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1408/2857] ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect
Date: Wed, 18 Nov 2026 15:40:42 +0100
Message-ID: <20261118150252.038357888@linuxfoundation.org>
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
[ sashal: Adapted the error return to use err = -ENODEV and goto unlock for explicit semaphore release. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index 9b739a515fdfa..6eece0d0afda2 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1723,6 +1723,10 @@ static int snd_ctl_elem_add(struct snd_ctl_file *file,
 	alloc_size = compute_user_elem_size(private_size, count);
 
 	down_write(&card->controls_rwsem);
+	if (card->shutdown) {
+		err = -ENODEV;
+		goto unlock;
+	}
 	if (check_user_elem_overflow(card, alloc_size)) {
 		err = -ENOMEM;
 		goto unlock;
-- 
2.53.0



