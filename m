Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55CE1474A0;
	Mon,  6 Jan 2025 15:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178691; cv=none; b=RbW6CCXurrp7qab+oc6d5E6NbgDVs3ZfdLID8sGwBw1JIbggHSwQgCSHbtTNsv8T80ot+MhJdDRVGukb7Knu29rVXcWfdD5OaMKIbYgy7SaH3wXWvrZGO6mQ4VjEcVzgzqrrzWKKE2EMzwq+BgFDzENGI/fjGNajKhaUb16PpcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178691; c=relaxed/simple;
	bh=BGf1qN7/VnIlBHcZbn4z1EYQFY760+05xMH4GviyRA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGsBWsBO4K9gKzIn98R1rRua1FTfXpSBs3V3DByhUEYuqJYx9ldFAYXOJM7/FcA86bfO6zQvU5OS8v9+IXLYUHHNC8U7bCxIGV+Wr0XWN+2RV/f4g6hb+ZYoxuHvXJkcX2r3kD+If1fE3vd5FahJ51lhgXSVnYFLttnanKXwnPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeCaT2XJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeCaT2XJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACD9C4CED2;
	Mon,  6 Jan 2025 15:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178690;
	bh=BGf1qN7/VnIlBHcZbn4z1EYQFY760+05xMH4GviyRA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeCaT2XJPNCOjyhiLYxjvXoLgnCWuglUASU3didG0u8XPyF/hoAmGkbhNs9IcWA7l
	 xFK+ZJryWDFD/gJUOS8+9y0ViEcq0JA/g/605CAq6bMvlEctzl6OZB9RLwx9L1Sx6J
	 eD5lWZ9eqru/6Tm6jTz9e7Z1xGVDD/yFfT++XRA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/168] tcp_bpf: Charge receive socket buffer in bpf_tcp_ingress()
Date: Mon,  6 Jan 2025 16:16:07 +0100
Message-ID: <20250106151140.692456178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1680d6dc4d19..ca3cc2b325d7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1570,7 +1570,7 @@ static inline bool sk_wmem_schedule(struct sock *sk, int size)
 }
 
 static inline bool
-sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
+__sk_rmem_schedule(struct sock *sk, int size, bool pfmemalloc)
 {
 	int delta;
 
@@ -1578,7 +1578,13 @@ sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
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
 
 static inline void sk_mem_reclaim(struct sock *sk)
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f2ae1e51e59f..dc1291827381 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -31,7 +31,7 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
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



