Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CA23FD94E;
	Fri, 15 May 2026 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862474; cv=none; b=WpV31f7yyMN5Zcc5Tv2AsPAw1LTGmhgg/akjQTXkR69fyiwW7COp6p1eSB3QPO690VaUTTLl37uP876AS/zxd2pDcKad+h+C5XS8VwdCgFShSrQ80p3Al/YTIIH91NaZZVxZXHpnqT81ZGk93dxYR5LMn0VqjacAb6NU5wfPbtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862474; c=relaxed/simple;
	bh=7JXJ0NjYxv5S0qInRgXQzz1t/SJOFpdqpiWt2G+bKkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9As5J7Wn1582vTsV/cUtYM5xMvHVSUY9MgYPgJ3cGwO9drwUZER+vDOH8K7Fg9hA0ff37nv5XYeKhcsyPEeEIi8E+CV2pDc+K0GeuLKHfITIs9jgo4KbeXP7uJ5Y+Dvt9aea9Km7/UnWmfT2riOFsWomhwMIEqKxCfMzLSrzOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlP4xXVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlP4xXVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E773C2BCC7;
	Fri, 15 May 2026 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862474;
	bh=7JXJ0NjYxv5S0qInRgXQzz1t/SJOFpdqpiWt2G+bKkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlP4xXVxYejxSzIsa686GVOiKZh9JKRDNg09X1st54ywwnysObZK96yakJ7RpkBhG
	 +hK4hIk/24KrZtjVaSO6H3QCCkuCgbxUOp5eLSNm7xKeo3p4+gnAHvyYoLSfSmICFm
	 dz7qzxs9DYJIHd5nw7c6t1uBS9k7vjR2aC3dUjLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 062/201] vsock/virtio: fix MSG_PEEK ignoring skb offset when calculating bytes to copy
Date: Fri, 15 May 2026 17:48:00 +0200
Message-ID: <20260515154659.879228939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luigi Leonardi <leonardi@redhat.com>

commit 080f22f5d30233faf3d83be3098f35b8be9b7a00 upstream.

`virtio_transport_stream_do_peek()` does not account for the skb offset
when computing the number of bytes to copy.

This means that, after a partial recv() that advances the offset, a peek
requesting more bytes than are available in the sk_buff causes
`skb_copy_datagram_iter()` to go past the valid payload, resulting in
a -EFAULT.

The dequeue path already handles this correctly.
Apply the same logic to the peek path.

Fixes: 0df7cd3c13e4 ("vsock/virtio/vhost: read data from non-linear skb")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Signed-off-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20260415-fix_peek-v4-1-8207e872759e@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -547,9 +547,8 @@ virtio_transport_stream_do_peek(struct v
 	skb_queue_walk(&vvs->rx_queue, skb) {
 		size_t bytes;
 
-		bytes = len - total;
-		if (bytes > skb->len)
-			bytes = skb->len;
+		bytes = min_t(size_t, len - total,
+			      skb->len - VIRTIO_VSOCK_SKB_CB(skb)->offset);
 
 		spin_unlock_bh(&vvs->rx_lock);
 


