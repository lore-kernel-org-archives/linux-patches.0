Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026197;
	b=tePTL/WNAVPFhwJL+9dXRMZJ23Re/t7vtzwYobIAf7dbliVMb+49pVV3WSr3mm2e5gm8
	 0sS33Wdl3YE9AFnTLppgnTSrXKIyMJbW3TyanuGV4t9HOTCCD23a+wrdLeos+RfTE1Eai
	 /ynzi/tGFcnXQRS6ZqQRuLAsE2XBHZfRfgnBFo8KsNYCkYKXZu+LGG6CWIjOlzc+XReas
	 RpmXi4y/456gWNC//8ojm4ROKuRJSyDc9wgJO7r/sdz2Abvngql0/pRI+RP0lLheCD6C6
	 IYufqK062VISVdtave1aynQTyWOLS7uZw8BcTX0IZegIMBDX5MqF9n86QXFcUh34/Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbr6inXyf/Mxn/tLHlebtINO26qMtfWU4ZfJmJY5siw=;
	b=DPUEXIbrZW/hBVtSV7zDROoMFHa7eZTGw9cdtOUjebRncZr6swNXhVx14SmElmEWuOy5
	 81x4rDraLsc334jSwC/wEHWv1hll91K0I74aNt6r1k5fVYlrRjdRhNwDhgBgapixghuFl
	 YzCeqHf0x4l5APLEWylXmKAjX2DJDrjRpUoi+O94nRWB6bpyboJYjB4MrHvoguFXXtXUB
	 qkEKbCqY23zU6UEhY5cimpCgK1Vh8ztdRzEcCVaieDJiTvY2l0B06t4wNgGi+1AzCWx9g
	 +cwtmlk2YL6e147o3v/tzfGH6S9dafRIOfxQhhgv/Xp1oLNgQQ3JvPQUcb3HOYkCsbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUqnWSKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215DA60A2601;
	Wed, 18 Nov 2026 18:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUqnWSKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311CD1F000CD;
	Wed, 18 Nov 2026 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026196;
	bh=hbr6inXyf/Mxn/tLHlebtINO26qMtfWU4ZfJmJY5siw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUqnWSKLR2MKxMHHVck49a4pWEh0aoDWDD+LTbMnFaFcmPmpudbm9Tosh8qMCjaYc
	 BC3X/hbTr9gCohjHjuk+bJqlA5xwgtoJaitv1u92QADnc1zzycAYcojWiPRbPA5bn6
	 kGhlGC50FJAWhfVeH0RQEZlQVejSLfXRFqaLstZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1332/2151] ALSA: virtio: reset I/O message fill level on prepare
Date: Wed, 18 Nov 2026 15:51:07 +0100
Message-ID: <20261118150210.588154563@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit f0e9db0f84249b65a72b5fba43e91212281ad378 ]

Since commit fe981e67568c ("ALSA: virtio: use ack callback"), an I/O
message is only queued to the device once the application has filled
the whole period: virtsnd_pcm_msg_send() accumulates the transferred
bytes in msg->length and queues the message when it reaches
period_bytes.  msg->length is reset to 0 only when the device completes
the message.

If the substream is stopped (e.g. snd_pcm_drop()) while a period is
only partially filled, the corresponding message is never queued and
keeps its partial length.  virtsnd_pcm_prepare() resets msg_count,
hw_ptr and the indirect PCM state, but not msg->length.  After the
next start, the stale length is added to the new data, the sum never
equals period_bytes, and the message is never sent again.  Playback
then stalls once hw_ptr reaches that period: writes fail with -EIO
("DMA or IRQ trouble") and drain fails with -EIO.  Capture is affected the
same way after a partial read.

Clear the fill level of all messages in prepare.  Outside of the resume
path, virtsnd_pcm_prepare() already refuses to run while I/O messages
are pending, so no message is owned by the device at this point and the
reset does not race with message completion.

Reproduced in QEMU (virtio-sound-pci, wav audiodev): prepare, write 1.5
periods, drop, prepare, write 16 full periods, drain.  Without this
patch WRITEI returns -EIO after 14 periods and DRAIN fails; with it all
16 periods are played and DRAIN succeeds.  Period-aligned prefill works
in both cases.  The same sequence on capture (read 1.5 periods, drop,
prepare, read 16 periods) fails with -EIO after 10 periods without this
patch and reads all 16 with it.

Found by code inspection, confirmed with the reproducer above.

Fixes: fe981e67568c ("ALSA: virtio: use ack callback")
Assisted-by: LLM
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Link: https://patch.msgid.link/20261011125426.35745-1-ue081723@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/virtio/virtio_pcm.h     |  2 ++
 sound/virtio/virtio_pcm_msg.c | 19 +++++++++++++++++++
 sound/virtio/virtio_pcm_ops.c |  1 +
 3 files changed, 22 insertions(+)

diff --git a/sound/virtio/virtio_pcm.h b/sound/virtio/virtio_pcm.h
index 5dd1b43b94932..0f3a433175e49 100644
--- a/sound/virtio/virtio_pcm.h
+++ b/sound/virtio/virtio_pcm.h
@@ -119,6 +119,8 @@ int virtsnd_pcm_msg_alloc(struct virtio_pcm_substream *vss,
 
 void virtsnd_pcm_msg_free(struct virtio_pcm_substream *vss);
 
+void virtsnd_pcm_msg_reset(struct virtio_pcm_substream *vss);
+
 int virtsnd_pcm_msg_send(struct virtio_pcm_substream *vss, unsigned long offset,
 			 unsigned long bytes);
 
diff --git a/sound/virtio/virtio_pcm_msg.c b/sound/virtio/virtio_pcm_msg.c
index 9778020a7ba89..d04763aba507e 100644
--- a/sound/virtio/virtio_pcm_msg.c
+++ b/sound/virtio/virtio_pcm_msg.c
@@ -182,6 +182,25 @@ void virtsnd_pcm_msg_free(struct virtio_pcm_substream *vss)
 	vss->nmsgs = 0;
 }
 
+/**
+ * virtsnd_pcm_msg_reset() - Reset the fill level of all I/O messages.
+ * @vss: VirtIO PCM substream.
+ *
+ * Messages that were only partially filled by the application when the
+ * substream was stopped are never sent to the device, so their length must be
+ * cleared before the substream is started again.
+ *
+ * Context: Any context. Takes and releases the VirtIO substream spinlock.
+ */
+void virtsnd_pcm_msg_reset(struct virtio_pcm_substream *vss)
+{
+	unsigned int i;
+
+	guard(spinlock_irqsave)(&vss->lock);
+	for (i = 0; vss->msgs && i < vss->nmsgs; ++i)
+		vss->msgs[i]->length = 0;
+}
+
 /**
  * virtsnd_pcm_msg_send() - Send asynchronous I/O messages.
  * @vss: VirtIO PCM substream.
diff --git a/sound/virtio/virtio_pcm_ops.c b/sound/virtio/virtio_pcm_ops.c
index 1105e7ff3523a..1091100a4c982 100644
--- a/sound/virtio/virtio_pcm_ops.c
+++ b/sound/virtio/virtio_pcm_ops.c
@@ -299,6 +299,7 @@ static int virtsnd_pcm_prepare(struct snd_pcm_substream *substream)
 	vss->xfer_xrun = false;
 	vss->suspended = false;
 	vss->msg_count = 0;
+	virtsnd_pcm_msg_reset(vss);
 
 	memset(&vss->pcm_indirect, 0, sizeof(vss->pcm_indirect));
 	vss->pcm_indirect.sw_buffer_size =
-- 
2.53.0



