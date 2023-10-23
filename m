Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33D715484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wr0a1I0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1A9C433C7;
	Mon, 23 Oct 2023 11:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060181;
	bh=RprSElW6J048w0zVJ690QJSm3llsgfRBpPj863AalxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wr0a1I0Nb6WPGegLtb9SiMADI+FiaM6hjidw71sr6N80akvV4RypfT5md99bzH/5N
	 HLz0DXapL7pueliskTZXRAZKWErPbqIEBh1zlJ8ulAcR692eqATnnhFHsSu9R6tIip
	 6+2OOJKTDz2lQGDupm7C7WwoPlwWual5STH7xm08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.1 048/196] xfrm: fix a data-race in xfrm_gen_index()
Date: Mon, 23 Oct 2023 12:55:13 +0200
Message-ID: <20231023104829.875320515@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 3e4bc23926b83c3c67e5f61ae8571602754131a6 upstream.

xfrm_gen_index() mutual exclusion uses net->xfrm.xfrm_policy_lock.

This means we must use a per-netns idx_generator variable,
instead of a static one.
Alternative would be to use an atomic variable.

syzbot reported:

BUG: KCSAN: data-race in xfrm_sk_policy_insert / xfrm_sk_policy_insert

write to 0xffffffff87005938 of 4 bytes by task 29466 on cpu 0:
xfrm_gen_index net/xfrm/xfrm_policy.c:1385 [inline]
xfrm_sk_policy_insert+0x262/0x640 net/xfrm/xfrm_policy.c:2347
xfrm_user_policy+0x413/0x540 net/xfrm/xfrm_state.c:2639
do_ipv6_setsockopt+0x1317/0x2ce0 net/ipv6/ipv6_sockglue.c:943
ipv6_setsockopt+0x57/0x130 net/ipv6/ipv6_sockglue.c:1012
rawv6_setsockopt+0x21e/0x410 net/ipv6/raw.c:1054
sock_common_setsockopt+0x61/0x70 net/core/sock.c:3697
__sys_setsockopt+0x1c9/0x230 net/socket.c:2263
__do_sys_setsockopt net/socket.c:2274 [inline]
__se_sys_setsockopt net/socket.c:2271 [inline]
__x64_sys_setsockopt+0x66/0x80 net/socket.c:2271
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffffffff87005938 of 4 bytes by task 29460 on cpu 1:
xfrm_sk_policy_insert+0x13e/0x640
xfrm_user_policy+0x413/0x540 net/xfrm/xfrm_state.c:2639
do_ipv6_setsockopt+0x1317/0x2ce0 net/ipv6/ipv6_sockglue.c:943
ipv6_setsockopt+0x57/0x130 net/ipv6/ipv6_sockglue.c:1012
rawv6_setsockopt+0x21e/0x410 net/ipv6/raw.c:1054
sock_common_setsockopt+0x61/0x70 net/core/sock.c:3697
__sys_setsockopt+0x1c9/0x230 net/socket.c:2263
__do_sys_setsockopt net/socket.c:2274 [inline]
__se_sys_setsockopt net/socket.c:2271 [inline]
__x64_sys_setsockopt+0x66/0x80 net/socket.c:2271
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00006ad8 -> 0x00006b18

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 29460 Comm: syz-executor.1 Not tainted 6.5.0-rc5-syzkaller-00243-g9106536c1aa3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023

Fixes: 1121994c803f ("netns xfrm: policy insertion in netns")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netns/xfrm.h |    1 +
 net/xfrm/xfrm_policy.c   |    6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -50,6 +50,7 @@ struct netns_xfrm {
 	struct list_head	policy_all;
 	struct hlist_head	*policy_byidx;
 	unsigned int		policy_idx_hmask;
+	unsigned int		idx_generator;
 	struct hlist_head	policy_inexact[XFRM_POLICY_MAX];
 	struct xfrm_policy_hash	policy_bydst[XFRM_POLICY_MAX];
 	unsigned int		policy_count[XFRM_POLICY_MAX * 2];
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1371,8 +1371,6 @@ EXPORT_SYMBOL(xfrm_policy_hash_rebuild);
  * of an absolute inpredictability of ordering of rules. This will not pass. */
 static u32 xfrm_gen_index(struct net *net, int dir, u32 index)
 {
-	static u32 idx_generator;
-
 	for (;;) {
 		struct hlist_head *list;
 		struct xfrm_policy *p;
@@ -1380,8 +1378,8 @@ static u32 xfrm_gen_index(struct net *ne
 		int found;
 
 		if (!index) {
-			idx = (idx_generator | dir);
-			idx_generator += 8;
+			idx = (net->xfrm.idx_generator | dir);
+			net->xfrm.idx_generator += 8;
 		} else {
 			idx = index;
 			index = 0;


