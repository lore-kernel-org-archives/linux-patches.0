Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359051A618E;
	Tue, 30 Jul 2024 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356599; cv=none; b=QZDwfRfUocZ/d2R7p2hChAk15rmTQFjV0ODwOQMXNlRo0C1k7fvX+DqZHyMOVFPgFNFednLT1QGmaSVXWoFRyOBktEXD6htS/wBf+gyNzAzJpM3Vee4JBb0drTWwexqsA2a9CTiKjH4JVg3SMz+N4oom67vbvUbTUUjLDPlAC3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356599; c=relaxed/simple;
	bh=Wpg/ri5j+fLytzS3EvqnQKKLmzyMQP+pWYtOss0uk9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Go8j8ddzo+Xj4dbYDcx3CuKPDR75/pUY+rLo9ZEtmTobTLvnRcCJSxmXT55nxNQwqbJFd55azF7Blzlvvty3sQiAwEulJJ6mXWeFPTl2ojeA2Tuk/cV/+cQrO84gy0rEroWwrQKHlJ5a8CbMK8r9eqGzpz155V2jDEkjdEaoyhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrghPUI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrghPUI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7699FC4AF0A;
	Tue, 30 Jul 2024 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356599;
	bh=Wpg/ri5j+fLytzS3EvqnQKKLmzyMQP+pWYtOss0uk9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrghPUI42pIqI9lI9zXcTx0Gb+GIbXNl0DpKrC9TS6xV72CM9oa3zaJPTK7Bwa7KI
	 2HQCwe28NO8+hrTdiTRnTBdhtvGDFX/UooMqBFcraZ2wwp84TTOeXlAK0NnsH4vOdb
	 HUa1nHV2vUxC7cLD6kgXasinAvK1IEhO5qF6yXjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Arseny Krasnov <arseny.krasnov@kaspersky.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/440] vhost/vsock: always initialize seqpacket_allow
Date: Tue, 30 Jul 2024 17:47:24 +0200
Message-ID: <20240730151624.107459159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 1e1fdcbdde3b7663e5d8faeb2245b9b151417d22 ]

There are two issues around seqpacket_allow:
1. seqpacket_allow is not initialized when socket is
   created. Thus if features are never set, it will be
   read uninitialized.
2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
   then seqpacket_allow will not be cleared appropriately
   (existing apps I know about don't usually do this but
    it's legal and there's no way to be sure no one relies
    on this).

To fix:
	- initialize seqpacket_allow after allocation
	- set it unconditionally in set_features

Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
Reported-by: Jeongjun Park <aha310510@gmail.com>
Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
Tested-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20240422100010-mutt-send-email-mst@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 1f3b89c885cca..c00f5821d6ecb 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -654,6 +654,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	}
 
 	vsock->guest_cid = 0; /* no CID assigned yet */
+	vsock->seqpacket_allow = false;
 
 	atomic_set(&vsock->queued_replies, 0);
 
@@ -797,8 +798,7 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 			goto err;
 	}
 
-	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
+	vsock->seqpacket_allow = features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET);
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
-- 
2.43.0



