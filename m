Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B45A2AF07;
	Mon, 28 Oct 2024 06:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098236; cv=none; b=aE6jNp6vklyt/tUMsF221yw9SpaPGdAaotzAyjbOh3+F243F4bCX8D0tbzQfX2cr0WLzBVUz9X3SkUNXvz1eGoAlKFTQswscULpX83L45zHrrSZAbIofcNOvRPAyuSjitrfIWAoOQOJwaRMibWKNDrObLJkmA9gKy5A2Mvjti+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098236; c=relaxed/simple;
	bh=v0ZXueXPDSINQpjeRAHVbe66Z2sGg3pEl3kh8ro5FRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjjxvSA/6UXUe2SW875vrDU4IO2yuiVgH9OhocdMB/zKBTmu9aVortILU291xHiOxqM57a6EOJF3nOOti2HQgHchMVKf9ZdVvOsPD86dt4YcpK4fzdgpQx9mZv20kn9ha5Uuhwkse7cyyDNon0uT6o/bHTQWBeqaR+CPs9El74M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAeDGoZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAeDGoZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0873C4CEC7;
	Mon, 28 Oct 2024 06:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098236;
	bh=v0ZXueXPDSINQpjeRAHVbe66Z2sGg3pEl3kh8ro5FRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAeDGoZEcL2Q2a7rTS2WNKTa69hLrRpS6RA8XRUJzdYjOTIJ+6PoC0qXsBlvfJna8
	 PtjjqlMHM/xNZOgDVnkL6/wpWRaUbGKq7U1NYFny5ESjpxCEqaIvxJlS3GwlmIlYdP
	 IAdjeNwATzR2KZMSbzjrysXq61zfAG1Dbe3oAW/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 102/261] bpf, sockmap: SK_DROP on attempted redirects of unsupported af_vsock
Date: Mon, 28 Oct 2024 07:24:04 +0100
Message-ID: <20241028062314.585877627@linuxfoundation.org>
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
index 2d4149075091b..f127fc268a5ef 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2715,6 +2715,11 @@ static inline bool sk_is_stream_unix(const struct sock *sk)
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
index 724b6856fcc3e..219fd8f1ca2a4 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -656,6 +656,8 @@ BPF_CALL_4(bpf_sk_redirect_map, struct sk_buff *, skb,
 	sk = __sock_map_lookup_elem(map, key);
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+	if ((flags & BPF_F_INGRESS) && sk_is_vsock(sk))
+		return SK_DROP;
 
 	skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
 	return SK_PASS;
@@ -684,6 +686,8 @@ BPF_CALL_4(bpf_msg_redirect_map, struct sk_msg *, msg,
 		return SK_DROP;
 	if (!(flags & BPF_F_INGRESS) && !sk_is_tcp(sk))
 		return SK_DROP;
+	if (sk_is_vsock(sk))
+		return SK_DROP;
 
 	msg->flags = flags;
 	msg->sk_redir = sk;
@@ -1258,6 +1262,8 @@ BPF_CALL_4(bpf_sk_redirect_hash, struct sk_buff *, skb,
 	sk = __sock_hash_lookup_elem(map, key);
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+	if ((flags & BPF_F_INGRESS) && sk_is_vsock(sk))
+		return SK_DROP;
 
 	skb_bpf_set_redir(skb, sk, flags & BPF_F_INGRESS);
 	return SK_PASS;
@@ -1286,6 +1292,8 @@ BPF_CALL_4(bpf_msg_redirect_hash, struct sk_msg *, msg,
 		return SK_DROP;
 	if (!(flags & BPF_F_INGRESS) && !sk_is_tcp(sk))
 		return SK_DROP;
+	if (sk_is_vsock(sk))
+		return SK_DROP;
 
 	msg->flags = flags;
 	msg->sk_redir = sk;
-- 
2.43.0



