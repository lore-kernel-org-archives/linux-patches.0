Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F2E749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43055C433D2;
	Thu, 12 Jan 2023 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532555;
	bh=pkxb+LhNGkSQEQFDthM1BykkvxGJojxZ477GB/uFzTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6EvqNCQUvaHN3OgKkftmftPjHXcb+k//ucQ3cdmAgt2LHbfr40VvupI1lB4jZt5M
	 6QGNe5ZluIl9U6GRgQN8J2pIK6CYf4hacb2VDbTbFV4z01XZ/ImatBw8GFtz/nG+BL
	 sHXOQgHfPuHjPv/t2zxlspaKTpj7TFWHY+7319Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengcheng Yang <yangpc@wangsu.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 199/783] bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect
Date: Thu, 12 Jan 2023 14:48:35 +0100
Message-Id: <20230112135533.554268757@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengcheng Yang <yangpc@wangsu.com>

[ Upstream commit 9072931f020bfd907d6d89ee21ff1481cd78b407 ]

Use apply_bytes on ingress redirect, when apply_bytes is less than
the length of msg data, some data may be skipped and lost in
bpf_tcp_ingress().

If there is still data in the scatterlist that has not been consumed,
we cannot move the msg iter.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/1669718441-2654-4-git-send-email-yangpc@wangsu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 027f7f9256e1..6a1685461f89 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -125,8 +125,11 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 		tmp->sg.end = i;
 		if (apply) {
 			apply_bytes -= size;
-			if (!apply_bytes)
+			if (!apply_bytes) {
+				if (sge->length)
+					sk_msg_iter_var_prev(i);
 				break;
+			}
 		}
 	} while (i != msg->sg.end);
 
-- 
2.35.1



