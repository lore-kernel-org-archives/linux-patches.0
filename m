Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE4253C3CA;
	Wed, 23 Sep 2026 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174711; cv=none; b=sWa/iyeJyLlsNAgvPTki68ETwFVXfIjLg1rJi0T//lqLLWMUCNeFtsnncHMtg3mQ0x94EV3ktDY5IL7Nhc/1lT0OMwX+vsb0cwsDmzvvQNqyBIOR1uDUuseUuxEwOrV4YRNBiix+i7G4L9r5R6otCKQSA6FvBiwxNPC0WPiSz6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174711; c=relaxed/simple;
	bh=RFjXOpI7X6i3gQlvwK4XLoE7sr8vhzp+4tmOnzvRFOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQzs+XUfNvWfZKf0cBNJB3YoDl0DiN51BzMVVUiCsXDmc/j+zgUmJ39dx2m0kjd3/Jwfx5W1zSJtY1EF4ga5We3qpO9A5aFJPNe7rKK69d0nleyVdWbj8rUfWMnH8VaW9pqNNgglNJPQbxy2MiuGtJ2hCZcXgOQJf1IMpFFj760=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Onx55v0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Onx55v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A841B1F00893;
	Wed, 23 Sep 2026 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174710;
	bh=l28kuW1jGv/7zmMgCe7oU0uLbmU4p9LvvvvUreiUgeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Onx55v0FAzBwWajAg9O7D+1EXV6um6aOyS8Sy9fi6jbSZeXtHCCz/Abe2FQiFZeW
	 sPGIw0ngxImWhQfHSn1PSMDdw5mh3MqzMsqzV+3ukdIbcQy+ITfqJs4StzyaRN0xVY
	 yOmICncx8qW+6DduaREOXMMQXtItNmkrr65QA7MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 200/398] ALSA: virtio: reset device before deleting virtqueues
Date: Wed, 23 Sep 2026 16:04:34 +0200
Message-ID: <20260923140648.609097277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -355,8 +355,8 @@ static void virtsnd_remove(struct virtio
 	if (snd->card)
 		snd_card_free(snd->card);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; snd->substreams && i < snd->nsubstreams; ++i) {
 		struct virtio_pcm_substream *vss = &snd->substreams[i];
@@ -384,8 +384,8 @@ static int virtsnd_freeze(struct virtio_
 	virtsnd_disable_event_vq(snd);
 	virtsnd_ctl_msg_cancel_all(snd);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; i < snd->nsubstreams; ++i)
 		cancel_work_sync(&snd->substreams[i].elapsed_period);


