Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDE744AB60;
	Tue, 21 Jul 2026 21:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669188; cv=none; b=SgO8mi1FwcaxAT0hZzXlAxD7cwOmjpE8d2g5gA4NC47pgPW/cLyO1vNT4iDbSeOGVR+tymVo8oMXwS0bX+u/+JM4TSqk6rndMU3qxV7IBk8CvdLHjntd6t8ss5rq6SKwMHvZNIfZe769IpOKZMTCy6Q1ocVj9kaOjEoMI0P15/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669188; c=relaxed/simple;
	bh=T5vnxeusd2DDMxZdv58+4lZE2XwVH58TiR7SAM1SK/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U51pDQ2JfT6LVkrtIxlnc5IOq4wC+ayJ34v9XPB/Kstz6rMB7jvmu39n2SGTLIfvwuJUZ2oBGq0PmXJSLZ+Bb3x89Oa7rTHcSIRVrvqvShgxqEdxjw8qZiLpHs6MwnviMzWq04UrqOo/WUqH87MklSdtLBWvUT5cGfyTkaePBz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7q5l/jd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7q5l/jd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33851F000E9;
	Tue, 21 Jul 2026 21:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669187;
	bh=T7xy4G4k2Y9zHBOOoVT1/wCO425Xrf7lG+PhohHpOs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7q5l/jdAQ3Z/R+LoSN4S4uDMQTOKTmyojVRJKsVAkHPreOoKy63qaPP16m5vNbiu
	 4XKZxrme8tatNR23SQLL2/y1emMDDYzHdyIZ+t/RCtBPAPBwcpzhp6nOlaAIeHe94E
	 rgRuu9NrRbnT7jjAQruom/2XVOmQdsl31Y3qMCMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Zhou <zhoufeng.zf@bytedance.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0459/1067] bpf: Fix bpf_get/setsockopt to tos for ipv4-mapped ipv6 socket
Date: Tue, 21 Jul 2026 17:17:40 +0200
Message-ID: <20260721152434.883820932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f65131e24894e..26762c3825a3dd 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5374,11 +5374,24 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
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



