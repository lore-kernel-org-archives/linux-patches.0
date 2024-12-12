Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED2021660B;
	Thu, 12 Dec 2024 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015930; cv=none; b=lqWiSnQ6PBBU5WFzm/wPfaeZD22izNJjKEsev6LDkKSVTLz+88Y7Y2Z5OiElM/GmFVHVz81pjDvHb0ELRq74sYDCIpV/qRVAGgInuyCF+dCPq9fYHwRZF6YhGgnB1r5vT+vWtO7JsvadLcH42fJ+8OMvZBHzX2+wVe22mnAjLaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015930; c=relaxed/simple;
	bh=qRW4d6QKLmkB6YKpHG2RYgA/FxE2zYHzuxaz7r477lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giHlV3XbJZfyEN/Y7zRWW1IaLbfaSoWjcGzPVGMEs6E1o1hB8wBs9rJPAnCGCghSX8Dw0wlE3APzwT7jSMjt0ypsGo6IGM/OWUKk18ZYn4iSIbRB6JD46Ze7FkALBbiDAcdxiK+3J4xgY1WxS1lVw+1RGwiyvGM2oAsyPdzFiS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ug5DzONm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ug5DzONm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB54C4CED4;
	Thu, 12 Dec 2024 15:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015930;
	bh=qRW4d6QKLmkB6YKpHG2RYgA/FxE2zYHzuxaz7r477lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ug5DzONmaIHukIFllGDl4VjMzfbSHMVNFn4XnOuK0y1ho7WaorKAUijjOQ7ER5v3q
	 JSm0UB/oBDBGirNi4DDtmJaWhXl1tk+9cq9pewqjKJwKHIHpN0TPEgPC4zvR55FCaH
	 L8p1IxG7b2AdW/SErTk//0IEQY8crCPxn5/xX+Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/466] bpf, vsock: Fix poll() missing a queue
Date: Thu, 12 Dec 2024 15:54:12 +0100
Message-ID: <20241212144310.101656670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 9f0fc98145218ff8f50d8cfa3b393785056c53e1 ]

When a verdict program simply passes a packet without redirection, sk_msg
is enqueued on sk_psock::ingress_msg. Add a missing check to poll().

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://lore.kernel.org/r/20241118-vsock-bpf-poll-close-v1-1-f1b9669cacdc@rbox.co
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index dfd29160fe11c..919da8edd03c8 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1054,6 +1054,9 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLRDHUP;
 	}
 
+	if (sk_is_readable(sk))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
 	if (sock->type == SOCK_DGRAM) {
 		/* For datagram sockets we can read if there is something in
 		 * the queue and write as long as the socket isn't shutdown for
-- 
2.43.0



