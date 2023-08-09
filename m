Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10FD6131
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3571BC433C9;
	Wed,  9 Aug 2023 11:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579752;
	bh=kO1ykwnZrscLM7BO0jq4nU+m7cabt4pkOevqJ328lFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJBcAJ0j//97VR1/kOJ43iVXIfeVbuIy1UCFelE2fe1niLdTDsRvMxBHBRm3UxlDq
	 Nh2Thr9IibgqO1GGobQjgGxbzwMwP6xLI63bSTc8SkNgRAGhedY6io7YDPYdSRDecK
	 X5sttbYEnP4gVJTYr9chXeVQ7zkEYv4PTyevw3/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <lvivier@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/323] hwrng: virtio - dont waste entropy
Date: Wed,  9 Aug 2023 12:38:32 +0200
Message-ID: <20230809103701.533603300@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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

[ Upstream commit 5c8e933050044d6dd2a000f9a5756ae73cbe7c44 ]

if we don't use all the entropy available in the buffer, keep it
and use it later.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20211028101111.128049-4-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: ac52578d6e8d ("hwrng: virtio - Fix race on data_avail and actual data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 52 +++++++++++++++++++----------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 9a3fbd2b41107..c88f175e60a4c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -38,6 +38,7 @@ struct virtrng_info {
 	/* data transfer */
 	struct completion have_data;
 	unsigned int data_avail;
+	unsigned int data_idx;
 	/* minimal size returned by rng_buffer_size() */
 #if SMP_CACHE_BYTES < 32
 	u8 data[32];
@@ -54,6 +55,9 @@ static void random_recv_done(struct virtqueue *vq)
 	if (!virtqueue_get_buf(vi->vq, &vi->data_avail))
 		return;
 
+	vi->data_idx = 0;
+	vi->busy = false;
+
 	complete(&vi->have_data);
 }
 
@@ -70,6 +74,16 @@ static void register_buffer(struct virtrng_info *vi)
 	virtqueue_kick(vi->vq);
 }
 
+static unsigned int copy_data(struct virtrng_info *vi, void *buf,
+			      unsigned int size)
+{
+	size = min_t(unsigned int, size, vi->data_avail);
+	memcpy(buf, vi->data + vi->data_idx, size);
+	vi->data_idx += size;
+	vi->data_avail -= size;
+	return size;
+}
+
 static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 {
 	int ret;
@@ -80,17 +94,29 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	if (vi->hwrng_removed)
 		return -ENODEV;
 
-	if (!vi->busy) {
-		vi->busy = true;
-		reinit_completion(&vi->have_data);
-		register_buffer(vi);
+	read = 0;
+
+	/* copy available data */
+	if (vi->data_avail) {
+		chunk = copy_data(vi, buf, size);
+		size -= chunk;
+		read += chunk;
 	}
 
 	if (!wait)
-		return 0;
+		return read;
 
-	read = 0;
+	/* We have already copied available entropy,
+	 * so either size is 0 or data_avail is 0
+	 */
 	while (size != 0) {
+		/* data_avail is 0 */
+		if (!vi->busy) {
+			/* no pending request, ask for more */
+			vi->busy = true;
+			reinit_completion(&vi->have_data);
+			register_buffer(vi);
+		}
 		ret = wait_for_completion_killable(&vi->have_data);
 		if (ret < 0)
 			return ret;
@@ -100,20 +126,11 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 		if (vi->data_avail == 0)
 			return read;
 
-		chunk = min_t(unsigned int, size, vi->data_avail);
-		memcpy(buf + read, vi->data, chunk);
-		read += chunk;
+		chunk = copy_data(vi, buf + read, size);
 		size -= chunk;
-		vi->data_avail = 0;
-
-		if (size != 0) {
-			reinit_completion(&vi->have_data);
-			register_buffer(vi);
-		}
+		read += chunk;
 	}
 
-	vi->busy = false;
-
 	return read;
 }
 
@@ -173,6 +190,7 @@ static void remove_common(struct virtio_device *vdev)
 
 	vi->hwrng_removed = true;
 	vi->data_avail = 0;
+	vi->data_idx = 0;
 	complete(&vi->have_data);
 	vdev->config->reset(vdev);
 	vi->busy = false;
-- 
2.39.2



