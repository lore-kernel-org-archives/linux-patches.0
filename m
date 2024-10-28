Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B2718E36D;
	Mon, 28 Oct 2024 06:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097640; cv=none; b=E4i/Wsz7Bh56sdAO7WDo+JXfoDXmSXN+1rkWf+ldjWKAZYJCfC+t6d7x8IXTzltVfKIreVROJGXO5/1pXfQqp1n7akLwxzNcUdddj9aa1n6UfqL0QdLrnlRPvDIub1xD1lLVFBW0gmpYg8OyBExb+hymToEukttBI36pWqyidvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097640; c=relaxed/simple;
	bh=jJTlhGtjZPB503612moJTmmYBaXz/tIOUPr63ew1IWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWN0HkibivF4YAwAINKuEe0rm9PkViJViSlhjbPPKRzWVBDQrRG+o/zhpVFSCHzciwpuL6ogsT5wFQX4wQJB8q+DksqMM9oeH9CGmXSWnvKuK2gcQeRPzpl3t85lySwzCnrY1Dw5Wipk6UEpd8r5f2z4xeqfWwmLGNuGCAJOD5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8lR41zq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8lR41zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115B6C4CEC3;
	Mon, 28 Oct 2024 06:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097640;
	bh=jJTlhGtjZPB503612moJTmmYBaXz/tIOUPr63ew1IWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8lR41zqAUO8aeGUltUFwFgKLDpLwC66z2pcxVsqoKbKoTJWW/SX0LKgKRaSRmcX7
	 IYOq8VCUAd/+aGIFj2NuPngmIlJs6NBApfkUAx0TEck3EGYWWJ3lNXRPAVYPv8F8zG
	 YR+depwKsu3JBZuqutkpvfxrimljEj7XGkt8b1kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/208] bpf, sockmap: SK_DROP on attempted redirects of unsupported af_vsock
Date: Mon, 28 Oct 2024 07:24:22 +0100
Message-ID: <20241028062308.666927351@linuxfoundation.org>
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

[ Upstream commit 9c5bd93edf7b8834aecaa7c340b852d5990d7c78 ]

Don't mislead the callers of bpf_{sk,msg}_redirect_{map,hash}(): make sure
to immediately and visibly fail the forwarding of unsupported af_vsock
packets.

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241013-vsock-fixes-for-redir-v2-1-d6577bbfe742@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h  | 5 +++++
 net/core/sock_map.c | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index c3961050b8e39..e0be8bd983960 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2826,6 +2826,11 @@ static inline bool sk_is_stream_unix(const struct sock *sk)
 	return sk->sk_family == AF_UNIX && sk->sk_type == SOCK_STREAM;
 }
 
+static inline bool sk_is_vsock(const struct sock *sk)
+{
+	return sk->sk_family == AF_VSOCK;
+}
+
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 2afac40bb83ca..2da881a8e7983 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -644,6 +644,8 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	sk = __sock_map_lookup_elem(map, key);
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+	if ((flags & BPF_F_INGRESS) && sk_is_vsock(sk))
+		return SK_DROP;
 
 	skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
 	return SK_PASS;
@@ -672,6 +674,8 @@ BPF_CALL_4(bpf_msg_redirect_map, struct sk_msg *, msg,
 		return SK_DROP;
 	if (!(flags & BPF_F_INGRESS) && !sk_is_tcp(sk))
 		return SK_DROP;
+	if (sk_is_vsock(sk))
+		return SK_DROP;
 
 	msg->flags = flags;
 	msg->sk_redir = sk;
@@ -1246,6 +1250,8 @@ BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
 	sk = __sock_hash_lookup_elem(map, key);
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+	if ((flags & BPF_F_INGRESS) && sk_is_vsock(sk))
+		return SK_DROP;
 
 	skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
 	return SK_PASS;
@@ -1274,6 +1280,8 @@ BPF_CALL_4(bpf_msg_redirect_hash, struct sk_msg *, msg,
 		return SK_DROP;
 	if (!(flags & BPF_F_INGRESS) && !sk_is_tcp(sk))
 		return SK_DROP;
+	if (sk_is_vsock(sk))
+		return SK_DROP;
 
 	msg->flags = flags;
 	msg->sk_redir = sk;
-- 
2.43.0



