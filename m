Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942052EA172;
	Wed, 28 Jan 2026 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615394; cv=none; b=b5pejiaX/r39gQO8c23eDW7E4WTyeSlWz9pxO3bf5vUqBttLLdzW6teKLHl26SBMYvXikoxvOMqYeEz1OpnYsXSLxsI2Bn+aoPdwkDKDx/u+TvDsrFFuaDvWhNzeCkrx4n7xAb6iu0CkH2wp0PdZ8oj/SspVoUbjw3Ivgp55MLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615394; c=relaxed/simple;
	bh=Q20CDpNz9Xb73sC5b3s2ZBo/pLfeW/qrS61y4XUJnHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atcYixRJhm4xrhI4HxFC6NOJX23KWq5CaSFZNPG5zBtvBcJ/1djO8uLHusH91LKjR+P9hKCA4rljLj83rvY2FhV8IBbLk6EjASbBtw8SpnLOf7AItyXCoEfhVOrzpqKfwFN30WJSwFAay4ax7aK4b8fzwaxvK0GCMAha1PphjHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7Ep+jN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7Ep+jN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC5FC4CEF7;
	Wed, 28 Jan 2026 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615394;
	bh=Q20CDpNz9Xb73sC5b3s2ZBo/pLfeW/qrS61y4XUJnHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7Ep+jN3GcMm6YOtGNHw2uOipjyXBSPbhDICYut+kq9vVJWnqmDIGBchk8yt9JJdQ
	 G8Ss4YQNeonqPqReTZsWp9hfeY/aiprQeH1F3Hn5Pq0c2210zaDRxNjvISnL1d/ynW
	 JUrvgfO6yL+PUsyY1EXipNPq9I0LmBoBCCvKfmU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernel-dev@igalia.com, Heitor Alves de Siqueira" <halves@igalia.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 167/169] vsock/virtio: Allocate nonlinear SKBs for handling large transmit buffers
Date: Wed, 28 Jan 2026 16:24:10 +0100
Message-ID: <20260128145340.037790800@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[Upstream commit 6693731487a8145a9b039bc983d77edc47693855]

When transmitting a vsock packet, virtio_transport_send_pkt_info() calls
virtio_transport_alloc_linear_skb() to allocate and fill SKBs with the
transmit data. Unfortunately, these are always linear allocations and
can therefore result in significant pressure on kmalloc() considering
that the maximum packet size (VIRTIO_VSOCK_MAX_PKT_BUF_SIZE +
VIRTIO_VSOCK_SKB_HEADROOM) is a little over 64KiB, resulting in a 128KiB
allocation for each packet.

Rework the vsock SKB allocation so that, for sizes with page order
greater than PAGE_ALLOC_COSTLY_ORDER, a nonlinear SKB is allocated
instead with the packet header in the SKB and the transmit data in the
fragments. Note that this affects both the vhost and virtio transports.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-10-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -111,7 +111,8 @@ static int virtio_transport_fill_skb(str
 					       &info->msg->msg_iter,
 					       len);
 
-	return memcpy_from_msg(skb_put(skb, len), info->msg, len);
+	virtio_vsock_skb_put(skb, len);
+	return skb_copy_datagram_from_iter(skb, 0, &info->msg->msg_iter, len);
 }
 
 static void virtio_transport_init_hdr(struct sk_buff *skb,
@@ -263,7 +264,7 @@ static struct sk_buff *virtio_transport_
 	if (!zcopy)
 		skb_len += payload_len;
 
-	skb = virtio_vsock_alloc_linear_skb(skb_len, GFP_KERNEL);
+	skb = virtio_vsock_alloc_skb(skb_len, GFP_KERNEL);
 	if (!skb)
 		return NULL;
 


