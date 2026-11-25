Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622157;
	b=1Rn1B3Y6W4TRxGMVNiA4+mpo1k4xcB/55ImoEWDt+rhfIRdrtokjjO1YHxevQ+psa4GE
	 zI6a44TO8EeSJ68nc9B5MDj6xKFOqxOqKTayQlGKT2l92hoXrwdnMYF5z8qyARwIBKA2h
	 XrPDcHSRVQDp62f9aM2LjS3d+8bou+R6di4h2vCi7Z5vkv/EFynJXY+Px84sHiKV+X4Ku
	 uWpiBMoOuvCMzBT1KaNOhvNL8kpO24JxDTRMeRpgSQOiNyHTQD0/zh5ey1l+fJxD489uV
	 NAqqiChKZJ4A6HOF7JvUomsGaRxpGaizmVrKS1eGmJdp5acv2US6zqZ/kz4CbC5wwUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bX7tcOuLuDJoH/pwnV7oqkOMTdEACozboMnHUVZmrs8=;
	b=l/pg/RA+bj/WDXEQzxD9FodFn+NjSPfnDT8JRj0wX+No7pUhY5jvKVXUYESNQJ0xy/Xw
	 nhOgduth5QHJIH2ZXrYTg6gpI6A1gP2GV4KV/Mxjc2bH37n1+Ahgw2Ryg+t67csubJLYW
	 i44fhp9Wi/NKTk5yTCBmpsfvchBps/fNGB9iSsSiS4GIiJWoCWFVdA5EN90yONa+Ye8jt
	 GZmyTOZLV7xmtZ4EkvXTg1yi7+z2sBCWGC5/cJmHhggG58pBfHn50Mo+ES8SPpEokF5v1
	 CrbY61/9rAYHy2v3iFCrdkEJxIqCXrMqxw2Iaahs3NitWAnc2i6jnDsAz+AGmI8tGaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rme9QwdR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350C2606A33F;
	Wed, 25 Nov 2026 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rme9QwdR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889BF1F000CF;
	Wed, 25 Nov 2026 15:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622157;
	bh=bX7tcOuLuDJoH/pwnV7oqkOMTdEACozboMnHUVZmrs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rme9QwdRed2gXre2BOQRWuXScKIhQKxlYVumcALdRQQrsAVgbT5uB+R+vt2HK1G7W
	 GiDayfj52+UwSL4XxaMOdHLxWnS4gQ5F5ALuu6jRNWfDciMAXVLinT4lR3kwHJpiHf
	 2c65qqQYPxiWzCSQ3Jsn4B0eBIVXMcwcZlZ/5Pco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 440/990] tcp: do not resurrect a former listener with SO_ATTACH_REUSEPORT_[CE]BPF
Date: Wed, 25 Nov 2026 15:30:07 +0100
Message-ID: <20261125143832.400884642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 8c011697f76abf3b2302718a7a1c50e36d849f28 ]

After listen() + shutdown(), a TCP socket is moved to the closed
section of its reuseport group, while TCP_NEW_SYN_RECV requests
can still reference it as rsk_listener.

If SO_ATTACH_REUSEPORT_[CE]BPF is then used on this socket,
reuseport_attach_prog() calls reuseport_alloc(), which resurrects
it into the listening section of a new group, even though the
socket is still in TCP_CLOSE.

After close(), the socket stays in that group and the pending
requests keep it allocated. When the final ACK arrives,
reuseport_migrate_sock() can select this dead socket and
inet_csk_clone_lock() clones it. With a ULP like espintcp installed
while in TCP_CLOSE, the child inherits icsk_ulp_data and sk_destruct
after tcp_cleanup_ulp() cleared icsk_ulp_ops, leading to a
use-after-free in espintcp_destruct().

As done in commit 8cc3aef0cb19 ("tcp: Do not allow buggy transitions
between ehash and lhash2."), deny this transition instead of adding
checks to the fast path.

Only an unhashed former listener is affected. Applications can still
attach a reuseport prog to a socket that never listened, or to a
listener (including one that called listen() again after shutdown()).

Fixes: 333bb73f620e ("tcp: Keep TCP_CLOSE sockets in the reuseport group.")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261106084300.2029567-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_reuseport.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index d4b7caf86eee3..eb8d24964e2f6 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -6,6 +6,7 @@
  * selecting the socket index from the array of available sockets.
  */
 
+#include <net/inet_connection_sock.h>
 #include <net/ip.h>
 #include <net/sock_reuseport.h>
 #include <linux/bpf.h>
@@ -692,6 +693,14 @@ int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
 		if (!sk->sk_reuseport)
 			return -EINVAL;
 
+		/* Do not put a shutdown()ed TCP listener back into the
+		 * listening section of a reuseport group while it is in
+		 * TCP_CLOSE: requests can still migrate to it.
+		 */
+		if (sk_is_tcp(sk) &&
+		    inet_csk(sk)->unhashed_state == TCP_LISTEN)
+			return -EINVAL;
+
 		err = reuseport_alloc(sk, false);
 		if (err)
 			return err;
-- 
2.53.0



