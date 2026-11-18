Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039021;
	b=cGddI2byk4UCbhUwGyurGEP3HkEa+TLMLQPxs8zQ4DIZ9Hd+twV4ycxeRk2i/2+9kbAW
	 lo0aOH6w57ljgDrGGt0rYm+z3+WpN8uICO+h+SnRIwC6Qpg9RPzBqWKavPMGBzTEa6bvZ
	 t/fG0+Basth2NiSgficiZ7ybVLoRlnkO6kBHY/nRU2kvY88CRoO0a5nG5JMdjgXfHPovO
	 FziVv89pou3djjYDW7UNyyim3KNayF2wDcydZOnC8apA5bfN8o9dM3TBnvw2LsF/6YI3w
	 cLVWHoL9638WJZ3WG4Li5vKTs108G5oC/o2jEQgXlNvQpowG2hwS+bUf1RPxP0P+z0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qbEsZ79yEWqZeKrtFeWYk29efeU7iy11BjuoiNdBilI=;
	b=0xoR+zL0wmWobpFtQBC9qMkAyB1Epk2hfKQsVi7OtH9QHEZMDa21+cJ6gLJLW5Lf7LMR
	 jLeJAbALgwMOwlcSCLYis5jWPQEmZl5HhzxGtasMddU1XBH5NikPMmGAaW5WhCOp4esp9
	 1usLr/fYr7TpPUeBDb+KisLC07ag+fd/WcLh3HWLCEV5cq26+KQdboSwGZB+rUXS47pVm
	 xkFHdgS8u9LYXM73/87fsWE4ihYzXxXIzsXKuXIfw5TgNOGI0ydEX5NuC48L20N0ti3XL
	 tRILKVYa3XEdPn3cNNArPqni4+MJElLG7ew2nehTKtgDG0nUJrheCTPmVM4+0II0Y5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzEudfYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7655A606A31C;
	Wed, 18 Nov 2026 21:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzEudfYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F141F000C5;
	Wed, 18 Nov 2026 21:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039021;
	bh=qbEsZ79yEWqZeKrtFeWYk29efeU7iy11BjuoiNdBilI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzEudfYDiRUkQG5k5GsBQLqaa8S+f1k+6rF7Q0Wi1ehx8PtJiLIytjwEuu54Yd61+
	 /aW4o0nDT53ONsuM37mKA+isS2WYNwS3cmelnhVk37BqT6tjomDJjsD06kKLSmI5RV
	 dCZ4TtzuZuwTtam2Ofw9yo5+XZOSHejYcbYcn/c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 6.6 1950/3318] hwrng: virtio - prevent use-after-free after a failed restore
Date: Wed, 18 Nov 2026 15:42:52 +0100
Message-ID: <20261118150420.573551558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 65984504a3ca9..3b47bf1a65f51 100644
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



