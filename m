Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209057;
	b=lDe18pYemWGDiQwm6esYnkvaI6Omr+HUdKegjl7iNplLm4UH+uTyhPjBUtczqDvFCN85
	 r4GrZ21dAaVwVAcn21P/LpQOs/xeAMLG2zrVmPly1WfywNGvO166ly8zT8JZr2Ohj48vK
	 04ZMnCh0+5UukFM+DFdcRcgXJ+GgRYkZPSvMUtD5v2xSlF1NE7hYJ7uNsj9S+iz9Vpj/Q
	 GfaYOCnJTOixDKbnhL5+RbfenxHM8AIZnrmEA3L/KOvgzvA9AP5o7VnBoDgtm6DgCmeTc
	 vFF6C4QLXOnvGNlaoaPpoXM4wd/jMI0ZUzU5jm8FL6oYymMojK1TvvYE1B0yFRnHeCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VRloFzujeMmVIbOjBBdjOo+EpxYR7FL02wfTomqvoR8=;
	b=Ms/3U2BxieZx3ZkUBiDLWQ27wRdDEtxyCtc+zggOXz6HpyynA7ZhXLUBXDfsbmSC8V/p
	 3vPM9q33PaKVZGuIokKlQkYWj7uuAwShvF2EITRcPk2/hOpx5p3cTHw0CuJukwmGWeUGo
	 Pftyuxxwlc/eoKzv1iKrh5pqRCYanE+LT8LZc0tjy7dGbfCRqA4s5CCavi7g45NGtnUBm
	 ipizn1nsowOlfwGvtlaXjONXHYQeNGWnWt7Ig5UL0bzWwDx9uTWprdz57LY4zAu24ztQg
	 3mtWreRNIPnlNiBqJlgvntXbTHzvIMLTxm1oK5N5cy9SzUkz44hruGbGsSlz9Fz8NAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3wkSIlF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F9C60A2614;
	Wed, 28 Oct 2026 17:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3wkSIlF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D90B1F031E0;
	Wed, 28 Oct 2026 17:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209056;
	bh=VRloFzujeMmVIbOjBBdjOo+EpxYR7FL02wfTomqvoR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3wkSIlFSYhr9Fj+sMSsSpFocYv7NgHI6q0tsrth2kgwH6POf7KQljrsAQP6Z5XU9
	 b3ZSfzeQV8z8nyP5EFnReTjoRe/bs2XcDw3+eTaLWKRlWnBMFqaLhend/L/DoJ8SKc
	 pIg3unRTYA5xz7jvoQDBFl9dW08wNbaD+x08pTQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 338/516] net/smc: protect clcsock lifetime in smc_getname
Date: Wed, 28 Oct 2026 17:58:10 +0100
Message-ID: <20261028170011.495435585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1987,6 +1987,7 @@ static int smc_getname(struct socket *so
 		       int peer)
 {
 	struct smc_sock *smc;
+	int rc = -EBADF;
 
 	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
 	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
@@ -1994,7 +1995,11 @@ static int smc_getname(struct socket *so
 
 	smc = smc_sk(sock->sk);
 
-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)


