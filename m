Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9151200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D2DC433C7;
	Fri, 21 Jul 2023 19:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966086;
	bh=to5B9D5qf0Y6+XQ1rhkyuHzXZKaeHvIUOnBmmVx6Q+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLll2sN34slY/Qak1Aleehpicub+4AAYaIvFtXTffvER8+7BZmTr7YCv0h+8vnkan
	 LHI6PWENyetoZXZLBoalyzEYeSdui+0V2bDyNr4Zvs3v2dsY0Vrthto4smEosLJmkc
	 wl2makH1tFQRDapLFJo+A/HKOP2gWQvmkv9GWeRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <lvivier@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/532] hwrng: virtio - add an internal buffer
Date: Fri, 21 Jul 2023 18:02:03 +0200
Message-ID: <20230721160626.269681568@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit bf3175bc50a3754dc427e2f5046e17a9fafc8be7 ]

hwrng core uses two buffers that can be mixed in the
virtio-rng queue.

If the buffer is provided with wait=0 it is enqueued in the
virtio-rng queue but unused by the caller.
On the next call, core provides another buffer but the
first one is filled instead and the new one queued.
And the caller reads the data from the new one that is not
updated, and the data in the first one are lost.

To avoid this mix, virtio-rng needs to use its own unique
internal buffer at a cost of a data copy to the caller buffer.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20211028101111.128049-2-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: ac52578d6e8d ("hwrng: virtio - Fix race on data_avail and actual data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 43 ++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index a90001e02bf7a..208c547dcac16 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -18,13 +18,20 @@ static DEFINE_IDA(rng_index_ida);
 struct virtrng_info {
 	struct hwrng hwrng;
 	struct virtqueue *vq;
-	struct completion have_data;
 	char name[25];
-	unsigned int data_avail;
 	int index;
 	bool busy;
 	bool hwrng_register_done;
 	bool hwrng_removed;
+	/* data transfer */
+	struct completion have_data;
+	unsigned int data_avail;
+	/* minimal size returned by rng_buffer_size() */
+#if SMP_CACHE_BYTES < 32
+	u8 data[32];
+#else
+	u8 data[SMP_CACHE_BYTES];
+#endif
 };
 
 static void random_recv_done(struct virtqueue *vq)
@@ -39,14 +46,14 @@ static void random_recv_done(struct virtqueue *vq)
 }
 
 /* The host will fill any buffer we give it with sweet, sweet randomness. */
-static void register_buffer(struct virtrng_info *vi, u8 *buf, size_t size)
+static void register_buffer(struct virtrng_info *vi)
 {
 	struct scatterlist sg;
 
-	sg_init_one(&sg, buf, size);
+	sg_init_one(&sg, vi->data, sizeof(vi->data));
 
 	/* There should always be room for one buffer. */
-	virtqueue_add_inbuf(vi->vq, &sg, 1, buf, GFP_KERNEL);
+	virtqueue_add_inbuf(vi->vq, &sg, 1, vi->data, GFP_KERNEL);
 
 	virtqueue_kick(vi->vq);
 }
@@ -55,6 +62,8 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 {
 	int ret;
 	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
+	unsigned int chunk;
+	size_t read;
 
 	if (vi->hwrng_removed)
 		return -ENODEV;
@@ -62,19 +71,33 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	if (!vi->busy) {
 		vi->busy = true;
 		reinit_completion(&vi->have_data);
-		register_buffer(vi, buf, size);
+		register_buffer(vi);
 	}
 
 	if (!wait)
 		return 0;
 
-	ret = wait_for_completion_killable(&vi->have_data);
-	if (ret < 0)
-		return ret;
+	read = 0;
+	while (size != 0) {
+		ret = wait_for_completion_killable(&vi->have_data);
+		if (ret < 0)
+			return ret;
+
+		chunk = min_t(unsigned int, size, vi->data_avail);
+		memcpy(buf + read, vi->data, chunk);
+		read += chunk;
+		size -= chunk;
+		vi->data_avail = 0;
+
+		if (size != 0) {
+			reinit_completion(&vi->have_data);
+			register_buffer(vi);
+		}
+	}
 
 	vi->busy = false;
 
-	return vi->data_avail;
+	return read;
 }
 
 static void virtio_cleanup(struct hwrng *rng)
-- 
2.39.2



