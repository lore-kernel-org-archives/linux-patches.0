Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3F7367F42;
	Wed, 28 Jan 2026 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615147; cv=none; b=un3jy0GFGZTzmaiQrzevd1v8DKmOCr8uAJcpoPzoKGkckrdVBFo+fbTgez9XlIPKM/SJmeBmvLL8G5bKzhbE6jvUs5jS90XOi7uWPRNATMhhARMXett8dVfxz3sElLul/J4D4rOTc0GAHW4c4RSpv6RBQJO4zf9QZrAf98Q1icI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615147; c=relaxed/simple;
	bh=Y9X1BD488DY2vdsmyNjo8FE+snTmIRVDOFEquCfAp6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfq5aka+vH2LUF3gDE7czAn9lPHAg/YNWLd3WYpMAnqhOi/ChA4Z4Ii0KJPfMsqcoE0O4O1QTcIq8Ryk87sbySCkRS/FxTD0c6hy1F1lM1ues2iZ1jAB+VlcwvzIRa4SltwWUV4IyNEl9qxWJH4KzUJU/KduUi38xXr1d5hC/AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zB4sjlaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zB4sjlaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B09C4CEF1;
	Wed, 28 Jan 2026 15:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615147;
	bh=Y9X1BD488DY2vdsmyNjo8FE+snTmIRVDOFEquCfAp6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zB4sjlafuKh7DTj/XSOUSpuVT84z02W0HObi6lyYAn9xHdHrU3cMHMkJXMSf2KUxF
	 8PDPsQVPMn2PTKdXCH5KDD4RNdQCgp2fogz9GiU0ssXgbMgQi6TovtokQbaRV3TBW8
	 yN58pwC6S2yYlrf55gTw9VHqPJtPg8SzUD7YYoLY=
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
Subject: [PATCH 6.12 093/169] vsock/virtio: fix potential underflow in virtio_transport_get_credit()
Date: Wed, 28 Jan 2026 16:22:56 +0100
Message-ID: <20260128145337.353888450@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4e8a9771a04d6..dfb8cad4259c2 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -28,6 +28,7 @@
 
 static void virtio_transport_cancel_close_work(struct vsock_sock *vsk,
 					       bool cancel_timeout);
+static s64 virtio_transport_has_space(struct virtio_vsock_sock *vvs);
 
 static const struct virtio_transport *
 virtio_transport_get_ops(struct vsock_sock *vsk)
@@ -497,9 +498,7 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 		return 0;
 
 	spin_lock_bh(&vvs->tx_lock);
-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
-	if (ret > credit)
-		ret = credit;
+	ret = min_t(u32, credit, virtio_transport_has_space(vvs));
 	vvs->tx_cnt += ret;
 	vvs->bytes_unsent += ret;
 	spin_unlock_bh(&vvs->tx_lock);
@@ -875,11 +874,14 @@ u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
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
@@ -893,7 +895,7 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk)
 	s64 bytes;
 
 	spin_lock_bh(&vvs->tx_lock);
-	bytes = virtio_transport_has_space(vsk);
+	bytes = virtio_transport_has_space(vvs);
 	spin_unlock_bh(&vvs->tx_lock);
 
 	return bytes;
@@ -1507,7 +1509,7 @@ static bool virtio_transport_space_update(struct sock *sk,
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



