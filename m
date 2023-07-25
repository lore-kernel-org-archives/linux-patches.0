Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B241ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53864C433C8;
	Tue, 25 Jul 2023 11:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285166;
	bh=WJrYh8x1GfY8JYSSmLL/FMv8SGs1RxfwfZnrKDUBL4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sNQ6cAzUD++zuEJWEluuEJUiJ48Z4s6sC/oyOcx4NTVZDU2IUt8cFQGBW/C2N2yY
	 jqjF7XjvUZgVYd4NoAtiNVxBCGVdejBwPmItkfnR+7AISu+YzJ9KthwDCPij41LdS6
	 zx8UYPcznfYqeFiwxTx7wyvK+9Gq9F4AX1yIVytc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <lvivier@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 108/313] hwrng: virtio - always add a pending request
Date: Tue, 25 Jul 2023 12:44:21 +0200
Message-ID: <20230725104525.662873672@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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

[ Upstream commit 9a4b612d675b03f7fc9fa1957ca399c8223f3954 ]

If we ensure we have already some data available by enqueuing
again the buffer once data are exhausted, we can return what we
have without waiting for the device answer.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Link: https://lore.kernel.org/r/20211028101111.128049-5-lvivier@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: ac52578d6e8d ("hwrng: virtio - Fix race on data_avail and actual data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 207a5f3b335c0..f98e3ee5f8b03 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -19,7 +19,6 @@ struct virtrng_info {
 	struct virtqueue *vq;
 	char name[25];
 	int index;
-	bool busy;
 	bool hwrng_register_done;
 	bool hwrng_removed;
 	/* data transfer */
@@ -43,16 +42,18 @@ static void random_recv_done(struct virtqueue *vq)
 		return;
 
 	vi->data_idx = 0;
-	vi->busy = false;
 
 	complete(&vi->have_data);
 }
 
-/* The host will fill any buffer we give it with sweet, sweet randomness. */
-static void register_buffer(struct virtrng_info *vi)
+static void request_entropy(struct virtrng_info *vi)
 {
 	struct scatterlist sg;
 
+	reinit_completion(&vi->have_data);
+	vi->data_avail = 0;
+	vi->data_idx = 0;
+
 	sg_init_one(&sg, vi->data, sizeof(vi->data));
 
 	/* There should always be room for one buffer. */
@@ -68,6 +69,8 @@ static unsigned int copy_data(struct virtrng_info *vi, void *buf,
 	memcpy(buf, vi->data + vi->data_idx, size);
 	vi->data_idx += size;
 	vi->data_avail -= size;
+	if (vi->data_avail == 0)
+		request_entropy(vi);
 	return size;
 }
 
@@ -97,13 +100,7 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	 * so either size is 0 or data_avail is 0
 	 */
 	while (size != 0) {
-		/* data_avail is 0 */
-		if (!vi->busy) {
-			/* no pending request, ask for more */
-			vi->busy = true;
-			reinit_completion(&vi->have_data);
-			register_buffer(vi);
-		}
+		/* data_avail is 0 but a request is pending */
 		ret = wait_for_completion_killable(&vi->have_data);
 		if (ret < 0)
 			return ret;
@@ -125,8 +122,7 @@ static void virtio_cleanup(struct hwrng *rng)
 {
 	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
 
-	if (vi->busy)
-		complete(&vi->have_data);
+	complete(&vi->have_data);
 }
 
 static int probe_common(struct virtio_device *vdev)
@@ -162,6 +158,9 @@ static int probe_common(struct virtio_device *vdev)
 		goto err_find;
 	}
 
+	/* we always have a pending entropy request */
+	request_entropy(vi);
+
 	return 0;
 
 err_find:
@@ -180,7 +179,6 @@ static void remove_common(struct virtio_device *vdev)
 	vi->data_idx = 0;
 	complete(&vi->have_data);
 	vdev->config->reset(vdev);
-	vi->busy = false;
 	if (vi->hwrng_register_done)
 		hwrng_unregister(&vi->hwrng);
 	vdev->config->del_vqs(vdev);
-- 
2.39.2



