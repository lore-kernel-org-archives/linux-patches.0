Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211550;
	b=eh7VSop88VnIr/adRuDLIMc0QSF003OgxDpYXspiS/zTsr2WMCZFl6q/F84uokPuEyHo
	 cny3fT85SRbjBTZZwXJExp+Apuc6Gka1ZTNsiIDzqQE5aATbyJWsciDjWWka4WlYTtt99
	 R6BbEbVyhZU86LkJA2bVh5Tgg0fXL2lsjzRMmtJLM7ZczgxqA7BkfAvQ/K7ZrGG7lkSuj
	 OKsU6XaOxLdhL0eln+PuOA12yj90Gjdxi8powFv8XW0xMpHKGMTtRZ5WibrDGBYR78TuA
	 nYI/EaUF4t9dlo+5iwhPwKHWlzjoIu30p9pf6UpsVHFb1u3gQi+2UJrikjW05ZTCWAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YAro1frriZjB4ZTaEIFPjjq6zPTvGwbci2uri9WBAsw=;
	b=uwDj/U5veY7W3LqGA5EAsos0SnXwn7oN2i+Lv9S52OKcFFdFQexqEmZ+l1Us1X4I4zpe
	 giTdDfjyAe8ug23QCwXP3j5Ut8Fj4FDaespxdjCtTz8Ogt6lCkblx6luqUJkoY3phKQAP
	 OJqmMJqGNymQHZ/03IUh2nJThIYK9UkdyKKDMqraYo7m+1ZBRMsM+YKTm8vdDCJzvKL12
	 oil1W9K+cDS47hkYfAVmnN/QpOVTNuDOxTVqVOgthJURkb6NcXOWd18Jm1/tqg/1uG6Fs
	 k1uUKkZteenuIkJmpAElcbHSbv0bjBwQncbifoYwzvEHFjB1ceBVhri3kOjYcjGMaiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJPTt3Kp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35620606A321;
	Wed, 28 Oct 2026 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJPTt3Kp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86ED31F01825;
	Wed, 28 Oct 2026 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211550;
	bh=YAro1frriZjB4ZTaEIFPjjq6zPTvGwbci2uri9WBAsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJPTt3KpfaEaiVEif5e5PXYbf8IknJyG1Ib3oUJp7EDBWLTrOhZT1fi4g6ZIEqiNA
	 AAV7tzse2+pYwLdam8lKdQ3e+2Sln9rU96QAlnrqsjACk2CF/DAxlKX99iuhDc8zwP
	 FLr3wcwL5YDVJmaf8n1nVlQeR8Yk6sOYSb8i1i7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 372/571] net/smc: protect clcsock lifetime in smc_getname
Date: Wed, 28 Oct 2026 17:58:39 +0100
Message-ID: <20261028170016.840475526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 64a6b36b0e1855288080bc5f89769f27d6dc03c8 upstream.

smc_getname() dereferences smc->clcsock without holding
clcsock_release_lock. Link-group termination can release the CLC socket
through smc_close_active_abort() while the SMC socket is still open,
for example after shutdown(SHUT_WR).

A getsockname() caller can load smc->clcsock, then the termination worker
can clear the pointer and call sock_release() before the caller accesses
clcsock->ops or invokes getname(). This causes a use-after-free; if the
worker clears the pointer before the load, it causes a NULL dereference.
The syscall's file reference keeps the SMC socket alive but does not
prevent asynchronous release of its CLC socket.

KASAN reported the following with test-only timing instrumentation:

  BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
  Read of size 8 at addr ffff888109abb4e0 by task poc/103
  Call Trace:
   smc_getname+0x19e/0x1b0
   do_getsockname+0xe5/0x170
   __sys_getsockname+0x8c/0x100

  Allocated by task 95:
   sock_alloc_inode+0x1e/0x280
   sock_alloc+0x3d/0x240
   __sock_create+0x7e/0x430
   smc_create+0x121/0x240

  Freed by task 0:
   kmem_cache_free+0xcc/0x340
   rcu_core+0x50a/0x1850

  Last potentially related work creation:
   evict+0x446/0x6c0
   smc_clcsock_release+0xa8/0xd0
   smc_close_active_abort+0x26a/0x3a0
   __smc_lgr_terminate.part.0+0x137/0x2e0

Hold clcsock_release_lock across the pointer check and the getname()
callback to serialize with smc_clcsock_release(). Return -EBADF if the
CLC socket has already been released, preserving the existing peer
state check and the callback's return value otherwise.

Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20261008084444.787449-1-nicoyip.dev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2291,6 +2291,7 @@ static int smc_getname(struct socket *so
 		       int peer)
 {
 	struct smc_sock *smc;
+	int rc = -EBADF;
 
 	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
 	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
@@ -2298,7 +2299,11 @@ static int smc_getname(struct socket *so
 
 	smc = smc_sk(sock->sk);
 
-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)


