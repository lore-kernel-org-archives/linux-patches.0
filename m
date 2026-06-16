Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DCC3BE650;
	Tue, 16 Jun 2026 16:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626459; cv=none; b=VZ8YvXvl5QFbHbH1TOncc6wnDgUuTlblhIoDKQk0SE/GYJQN3NR1vMs93m/RpgEq+Hs/ZBnb9/UHUFfZG46LjVNsqifQ2Hw0RGEEQc/IUagvZCsv4D2/AEzp35IzSQSCj6CC3kMKDXG1+5cE5V/ySyplQmKH8OF+WDKEbwPKlP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626459; c=relaxed/simple;
	bh=KhGJnAES7iqBw7FnmICDZHh0j6KaFvyQH3xaJr87EWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Na6M/vm5uzmt7I+jhx3aqHfPvUj55siZaw/EMpidvRywwgjMLAFaMrEZScPC1H1k/X08MwemdbbGL+NMOWiZjkPU0mPD+f2Hip59ep61jcVPUsA1GVYSs/oMCDZJVUrbI9UK66bWIpEzZnX2eD6F5S+tioCz/MbaC5TIig+1eb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDIJsOJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDIJsOJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DCA1F000E9;
	Tue, 16 Jun 2026 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626458;
	bh=LsNEOL5KvEjsyaQoUkDUibU/flXfH4w7AzxDCTehK1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDIJsOJfOi3QB0Z1ofoERLnKb8cHGtNrLFfKRFU+ngkS3WilTlMX6ZOGVfFEAS8Dx
	 fyviedGmRvh+3AObOYhnnObajHW927wGRx833lwD5UQJNUdMQgkfZcEOAaeAZGYRTi
	 sSFSXnSpQe5ZDUHarzp23BxWVFumA/Oy1rndPd2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 318/325] vsock/virtio: fix potential unbounded skb queue
Date: Tue, 16 Jun 2026 20:31:54 +0530
Message-ID: <20260616145114.923242115@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 059b7dbd20a6f0c539a45ddff1573cb8946685b5 upstream.

virtio_transport_inc_rx_pkt() checks vvs->rx_bytes + len > vvs->buf_alloc.

virtio_transport_recv_enqueue() skips coalescing for packets
with VIRTIO_VSOCK_SEQ_EOM.

If fed with packets with len == 0 and VIRTIO_VSOCK_SEQ_EOM,
a very large number of packets can be queued
because vvs->rx_bytes stays at 0.

Fix this by estimating the skb metadata size:

	(Number of skbs in the queue) * SKB_TRUESIZE(0)

Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: "Eugenio Pérez" <eperezma@redhat.com>
Cc: virtualization@lists.linux.dev
Link: https://patch.msgid.link/20260430122653.554058-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -425,7 +425,9 @@ static int virtio_transport_send_pkt_inf
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
 					u32 len)
 {
-	if (vvs->buf_used + len > vvs->buf_alloc)
+	u64 skb_overhead = (skb_queue_len(&vvs->rx_queue) + 1) * SKB_TRUESIZE(0);
+
+	if (skb_overhead + vvs->buf_used + len > vvs->buf_alloc)
 		return false;
 
 	vvs->rx_bytes += len;


