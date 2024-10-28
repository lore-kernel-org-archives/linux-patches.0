Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1E72C697;
	Mon, 28 Oct 2024 06:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097645; cv=none; b=DetfHQc8BJWmGFvLQ18O+eRLjRQ8ffYj1DOXRUvotFtp1XMdWwYIRAh2iDR7PEgduYqMLUvry7+oTKwG+fm/rVPyfAfx+S/4bILWdoxGy5zgwetdLJGi9x0K76vTMssEHoiMWSG+sAABa8nl6mIBFodV3ch5lAA6S9MqqCngn1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097645; c=relaxed/simple;
	bh=uHw7fOuWqbJrVFfmRzZj0rFcw2EnxtL1gblFk0QaFdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cmb5UxLeHgxh+whbuWX6+Mv1H2fuVOtTul+isJOY90iUmjvEqpUCPUgPhGzsgY9ThsDcXwV8oF8xeNUstNIYl13OaD4O9IZfHluJWLe3enWEF/qvZgEOOsoZzkUTSOMnVv2FveN3EtALjwSYTZWJRdR6uPg+sAdIl9J8yfzCYaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkAK/k8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkAK/k8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE4FC4CEC3;
	Mon, 28 Oct 2024 06:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097644;
	bh=uHw7fOuWqbJrVFfmRzZj0rFcw2EnxtL1gblFk0QaFdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkAK/k8sPeG31lcWsreGamVMu5ayHygvOG1rzUYzlyxL4vOBn65sda0sUglSS1lWk
	 CjNzuyzNGfeelQlEcUivMxURvNLmOFe90DQUvpLrbwZ5DNemLs6nY1b0woiu8Bd9Uh
	 MKtjLRmwoSYv1JMJBKaz5yOe9mp0WFCttTNeeVv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stefano Garzarella <sgarzare@redhat.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/208] vsock: Update msg_count on read_skb()
Date: Mon, 28 Oct 2024 07:24:24 +0100
Message-ID: <20241028062308.717401928@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 072878012b51e..78b5f4f8808b9 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1524,6 +1524,9 @@ int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t recv_acto
 	}
 
 	hdr = virtio_vsock_hdr(skb);
+	if (le32_to_cpu(hdr->flags) & VIRTIO_VSOCK_SEQ_EOM)
+		vvs->msg_count--;
+
 	virtio_transport_dec_rx_pkt(vvs, le32_to_cpu(hdr->len));
 	spin_unlock_bh(&vvs->rx_lock);
 
-- 
2.43.0



