Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E5E11CAB
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F794C433C0;
	Mon, 26 Jun 2023 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804945;
	bh=AZ8Q9VAYM223LUexf8dbA47go9hxrVRQN86tSdl0m4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OM0qSChmo2neHqiOOw/Q5/4EX9jPpGzbZ/p4sLUJp/lZSW8SjCf4Qw6S/YK6hyQAL
	 MyONT6sR+i4shyUmQu5C5f6wer9ruBa3PWcXCwj3b79arzXtvO6j6ShTG/Enpo7ryb
	 FrgHlXEKxaAuw0lEXPXCep2Yei1UcDF7rsTgK1Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Smetanin <asmetanin@yandex-team.ru>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 94/96] vhost_net: revert upend_idx only on retriable error
Date: Mon, 26 Jun 2023 20:12:49 +0200
Message-ID: <20230626180750.967675598@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
References: <20230626180746.943455203@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrey Smetanin <asmetanin@yandex-team.ru>

[ Upstream commit 1f5d2e3bab16369d5d4b4020a25db4ab1f4f082c ]

Fix possible virtqueue used buffers leak and corresponding stuck
in case of temporary -EIO from sendmsg() which is produced by
tun driver while backend device is not up.

In case of no-retriable error and zcopy do not revert upend_idx
to pass packet data (that is update used_idx in corresponding
vhost_zerocopy_signal_used()) as if packet data has been
transferred successfully.

v2: set vq->heads[ubuf->desc].len equal to VHOST_DMA_DONE_LEN
in case of fake successful transmit.

Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>
Message-Id: <20230424204411.24888-1-asmetanin@yandex-team.ru>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 32148f0112004..00f10d3402590 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -933,13 +933,18 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
+			bool retry = err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS;
+
 			if (zcopy_used) {
 				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
 					vhost_net_ubuf_put(ubufs);
-				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
-					% UIO_MAXIOV;
+				if (retry)
+					nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
+						% UIO_MAXIOV;
+				else
+					vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
 			}
-			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
+			if (retry) {
 				vhost_discard_vq_desc(vq, 1);
 				vhost_net_enable_vq(net, vq);
 				break;
-- 
2.39.2



