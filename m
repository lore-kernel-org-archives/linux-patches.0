Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D2218E77D;
	Mon, 28 Oct 2024 06:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098240; cv=none; b=fxxe+glBUztsImQar/cYR7EFcWxNYb6km0YAQoksAIVHi2d1F7CIGjd1aNQLqDcTEMiQ10y4Eb4YMXOCd+PeIXTQWqO8l/SH3bTgcqmD+hhpX8lOmBv0zTThGBhGTt4KfC7AI6MjhLKN5Rr4nR9k7xhW2WIFaUSNv8c+wV/PHVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098240; c=relaxed/simple;
	bh=CGg7wDhvp4gcMRJp/6r5l5LIHP85cQv02ILr7g43NBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwqPr+cE4zTKfdJ1Mx3DpRiY4w4zEqfk5QfDgrUof6QMQhaQdUDWA/pTMJcpDmKXw+TQw3do6LQfnMzi9r6VE3AJDbWwa+q1HlZzmANXLtwZSpCJeGda6pdSlVsqoHp/8YFqZE5n91bNUYT5ssx4rSRycgeIuxB+8O1VSK0cyps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2JZ/9nO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2JZ/9nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4929FC4CEC3;
	Mon, 28 Oct 2024 06:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098240;
	bh=CGg7wDhvp4gcMRJp/6r5l5LIHP85cQv02ILr7g43NBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2JZ/9nOkQcwZvo5a5pW6XTD7ee9tttoZhb12xqNCETpWqjiNqbD6cku0kxuzpyZO
	 FX6rAkSCUMxjM6GU/YGV9DYMzueSLd9rhsV9L+c0Le7Dp7qkdVr1yMA7DCYWkWT6pW
	 76MAvbkr4P9O+hpYyjmpCedYMOnCo7u3bDOguukM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stefano Garzarella <sgarzare@redhat.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 104/261] vsock: Update msg_count on read_skb()
Date: Mon, 28 Oct 2024 07:24:06 +0100
Message-ID: <20241028062314.637652300@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 6dafde852df8de3617d4b9f835b629aaeaccd01d ]

Dequeuing via vsock_transport::read_skb() left msg_count outdated, which
then confused SOCK_SEQPACKET recv(). Decrease the counter.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241013-vsock-fixes-for-redir-v2-3-d6577bbfe742@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 0f67cb0c64702..645222ac84e3f 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1688,6 +1688,9 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 	}
 
 	hdr = virtio_vsock_hdr(skb);
+	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
+		vvs->msg_count--;
+
 	virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
 	spin_unlock_bh(&vvs->rx_lock);
 
-- 
2.43.0



