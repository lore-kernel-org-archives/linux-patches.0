Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210641;
	b=Beg2SSbNb/SRan+aYiiA1l1M2hC6UK60cxyKDzXP/+27bJRjxP0Vf8kBFvP3ChkeLd9n
	 XgGSfjoZNTjYp9YhwQVC4rAYDHKISgJio4TCuOgBeE6prfVBaHh60cmrQrYn2HBOtJAbJ
	 kYOvgaeGqXaKyPwN3cSsmjWjEwbkXbgL77HaK8hIziIr3n8YMIpo2hEg6iwp4tDT65Yb+
	 rgTaSGCQMVljZnyYc+PD2TmrZAYEz87dFGdWVETd1LnXZPthKkC8JogvXlpkJqfUkp2Sd
	 9QvxvJbXskB+BvmNWDjeITDnTUM82oxZUg5Rzlu83Rzx2DrENu6tJBxH9Y2mNgmvfUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pI1qaWg0nDpyDmhqC9n4rrWxx3PyD0teCnhaDYzgPKU=;
	b=UnbV3n+NYTifdM9lzbAu5vjJth/nk1PcHRUUeAIboN2G3A2z5zeLRav4vl5M3FWLW7aj
	 wVN+QBki3BkkM3WVsemxgllQpjRIgnNBUiAc7KkUoC0XfE+aYXP2R1Nliu+ixBz7FISop
	 jC9HYijq4/P+DGJwtuEMcBf69fugtsUHq0SEKG9ogvWk54LEzXAK8hCnnXvuLa6ZnA5XI
	 HiTjtfPtVOp+kxtltfNUs14VQZm9tVnUugND0YxJsseqbdct5k7entaRuuOD5NFcBETSr
	 K3Qz8LaT5x8hvnr8vs7iaWInXrAMVVc5ZDbDdVAfF6qc3iWyKHlCkxjnwWoSGwJkT2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuGjjdeH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC5606A31C;
	Wed, 28 Oct 2026 18:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MuGjjdeH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CB31F01825;
	Wed, 28 Oct 2026 18:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210640;
	bh=pI1qaWg0nDpyDmhqC9n4rrWxx3PyD0teCnhaDYzgPKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuGjjdeH52l2XHRBPOUwmHxpQCt59DZu2n8rGPvkw7CZ7I0/mNiJExiDZfoVDiWlG
	 C4vEc5XrP+iW4G34ysQnIDG/PnQwB1UM+z+cWxpU/qS372N4YaFnZFmdkmdg3yV79F
	 XFojfxxffkAqLaatUwZoayia2q+yTHfvahvNLITg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/571] ALSA: virtio: reset device before deleting virtqueues
Date: Wed, 28 Oct 2026 17:54:05 +0100
Message-ID: <20261028170010.347911555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 6c05d00af307560e6a9f1631d6270d3df5aa2272 ]

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
[ Replaced virtio_reset_device(vdev) calls with vdev->config->reset(vdev) for the older API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/virtio/virtio_card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/virtio/virtio_card.c b/sound/virtio/virtio_card.c
index 150ab3e37013e..1a4007c99c538 100644
--- a/sound/virtio/virtio_card.c
+++ b/sound/virtio/virtio_card.c
@@ -349,8 +349,8 @@ static void virtsnd_remove(struct virtio_device *vdev)
 	if (snd->card)
 		snd_card_free(snd->card);
 
-	vdev->config->del_vqs(vdev);
 	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; snd->substreams && i < snd->nsubstreams; ++i) {
 		struct virtio_pcm_substream *vss = &snd->substreams[i];
@@ -378,8 +378,8 @@ static int virtsnd_freeze(struct virtio_device *vdev)
 	virtsnd_disable_event_vq(snd);
 	virtsnd_ctl_msg_cancel_all(snd);
 
-	vdev->config->del_vqs(vdev);
 	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
 
 	for (i = 0; i < snd->nsubstreams; ++i)
 		cancel_work_sync(&snd->substreams[i].elapsed_period);
-- 
2.53.0



