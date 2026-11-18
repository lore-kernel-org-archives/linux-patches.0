Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053842;
	b=wP95NRVshhSRt7bNRuHnUEWQYOlMiWbghapIGR9EDJ7/5fOAt3kXXcEhuXlqwnOoTRkh
	 z3PP4gfImqHnmRC69dBusbF0dqdXFpwNK+vuOQvDE8bjkbgdyT5CmfvDEnKxkjLnDcjU6
	 xDoW6ZTcptGspKN2o62cXRwPobGMT3q17GDeBW279UgNpLS1x8SiqQCFnIrGbLn7+hqIL
	 vx7lO7mqxqmR1FQnjEkvowXWHqDcdVTIrJVXf8YbnmypaOtsCAVNossPJKfY/S2grnQ1M
	 UIdOjiw7kf/HdjLccpXecv+8YTD5dOj4WyTJZCgnuzTDK+m7jOauKmbL6hq59obBRfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wfVnAJboIehC2tEWHmMKharQSHKcwQN6LMVPTKA2geQ=;
	b=WOGIuI9us+aQNTRKzc5ciisk1GcXl/xSHGJ5M7+/J7OvgrMtPM/WK6tgVgvZfFftBwRV
	 YizRvxCE17mgwEIw3npDrlbyOZyoj27+DMjVmXFzuz+qLyDyT6D91sFj1mouILZ7/bGK7
	 qe8sOs4z+lLS70qN5OixyjI8mbJvOc32FLnaI3vGr14sKil2FGzzIcgyCo/5/3sQ1o/Ie
	 yfUJm91sbvdN7mIkQpvlx/PpZz2oP7qbS+IHNHjNOW5gfNORYNiDaopkwxD4p+xyTPfeV
	 g0h9nkJ4iAtzHK7MyvMto5QlYi8eeB+5qGxezq7XtwM0/LmXjjAjsnxc49q5z2uMF1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hj7FSn95;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DDF606A320;
	Thu, 19 Nov 2026 02:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hj7FSn95
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662371F000C4;
	Thu, 19 Nov 2026 02:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053841;
	bh=wfVnAJboIehC2tEWHmMKharQSHKcwQN6LMVPTKA2geQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hj7FSn956hj17RBP+xvxpBHM8GDMGVEf2f1wxEnB7wrFzYWoGJtQ42R/yUypv6FlZ
	 md2Ip2wgXGm+2e0VEgka1PRnPLg1FBzQ8yK7BULEMhgpfRG1/DNqQFetnNasIdzw5P
	 BPQbdkq81zHe9iItNTYor7266v+LZ19SLa5ri/Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1025/2214] ALSA: control: Fix UAF in snd_ctl_elem_add() on card disconnect
Date: Wed, 18 Nov 2026 15:45:01 +0100
Message-ID: <20261118150053.353229943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the direct error return to set err and goto unlock for explicit rwsem locking ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/control.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index bce311cd5326b..3c06f426dadd0 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1534,6 +1534,10 @@ static int snd_ctl_elem_add(struct snd_ctl_file *file,
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



