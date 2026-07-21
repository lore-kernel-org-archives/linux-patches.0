Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894B5395D99;
	Tue, 21 Jul 2026 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666194; cv=none; b=GS3qMIIRKirInFuwrVe3GQKXPFuxVOMvhGpHNnaRW2wZr8Np2OMIikqYt4ukfYKi7Mx/T1rl7sFI2qJ+8UkyuHKcb9J0w7UsjJ5j2AklnSqyUWUHfyVcLkzWjQjDVDTaocfnyNuxa1tX1i/g96mIIA7CJNZb0wRetSmC5/RUOBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666194; c=relaxed/simple;
	bh=rrikazyjtERAUXHZ72pjC9UHuSJEumJ5fMSjzcRwrpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z++sp2jXI6rZkzoGkdIFqvwpy1UyI/0DHMhVE5C3V6wWb89J7BosqGZ5rDuJtkAB2SG5nT02nwBlJ+Vd6GQyaCGyWCjCxilHjLo/gKyzpOBN1GeHw29sjQXEnpLUf4MNDVQXkl+Wh/Khvq62+hIW5uAS7G+WDptDnDT/F/2Dy78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLzt1sv3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLzt1sv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60901F000E9;
	Tue, 21 Jul 2026 20:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666193;
	bh=TkyT0VukTNq8sUOWqISpFou/6R5zBbcx2MDggZvVfU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLzt1sv3Nue9mMvh/SSLLef4EAc96tWKhlFts1blrty+iUXNh4aJQzmfL/gHMuOBL
	 bze4DtfcoFsY66/C1JPIK+zP+wMBeMr7zaJGyVhTjK7LoRdFy7zR0hKKBGTI5tSFvm
	 K7RlZ80IaV4VvZ/W7Z5OZ6XETy5eFu1Umz0E2oxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Zhou <zhoufeng.zf@bytedance.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0589/1266] bpf: Fix bpf_get/setsockopt to tos for ipv4-mapped ipv6 socket
Date: Tue, 21 Jul 2026 17:17:06 +0200
Message-ID: <20260721152455.045005504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a9c1367ea4d5e..5f99b2144c257f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5455,11 +5455,24 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
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



