Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD08779CD;
	Sat, 30 Dec 2023 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdgMoshJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D67C433C8;
	Sat, 30 Dec 2023 12:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937761;
	bh=LSVRey+NE+3PAn/DWw7/sr/ZJATj1Swe83GLIOteojI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdgMoshJmDYyyadRIvu9pR+Cv8te7OJyVytKjQjhKoq0GKK8VAuzurQFXIE5jxQoJ
	 w8qDg0DlsuI45pofmuIykw9P2D3iaVim8C0feoMi62+WY7633dLa4pr1pirvAOIN4Z
	 GZ1xXRGWYL8mBHn4AI922jwTLSxOnQHyLWxk6n+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot+e8030702aefd3444fb9e@syzkaller.appspotmail.com,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/156] bpf: syzkaller found null ptr deref in unix_bpf proto add
Date: Sat, 30 Dec 2023 11:58:03 +0000
Message-ID: <20231230115813.324157087@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 8d6650646ce49e9a5b8c5c23eb94f74b1749f70f ]

I added logic to track the sock pair for stream_unix sockets so that we
ensure lifetime of the sock matches the time a sockmap could reference
the sock (see fixes tag). I forgot though that we allow af_unix unconnected
sockets into a sock{map|hash} map.

This is problematic because previous fixed expected sk_pair() to exist
and did not NULL check it. Because unconnected sockets have a NULL
sk_pair this resulted in the NULL ptr dereference found by syzkaller.

BUG: KASAN: null-ptr-deref in unix_stream_bpf_update_proto+0x72/0x430 net/unix/unix_bpf.c:171
Write of size 4 at addr 0000000000000080 by task syz-executor360/5073
Call Trace:
 <TASK>
 ...
 sock_hold include/net/sock.h:777 [inline]
 unix_stream_bpf_update_proto+0x72/0x430 net/unix/unix_bpf.c:171
 sock_map_init_proto net/core/sock_map.c:190 [inline]
 sock_map_link+0xb87/0x1100 net/core/sock_map.c:294
 sock_map_update_common+0xf6/0x870 net/core/sock_map.c:483
 sock_map_update_elem_sys+0x5b6/0x640 net/core/sock_map.c:577
 bpf_map_update_value+0x3af/0x820 kernel/bpf/syscall.c:167

We considered just checking for the null ptr and skipping taking a ref
on the NULL peer sock. But, if the socket is then connected() after
being added to the sockmap we can cause the original issue again. So
instead this patch blocks adding af_unix sockets that are not in the
ESTABLISHED state.

Reported-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+e8030702aefd3444fb9e@syzkaller.appspotmail.com
Fixes: 8866730aed51 ("bpf, sockmap: af_unix stream sockets need to hold ref for pair sock")
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20231201180139.328529-2-john.fastabend@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h  | 5 +++++
 net/core/sock_map.c | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7753354d59c0b..1b7ca8f35dd60 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2798,6 +2798,11 @@ static inline bool sk_is_tcp(const struct sock *sk)
 	return sk->sk_type == SOCK_STREAM && sk->sk_protocol == IPPROTO_TCP;
 }
 
+static inline bool sk_is_stream_unix(const struct sock *sk)
+{
+	return sk->sk_family == AF_UNIX && sk->sk_type == SOCK_STREAM;
+}
+
 /**
  * sk_eat_skb - Release a skb if it is no longer needed
  * @sk: socket to eat this skb from
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 4292c2ed18286..27d733c0f65e1 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -536,6 +536,8 @@ static bool sock_map_sk_state_allowed(const struct sock *sk)
 {
 	if (sk_is_tcp(sk))
 		return (1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_LISTEN);
+	if (sk_is_stream_unix(sk))
+		return (1 << sk->sk_state) & TCPF_ESTABLISHED;
 	return true;
 }
 
-- 
2.43.0



