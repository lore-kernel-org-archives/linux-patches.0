Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223B61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98155C433D2;
	Wed, 28 Dec 2022 15:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239733;
	bh=t+DdR3AGDJohcKG6a+DJBy8uLuku062ruhfRulGYuM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8o84xgpVKWhTZnEZDcb+rNhJL3wKfupHkCc1fhffsghxnZFPOKr3Sog2aUKSzNJj
	 700GswYBmjGu+P/h5IU60ola3zmJsQjpxxq+/G/UkgBFGgrjqcuWSvL4qf8Qn2DWgu
	 /XRlQ0FZ6/6PcygC5MLBJEYQ78x3BBTRxWRLgVBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengcheng Yang <yangpc@wangsu.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/731] bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect
Date: Wed, 28 Dec 2022 15:36:10 +0100
Message-Id: <20221228144304.186660751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 2db868ca32af..b4b642e3de78 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -45,8 +45,11 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
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



