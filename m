Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D7C1607AA;
	Mon,  6 Jan 2025 15:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178223; cv=none; b=nlyTzlxZMiwbUmtCq5jkw2PHjSM6O/PkVBhTRkQR5q4CJRKYdY5zcqXxg3GugpJ50NXPSdTNSGkKzhRYVmE7h+i/lwmdbYwr+CgaKGYDEJf0KGBUaus+8kOduGYLrRXX2eNC+qwzQmBPlFYQIrdBXRGSkUBtGk98UOfiWtgrXpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178223; c=relaxed/simple;
	bh=MSsSFfW6NOLchXSAbuFRsR20lKCBpRgsZq+XdFmDMg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcuSSOOvF3pVS3korcyS9NpsNWs3K262jzCe97MW2xIjH0I9p98W7hv1ClGk333vGnlLUdHPdmDhGEJAhRwqHNcYq4YlTkRk7hlfO2IMnsnuRM/HaHFptk2dWINkBLpUTrFN9/AotFkBWxVUKJglEi/VhxuMCZb6tV8IENX/ceY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcgpanaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcgpanaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC652C4CED2;
	Mon,  6 Jan 2025 15:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178223;
	bh=MSsSFfW6NOLchXSAbuFRsR20lKCBpRgsZq+XdFmDMg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcgpanaMIHzipkF1E3yff3OUKsyNcECM+TWRfigGFC1yTsKy0vVGgNocbCZD4Dof9
	 4v+3N1EMy4zj/GMZBuzVjzNJVekjVth+N0LY4+RdkO9XDOc2F9Awy5ZZEPQJkKVdtZ
	 YsvPrYoXe6q51/0SAXzbi9YPXsjitFRkcrNAbYQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <cong.wang@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/138] tcp_bpf: Charge receive socket buffer in bpf_tcp_ingress()
Date: Mon,  6 Jan 2025 16:16:10 +0100
Message-ID: <20250106151134.981550802@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c45958a68978..548f9aab9aa1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1525,7 +1525,7 @@ static inline bool sk_wmem_schedule(struct sock *sk, int size)
 }
 
 static inline bool
-sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
+__sk_rmem_schedule(struct sock *sk, int size, bool pfmemalloc)
 {
 	int delta;
 
@@ -1533,7 +1533,13 @@ sk_rmem_schedule(struct sock *sk, struct sk_buff *skb, int size)
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
index 85ae2c310148..804464beb343 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -111,7 +111,7 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
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



