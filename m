Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67333AA19B;
	Wed, 23 Sep 2026 14:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173417; cv=none; b=lzvTXH42nLJvAQ2637mrV99wntgzdsrylO18akIG4n+io2FCQM58RuPx5sO4zYS6d/D+BL9mJiYN5cOr5LAW6XvAGRI7rTdJtdWz1M8oV34vWJ+2HYBhmb+yFwBANl75SKQpHohL4+UVo+113pHuqb1OtY4hAMbJpHVixxcBjFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173417; c=relaxed/simple;
	bh=3Stk7zTuhAt3rTB4icV/38yPNn9OwMR47BQDwqDkHBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf2gjG10p0tmqdI7x7J7s+CMimybEhAj7bgiRVd43aL80+ueLWR0mYx7KcynFPHe1A+4j6PVH36vNMz4mwV+rhh1MPXrAUjg3fgq7TVeWslDS5ksUigWgRCccnnsW/wlJ4oZTZ8Ns+t3CPCKFUdgraYOLKwxToB1ZM2dn5tTogY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4GEgT9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4GEgT9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BDE1F000FF;
	Wed, 23 Sep 2026 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173416;
	bh=IcojMWaJ82KzQI+alDBXS3xqqJBBsr/VbvFey3OSZus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4GEgT9Xhfvy6or4TcirSWpdzya4dpUH3AUDTRqrIwVDNWKDhNq1Nr0vqBQoK/Pf3
	 BJOHKNviA1KkHFMe/1/I6uE24o0pmIjz3h4dPf39OKloQVgAPQb9HklgjpQ0XhL5s6
	 Nmlz6fnNxn5xp69ltaj0gictisEykOijIax2SE50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 239/438] ALSA: virtio: reset device before deleting virtqueues
Date: Wed, 23 Sep 2026 16:04:20 +0200
Message-ID: <20260923140650.968923604@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

commit 6c05d00af307560e6a9f1631d6270d3df5aa2272 upstream.

virtsnd_remove() and virtsnd_freeze() delete the virtqueues before
resetting the device. del_vqs() frees the vring backing, but does not
provide a generic device quiesce operation. In particular, modern
virtio-pci keeps enabled queues active until the device is reset.

Reset the device before deleting the virtqueues so it can no longer
access the vring memory when that memory is released. This also covers
probe failures after DRIVER_OK, which unwind through virtsnd_remove().

Fixes: de3a9980d8c3 ("ALSA: virtio: add virtio sound driver")
Fixes: 575483e90a32 ("ALSA: virtio: introduce device suspend/resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://patch.msgid.link/20260911031121.1542502-1-oss.patchbox@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/virtio/virtio_card.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/virtio/virtio_card.c
+++ b/sound/virtio/virtio_card.c
@@ -354,8 +354,8 @@ static void virtsnd_remove(struct virtio
 	if (snd->card)
 		snd_card_free(snd->card);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; snd->substreams && i < snd->nsubstreams; ++i) {
 		struct virtio_pcm_substream *vss = &snd->substreams[i];
@@ -383,8 +383,8 @@ static int virtsnd_freeze(struct virtio_
 	virtsnd_disable_event_vq(snd);
 	virtsnd_ctl_msg_cancel_all(snd);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; i < snd->nsubstreams; ++i)
 		cancel_work_sync(&snd->substreams[i].elapsed_period);


