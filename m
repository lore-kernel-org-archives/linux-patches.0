Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C160275;
	Tue, 23 Jan 2024 00:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970837; cv=none; b=ATfuzIvirj8OlyIPafkX04L3I7QnhtbfBe5PrDNoHxuAs2dgg2XPyeNDEZ2LSKr0QNsI0++fPblxgcf2zcoF+qMorObxtwx5kKE0ACioLj95pAT/15yZKxZFq7OMNCKosWaypH//M3sGOnxyqtRzzp3wblX5at2PP/XFvK4W0aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970837; c=relaxed/simple;
	bh=dcW9sC5h6ZTvl+06Z0e3grlDUKZdcnnc6EgAr/veVlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elsMgSW22k6LNrK8ruO+AmgJreeRxJC/lgBbgkR8ygXQ4iize/Od5fVOjzN+eL2avKj7abkmnLzW3M8+2r3HcS1YuTFGGCykZfqUP/pLbn712mpGLsUeJapwKazxSLHfu7cH34DrdPj+b1Pko1EZF3pSH82QCdKeyRi2ofk6Upg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTP67zTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTP67zTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35679C43390;
	Tue, 23 Jan 2024 00:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970837;
	bh=dcW9sC5h6ZTvl+06Z0e3grlDUKZdcnnc6EgAr/veVlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTP67zTAn2lH1W8deYbdAWmdU4+D/c1cYiubTlzym7CyhxU2P1pWn2YksyV/tUoTH
	 UjxbUJRpDEG9HnVGdoRXsTd+UoY9XkhB0idaMLo21Y+6ptOHtPwtvteVYqAXrc0a3P
	 A3VQECCFd+H/+pzMyVJGstZwB9uQpTArr37enJLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/417] virtio/vsock: fix logic which reduces credit update messages
Date: Mon, 22 Jan 2024 15:54:50 -0800
Message-ID: <20240122235756.026460825@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

[ Upstream commit 93b80887668226180ea5f5349cc728ca6dc700ab ]

Add one more condition for sending credit update during dequeue from
stream socket: when number of bytes in the rx queue is smaller than
SO_RCVLOWAT value of the socket. This is actual for non-default value
of SO_RCVLOWAT (e.g. not 1) - idea is to "kick" peer to continue data
transmission, because we need at least SO_RCVLOWAT bytes in our rx
queue to wake up user for reading data (in corner case it is also
possible to stuck both tx and rx sides, this is why 'Fixes' is used).

Fixes: b89d882dc9fc ("vsock/virtio: reduce credit update messages")
Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 2e25890ca52d..9983b833b55d 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -366,6 +366,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	size_t bytes, total = 0;
 	struct sk_buff *skb;
+	u32 fwd_cnt_delta;
+	bool low_rx_bytes;
 	int err = -EFAULT;
 	u32 free_space;
 
@@ -400,7 +402,10 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		}
 	}
 
-	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
+	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
+	free_space = vvs->buf_alloc - fwd_cnt_delta;
+	low_rx_bytes = (vvs->rx_bytes <
+			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
 
 	spin_unlock_bh(&vvs->rx_lock);
 
@@ -410,9 +415,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	 * too high causes extra messages. Too low causes transmitter
 	 * stalls. As stalls are in theory more expensive than extra
 	 * messages, we set the limit to a high value. TODO: experiment
-	 * with different values.
+	 * with different values. Also send credit update message when
+	 * number of bytes in rx queue is not enough to wake up reader.
 	 */
-	if (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
+	if (fwd_cnt_delta &&
+	    (free_space < VIRTIO_VSOCK_MAX_PKT_BUF_SIZE || low_rx_bytes))
 		virtio_transport_send_credit_update(vsk);
 
 	return total;
-- 
2.43.0



