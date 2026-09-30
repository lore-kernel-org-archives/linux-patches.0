Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D14D348C6B;
	Wed, 30 Sep 2026 19:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796220; cv=none; b=N2MO4k3V9wl6mcz3zi9GDx7YGd6zVtUbxA03ECgWSfif+CsDl9CN3auUyz4joy7Ao7Wct3i1nbrCm9v+tMk00ARbOwiSmQU7Mt6QaSfFVfUk5jtbdfIPhtG3FqNbBNltYQSu5x99/km6gzQUoIL1dN1JxRzgH73uk7tgRon3mss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796220; c=relaxed/simple;
	bh=jDI6k7F+KSHjZQyTVINGD85P4kVyIzoUk/1PBgLZcbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7m8TokVyKJHuQMKCA0aNOhPP73QRzjy81EkxLj08e/VY9ABwWLhyYSUimWBkA3p42A25F77GDV9YLIKOuBvOV+AvCu+PltkGgmeV3INSpa+PJBjIbNHHMLoZb0yhAe/2Wr4Pq71thS81x3yLhHWvUilEwNEfrHDcdzi8wvl/5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pd7alHfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pd7alHfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C038B1F000FF;
	Wed, 30 Sep 2026 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796219;
	bh=FjhRBy9WqJwsvwjB2VzzVSgTRWH8rdRHYuSJwzbt8RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pd7alHfhFOL77QKzPIfBcpON1UrV3wB57mpO3D1nhqksrlHoUIjpICgJqKb5/JXJs
	 UaexSEc1ScQHl6kcF0UJTIdAlYDlGK81DiBs6M+kSyQ9cbAyPQPSpvW+5TnCm39TuQ
	 Dy1QytgfWOl6uxDaGmpmhla/4VsX0uAvX9g1GhF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0835/1193] ALSA: virtio: reset device before deleting virtqueues
Date: Wed, 30 Sep 2026 17:25:19 +0200
Message-ID: <20260930152452.794082064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -349,8 +349,8 @@ static void virtsnd_remove(struct virtio
 	if (snd->card)
 		snd_card_free(snd->card);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; snd->substreams && i < snd->nsubstreams; ++i) {
 		struct virtio_pcm_substream *vss = &snd->substreams[i];
@@ -378,8 +378,8 @@ static int virtsnd_freeze(struct virtio_
 	virtsnd_disable_event_vq(snd);
 	virtsnd_ctl_msg_cancel_all(snd);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; i < snd->nsubstreams; ++i)
 		cancel_work_sync(&snd->substreams[i].elapsed_period);


