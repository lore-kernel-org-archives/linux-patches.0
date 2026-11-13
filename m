Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585658;
	b=1GbCKrnYzJMeoPdRkFySCfHYfxIwvS5bpqJ8UE//dxsVN+Opb85DiArq6DTvkdUfmkH1
	 PNwViVYzJBXHnMwYuMAIHPsNf63Zi7oSW/DlFmG5E3P9Jdq37V7AANS60xtffeQz5E+tL
	 bi3gyRDd6Wlb3K552dA5DbhFTWUjnMgHWrL2h7A9yWHAmX/okgj5xhS8BA1PvHlsg5xSX
	 oMOzwdGhsThgfXZQRmfGRsNBy5ooQxMwcsCE+wtCGSgT6pz9yh7WG50tzEC0wsANdVFo0
	 d4j2Obzs+0xwmvPrnOCLl2VfMWAeOlzYtg5axkmXwHs/P7jn6dSAWtNjFB1nraDhs7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GvOSnwVm0S73R74GAfcXhu/gJBFd+wT7pvhqYM6moaw=;
	b=jzLaraSrcfzISMAx3NxxpD9SGd/dC8Mf8Slk8TikD5KTCcGmtHgrOjgXkPGjaHXyQ5e6
	 oNIJ2u8Ajafo8lksNyjFJ5qnbYGu3YfP4GKuPXiX66KjYyTaxeP4S9hxZDnZdHkWoKFzW
	 84iUQKh0YgxMGCXknPPyRRYpaBxSTNwHn9FO97/g+OpxA9hTXiG/xJK8K67hST3fLVE58
	 IZdMUQsK6DNFuRRa9KxsyVYdAdFvbwV0PKYRTKp+M6JxN8NC2OP1sQrPMZtL10b9z3Zpp
	 wxsk2Tyab89l+JbA5qOx6Ux1gh2WNpK+1lTBSjFY9OhUleDe0cQOhqK+9sbudPzv2/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRWPi6Yb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D36606B5F6;
	Fri, 13 Nov 2026 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRWPi6Yb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B500C1F000C4;
	Fri, 13 Nov 2026 16:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585657;
	bh=GvOSnwVm0S73R74GAfcXhu/gJBFd+wT7pvhqYM6moaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRWPi6YbkTx+tZQQ2pfnuv3g2ndxqpKpTENbIi0kROMag8NSTNitdYieVFcSdWAnK
	 CEAy1giM1N33LO1OQLAQJhcEwHKH+aLcDJJEP2Y4zV+7XBqy+FTMJLzQz+ExOOwwz+
	 gb6ERglyFznQV9KWYNghPJ+zxOsaOyQR32SSbT1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 7.3 271/507] hwrng: virtio - prevent use-after-free after a failed restore
Date: Fri, 13 Nov 2026 10:49:35 -0500
Message-ID: <20261113153803.863701081@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 5e83ffa105e41..a9ff520975a7c 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -190,6 +190,7 @@ static int probe_common(struct virtio_device *vdev)
 err_find:
 	ida_free(&rng_index_ida, index);
 err_ida:
+	vdev->priv = NULL;
 	kfree(vi);
 	return err;
 }
@@ -198,6 +199,11 @@ static void remove_common(struct virtio_device *vdev)
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
@@ -207,6 +213,7 @@ static void remove_common(struct virtio_device *vdev)
 	virtio_reset_device(vdev);
 	vdev->config->del_vqs(vdev);
 	ida_free(&rng_index_ida, vi->index);
+	vdev->priv = NULL;
 	kfree(vi);
 }
 
-- 
2.53.0



