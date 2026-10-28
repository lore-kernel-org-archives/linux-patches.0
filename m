Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216452;
	b=w2IuXHVoGqUATstID5tarNqRJVjPZctRM1QVil7recDruWosJsRu77SjeN44EfCMnrcx
	 cPtQQKBYOSaX+ZA2Vg9NTB2dK/+B9sMQ6IgDmimfE/yn5lLqPMb7TET6QSE9c1fBtT/WJ
	 jFyP8O+5TJsy72TaFV8OA1K1KQ56ZU5sdFo+qZG+Jnjrzb4Qd4YWGowNHsH5wwN+uYUPF
	 AkraipZqK/Ep0/ROBYs1QbZXJyzP9jsTdHp6NI+Qfq9crRlVnH63mytKmHvD/WwUfmGGo
	 y9ASDF0LD4uyP0nYX2jCZw0gSuQwoNDZQLvWKJeBn5jBMP4Kge5G0Y7naMMUqq17kVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBrMyJwrsIEvey5Zv7vrnbmL6ARxX13aMr3oeohJBnA=;
	b=k6xYz8ao/nlShSx8Lh6srRsTVMbZ0oTqKsL6hgDo15i1pimziKfYr5O6ztTlGCjFCyoE
	 lRurvIlSFFmBO/WKTr9U5JgsakgCMrouizMMq4izePgOx15Vtp0PSxnGH0jXmYeBz0URo
	 xqSy3XuL4Qp6lysTWRAwo2wmsrxlr95Lwdn2INy9QU9nQwor83xufGMuFU1fWQLGOHgAP
	 rjYzCiETGeFSqvzXe0yBVzKzv97LfuATmfdjWH1oFUTMpXU1Ck+KoSunteKiZJXm+KeYY
	 7Meot4i3N8Iz0ofFBCIr+ukxGgFnnt0b1VzofbVuj9JUqgOj3HJkrvSrbOxbFrfcndQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NP93qa6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE8D606A326;
	Wed, 28 Oct 2026 19:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0NP93qa6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3751F031E1;
	Wed, 28 Oct 2026 19:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216452;
	bh=PBrMyJwrsIEvey5Zv7vrnbmL6ARxX13aMr3oeohJBnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0NP93qa6/tq7BMhbX5PnbYi9+Ip6ehw+pPwDFaZCQI2L23vif6p3T8E12d21kKiTe
	 6dVFvEQFvInORgFhWVW5X9N4JLoI+sp+VPawsnrkMQKkOPfiSR4y4bKnU6a7+/c/OT
	 v2BhXWEg23gbdzPNW4hkw4EMZyOl9lJVj7GbBGPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1562/1887] net: Introduce sk_use_task_frag in struct sock.
Date: Wed, 28 Oct 2026 18:00:58 +0100
Message-ID: <20261028170535.010483440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit fb87bd47516d9a26b6d549231aa743b20fd4a569 ]

Sockets that can be used while recursing into memory reclaim, like
those used by network block devices and file systems, mustn't use
current->task_frag: if the current process is already using it, then
the inner memory reclaim call would corrupt the task_frag structure.

To avoid this, sk_page_frag() uses ->sk_allocation to detect sockets
that mustn't use current->task_frag, assuming that those used during
memory reclaim had their allocation constraints reflected in
->sk_allocation.

This unfortunately doesn't cover all cases: in an attempt to remove all
usage of GFP_NOFS and GFP_NOIO, sunrpc stopped setting these flags in
->sk_allocation, and used memalloc_nofs critical sections instead.
This breaks the sk_page_frag() heuristic since the allocation
constraints are now stored in current->flags, which sk_page_frag()
can't read without risking triggering a cache miss and slowing down
TCP's fast path.

This patch creates a new field in struct sock, named sk_use_task_frag,
which sockets with memory reclaim constraints can set to false if they
can't safely use current->task_frag. In such cases, sk_page_frag() now
always returns the socket's page_frag (->sk_frag). The first user is
sunrpc, which needs to avoid using current->task_frag but can keep
->sk_allocation set to GFP_KERNEL otherwise.

Eventually, it might be possible to simplify sk_page_frag() by only
testing ->sk_use_task_frag and avoid relying on the ->sk_allocation
heuristic entirely (assuming other sockets will set ->sk_use_task_frag
according to their constraints in the future).

The new ->sk_use_task_frag field is placed in a hole in struct sock and
belongs to a cache line shared with ->sk_shutdown. Therefore it should
be hot and shouldn't have negative performance impacts on TCP's fast
path (sk_shutdown is tested just before the while() loop in
tcp_sendmsg_locked()).

Link: https://lore.kernel.org/netdev/b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com/
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 33930840b5f0 ("sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 11 +++++++++--
 net/core/sock.c    |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 4006584514f24..13c112bd2d316 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -319,6 +319,9 @@ struct sk_filter;
   *	@sk_stamp: time stamp of last packet received
   *	@sk_stamp_seq: lock for accessing sk_stamp on 32 bit architectures only
   *	@sk_tsflags: SO_TIMESTAMPING flags
+  *	@sk_use_task_frag: allow sk_page_frag() to use current->task_frag.
+  *			   Sockets that can be used under memory reclaim should
+  *			   set this to false.
   *	@sk_bind_phc: SO_TIMESTAMPING bind PHC index of PTP virtual clock
   *	              for timestamping
   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
@@ -520,6 +523,7 @@ struct sock {
 	u8			sk_txtime_deadline_mode : 1,
 				sk_txtime_report_errors : 1,
 				sk_txtime_unused : 6;
+	bool			sk_use_task_frag;
 
 	struct socket		*sk_socket;
 	void			*sk_user_data;
@@ -2685,14 +2689,17 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
  * socket operations and end up recursing into sk_page_frag()
  * while it's already in use: explicitly avoid task page_frag
  * usage if the caller is potentially doing any of them.
- * This assumes that page fault handlers use the GFP_NOFS flags.
+ * This assumes that page fault handlers use the GFP_NOFS flags or
+ * explicitly disable sk_use_task_frag.
  *
  * Return: a per task page_frag if context allows that,
  * otherwise a per socket one.
  */
 static inline struct page_frag *sk_page_frag(struct sock *sk)
 {
-	if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
+	if (sk->sk_use_task_frag &&
+	    (sk->sk_allocation & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC |
+				  __GFP_FS)) ==
 	    (__GFP_DIRECT_RECLAIM | __GFP_FS))
 		return &current->task_frag;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index fcd47d51b9f23..d05c0cb1e52e2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3440,6 +3440,7 @@ void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 	sk->sk_rcvbuf		=	READ_ONCE(sysctl_rmem_default);
 	sk->sk_sndbuf		=	READ_ONCE(sysctl_wmem_default);
 	sk->sk_state		=	TCP_CLOSE;
+	sk->sk_use_task_frag	=	true;
 	sk_set_socket(sk, sock);
 
 	sock_set_flag(sk, SOCK_ZAPPED);
-- 
2.53.0



