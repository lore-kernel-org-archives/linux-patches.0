Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3728C30B512;
	Wed,  3 Dec 2025 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777721; cv=none; b=Mp3FOexoGyTMBpZpWN1W4qQXl9Nylg4bt7N5j1EZGW5zmPreSI6X6UyAiauciMUVpzipKVpAg176lzteaLb2RicMvlMLljmhLCtEl5Oph0wbwL/jC6/qIGpIrX5vKslmFoPxAnOr5jh4eYougwLXEbqyzDJF38F/wZVqAT4VnKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777721; c=relaxed/simple;
	bh=OXQBW556gBp999UEWNJd+z+vpl3G74m7CADBfoYFEb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cv9NS2YBn2YdjtY5AGjrFkjJAs4N4771MKA+XGOWXQX2mJnY6IQ9tbJbgoszwXizKgbiTtoLDnHO2YAui0/eOD/7GfeP5ek77AyYoRE+UZQSeWQmIesrfpFTvE8Vte+wLANmPbNWSxgZ0TGGbXcPEuUunU8uOGLr6e0covt+uLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUvU9c7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUvU9c7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBA8C116B1;
	Wed,  3 Dec 2025 16:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777721;
	bh=OXQBW556gBp999UEWNJd+z+vpl3G74m7CADBfoYFEb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUvU9c7WPB27gi1s+ClWCMXKsNqlfT7kmVK3P0m0zNjTU5ct+XO3tv0ajM4piGfmf
	 BtTPwdXzonpmcMaJ0h9KMYtvd9nCZpnr1hUj0VaYX9HY4YN2rNrrv8uYzHCZnGhwve
	 NuPjYm+VO8GjPGSdhncHUdxU37VSufMTxr8F3jIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 098/392] media: pci: ivtv: Dont create fake v4l2_fh
Date: Wed,  3 Dec 2025 16:24:08 +0100
Message-ID: <20251203152417.706097407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit cc6e8d1ccea792d8550428e0831e3a35b0ccfddc ]

The ivtv driver has a structure named ivtv_open_id that models an open
file handle for the device. It embeds a v4l2_fh instance for file
handles that correspond to a V4L2 video device, and stores a pointer to
that v4l2_fh in struct ivtv_stream to identify which open file handle
owns a particular stream.

In addition to video devices, streams can be owned by ALSA PCM devices.
Those devices do not make use of the v4l2_fh instance for obvious
reasons, but the snd_ivtv_pcm_capture_open() function still initializes
a "fake" v4l2_fh for the sole purpose of using it as an open file handle
identifier. The v4l2_fh is not properly destroyed when the ALSA PCM
device is closed, leading to possible resource leaks.

Fortunately, the v4l2_fh instance pointed to by ivtv_stream is not
accessed, only the pointer value is used for comparison. Replace it with
a pointer to the ivtv_open_id structure that embeds the v4l2_fh, and
don't initialize the v4l2_fh for ALSA PCM devices.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c |  2 --
 drivers/media/pci/ivtv/ivtv-driver.h   |  3 ++-
 drivers/media/pci/ivtv/ivtv-fileops.c  | 18 +++++++++---------
 drivers/media/pci/ivtv/ivtv-irq.c      |  4 ++--
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index 8f346d7da9c8d..269a799ec046c 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -148,14 +148,12 @@ static int snd_ivtv_pcm_capture_open(struct snd_pcm_substream *substream)
 
 	s = &itv->streams[IVTV_ENC_STREAM_TYPE_PCM];
 
-	v4l2_fh_init(&item.fh, &s->vdev);
 	item.itv = itv;
 	item.type = s->type;
 
 	/* See if the stream is available */
 	if (ivtv_claim_stream(&item, item.type)) {
 		/* No, it's already in use */
-		v4l2_fh_exit(&item.fh);
 		snd_ivtv_unlock(itvsc);
 		return -EBUSY;
 	}
diff --git a/drivers/media/pci/ivtv/ivtv-driver.h b/drivers/media/pci/ivtv/ivtv-driver.h
index ce3a7ca51736e..df2dcef1af3f0 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.h
+++ b/drivers/media/pci/ivtv/ivtv-driver.h
@@ -322,6 +322,7 @@ struct ivtv_queue {
 };
 
 struct ivtv;				/* forward reference */
+struct ivtv_open_id;
 
 struct ivtv_stream {
 	/* These first four fields are always set, even if the stream
@@ -331,7 +332,7 @@ struct ivtv_stream {
 	const char *name;		/* name of the stream */
 	int type;			/* stream type */
 
-	struct v4l2_fh *fh;		/* pointer to the streaming filehandle */
+	struct ivtv_open_id *id;	/* pointer to the streaming ivtv_open_id */
 	spinlock_t qlock;		/* locks access to the queues */
 	unsigned long s_flags;		/* status flags, see above */
 	int dma;			/* can be PCI_DMA_TODEVICE, PCI_DMA_FROMDEVICE or PCI_DMA_NONE */
diff --git a/drivers/media/pci/ivtv/ivtv-fileops.c b/drivers/media/pci/ivtv/ivtv-fileops.c
index 4202c3a47d33e..7ed0d2d85253e 100644
--- a/drivers/media/pci/ivtv/ivtv-fileops.c
+++ b/drivers/media/pci/ivtv/ivtv-fileops.c
@@ -38,16 +38,16 @@ int ivtv_claim_stream(struct ivtv_open_id *id, int type)
 
 	if (test_and_set_bit(IVTV_F_S_CLAIMED, &s->s_flags)) {
 		/* someone already claimed this stream */
-		if (s->fh == &id->fh) {
+		if (s->id == id) {
 			/* yes, this file descriptor did. So that's OK. */
 			return 0;
 		}
-		if (s->fh == NULL && (type == IVTV_DEC_STREAM_TYPE_VBI ||
+		if (s->id == NULL && (type == IVTV_DEC_STREAM_TYPE_VBI ||
 					 type == IVTV_ENC_STREAM_TYPE_VBI)) {
 			/* VBI is handled already internally, now also assign
 			   the file descriptor to this stream for external
 			   reading of the stream. */
-			s->fh = &id->fh;
+			s->id = id;
 			IVTV_DEBUG_INFO("Start Read VBI\n");
 			return 0;
 		}
@@ -55,7 +55,7 @@ int ivtv_claim_stream(struct ivtv_open_id *id, int type)
 		IVTV_DEBUG_INFO("Stream %d is busy\n", type);
 		return -EBUSY;
 	}
-	s->fh = &id->fh;
+	s->id = id;
 	if (type == IVTV_DEC_STREAM_TYPE_VBI) {
 		/* Enable reinsertion interrupt */
 		ivtv_clear_irq_mask(itv, IVTV_IRQ_DEC_VBI_RE_INSERT);
@@ -93,7 +93,7 @@ void ivtv_release_stream(struct ivtv_stream *s)
 	struct ivtv *itv = s->itv;
 	struct ivtv_stream *s_vbi;
 
-	s->fh = NULL;
+	s->id = NULL;
 	if ((s->type == IVTV_DEC_STREAM_TYPE_VBI || s->type == IVTV_ENC_STREAM_TYPE_VBI) &&
 		test_bit(IVTV_F_S_INTERNAL_USE, &s->s_flags)) {
 		/* this stream is still in use internally */
@@ -125,7 +125,7 @@ void ivtv_release_stream(struct ivtv_stream *s)
 		/* was already cleared */
 		return;
 	}
-	if (s_vbi->fh) {
+	if (s_vbi->id) {
 		/* VBI stream still claimed by a file descriptor */
 		return;
 	}
@@ -349,7 +349,7 @@ static ssize_t ivtv_read(struct ivtv_stream *s, char __user *ubuf, size_t tot_co
 	size_t tot_written = 0;
 	int single_frame = 0;
 
-	if (atomic_read(&itv->capturing) == 0 && s->fh == NULL) {
+	if (atomic_read(&itv->capturing) == 0 && s->id == NULL) {
 		/* shouldn't happen */
 		IVTV_DEBUG_WARN("Stream %s not initialized before read\n", s->name);
 		return -EIO;
@@ -819,7 +819,7 @@ void ivtv_stop_capture(struct ivtv_open_id *id, int gop_end)
 		     id->type == IVTV_ENC_STREAM_TYPE_VBI) &&
 		    test_bit(IVTV_F_S_INTERNAL_USE, &s->s_flags)) {
 			/* Also used internally, don't stop capturing */
-			s->fh = NULL;
+			s->id = NULL;
 		}
 		else {
 			ivtv_stop_v4l2_encode_stream(s, gop_end);
@@ -903,7 +903,7 @@ int ivtv_v4l2_close(struct file *filp)
 	v4l2_fh_exit(fh);
 
 	/* Easy case first: this stream was never claimed by us */
-	if (s->fh != &id->fh)
+	if (s->id != id)
 		goto close_done;
 
 	/* 'Unclaim' this stream */
diff --git a/drivers/media/pci/ivtv/ivtv-irq.c b/drivers/media/pci/ivtv/ivtv-irq.c
index e39bf64c5c715..404335e5aff4e 100644
--- a/drivers/media/pci/ivtv/ivtv-irq.c
+++ b/drivers/media/pci/ivtv/ivtv-irq.c
@@ -305,7 +305,7 @@ static void dma_post(struct ivtv_stream *s)
 			ivtv_process_vbi_data(itv, buf, 0, s->type);
 			s->q_dma.bytesused += buf->bytesused;
 		}
-		if (s->fh == NULL) {
+		if (s->id == NULL) {
 			ivtv_queue_move(s, &s->q_dma, NULL, &s->q_free, 0);
 			return;
 		}
@@ -330,7 +330,7 @@ static void dma_post(struct ivtv_stream *s)
 		set_bit(IVTV_F_I_HAVE_WORK, &itv->i_flags);
 	}
 
-	if (s->fh)
+	if (s->id)
 		wake_up(&s->waitq);
 }
 
-- 
2.51.0



