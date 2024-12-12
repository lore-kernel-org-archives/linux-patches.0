Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772086F2FE;
	Thu, 12 Dec 2024 15:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017791; cv=none; b=HXybPynOmO3Mvui2t6kZat97gBVBzIG19tYmYJ7n+OWB+LUAd2RpYfhOjqmsyt4YG+H6+jq7IHiAd4ePtIvPXpY+S2o+eiHEWBe1HmyKGFgUHfxFN1T4eQc7DcI281xQC2CNoEtQDtgf4gfFPd4BcLMaP10/GxrOmM85+jO0wqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017791; c=relaxed/simple;
	bh=vtMHDLIDRzbaV524eWvbc4n+iyeyAZdaic7pahJS3ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACDEzy+xmNvC1Bhyw9l8eXFrCF6cXuSWGaI85RcAmXaugJlu9T76YL8MuV+upvIyUwcv6md5Sj18up5qJQvx7TXAX9GlVYHopDUiWWd9cvb2Fjmcp/UcZWx8u6YjBaS671kOgQojTUYyymILwkw6KGVoDdJQLw87xnjqzEFXhgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8idO4KG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8idO4KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D8BC4CECE;
	Thu, 12 Dec 2024 15:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017791;
	bh=vtMHDLIDRzbaV524eWvbc4n+iyeyAZdaic7pahJS3ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8idO4KGPrZkCGpHuT5jC4oHRLVF4ZrCwIVTgNS7W2X1qOpxVCC9Y+z842EGAkz55
	 YikETM+oAO2PAXExfvjUp+HD3GuioZDzPgABZiBgDeWed9328xWR9P5sYQW0uUMip4
	 oWHDNnuVMcEy3AJQ3J9DzxvsPSrzDaPRHmerlgiM=
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
Subject: [PATCH 6.6 111/356] bpf, vsock: Fix poll() missing a queue
Date: Thu, 12 Dec 2024 15:57:10 +0100
Message-ID: <20241212144249.029061410@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
index f5eb737a677d9..7ba3357c9882c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1050,6 +1050,9 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
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



