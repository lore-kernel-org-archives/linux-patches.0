Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412EE471255;
	Tue, 21 Jul 2026 18:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656842; cv=none; b=Fmnb/0dvOIIDTr+KT2LQeHax17w0AQAuyZ06T/ekt5eYXLqteqcwmixWYyfVN2lvSrFIHR5J5Z3cM9FN4WzGP84sp0iKzMBMSWIOUB17Dv1L93i6JKA2/kvrklsw0Gz4cY6KnOknbkWdRfNektjnaQZgKUND8T8UKdQkPy8p/Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656842; c=relaxed/simple;
	bh=oKKqreAjdbWCP8MNqkBmSJml8ZxNuLe5Xkfs22RMI+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZXMK7gyLB9UOBtAY0qHlNk3sWsZ8oLVddCwYF7Pr2yqdnp5yDyq7r0BAHlHgajLY8lZo87J4JYXrasikAyZyMaJgZT48FcUNHr5GxIlxgpPThJvr66CUFxMcqxxvEyjmxNlIyXg6i0APpA4ngKnuE2tNFlfKCodQRclmiSLddE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVhCQ86k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVhCQ86k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78781F000E9;
	Tue, 21 Jul 2026 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656841;
	bh=GDu8VRD7kHb9pOXgmCQdnW73D0CvP7UZVY8Z/SwW5kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVhCQ86kIfmJrrtJLS9shM9FOz0z2a60cl8Z7B3nlxovCwLli4J5dEMTvsC33GnYt
	 KMvLi+IkoYS1BrEaGPE1ShEJgFWa/XY36dyGazi7lxBDS8BcOQ/40bpPGwuGYKMMYE
	 fG6ZOSFE5QxUmMRmsLraSxNK0Gv73bIDaYMKmw2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Zhou <zhoufeng.zf@bytedance.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0539/1611] bpf: Fix bpf_get/setsockopt to tos for ipv4-mapped ipv6 socket
Date: Tue, 21 Jul 2026 17:10:55 +0200
Message-ID: <20260721152527.486970103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit ca0f587c029afa66227f7b932450b1c417403394 ]

When TCP over IPv4 via INET6 API, bpf_get/setsockopt with ipv4 will
fail, because sk->sk_family is AF_INET6. With ipv6 will success, not
take effect, because inet_csk(sk)->icsk_af_ops is ipv6_mapped and
use ip_queue_xmit, inet_sk(sk)->tos.

To relax this restriction, allow getting/setting tos for those possible
ipv4-mapped ipv6 sockets.

Fixes: ee7f1e1302f5 ("bpf: Change bpf_setsockopt(SOL_IP) to reuse do_ip_setsockopt()")
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20260613162443.60515-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6dd9bdbef19965..0e7e85cba3d3ab 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5562,11 +5562,24 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
 				 KERNEL_SOCKPTR(optval), *optlen);
 }
 
+static bool sk_allows_sol_ip_sockopt(struct sock *sk)
+{
+	switch (sk->sk_family) {
+	case AF_INET:
+		return true;
+	case AF_INET6:
+		/* Allow getting/setting sockopt for possible ipv4-mapped ipv6 socket. */
+		return sk->sk_type != SOCK_RAW && !ipv6_only_sock(sk);
+	default:
+		return false;
+	}
+}
+
 static int sol_ip_sockopt(struct sock *sk, int optname,
 			  char *optval, int *optlen,
 			  bool getopt)
 {
-	if (sk->sk_family != AF_INET)
+	if (!sk_allows_sol_ip_sockopt(sk))
 		return -EINVAL;
 
 	switch (optname) {
-- 
2.53.0



