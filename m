Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E464E42DFEC;
	Tue, 21 Jul 2026 19:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662271; cv=none; b=eghZBHnSjFEN/ZmJ8BlaT7za1O/lJ0TrIxioQJIOpXjGmaaV/ePdlwGpXtH6KSh2vgb5d8Nyz/K0zw5Cu/d7piQ4D639TogrLfCChL4xUAZqg1cJv9VaayX+UWTwqNYFOpox/+OShCoCcdOEfAhOOfigCbqgzcqVG3M7pszS/VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662271; c=relaxed/simple;
	bh=CHYFn7bKGfRhhjhOdIEJ8TdNojCS4FsWQFK/SUwjNgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zokw/M5/rdE4i+JVIfihW6hkKFc2bzsGVooR7Xn/lgHg6UgMiaOgfkDdtaqVn8I/UQzCzLOaMIgP5CNGeNVEj56OSEASUzbjZMedOVU4CxrTPNMLcmVrNokmI79BGC/qMKxWFTz8cjAnnhVIArC/hE1yYxa5A1AQVPUZq4BHPCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+uEcSar; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+uEcSar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471F51F000E9;
	Tue, 21 Jul 2026 19:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662269;
	bh=8TqztQ6hBtGBbUPd8nRRK9AkItKutYWwKOreO2MKd28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+uEcSarFGFHSvijd32Ruk17B8LbSsTFGot3tJ8IpCATK92tI7MC+cTQjJW87LCBz
	 ksHQIaMxW2nBRonj9jfoHyd8w54Nfvh+YUFNtUZBX3nD3gVUw8pHqWw86/izmUwVg/
	 21MZkDJ/4EF1tUlXqjJ35gmkG6DCBXWQD+Us5W7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Zhou <zhoufeng.zf@bytedance.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0382/1276] bpf: Fix bpf_get/setsockopt to tos for ipv4-mapped ipv6 socket
Date: Tue, 21 Jul 2026 17:13:45 +0200
Message-ID: <20260721152454.653249250@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b03621405d0628..77022dedb581ea 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5507,11 +5507,24 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
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



