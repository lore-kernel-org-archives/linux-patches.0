Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827176;
	b=JvMoB7lbjYz64p0qTcbqCatgremumjvglamnczOVokl0Z6fPy30lbfk7KxKhR7WnAtQ9
	 26FdR2xrI9/dfs1HtEwMyBh4A5MsAMqjozt/2bK58MOEBE8xKzfOBmmjTp6URYio8hs8p
	 d6VtfntZBwXm/WgNzKBqMiUhmgkaATnwQ36780+HsWbXinPB7AwGB4hez12QWj/+oO2Jv
	 2edndGLLWPweBg5hqaqA/8tBARqcEN70ElEru18HywmJC6zIPj4jQ2I8OqkU0B1oPoXTT
	 63ozBXH6rEpjYRphOp7t7Z5yxsrjgScE82vkjvM1wme5G5+wNH9ua765vvAEcUP0M6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=02VfhqOk4v+1wZSGxsO9F8XmnlEuA3vDqDgnr45bwyg=;
	b=uhfJHYfAupTlrDCviQ8tkR6bOt2EHo5pld/ElQMCp650G6qjY6LkXYDU93lHT8aBvGOV
	 1087vDkG86CQusFbghmBirQ91Ua7VrlBHHQdDGeHuayJL7LnjRm5qpI5ibzopA79aemxO
	 pyjmpiocoOgskcie5ABu7PmMIVbq+7Z7Y9I6rN4nH1yC33xIaLkT/CbyO6deRXnChCWGZ
	 LGhnuJxAyUDDkjSVyssWdjlV+S8uBmsLuJalv5cxTixdhziQRTqTiuPmk8Ny4E2KRVxN1
	 z2Wh4QsvZssnzzgGjL820cUdemD45EwzsgSr5nB4YyLnNX1fGds8FP6zszcBU66ZXDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KB52oo6p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB91D607525E;
	Wed,  4 Nov 2026 21:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KB52oo6p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3241F000C1;
	Wed,  4 Nov 2026 21:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827175;
	bh=02VfhqOk4v+1wZSGxsO9F8XmnlEuA3vDqDgnr45bwyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KB52oo6pIL5XfdjKICgIHoLdYz6sSU5SxF4tj7cnHT+bVMR6+YvmfWpTx2qh399Yq
	 ZhkBvulbupF7T2KEKnKg682kzqU2ohCBQATvxd9CGnKdTCxQ20zF6fNT5fZwtl1i0u
	 q3CJzfXWuDndsns7+fbvDnj4yPVL5NzibjfbTiz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Vega <vega@nebusec.ai>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 239/547] mptcp: hold MP_JOIN msk ref when cloning reqsk
Date: Wed,  4 Nov 2026 16:07:03 -0500
Message-ID: <20261104211044.956041806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruide Cao <caoruide123@gmail.com>

commit c9c90cf437a9e6597611b6d3aad6e255fad22867 upstream.

TCP request migration clones pending request sockets with
inet_reqsk_clone().  For MPTCP MP_JOIN requests this byte-copies
subflow_req->msk, but the clone does not own a reference.

The original and cloned requests can consequently drop the same msk
reference, leaving one request with a dangling pointer.  This manifests as
a KASAN slab-use-after-free in subflow_req_destructor():

  BUG: KASAN: slab-use-after-free in subflow_req_destructor (net/mptcp/subflow.c:45)
  Write of size 4 at addr ff1100010e008d40 by task swapper/0/0
  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc5-00353-gc27e36054537 #10 PREEMPT(full)

  Call Trace:
   subflow_req_destructor (net/mptcp/subflow.c:45)
   subflow_v4_req_destructor (net/mptcp/subflow.c:694)
   __reqsk_free (net/ipv4/inet_connection_sock.c:906)
   reqsk_timer_handler (include/net/request_sock.h:137 net/ipv4/inet_connection_sock.c:1147)

  Allocated by task 10014:
   sk_prot_alloc (net/core/sock.c:2246)
   sk_clone (net/core/sock.c:2488)
   mptcp_sk_clone_init (include/net/sock.h:1848 net/mptcp/protocol.c:3564)
   subflow_syn_recv_sock (net/mptcp/subflow.c:883)
   tcp_check_req (net/ipv4/tcp_minisocks.c:934)

  Freed by task 0:
   slab_free_after_rcu_debug (include/linux/kasan.h:235 mm/slub.c:2677 mm/slub.c:6439)
   rcu_core (kernel/rcu/tree.c:2645 kernel/rcu/tree.c:2897)

  Last potentially related work creation:
   kmem_cache_free (mm/slub.c:2638 mm/slub.c:6377 mm/slub.c:6504)
   __sk_destruct (net/core/sock.c:2289 net/core/sock.c:2391)
   sk_destruct (net/core/sock.c:2419)
   __sk_free (net/core/sock.c:2430)
   sk_free (net/core/sock.c:2441)
   mptcp_close (include/net/sock.h:2020 net/mptcp/protocol.c:3399)
   inet_release (net/ipv4/af_inet.c:442)

  The buggy address belongs to the cache MPTCP of size 2968
  The buggy address is 128 bytes inside a freed 2968-byte region

A non-NULL subflow_req->msk means that the request owns one reference. The
third ACK can concurrently transfer the original request reference to the
child and release it, so taking an unconditional hold on the copied pointer
is unsafe.

MPTCP sockets use SLAB_TYPESAFE_BY_RCU and all current inet_reqsk_clone()
callers run in an RCU read-side critical section. Document and
lockdep-check that calling-context requirement.  Read the pointer from the
original request and acquire a reference only if it is still live.  Use
refcount_inc_not_zero_acquire() so the subsequent ownership validation
cannot be reordered before the try-get, then re-read the original request
to verify that it still owns the same msk. If either check fails, clear the
clone pointer; otherwise its normal destructor balances the new reference.
Mark the ownership-transfer store with WRITE_ONCE() to match the lockless
reads.

The following patch completes the clone fixup for MP_CAPABLE token
ownership. Both patches carry the same Fixes tag and are required for
stable backports.

Fixes: c905dee62232 ("tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.")
Cc: stable@vger.kernel.org
Reported-by: Kyle Zeng <kylebot@openai.com>
Reported-by: David Lee <david.lee@trailofbits.com>
Reported-by: Vega <vega@nebusec.ai>
Closes: https://lore.kernel.org/all/20260804095051.715355-1-david.lee@trailofbits.com/
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-3-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mptcp.h             |    9 +++++++++
 net/ipv4/inet_connection_sock.c |    4 ++++
 net/mptcp/subflow.c             |   35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 47 insertions(+), 1 deletion(-)

--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -219,6 +219,9 @@ int mptcp_subflow_init_cookie_req(struct
 struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
 					       struct sock *sk_listener,
 					       bool attach_listener);
+/* Caller must hold an RCU read-side lock. */
+void mptcp_subflow_reqsk_clone(struct request_sock *req,
+			       struct request_sock *new_req);
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb);
 
@@ -305,6 +308,12 @@ static inline struct request_sock *mptcp
 	return NULL;
 }
 
+/* Caller must hold an RCU read-side lock. */
+static inline void mptcp_subflow_reqsk_clone(struct request_sock *req,
+					     struct request_sock *new_req)
+{
+}
+
 static inline __be32 mptcp_reset_option(const struct sk_buff *skb)  { return htonl(0u); }
 
 static inline void mptcp_active_detect_blackhole(struct sock *sk, bool expired) { }
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -21,6 +21,7 @@
 #include <net/xfrm.h>
 #include <net/tcp.h>
 #include <net/tcp_ecn.h>
+#include <net/mptcp.h>
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 
@@ -961,6 +962,9 @@ static struct request_sock *inet_reqsk_c
 		rcu_assign_pointer(tcp_sk(nreq->sk)->fastopen_rsk, nreq);
 	}
 
+	if (rsk_is_mptcp(req))
+		mptcp_subflow_reqsk_clone(req, nreq);
+
 	return nreq;
 }
 
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -47,6 +47,39 @@ static void subflow_req_destructor(struc
 	mptcp_token_destroy_request(req);
 }
 
+void mptcp_subflow_reqsk_clone(struct request_sock *req,
+			       struct request_sock *new_req)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	struct mptcp_subflow_request_sock *new_subflow_req;
+	struct mptcp_sock *msk;
+
+	new_subflow_req = mptcp_subflow_rsk(new_req);
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
+			 "MPTCP reqsk clone called without RCU");
+
+	/* A non-NULL ->msk means the request owns one reference.  The clone
+	 * copied only the pointer, while the original request can concurrently
+	 * transfer its reference to the child.  Acquire a reference for the
+	 * clone, then verify that the original request still owns the same msk.
+	 * MPTCP sockets use SLAB_TYPESAFE_BY_RCU and all clone callers run in
+	 * an RCU read-side critical section, keeping the memory stable here.
+	 */
+	msk = READ_ONCE(subflow_req->msk);
+	if (msk) {
+		struct sock *sk = (struct sock *)msk;
+
+		if (!refcount_inc_not_zero_acquire(&sk->sk_refcnt)) {
+			msk = NULL;
+		} else if (READ_ONCE(subflow_req->msk) != msk) {
+			sock_put(sk);
+			msk = NULL;
+		}
+	}
+
+	new_subflow_req->msk = msk;
+}
+
 static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
 				  void *hmac)
 {
@@ -927,7 +960,7 @@ create_child:
 			}
 
 			/* move the msk reference ownership to the subflow */
-			subflow_req->msk = NULL;
+			WRITE_ONCE(subflow_req->msk, NULL);
 			ctx->conn = (struct sock *)owner;
 
 			if (subflow_use_different_sport(owner, sk)) {


