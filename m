Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304082874FE;
	Wed, 28 Jan 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615885; cv=none; b=bKc5MG8fbTCUKxLtnErWgn4zDOonTl6uvWivV27vkyaVqlPH0TiKKcFVfJjjz1XFLe4z7zhnHC+GmqMI4w1tgLLfNQUuUtEVXGok82at/kzoZGiIoIk40XEn/g5Lw+MtxwiXow9p7OwQGhVgYGMEFaE5Rpw8+2M2wfPT+FD/KOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615885; c=relaxed/simple;
	bh=flV/hm/IpEVVHWxSPcF2BzvM3lmKjS8My0i4X2Eb+S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUazPLXCnIsg+U7z6m2d3N8lwC0lzJ0RNay5zHcU7O2ZgY4Q2OPePAHb4XtLVnqq+fYYPW9iLNHUGoLua/1oYZvMgCD/J1e2t3tiKCly17jr2dqIofx7dP9jCAQs56OCMPscmmHA/KD83RbhpAY3LTso3k5ChjL55eSJzwcbRqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHnm/c2g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHnm/c2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95590C4CEF1;
	Wed, 28 Jan 2026 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615885;
	bh=flV/hm/IpEVVHWxSPcF2BzvM3lmKjS8My0i4X2Eb+S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHnm/c2gq8BlLWEJtjZbyi+S41fSd9ttAwTzcjrl/JOxM58FhC7AzmoUmAqPFwf4q
	 Yunjx4BjTnDBte81odI7Npf5tz6CosVZGNvuvEDs/v/+3ATaiL7Ac/SyIlhvLr+dgR
	 6Pv7lC1qAw13SNhTEbsw2i+cf3JoNz0Kug7edLV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Melbin K Mathew <mlbnkm1@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/227] vsock/virtio: fix potential underflow in virtio_transport_get_credit()
Date: Wed, 28 Jan 2026 16:23:08 +0100
Message-ID: <20260128145349.604523526@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melbin K Mathew <mlbnkm1@gmail.com>

[ Upstream commit 3ef3d52a1a9860d094395c7a3e593f3aa26ff012 ]

The credit calculation in virtio_transport_get_credit() uses unsigned
arithmetic:

  ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);

If the peer shrinks its advertised buffer (peer_buf_alloc) while bytes
are in flight, the subtraction can underflow and produce a large
positive value, potentially allowing more data to be queued than the
peer can handle.

Reuse virtio_transport_has_space() which already handles this case and
add a comment to make it clear why we are doing that.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
[Stefano: use virtio_transport_has_space() instead of duplicating the code]
[Stefano: tweak the commit message]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20260121093628.9941-2-sgarzare@redhat.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 26b979ad71f09..6175124d63d34 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -28,6 +28,7 @@
 
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
 					       bool cancel_timeout);
+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs);
 
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
@@ -499,9 +500,7 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 		return 0;
 
 	spin_lock_bh(&vvs->tx_lock);
-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
-	if (ret > credit)
-		ret = credit;
+	ret = min_t(u32, credit, virtio_transport_has_space(vvs));
 	vvs->tx_cnt += ret;
 	vvs->bytes_unsent += ret;
 	spin_unlock_bh(&vvs->tx_lock);
@@ -877,11 +876,14 @@ u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_has_data);
 
-static s64 virtio_transport_has_space(struct vsock_sock *vsk)
+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs)
 {
-	struct virtio_vsock_sock *vvs = vsk->trans;
 	s64 bytes;
 
+	/* Use s64 arithmetic so if the peer shrinks peer_buf_alloc while
+	 * we have bytes in flight (tx_cnt - peer_fwd_cnt), the subtraction
+	 * does not underflow.
+	 */
 	bytes = (s64)vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
 	if (bytes < 0)
 		bytes = 0;
@@ -895,7 +897,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk)
 	s64 bytes;
 
 	spin_lock_bh(&vvs->tx_lock);
-	bytes = virtio_transport_has_space(vsk);
+	bytes = virtio_transport_has_space(vvs);
 	spin_unlock_bh(&vvs->tx_lock);
 
 	return bytes;
@@ -1492,7 +1494,7 @@ static bool virtio_transport_space_update(struct sock *sk,
 	spin_lock_bh(&vvs->tx_lock);
 	vvs->peer_buf_alloc = le32_to_cpu(hdr->buf_alloc);
 	vvs->peer_fwd_cnt = le32_to_cpu(hdr->fwd_cnt);
-	space_available = virtio_transport_has_space(vsk);
+	space_available = virtio_transport_has_space(vvs);
 	spin_unlock_bh(&vvs->tx_lock);
 	return space_available;
 }
-- 
2.51.0



