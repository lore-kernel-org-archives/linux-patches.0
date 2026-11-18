Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019573;
	b=fwrgKzjY1YZAbjvjkokEXXvHxcJfmfLOpEZt1MZpnmKeIpPjGTIyDImDZ8BFbIDS5pxt
	 m3y/XL0dQGBPjUvN9jH36bK57yoBSosSx6RRxTCu7scAtfEfwVVNwh7tfkOwmCj5LY30I
	 7r3PXSoPMbrhQSoLJ0rb4Jjw4R6yHYziW79OBs1K9EtnMFewHjjbh+pusnnaiRVHFPSC1
	 XL11kBuPM/UoWTNvDyu7vPpO7DNion8r/BGE3aoOsJvJmWi4JqDrlD+EOyHQdk02p6dB9
	 iPlweK4LK1BXP5bhoW4E7aVFd9899uZsJE2ArnTv1uz8zaycYh7aH008flq+EAS647A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s053aImAo1Ww7UNENyodxOroqjrUJxxpP1LkkJjMzrE=;
	b=RLoTITC72+o6kccgQi9oOI3fEeEeNV4AQmN9dCC79Bizgyue04LRRk54I36HJRHtDY/W
	 Sk9110MxuWtbpRSBs6MTnxCdzHvhxU67zTXoq2tdeCdpZXCjEWReFWg67/G32gsbBbit3
	 Nfsc99S88Bzt9vd3iSGNs9lRdj0w2/jEZPls/s8CRfQkGTRmfVUKsG4uGGcasdDyUbK5J
	 0qATs0F7hJE7+S0Oy8D2we/+G1znVvpN8RrUAmJGXwLP0UE+AH1HS917301XXsypPJ6W9
	 edqYMZI9nNaxJ69lB8JWikeC/0fJUNHFFJzr16+byNtPCgvZNh9syVXT5wtpKgseEbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4Uq5nXH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEC1606A7C8;
	Wed, 18 Nov 2026 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p4Uq5nXH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B991F000C4;
	Wed, 18 Nov 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019573;
	bh=s053aImAo1Ww7UNENyodxOroqjrUJxxpP1LkkJjMzrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p4Uq5nXHKIAUUqRFESG6C/hcV92dxb837QrViILuNP+guwdGX7zzEGa9M+AamKY2t
	 kmUJB/96rD3wctSxgh8pVVi1rvNtLKtQaBf4gBsIxxLgQSI2JUhG377nMEpyyPfo5o
	 ZyCosGq3dQWWIHmbc0d+cakkVmzrG5k+glslR+og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1617/2651] ALSA: virtio: reset I/O message fill level on prepare
Date: Wed, 18 Nov 2026 15:47:37 +0100
Message-ID: <20261118150346.069824072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 368dafa5df3f3..8837dfc128289 100644
--- a/sound/virtio/virtio_pcm.h
+++ b/sound/virtio/virtio_pcm.h
@@ -118,6 +118,8 @@ int virtsnd_pcm_msg_alloc(struct virtio_pcm_substream *vss,
 
 void virtsnd_pcm_msg_free(struct virtio_pcm_substream *vss);
 
+void virtsnd_pcm_msg_reset(struct virtio_pcm_substream *vss);
+
 int virtsnd_pcm_msg_send(struct virtio_pcm_substream *vss, unsigned long offset,
 			 unsigned long bytes);
 
diff --git a/sound/virtio/virtio_pcm_msg.c b/sound/virtio/virtio_pcm_msg.c
index a5c4e70277173..72103f6067169 100644
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



