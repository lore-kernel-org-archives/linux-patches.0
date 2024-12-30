Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813E22AE68;
	Mon, 30 Dec 2024 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573999; cv=none; b=mBh7/VT4hrDm/cF9fVzvUpxhcAn2BrSAJrIDgAsbIstFsofkgwb7tZL1VXZmSxG8qzEgaK1fV2pq18/vEWQTBswueaOSRrJd7FFPCPN+3jbz35PTxbqLRCPqRevFR5Huhv6/0ySATPDxhFpOBBvay5GgoyVk3re2KaB3Kb7WDQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573999; c=relaxed/simple;
	bh=U7xnjmB45Gx+d7KBRXgsC5HRwnpX441gQRU87dlPQmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdtziR+aW46kJsDKoWxBFaXy9lUSnE5iZi01GEea+JnUAO/8T0SgF2EIohdXxnw/Iy9eWZgj3zf9wzTTS3almHf2T0QnSNXQdWgPpt/jFvcjS3In3d/KKTYf6lhhC8k1eERfIOyAtiFvpgX+jrx3ZkJ6AJWxvOUq7VPMQF4kYX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pA6sybbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pA6sybbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BBDC4CED0;
	Mon, 30 Dec 2024 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573999;
	bh=U7xnjmB45Gx+d7KBRXgsC5HRwnpX441gQRU87dlPQmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pA6sybbvrRGKDCzN9ADVdMwXgbNyhCIKEjAQmZJu8XDQRNNE3+IW/0+jp29SgFl/q
	 3ex3fzdjWHpTicIqoLsu9q5iM1gHJmNslqkMSjLsw97jkwPmjj7GlLe86BBrsTPSsw
	 6w6ejH8pAFv4WRlSF5yxkROG1LUbTFRGP+TZ/X4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/114] tcp_bpf: Charge receive socket buffer in bpf_tcp_ingress()
Date: Mon, 30 Dec 2024 16:42:07 +0100
Message-ID: <20241230154218.456926270@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 54f89b3178d5448dd4457afbb98fc1ab99090a65 ]

When bpf_tcp_ingress() is called, the skmsg is being redirected to the
ingress of the destination socket. Therefore, we should charge its
receive socket buffer, instead of sending socket buffer.

Because sk_rmem_schedule() tests pfmemalloc of skb, we need to
introduce a wrapper and call it for skmsg.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241210012039.1669389-2-zijianzhang@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 10 ++++++++--
 net/ipv4/tcp_bpf.c |  2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index f29c14448938..fa055cf1785e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1521,7 +1521,7 @@ static inline bool sk_wmem_schedule(struct sock *sk, int size)
 }
 
 static inline bool
-sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
+__sk_rmem_schedule(struct sock *sk, int size, bool pfmemalloc)
 {
 	int delta;
 
@@ -1529,7 +1529,13 @@ sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
 		return true;
 	delta = size - sk->sk_forward_alloc;
 	return delta <= 0 || __sk_mem_schedule(sk, delta, SK_MEM_RECV) ||
-		skb_pfmemalloc(skb);
+	       pfmemalloc;
+}
+
+static inline bool
+sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
+{
+	return __sk_rmem_schedule(sk, size, skb_pfmemalloc(skb));
 }
 
 static inline int sk_unused_reserved_mem(const struct sock *sk)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 99cef92e6290..b21ea634909c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -49,7 +49,7 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 		sge = sk_msg_elem(msg, i);
 		size = (apply && apply_bytes < sge->length) ?
 			apply_bytes : sge->length;
-		if (!sk_wmem_schedule(sk, size)) {
+		if (!__sk_rmem_schedule(sk, size, false)) {
 			if (!copied)
 				ret = -ENOMEM;
 			break;
-- 
2.39.5



