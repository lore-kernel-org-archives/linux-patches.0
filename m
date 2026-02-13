Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5477360723;
	Fri, 13 Feb 2026 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991012; cv=none; b=BXN7+qx9qHH/yuM5Pi/rbWFQAiAj/B5vQJcUNtDAIqM4KxL9l4lmMiry8BwIT3DwNH6bhyt5XNOnGJAanfP/PXCriRagAh9IWaxjuouXGCc3H80OE/wgkd7oWnnVY7mA3fpNKlHDT/FfGkWDmV7A+iiw+2bDCUSO0Fkdn1nCznA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991012; c=relaxed/simple;
	bh=9QtzeyeUUjiQ1nZm7J40BSyPPZgHvhtnM/3wIg1q+vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moTJlUUA/ShfwfKwy7gfsTt4WGGp+DHab9xHaDqMQDVeC86sVzLUt11tn3X1NlSysdBzlFS7l0Ng+REjIshIFoQFutgmMuEb1f7uyl7lcgEW40EVK5HinhmeZDopiTrg3r/uo2PjZGI+lbUi3s+J5WaZkmh2nv+MLxbge6sH9OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sg4wCvR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg4wCvR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14577C116C6;
	Fri, 13 Feb 2026 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770991012;
	bh=9QtzeyeUUjiQ1nZm7J40BSyPPZgHvhtnM/3wIg1q+vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sg4wCvR1FY2gpgpqi0rkVhhEdZ/cCShAQ3oeLkxillwsk9UnDGp8ePeiyUN0Nkmli
	 +wbj18wsl841kmWF7YarV3cbkwDrdXvSl9CeYz6Ltuc16lbubcSQItn60sKHW4mtk7
	 1HSMEYfzSQ0dj0XlZs8SshIBUfdBnYIqEOsJoZJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 08/25] crypto: virtio - Add spinlock protection with virtqueue notification
Date: Fri, 13 Feb 2026 14:48:34 +0100
Message-ID: <20260213134704.189843256@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit b505047ffc8057555900d2d3a005d033e6967382 upstream.

When VM boots with one virtio-crypto PCI device and builtin backend,
run openssl benchmark command with multiple processes, such as
  openssl speed -evp aes-128-cbc -engine afalg  -seconds 10 -multi 32

openssl processes will hangup and there is error reported like this:
 virtio_crypto virtio0: dataq.0:id 3 is not a head!

It seems that the data virtqueue need protection when it is handled
for virtio done notification. If the spinlock protection is added
in virtcrypto_done_task(), openssl benchmark with multiple processes
works well.

Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -77,15 +77,20 @@ static void virtcrypto_done_task(unsigne
 	struct data_queue *data_vq = (struct data_queue *)data;
 	struct virtqueue *vq = data_vq->vq;
 	struct virtio_crypto_request *vc_req;
+	unsigned long flags;
 	unsigned int len;
 
+	spin_lock_irqsave(&data_vq->lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((vc_req = virtqueue_get_buf(vq, &len)) != NULL) {
+			spin_unlock_irqrestore(&data_vq->lock, flags);
 			if (vc_req->alg_cb)
 				vc_req->alg_cb(vc_req, len);
+			spin_lock_irqsave(&data_vq->lock, flags);
 		}
 	} while (!virtqueue_enable_cb(vq));
+	spin_unlock_irqrestore(&data_vq->lock, flags);
 }
 
 static void virtcrypto_dataq_callback(struct virtqueue *vq)


