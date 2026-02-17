Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB1D37646D;
	Tue, 17 Feb 2026 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361065; cv=none; b=W/4Rp96cNQwIboCwiCa6bHIBa8IOYUaPqc6LigfyDHITctl3DlwrqNCzk9h0S2BGz2efu97z552nrX6KytJOq0ZAmskR5arm6N1EyKhwfRgjZfQaJx6PJJx6ile2IcMXA/r+h+0UR4StBcVMkmJltmysIGhYwH+ZbCbJIOWPs2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361065; c=relaxed/simple;
	bh=QEf0xssPl6WIPilAc03XghxvEHqumnVMeaRUc6/Q6ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5wQg8PfLP7a3QWpQICu7x1oICea52uy9NKIyNLT4YZCuDQQ2RhYgz1cIQyZ5Rrhy2JeoKpuFXIUFVmn1ZRSQJqYV3DCf7BuiiRCg40gBAEBEqNTRMi2T56dN3EJGnHt36L+Sq/rj1tPGA4e5pxrUiO8rcubEoqiiYleo1q/WSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K55Uo5rI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K55Uo5rI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F11C4CEF7;
	Tue, 17 Feb 2026 20:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361065;
	bh=QEf0xssPl6WIPilAc03XghxvEHqumnVMeaRUc6/Q6ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K55Uo5rIvUnTmEtO5dO3QPmIUk38MzVlS0G1Zu6pP9XSkQVe1ZjEIpUAU+2bZKUBe
	 9PueuPloFRrmouhnxFMaz/VIzfaHz9RvdQpEdsKcLMAZ9DKRyKIj2EjZcckt7rs93A
	 kHIB7altwY8FYjr3BROCmgkbpe5bsWBjH+8RWxY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 03/39] crypto: virtio - Add spinlock protection with virtqueue notification
Date: Tue, 17 Feb 2026 21:31:12 +0100
Message-ID: <20260217200003.061572396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -27,15 +27,20 @@ static void virtcrypto_done_task(unsigne
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


