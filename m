Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E5B4F390D;
	Tue, 13 Oct 2026 12:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892869; cv=none; b=BdbdVjC/UFjQECX3+7t9cHst2IMSH13YGOV+WQsmLacEyLHJsbhxdnlDp0maCuObzYd2BdJ0sB3diJ49EaHGhC989PaT8DFx4ZKXEr4d1W+VZjEcU20q2bShkbvAJNcnvPRgkcTuUE0Cn1a+/mk6/NNHM8BcxjhPVmUqcCI4dbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892869; c=relaxed/simple;
	bh=6E2Ipt20h2EvgMCYR1Xu75FCNKHz2928JVjRF4qhBEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmWut9cELe3mKDXlIlwdwpo2ywQy1Afzav52hla8M1wwlnvbBxQP9NX157hyhnjuVVtIxAf8ngkatvn0I3Op/7LxCXmiIwYrA26dzJq40krzrC8afS5WY6tKhCYVHO6Ayab5aKy4m6jqap0TEf/T/j1Ws0+hc5lv5RQPAEMwqN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOxuGbrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOxuGbrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9C41F000FF;
	Tue, 13 Oct 2026 12:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892868;
	bh=/OC9lGh52jm1RLsyvenRcl+uD0G/noM7QlRl4cPyfyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOxuGbrq2+je2DUUv6cgttCJZ+Ps67Z6WsdBKQ4bcNxNQdgKq7FHsivF4ArgHC2Iu
	 WpH1l/ZzwD3Nxq84o5IxbA8fZs5iY2Muqw6SP2+ahgVIkC2zc1WGU0l1CK5pGH0G3F
	 l92aaV1T/658wdfhZkQjnNW5Z0SHbp/vH5o3+wj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 035/621] vsock/virtio: account only unread bytes in read_skb()
Date: Tue, 13 Oct 2026 13:30:30 +0200
Message-ID: <20261013112921.699270128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit a463f55c791b96cfd12df8b10ea737d45c80bb18 upstream.

After a partial stream receive, rx_bytes tracks the unread suffix while
buf_used and peer credit still cover the whole packet.
virtio_transport_read_skb() dequeues that packet but passes pkt_len for
both counters, underflowing rx_bytes.

On a connected CID_LOCAL stream with an SK_SKB verdict, a 40-byte read
from a 100-byte packet made SIOCINQ report -40, an empty recv return
ELOOP, and poll report the empty socket readable.  After verdict detach,
receiving 40 bytes wrapped the counter to zero and hid those queued bytes
until one more byte arrived.  The fixed run kept the counter balanced
and exposed all queued data immediately.

This was found during an LLM-assisted manual source audit of VSOCK
receive accounting while re-evaluating virtio_transport_read_skb() after
CVE-2024-50169.

Subtract only skb->len minus the VSOCK offset from rx_bytes.  Retain the
full packet length for buf_used and peer credit.

Fixes: 45ca7e9f0730 ("vsock/virtio: fix `rx_bytes` accounting for stream sockets")
Cc: stable@vger.kernel.org
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/20261001151310.4101006-1-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1903,6 +1903,7 @@ int virtio_transport_read_skb(struct vso
 	struct sock *sk = sk_vsock(vsk);
 	struct virtio_vsock_hdr *hdr;
 	struct sk_buff *skb;
+	u32 bytes_read;
 	u32 pkt_len;
 	int off = 0;
 	int err;
@@ -1922,7 +1923,8 @@ int virtio_transport_read_skb(struct vso
 		vvs->msg_count--;
 
 	pkt_len = le32_to_cpu(hdr->len);
-	virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
+	bytes_read = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->offset;
+	virtio_transport_dec_rx_pkt(vvs, bytes_read, pkt_len);
 	spin_unlock_bh(&vvs->rx_lock);
 
 	virtio_transport_send_credit_update(vsk);


