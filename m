Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260523769FB;
	Wed, 30 Sep 2026 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788681; cv=none; b=JKnI22cimcYIJLBzrevBGrkKasTMf+RLLX9n5qGasPL73TsEYtBG6mqp2juMaWPMT4MxqXhp5Ef0KWSsMRGWpiit9FtCVismkFHkDaZ+C4hwVuia9fFcYG+H/GKT/l4spkJkvyo95emQg1w/qHIc0NP1DYsWmmeqPfhv9ciErk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788681; c=relaxed/simple;
	bh=X+/DYcwo99u3Ysg6WRrTqnMFoFi+waBiJXrQFosRbWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJM8ps0dJaNw48vnhqaYtXtJgXDlCqilCH0jNwy2+ykKg7ACn3RfeqMdGduwoSFfXrlnazUg46BJSUFAfH0d1DOLPpgTHGeN5L15GqpD/B6oNE3u4bNp9lXyBdsT7RFlUtvs9Oon3U+wetiPLFwNa4odEwWK9rzn49fPGdRgh34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+D+BsvZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+D+BsvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4438C1F000FF;
	Wed, 30 Sep 2026 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788679;
	bh=mC2sRIa0ZmJ5VEsHSwDVTaMGPbw7WxyGzQpDanubtI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+D+BsvZXcp5rDOiYihf5Xfsqg8sQY2JmRtOAYL0neJAab7yVEMmMY0jXvAIF8Ooc
	 eud+mbv7jwzOlxUXRMMMmWtDAijHIxVE8yCrwE1pxke6nE5j1C5VabJzuGcN1koN8l
	 o4Em14gckyKFG+07/JOGVg8Z5QBPw0wIOph60DHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 165/877] ALSA: virtio: reset device before deleting virtqueues
Date: Wed, 30 Sep 2026 17:17:56 +0200
Message-ID: <20260930152418.282696889@linuxfoundation.org>
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
@@ -359,8 +359,8 @@ static void virtsnd_remove(struct virtio
 	if (snd->card)
 		snd_card_free(snd->card);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; snd->substreams && i < snd->nsubstreams; ++i) {
 		struct virtio_pcm_substream *vss = &snd->substreams[i];
@@ -388,8 +388,8 @@ static int virtsnd_freeze(struct virtio_
 	virtsnd_disable_event_vq(snd);
 	virtsnd_ctl_msg_cancel_all(snd);
 
-	vdev->config->del_vqs(vdev);
 	virtio_reset_device(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; i < snd->nsubstreams; ++i)
 		cancel_work_sync(&snd->substreams[i].elapsed_period);


