Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060103;
	b=haFFIfTaGrK/Ptm9ZYU3DSJ5VCVExHHFfc66xMbpQNyMbj4qU/QJv0qJdexJy1ccpsqO
	 7jH3OeKtezm7hsDwVcryRxBr5Ui6DIQtYing4iSrdCw6XKeOd9pyOK9FeQ77qQV/qkFsC
	 jht8sGOq0p40KEahufIUapSx6oAsDAfF9kt3p9jvbHDLTfraQoUBCq4pGfJ7duMJ8IQuP
	 zQp2Z6EWcRTfrpzB0yoW0ESIvVnlYpIMdJ9wnuNPTVNb8r3DhdgtHIG/QMqipFpWDOqoU
	 sLKiMR77L09719kDKFvL8LAlVuzr6wWDRFTQlWE2BPN7VkrsA6PAtlp341RQlfTrpyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q0deIuhPT+BWnYZlawxS8+onRevq7s6o6Yv85LH2r/c=;
	b=myamzdb42nXwm+9NDSPBYaHl9jtk0M2nj47TRPFBENfIf4NwF1MiIRJsyunCZVQcFQzk
	 wH/ucpBm5cnMf8yi1N5odwc7TP1vc3wV0pU15zbpDyN9dwDM7f3H+0ILAIwoUMNZnZiw6
	 0Mxrf7C+UjizFCij2J0ERMnLg9PVxXypukPS7NxQjDuDCnQ+c4MCk7NRfdNdbICzE195b
	 JBGm3n1EDqxT9PksKxYrrpP96KZacUoj9LBuNNvk8RB6GOVQTVniG9BSblfkeV3qhCwQl
	 XvzYrlC+Kwv6GrkzM7BnTDKaBOy5QGEV5nMqtEsAmvmXDnWnbmBOltjbU4KCvScmatA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxoglyOg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3582B606A320;
	Thu, 19 Nov 2026 03:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FxoglyOg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C03E1F000C5;
	Thu, 19 Nov 2026 03:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060103;
	bh=Q0deIuhPT+BWnYZlawxS8+onRevq7s6o6Yv85LH2r/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxoglyOgVSpFmjsHq9ggFHRrvUP9U7RBOmtkpOjDQgfhfYEw1DbXsnUpET13XDM7o
	 jnKpii3qdvyYW92jrx6+Q5ZhHvGd93OooAtQASf58LoL7V+vZNH4Qf10g5LlIMcN7d
	 d8Vl9oqjXwurZEQxfSyo5n1HNji8nAAlqnhdWzg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 5.10 1080/1848] hwrng: virtio - prevent use-after-free after a failed restore
Date: Wed, 18 Nov 2026 15:51:58 +0100
Message-ID: <20261118150003.590482972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced virtio_reset_device(vdev) with vdev->config->reset(vdev) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/virtio-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index f6c0de82c22bc..72c99fa35e78d 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -186,6 +186,7 @@ static int probe_common(struct virtio_device *vdev)
 err_find:
 	ida_simple_remove(&rng_index_ida, index);
 err_ida:
+	vdev->priv = NULL;
 	kfree(vi);
 	return err;
 }
@@ -194,6 +195,11 @@ static void remove_common(struct virtio_device *vdev)
 {
 	struct virtrng_info *vi = vdev->priv;
 
+	if (!vi) {
+		vdev->config->reset(vdev);
+		return;
+	}
+
 	vi->hwrng_removed = true;
 	vi->data_avail = 0;
 	vi->data_idx = 0;
@@ -203,6 +209,7 @@ static void remove_common(struct virtio_device *vdev)
 		hwrng_unregister(&vi->hwrng);
 	vdev->config->del_vqs(vdev);
 	ida_simple_remove(&rng_index_ida, vi->index);
+	vdev->priv = NULL;
 	kfree(vi);
 }
 
-- 
2.53.0



