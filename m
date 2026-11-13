Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591161;
	b=zQqFQ8pbg5D0bEeH5gVEpuUJrHfHjCht19vRrYqBOh+ONeoCEwyF1hvowe8b40FqecD2
	 bEcT7DkbpluE9vAXytGLJo8x+DGDwYDfFMmvMFoCjCgGODjZQE+x5LPzCyx5InZxnyj+E
	 6izF9shQiY6vysQBTmfp08hmhLxVKL/uk5FrEklHO3yAR2bK3ViirDeL+FAfnN/3jpwsR
	 R/kdeASN5nQOipZxxlQ7NZXEMUTYNwc9b6ES3bkNtfmAy7iD4SpneGiUXadaq04hlH9l0
	 fXcv5/6YZbEDndeW48dJm9CCcaLr88PdP/XUJbWpePWBD/rCq0sXNAANvnZ09uhR2pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KmjZ8Mxfo2mImiS06UqfEroLP4Pmh8474483NeloZv4=;
	b=ZaawB4HNeQ5Bqtlc3FKjGBoBnjjPH+hyreia1bPUcIK5q2yxbojxelXL6guz+IB1NZyM
	 siffmwOzdbASj9fER0Njj8j9iHEixe1uMjdrVG4fwRsgEjTIyjlQ2BOv8Te/o8gGyzwvB
	 gTuUbhkouIZIOgeqdhdkKEWlRa2FlUoPcuj7FBFzqLlCeWNqLrPolsTF6ZR/qirTDgR0W
	 dFM6aCKHBpP/x0WXyeCin4rVS2L0JAfLXFIj2ZyiPrXMLnv/Pjv21dX824J1GBtsCf+MJ
	 7RL+ZIqVh3qVVUQRr7cpAXR6iCFTg2zA/JNwDUOZ1ndezv8vlLK4/BtZLbgKm4G11Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IauxHZ7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2436073FD4;
	Fri, 13 Nov 2026 17:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IauxHZ7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94201F000C6;
	Fri, 13 Nov 2026 17:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591160;
	bh=KmjZ8Mxfo2mImiS06UqfEroLP4Pmh8474483NeloZv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IauxHZ7rotQ3bv7K6k4i16gvaPKszszg6NHThWMO/1Z3b05lC35r803Xf94K1e9xO
	 Ikli5fKgWKvj7wjHnJUAQYNYpBfM+bqvdw3Ih0c96RmzRTJ2C5o737LPUJEGGzvTGR
	 8866IDRyhdAGYHX62I+0D5sG/WjMRCJBkOMTByOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 6.12 304/670] hwrng: virtio - prevent use-after-free after a failed restore
Date: Fri, 13 Nov 2026 10:47:48 -0500
Message-ID: <20261113153822.218195455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 0f7bf47f5a0cc26320aa4b14f4504d03a07f4b74 ]

remove_common() frees the driver data during freeze, but does not clear
vdev->priv, which points to freed memory. If probe_common() then fails
during restore, a later remove or freeze can dereference the dangling
pointer.

Clear vdev->priv on the probe_common() error cleanup path and before
freeing the driver data in remove_common(). Also reset the device and
return early from remove_common() if vdev->priv is already NULL for a
safe teardown after a failed restore.

Fixes: 08e53fbdb85c ("virtio-rng: support multiple virtio-rng devices")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>.
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261016103640.4989-2-blum@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 2933f8cb769e4..fcb60d4deaacd 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -187,6 +187,7 @@ static int probe_common(struct virtio_device *vdev)
 err_find:
 	ida_free(&rng_index_ida, index);
 err_ida:
+	vdev->priv = NULL;
 	kfree(vi);
 	return err;
 }
@@ -195,6 +196,11 @@ static void remove_common(struct virtio_device *vdev)
 {
 	struct virtrng_info *vi = vdev->priv;
 
+	if (!vi) {
+		virtio_reset_device(vdev);
+		return;
+	}
+
 	vi->hwrng_removed = true;
 	vi->data_avail = 0;
 	vi->data_idx = 0;
@@ -204,6 +210,7 @@ static void remove_common(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 	ida_free(&rng_index_ida, vi->index);
+	vdev->priv = NULL;
 	kfree(vi);
 }
 
-- 
2.53.0



