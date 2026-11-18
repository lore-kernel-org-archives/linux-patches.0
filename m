Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054475;
	b=sb5RaMxYMIpSpxNnV29eNgVzCcVvzHX2v3Go3tWXogAa/m3kl2PotrKWbPFnaFueEEeu
	 4GOCllSql4vDwEZQ40SfqAOns0GQ0jn+ZkzPI/dX45uND6vt7JqHy3LcjHcuW/chN/Dsb
	 A0t5vHVZ9mYwUXym3k7lk+ofEljk9Z9TtR3HXl9ynUQOfpRArJ+swma+pA59MEEM2XcCI
	 8mURX2XxvAup6i+sBRf5Bhjlmz/1QQ7GwqahBWFY1M3j0MIN8CONogzizK08d6s94bvza
	 VppFxu16Bsda63m7N+ttqeUvgcrxQAZw8evnXGinHLmwdAiU4KyTQ4azqXGGGdpUrEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tKD6Vomo742kqdlfTTj/jO6Un24auNHHk0g3EvlJ2C4=;
	b=RGY8wC9lnQhxmndqWbIk5LoETse+Uf7DoqguAvYilVBsowLROv7EgY15WZDwCWz9EZr5
	 apHQlo+YQ7yzldeS85Ano2I3d08EeF9/luENWwqDIrJGC+Rzci8OMsdgwDU/QgeUcP7Z4
	 AucOxoGSx53SKIOPdYDBrrDuVzIs4NenymXD0MZhcCoMVs/G+R4bP3wxqowROfMEmcxSM
	 8MFZbcKz/64yooxyjeDa/eV5fh+uD+OVhVrN4FgrYuehSzhdxWQhHmOH7+XF8KiFxdznS
	 GsjQCjy+MP7Dhb3hRQMkXCLur5PcijdHX1Zzike9Jd4n8eBDt20IlKGD7fen2tWZ5mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1c69mKUq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8AF606A325;
	Thu, 19 Nov 2026 02:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1c69mKUq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7DE1F000C4;
	Thu, 19 Nov 2026 02:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054475;
	bh=tKD6Vomo742kqdlfTTj/jO6Un24auNHHk0g3EvlJ2C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1c69mKUqIk/teD4oh0wRxdRj/YCBwjVnCc+Sj46LtD6p8Zkxt+ZGULLwVOWIv5DmK
	 x5MMLNMBlu/vaLy/w0iL8zPJJqesLSu5rUFcW9n+/gKaQGadFn4Lb3Sibs0Q1o6aLK
	 fiB+z3Y/tPtiJwcl1ozYSzHSlrBOIS458II7VS5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 5.15 1285/2214] hwrng: virtio - prevent use-after-free after a failed restore
Date: Wed, 18 Nov 2026 15:49:21 +0100
Message-ID: <20261118150102.988769029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: Replaced virtio_reset_device(vdev) with the existing vdev->config->reset(vdev) callback. ]
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



