Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFF5175A87;
	Fri, 15 May 2026 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860286; cv=none; b=RjtDbHR9NrYLTKWcRU/YMGVt8UAqgeVb/iGnlURP+JNHedbP8aOUwdtqngu1jM2WcRzIokGluNa4RjnVbYZO//Y4jYzpVhUdqMpGXnf3U3PqXhswTk2/A+Rnm0tsi4cIsu1nPec9Y8GF6n1Q8LyVjFjOrF6dq/ZFWa05ulh0bec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860286; c=relaxed/simple;
	bh=jtyUstZHIMfGpN0Em53a+DxxOZDH0zyRSI0j0v1pA+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbwwInAVFnEpSfkcHtNIi1NYSXJ3emr6Iw4qa4SFunLoIliLE1plDIx1pKhdf7LAiLCvVy871Oo/tPXBfMLOXoAXW/sYx6iUvj2d7H92tzrAJCp1dDfKQOxYGtXBIUVNlG2ggrvI49iBX8sfYRoSSMzaQmNBNTnDTkkjHeKIiTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8fLn5ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8fLn5ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B96C2BCB0;
	Fri, 15 May 2026 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860286;
	bh=jtyUstZHIMfGpN0Em53a+DxxOZDH0zyRSI0j0v1pA+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8fLn5juKNCAPCuGxZJdsyRIp/jAkEyay4Hq5eHn1bR+19Nlad1ENq05s6H4yPCI7
	 Js/GMs6xGs4A3O2zyANgow4K0iZ3vAnUR1J5MOODJpGgdceAIyXre48uwN0Q1ZT3ui
	 6FpJSpTC38h92OURDt8t+hAsfezYcZcLp17zZq7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 031/144] vsock/virtio: fix MSG_PEEK ignoring skb offset when calculating bytes to copy
Date: Fri, 15 May 2026 17:47:37 +0200
Message-ID: <20260515154654.233254762@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
 


