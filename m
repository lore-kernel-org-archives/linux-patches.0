Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63A1154441;
	Tue, 23 Jan 2024 00:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969384; cv=none; b=tRj8t2rNHCYpPE3DCIiIRdB7ofnsxzcp69G+OIhLcRFEv/xLBbc+LBlhcyg4KM4v30x5Ek6E2sIGoMDgIhzc9PMdwQAys+FLGButPgl40EdS7fuQUIAK8Cq38R4aiUa0X61wNOeq5iFMdJSRPIlsC2ydiFQJahtlC+akbnQZyVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969384; c=relaxed/simple;
	bh=SZX2+5ZmSUOzADCvx7hRSjLTT6qLTEMaj++IWHp1Pg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArOQNNKljYdDilvTql5k+JHLOMrJUsgjKAW8Bl94+qL9NokNEgJG7E+mYx6VXSZWv3BFipUJTyX4CuPsQf7WTcyrl0u5EgYH0+3OFrHnSPNxi2il+NN9PB+S7B++Zo5AWH3EBSTljkfKKiMskuULdB4CBzX7MEWQUP6qQu1Qhkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVOwkeWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVOwkeWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6540BC433F1;
	Tue, 23 Jan 2024 00:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969384;
	bh=SZX2+5ZmSUOzADCvx7hRSjLTT6qLTEMaj++IWHp1Pg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVOwkeWgx45F0ApqISF5dwadXb9CepeaeL4GvrfjPYH3M8Mc01gmPwzStx8ZZi7Vt
	 29op4VODXoCrd6HJfVFKOXsiKpL9RnptTOgQ2Nz9LLqPskgBuxao5Xhek5SLQ+b1NN
	 AsUyp9jgDR08dbOOL7hKLNFzaXNo6wRGmFAinsRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 186/641] virtio/vsock: fix logic which reduces credit update messages
Date: Mon, 22 Jan 2024 15:51:30 -0800
Message-ID: <20240122235823.801583342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 6df246b53260..b35306dfcebe 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -557,6 +557,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	size_t bytes, total = 0;
 	struct sk_buff *skb;
+	u32 fwd_cnt_delta;
+	bool low_rx_bytes;
 	int err = -EFAULT;
 	u32 free_space;
 
@@ -600,7 +602,10 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		}
 	}
 
-	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
+	fwd_cnt_delta = vvs->fwd_cnt - vvs->last_fwd_cnt;
+	free_space = vvs->buf_alloc - fwd_cnt_delta;
+	low_rx_bytes = (vvs->rx_bytes <
+			sock_rcvlowat(sk_vsock(vsk), 0, INT_MAX));
 
 	spin_unlock_bh(&vvs->rx_lock);
 
@@ -610,9 +615,11 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
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



