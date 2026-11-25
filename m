Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624878;
	b=odT87Xd2vrByTYwDyVwLbW5uSNqEOaKWOsxD4+wEz9AkJeFt6KllDVN8x/ccw/Jb50gx
	 BWKiVqBzOkwSTeeZw3cqe0v4BxNRaxAhC+K7ha+zPNlicNovP12H5Y7e11Ez/S16B0Tq/
	 dDlky5vIjCGxEK/QD5ZKruTrGcwVNl8bE68Cx55N++ZeRuk2l6suXU+F2RxG2L3D/5MsO
	 Bng3kZ7A0GO1d+Cx0cvooC0TTTkgmS/+v/56Qn3yyf1BnqwrVicoejO70iQXK8Axa5iBC
	 kAypSaIdZkGtT4SNjVdp9EVU9Rs66qw/cNME++XdBcddUQh30aD59VTRMiUMceu8X8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gVPx0P/2Ytmw6wKYU0QxZ+GUCiTGEVQWg+aJNckhAFg=;
	b=VP1VkK36lnevwuZw+UbnL51zszu+G2pJjJpcSoN/CXCefuq05sD+lx/jGGtfm1VsbR6N
	 hSKUhVHZbkIJb0oPWtBu6o3u4OTu/X+SPBCe09l/ZRsOXPSYW+hteTR0bwGpg7h7SlHn+
	 Sq2KsX09qOTuvGy1Eie8rmH8nh+myO3q3nsdOZbt3WJ7ETCdWrIfkic9vbA22M281Hyr8
	 3m9fLwzBcZAa5xsieLICnCP0MaJej7IvRKpiJHEA1hqwcHMoU5mmwKrwoG1XMEjLWalDn
	 +8mXqGq96Nfg8CSpY99uH7juirjdNIxWvVKUU/q72/F2hMgzdqCp6kId7vq+e1ZkEag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSnnMOKv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696F3606A326;
	Wed, 25 Nov 2026 16:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eSnnMOKv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5751F000C6;
	Wed, 25 Nov 2026 16:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624877;
	bh=gVPx0P/2Ytmw6wKYU0QxZ+GUCiTGEVQWg+aJNckhAFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSnnMOKvD/rQAMaA3XM1atbTSAuF+JGV1e73/rhqWTCaK+wETrMqASafpZo4oNWgQ
	 mKrxZcoGpuIR0pIPHxP3tsT0xgD+cN5B1lowz4rHaNuySVvTMAhV+AlSBT0+NAJP7F
	 HPrBypy5LX+Q6MXWHfdnlCh3KU1H1cV2FXqyP3hM=
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
Subject: [PATCH 6.12 336/816] tcp: do not resurrect a former listener with SO_ATTACH_REUSEPORT_[CE]BPF
Date: Wed, 25 Nov 2026 15:31:24 +0100
Message-ID: <20261125143856.975873338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



