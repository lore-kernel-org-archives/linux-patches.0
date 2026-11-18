Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047688;
	b=3U+t/szzguZxHhmlf+X+E21c0Ey1TVThlbNPXyt6BpI7pJYxyEbFF4bFEGkBQh9y2Bpy
	 yCKgcnwZQLQXcIOsvTejZL5grXJiUbwo8CAz0QtQJ4MU/nE5Lg7z2jeElLPv5cygGu7/J
	 lYb7m2A2pnZjkwlta14dNny5Qy09idm1355kXSiIw9Cn3P+hS609TWV2q3zyrGVlQbSzN
	 ngRKHzyzMW7fnQS1wGIxU6OGi8CkyfMo6BJbOc+ceErRXo/wiCE0OVjHLnrJialuTc7AN
	 53ReCem4Eo871RIHaKm8dlaIvv2AeUpXxMeNXjxL9cVZCpEvBwkprvjAe3ezHtu4zXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AJVHmPBjVGrOIUYNg6uJAEgDwLzWwPBnxWBZfWb97Dw=;
	b=gjTcXgZUjHu95ucMHcKaUBt1SEDCDuiYJhI8RWD4Zu6+kq7SJj7+GQvRIkZXVrFVG8T0
	 hPC5l/WyKHL5xlc4JBgIbruq6W15M8GeURH1kK1Qo6WSTx7t2Tjv+KRHFwTyqtvuP1T7T
	 OqOiF6L96iUWsM/q4HGzvtNE/Sy5NwBKGXEJNaaLC46GmOq4TFPyS6SrI3kw3Sc+0k356
	 89WYyDsLxMaBUtyCEfhXw4i9xmkg1T9m8nKHs3igK5jzQNMwET2T7S6Z0CQLrcJyU4gn1
	 nrPbQcHYgYKlUnvLV9tNIzUoB6wBv6K3cCXh3ql9WpldlAdfOZthLn3tJwrA9+n8qeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gERmBn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5492606A320;
	Thu, 19 Nov 2026 00:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gERmBn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166171F000CD;
	Thu, 19 Nov 2026 00:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047688;
	bh=AJVHmPBjVGrOIUYNg6uJAEgDwLzWwPBnxWBZfWb97Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gERmBn0Y5SZjlFcDRpjCmA1fUQbM1Dg2diM7T1fm/MbT7YlQvN6sM9FZRfzOZ52s
	 jkHdLcNsxLFpDgfyofqcY8vycGPThnUwr5v/9SU6c/EGlRhqoNZQMLxTGuHZWArVjn
	 PVICzimBLyBoVVT/Zm+okeNfE7N1BqDcPEgWUqU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 6.1 1687/2857] hwrng: virtio - prevent use-after-free after a failed restore
Date: Wed, 18 Nov 2026 15:45:21 +0100
Message-ID: <20261118150302.077180972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 14ab1c2a7350b..0c32991e5754d 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -188,6 +188,7 @@ static int probe_common(struct virtio_device *vdev)
 err_find:
 	ida_free(&rng_index_ida, index);
 err_ida:
+	vdev->priv = NULL;
 	kfree(vi);
 	return err;
 }
@@ -196,6 +197,11 @@ static void remove_common(struct virtio_device *vdev)
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
@@ -205,6 +211,7 @@ static void remove_common(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 	ida_free(&rng_index_ida, vi->index);
+	vdev->priv = NULL;
 	kfree(vi);
 }
 
-- 
2.53.0



