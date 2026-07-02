Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C141FA859;
	Thu,  2 Jul 2026 17:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011663; cv=none; b=vFIPRME4bmTVuqcawhQuZHhJmhajEeybI/oRa48TDNT3NL9yLBW13FMOTGKZTqPzMwep+MRPxzjlZYuxiHgo/FKAFTsxxCTbuGS4BN0csuMoluiKsdudmJDPmrZp7DC/EcE+3CGPYwMhHX5H7seIKpbT+SY5DsSOt94vdvmH00Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011663; c=relaxed/simple;
	bh=kdXozMpITcUeAyLI8xdSJZY4Km+p+LQMWJJZ9gs6xAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkIpw5UmkZHcAw/Y0W10XU8s542hJ+q4Qp28qw7LpOpY5kqVXgyxA4YK6NFp2Op7KEw21bu3vh3pK9EYyH9SL0kQcDUihMQzYjU0CNu2D2oRoOS1GxHWo6cdqIrlc0h6zZgHzusF7bfzCFjWF9mo9qRm5xUPqQJvKlocRx+22RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVc6RhoW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVc6RhoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DD91F000E9;
	Thu,  2 Jul 2026 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011662;
	bh=amfcbCdEnAjOj9DCJ4R4R7UutXUgOFlZTznGcDs3SzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVc6RhoWnRIsrCLZSAYVAAqPJaTYlC3CAlSYRaU9qL7hV1dFR9Dh7YGufsT5IGHQp
	 fBzRHIi0lLFK3pvmH5lke+N/LO+pDptHDVPFmDC9cFF/ypZk7xA7Ii6aDlgoZNBRzI
	 GKMA01XKXkRHM6W7gLcAfJc31hu+bC5Hm5+edPu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 084/120] tipc: fix slab-use-after-free Read in tipc_aead_decrypt_done
Date: Thu,  2 Jul 2026 18:21:20 +0200
Message-ID: <20260702155114.698661137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit bda3348872a2ef0d19f2df6aa8cb5025adce2f20 upstream.

tipc_aead_decrypt() goes straight from tipc_bearer_hold(b) to
crypto_aead_decrypt(req) without taking a reference on the netns, unlike
the encrypt path. When crypto_aead_decrypt() is offloaded asynchronously
(e.g. the SIMD aead wrapper queuing to cryptd), the cryptd worker runs
tipc_aead_decrypt_done() later. If the bearer's netns is torn down in the
meantime, cleanup_net() -> tipc_exit_net() -> tipc_crypto_stop() frees the
per-netns tipc_crypto, and the completion then reads it:
tipc_aead_decrypt_done() dereferences aead->crypto->stats and
aead->crypto->net, and tipc_crypto_rcv_complete() dereferences
aead->crypto->aead[] and the node table -- reading freed memory.

Decoded KASAN splat (v7.1-rc7, CONFIG_KASAN_INLINE + TIPC + TIPC_CRYPTO):

  BUG: KASAN: slab-use-after-free in tipc_aead_decrypt_done (net/tipc/crypto.c:999)
  Read of size 8 at addr ffff8881056258a8 by task kworker/u16:2/51
  Workqueue: events_unbound
  Call Trace:
   tipc_aead_decrypt_done (net/tipc/crypto.c:999)
   process_one_work (kernel/workqueue.c:3314)
   worker_thread (kernel/workqueue.c:3397 kernel/workqueue.c:3478)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

  Allocated by task 169:
   __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
   tipc_crypto_start (net/tipc/crypto.c:1502)
   tipc_init_net (net/tipc/core.c:72)
   ops_init (net/core/net_namespace.c:137)
   setup_net (net/core/net_namespace.c:446)
   copy_net_ns (net/core/net_namespace.c:579)
   create_new_namespaces (kernel/nsproxy.c:132)
   __x64_sys_unshare (kernel/fork.c:3316)
   do_syscall_64 (arch/x86/entry/syscall_64.c:63)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  Freed by task 8:
   kfree (mm/slub.c:6566)
   tipc_exit_net (net/tipc/core.c:119)
   cleanup_net (net/core/net_namespace.c:704)
   process_one_work (kernel/workqueue.c:3314)
   kthread (kernel/kthread.c:436)

This is the same class of bug that commit e279024617134 ("net/tipc: fix
slab-use-after-free Read in tipc_aead_encrypt_done") fixed for the encrypt
side. The encrypt path takes maybe_get_net(aead->crypto->net) before
crypto_aead_encrypt() and drops it with put_net() on the synchronous
return paths and in tipc_aead_encrypt_done(); the -EINPROGRESS/-EBUSY
return keeps the reference for the async callback to release. The decrypt
path was left without the equivalent guard.

Mirror the encrypt-side fix on the decrypt path: take a net reference
before crypto_aead_decrypt() (failing with -ENODEV and the matching
bearer put if it cannot be acquired), keep it across the
-EINPROGRESS/-EBUSY async return, and drop it with put_net() on the
synchronous success/error return and at the end of
tipc_aead_decrypt_done().

Reproduced under KASAN on v7.1-rc7: a UDP bearer with a cluster key is
flooded with crafted encrypted frames from an unknown peer (driving the
cluster-key decrypt path) while the bearer's netns is repeatedly torn
down. The completion must run asynchronously to outlive
tipc_crypto_stop(); on x86 the stock aesni gcm(aes) now decrypts
synchronously, so the async path was exercised via cryptd offload. The
unguarded aead->crypto dereference in tipc_aead_decrypt_done() is the
unpatched upstream path; tipc_aead_decrypt() still lacks
maybe_get_net(aead->crypto->net), so the completion can outlive the free
on any config where crypto_aead_decrypt() goes async.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260617075818.37431-1-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/crypto.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -941,12 +941,20 @@ static int tipc_aead_decrypt(struct net
 		goto exit;
 	}
 
+	/* Get net to avoid freed tipc_crypto when delete namespace */
+	if (!maybe_get_net(net)) {
+		tipc_bearer_put(b);
+		rc = -ENODEV;
+		goto exit;
+	}
+
 	/* Now, do decrypt */
 	rc = crypto_aead_decrypt(req);
 	if (rc == -EINPROGRESS || rc == -EBUSY)
 		return rc;
 
 	tipc_bearer_put(b);
+	put_net(net);
 
 exit:
 	kfree(ctx);
@@ -984,6 +992,7 @@ static void tipc_aead_decrypt_done(void
 	}
 
 	tipc_bearer_put(b);
+	put_net(net);
 }
 
 static inline int tipc_ehdr_size(struct tipc_ehdr *ehdr)


