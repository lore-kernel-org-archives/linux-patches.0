Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699E26ED41;
	Mon, 13 Apr 2026 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096893; cv=none; b=XML/fiY5AbK9HVETHs7Ew0sZn6aXS+79xzAB61lD9Rf7E+j0ROtwmWoOGibulszB4O6vNxb1+5+3NGLcTrvQO6sPCEsvILNC7iu3NViNdEulSgGa8rQb/br4hsltUPDyAUwOsOojXWjtYT9COVNjsivh2iPryxBRoZlrrzdmwJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096893; c=relaxed/simple;
	bh=uMqKyN6AH9cctWv/YuFVnMrRJgCzYwz2uXDjWrEcrUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDCmIE2paOVyZfDh30SpC73jkl3WZsGcEabpx9LIlmoXEk8qsImU72uqUZjR88VbghuiH9qqJjs0a6FXHhIMC7ESEmIy86lQHfGqKPzB0sLm+doNrZfyP/5ERjFCuFMziR6gwXE0lCiSZZUiBmjgvl23Ua4ZFqog4aK8nYJglNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEi4q+ir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEi4q+ir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E2AC2BCAF;
	Mon, 13 Apr 2026 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096892;
	bh=uMqKyN6AH9cctWv/YuFVnMrRJgCzYwz2uXDjWrEcrUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEi4q+irvSsaChEmQDCe35Tcb94SYoV2uzMDcjFGWdMdizQ/YtjhKs8+teF21lYkp
	 lMa0/DlHhPi/6pRoA0GGrc3cScNENwiA7Dny6AjHfxELizoipVeN31HV9zdCl+leev
	 KvqhMjX2LGJe5IMNsrHHYZUuCU0JuFqyfcARH1UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 05/50] mptcp: fix slab-use-after-free in __inet_lookup_established
Date: Mon, 13 Apr 2026 18:00:32 +0200
Message-ID: <20260413155724.707213903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

commit 9b55b253907e7431210483519c5ad711a37dafa1 upstream.

The ehash table lookups are lockless and rely on
SLAB_TYPESAFE_BY_RCU to guarantee socket memory stability
during RCU read-side critical sections. Both tcp_prot and
tcpv6_prot have their slab caches created with this flag
via proto_register().

However, MPTCP's mptcp_subflow_init() copies tcpv6_prot into
tcpv6_prot_override during inet_init() (fs_initcall, level 5),
before inet6_init() (module_init/device_initcall, level 6) has
called proto_register(&tcpv6_prot). At that point,
tcpv6_prot.slab is still NULL, so tcpv6_prot_override.slab
remains NULL permanently.

This causes MPTCP v6 subflow child sockets to be allocated via
kmalloc (falling into kmalloc-4k) instead of the TCPv6 slab
cache. The kmalloc-4k cache lacks SLAB_TYPESAFE_BY_RCU, so
when these sockets are freed without SOCK_RCU_FREE (which is
cleared for child sockets by design), the memory can be
immediately reused. Concurrent ehash lookups under
rcu_read_lock can then access freed memory, triggering a
slab-use-after-free in __inet_lookup_established.

Fix this by splitting the IPv6-specific initialization out of
mptcp_subflow_init() into a new mptcp_subflow_v6_init(), called
from mptcp_proto_v6_init() before protocol registration. This
ensures tcpv6_prot_override.slab correctly inherits the
SLAB_TYPESAFE_BY_RCU slab cache.

Fixes: b19bc2945b40 ("mptcp: implement delegated actions")
Cc: stable@vger.kernel.org
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260406031512.189159-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    2 ++
 net/mptcp/protocol.h |    1 +
 net/mptcp/subflow.c  |   15 +++++++++------
 3 files changed, 12 insertions(+), 6 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -4301,6 +4301,8 @@ int __init mptcp_proto_v6_init(void)
 {
 	int err;
 
+	mptcp_subflow_v6_init();
+
 	mptcp_v6_prot = mptcp_prot;
 	strcpy(mptcp_v6_prot.name, "MPTCPv6");
 	mptcp_v6_prot.slab = NULL;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -746,6 +746,7 @@ static inline void mptcp_subflow_tcp_fal
 void __init mptcp_proto_init(void);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 int __init mptcp_proto_v6_init(void);
+void __init mptcp_subflow_v6_init(void);
 #endif
 
 struct sock *mptcp_sk_clone_init(const struct sock *sk,
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -2092,7 +2092,15 @@ void __init mptcp_subflow_init(void)
 	tcp_prot_override.psock_update_sk_prot = NULL;
 #endif
 
+	mptcp_diag_subflow_init(&subflow_ulp_ops);
+
+	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
+		panic("MPTCP: failed to register subflows to ULP\n");
+}
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+void __init mptcp_subflow_v6_init(void)
+{
 	/* In struct mptcp_subflow_request_sock, we assume the TCP request sock
 	 * structures for v4 and v6 have the same size. It should not changed in
 	 * the future but better to make sure to be warned if it is no longer
@@ -2132,10 +2140,5 @@ void __init mptcp_subflow_init(void)
 	/* Disable sockmap processing for subflows */
 	tcpv6_prot_override.psock_update_sk_prot = NULL;
 #endif
-#endif
-
-	mptcp_diag_subflow_init(&subflow_ulp_ops);
-
-	if (tcp_register_ulp(&subflow_ulp_ops) != 0)
-		panic("MPTCP: failed to register subflows to ULP\n");
 }
+#endif


