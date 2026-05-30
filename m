Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0535634A3C4;
	Sat, 30 May 2026 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162250; cv=none; b=JklfoLJLfhox2DARiF8ZgeNURPTAQM9JOgzH3g385J/iZ4rGfoKP2tUKUMoAMH+LZXCyNrCGbpb8k9ymxaVDFVMpxHSp0GEy/vSHD1BYnwJ2XkM/d2GPMX8DQs2ukOKXDW0Wef7cnKcgcRIrS99rkAsmNAEOZ/cAzapCjBWs/J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162250; c=relaxed/simple;
	bh=u/MIDZ60KTpUITUcSI2mGGSis2gGQ5surOOxka58dvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFXtNH+D8j21+Ut7TG2/TwR8Bla6t+dWxLeLBgF28UCIvFAVQFPPzzQ4uoiSNVevIQh8UYx5GTwA2V4nZ5/ly+7w3JObqitIq1id0caD0ohc+zI/854Y1yWet4cs/ZiN7whhdtOmKbnQnrv9hlUL7mEtxS5s/a/xa8NdqDx6/Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUTLWQcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUTLWQcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341F11F00893;
	Sat, 30 May 2026 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162248;
	bh=kQei8TwUkYaEYMX+EX+nScn53Hgd9G7IwnFSwASBKSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUTLWQcOfGFLgvywL+zG0FcoDFAgMm9BPBALFBK2ABKSpYUsmM+1aqWAffRTeM5NT
	 bRgLqt+mV9ipmR5f6QxdoMvrIAxfvn3ss0cNeZjnvGtlSWV36oXeqe+k4k/CLOusM3
	 sPcs6w+Fv+O+hUl96DUQ2kbw7DA+Bcy0mLDqYOOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 858/969] vsock/virtio: reset connection on receiving queue overflow
Date: Sat, 30 May 2026 18:06:22 +0200
Message-ID: <20260530160324.362729881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

commit a4f0b001782b21663d10df983b4b208195bec66c upstream.

When there is no more space to queue an incoming packet, the packet is
silently dropped. This causes data loss without any notification to
either peer, since there is no retransmission.

Under normal circumstances, this should never happen. However, it could
happen if the other peer doesn't respect the credit, or if the skb
overhead, which we recently began to take into account with commit
059b7dbd20a6 ("vsock/virtio: fix potential unbounded skb queue"),
is too high.

Fix this by resetting the connection and setting the local socket error
to ENOBUFS when virtio_transport_recv_enqueue() can no longer queue a
packet, so both peers are explicitly notified of the failure rather than
silently losing data.

Fixes: ae6fcfbf5f03 ("vsock/virtio: discard packets if credit is not respected")
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260518090656.134588-2-sgarzare@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1063,7 +1063,7 @@ destroy:
 	return err;
 }
 
-static void
+static bool
 virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 			      struct sk_buff *skb)
 {
@@ -1078,10 +1078,8 @@ virtio_transport_recv_enqueue(struct vso
 	spin_lock_bh(&vvs->rx_lock);
 
 	can_enqueue = virtio_transport_inc_rx_pkt(vvs, len);
-	if (!can_enqueue) {
-		free_pkt = true;
+	if (!can_enqueue)
 		goto out;
-	}
 
 	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
 		vvs->msg_count++;
@@ -1119,6 +1117,8 @@ out:
 	spin_unlock_bh(&vvs->rx_lock);
 	if (free_pkt)
 		kfree_skb(skb);
+
+	return can_enqueue;
 }
 
 static int
@@ -1131,7 +1131,17 @@ virtio_transport_recv_connected(struct s
 
 	switch (le16_to_cpu(hdr->op)) {
 	case VIRTIO_VSOCK_OP_RW:
-		virtio_transport_recv_enqueue(vsk, skb);
+		if (!virtio_transport_recv_enqueue(vsk, skb)) {
+			/* There is no more space to queue the packet, so let's
+			 * close the connection; otherwise, we'll lose data.
+			 */
+			(void)virtio_transport_reset(vsk, skb);
+			virtio_transport_do_close(vsk, true);
+			sk->sk_err = ENOBUFS;
+			sk_error_report(sk);
+			vsock_remove_sock(vsk);
+			break;
+		}
 		vsock_data_ready(sk);
 		return err;
 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:


