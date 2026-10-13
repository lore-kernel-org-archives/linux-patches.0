Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D01198A17;
	Tue, 13 Oct 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895732; cv=none; b=D2OIIVGmHMX9BMhyFydfwtlMIwzcoH6BrfVfpZpOOu+s2cfDhh7YOHVcYkCsvu5yj9+H2r9DMDfnvbF0y/yXlpijJC705echK7joaqQnjW4SSI5OzF2SAQ6QDi8jvbTm/O3qrGmIH1jiz2taEryvHsBzIWXOAU71L7PR8NRBuQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895732; c=relaxed/simple;
	bh=aTh9aJdFqUyIfFVrJmnH1WjP0gLm3xme3dc3qtCFk/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqWVadwcmYYq/BrnVVA75ECXWGNMEO6IQFjsjDUR+rFwm6jqJX6JWqwu+DMed1C7TWBSuYplc5YjBIeYohK+wGolwKFWpKt65i+LuXVMD2TZ9x9ivjS8jQyyUdGq8/O1jq/wViMMb7exnHhsV3mF3vzzp067u9nPFTiDvKWXzko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wRTWeoV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wRTWeoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444891F000FF;
	Tue, 13 Oct 2026 12:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895731;
	bh=zfrpYJz8/4nYnXYKoeXcYD+88vhiNKheZ4Kls41CI/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wRTWeoVjjgxIAkFD2FtEfgqdMk/dmguxaUvpzkmMrCiCZFxMPgc24tTVIW155zkz
	 CIzEahlrSwLt60Yi375jIxIzGy7B4R5D3CEinh1A50ZODyiEKpucEmqX8wqccwCJcu
	 pVVhjxoHjWOZ6RcpZgdq2s5LaVbewJXUEyDmZKq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luigi Leonardi <leonardi@redhat.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 367/497] vsock/virtio: account only unread bytes in read_skb()
Date: Tue, 13 Oct 2026 13:38:54 +0200
Message-ID: <20261013112916.611857283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1921,6 +1921,7 @@ int virtio_transport_read_skb(struct vso
 	struct sock *sk = sk_vsock(vsk);
 	struct virtio_vsock_hdr *hdr;
 	struct sk_buff *skb;
+	u32 bytes_read;
 	u32 pkt_len;
 	int off = 0;
 	int err;
@@ -1940,7 +1941,8 @@ int virtio_transport_read_skb(struct vso
 		vvs->msg_count--;
 
 	pkt_len = le32_to_cpu(hdr->len);
-	virtio_transport_dec_rx_pkt(vvs, pkt_len, pkt_len);
+	bytes_read = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->offset;
+	virtio_transport_dec_rx_pkt(vvs, bytes_read, pkt_len);
 	spin_unlock_bh(&vvs->rx_lock);
 
 	virtio_transport_send_credit_update(vsk);


