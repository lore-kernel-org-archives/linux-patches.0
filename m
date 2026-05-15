Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6117A44105E;
	Fri, 15 May 2026 16:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861801; cv=none; b=s91o7edlOtezSoN44fKZuNteQZWyJSIvvD4Z+uALhOPCVwVi67lE6ZXBPXXhmN2INjtghqg2hUuYrqzOBbt6eGNZS/9nK/yiyoUsCJgiwRm8iHrfVI09sKJBqmO4BCZxN2nqRy2MJFp/PvoS1ar2ZkxpjvHp8JUi7f2/r8YnIzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861801; c=relaxed/simple;
	bh=rzkPZYriuL3eSsvpzoy7guZQn1PNIXje57PrgTMiJhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psje3VKfpYk3hfazwKnNzzlV/lYJQtoDcXtpAPyzSURr2hx1FMutQnu66nVjJe5BRWkBVMws6zxmEAPERI+C4yzK2bLM0Ix8IJSIzaHTdhq83ttytAI60XKdppoWNREhpqN3VOIvVNyXoHFNzLHylohUVKD7I7rcnoAnkCsTcqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHsBfuwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHsBfuwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDF9C2BCB0;
	Fri, 15 May 2026 16:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861801;
	bh=rzkPZYriuL3eSsvpzoy7guZQn1PNIXje57PrgTMiJhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHsBfuwgPqSEhQ6Q2sMxp4KcHR8FJbQjN/0XV2aMeF+kQ7ePMsX7vWT/rZB+h6D58
	 aF9e4fa/bK6huSMhUcKlibBd3n1XGtYejlQcm0aJwyPD+JLCX1/tjGUEWn4PvxuqvC
	 hUFvYsgrfKTPZb3tKIbdOwk4tJ4bOXcXH03FsuTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Arseniy Krasnov <avkrasnov@rulkc.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 6.6 466/474] vsock/virtio: fix length and offset in tap skb for split packets
Date: Fri, 15 May 2026 17:49:35 +0200
Message-ID: <20260515154725.188310533@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

commit 5f344d809e015fba3709e5219428c00b8ac5d7df upstream.

virtio_transport_build_skb() builds a new skb to be delivered to the
vsockmon tap device. To build the new skb, it uses the original skb
data length as payload length, but as the comment notes, the original
packet stored in the skb may have been split in multiple packets, so we
need to use the length in the header, which is correctly updated before
the packet is delivered to the tap, and the offset for the data.

This was also similar to what we did before commit 71dc9ec9ac7d
("virtio/vsock: replace virtio_vsock_pkt with sk_buff") where we probably
missed something during the skb conversion.

Also update the comment above, which was left stale by the skb
conversion and still mentioned a buffer pointer that no longer exists.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Arseniy Krasnov <avkrasnov@rulkc.org>
Link: https://patch.msgid.link/20260508164411.261440-2-sgarzare@redhat.com
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[LL: Fixed conflict since this tree does not use the offset added by commit
 0df7cd3c13e4 ("vsock/virtio/vhost: read data from non-linear skb")]
Signed-off-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -122,12 +122,12 @@ static struct sk_buff *virtio_transport_
 	size_t payload_len;
 	void *payload_buf;
 
-	/* A packet could be split to fit the RX buffer, so we can retrieve
-	 * the payload length from the header and the buffer pointer taking
-	 * care of the offset in the original packet.
+	/* A packet could be split to fit the RX buffer, so we use
+	 * the payload length from the header, which has been updated
+	 * by the sender to reflect the fragment size.
 	 */
 	pkt_hdr = virtio_vsock_hdr(pkt);
-	payload_len = pkt->len;
+	payload_len = le32_to_cpu(pkt_hdr->len);
 	payload_buf = pkt->data;
 
 	skb = alloc_skb(sizeof(*hdr) + sizeof(*pkt_hdr) + payload_len,


