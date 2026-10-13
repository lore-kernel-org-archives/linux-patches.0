Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8354E7802;
	Tue, 13 Oct 2026 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895813; cv=none; b=IK+ocZ1rdBHWr9rkfUDASaF4k6joxK74CG6YkAPW0qgRxk84Ppu02Rr+ve8NgVoOsD6ZNKE6wnwlNy7/bbn8lBGonIAo8phOKYNVrtDPHmGHK+Ntt0t7EeHPCxWWdFqGa/hTnh/AfNC70PNMtEnrdLcB4S4LiW10oFUTVUIi11A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895813; c=relaxed/simple;
	bh=fumWAz66jWNJFNHemojpQVuF++iBjDKk2Qq1PtG35Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cy+M8I/QDONKY7k+0TJI8KIuv0uDx7fJXUkYPHXZBBo63Q6cXBfV/g+wHl7nPpWkqdSPZ9eymAAvArvR2oytF2IapTg3HV7y3XT+5lYWdBUdG8QKpRqOD1s5OsYEQuOCfOyjO+yHAsTsxuIWBVVq+eEmHBF/IiMJrRaslI8Oo6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGFc/W0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGFc/W0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CE51F0089E;
	Tue, 13 Oct 2026 12:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895812;
	bh=A7I0NEtX+6EmWvozJefu6/WsQhR2r0m0kNQqU5oUM28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGFc/W0jApiZwHEftVzRxDNGokgioEMl394H7x56d9I+L+oSa1fSMkNWrpMCG86/w
	 ThgyKT1LbLAcz0iJ2UEPfq2rtsIvMecudLyui1ieM+oujm1p9ltfjMe3FECHxLROKF
	 p4eSZshdLqk3S8pIno4YtosZQMHnktJHa73rzJtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 400/497] net/smc: protect clcsock lifetime in smc_getname
Date: Tue, 13 Oct 2026 13:39:27 +0200
Message-ID: <20261013112917.385093504@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2789,6 +2789,7 @@ int smc_getname(struct socket *sock, str
 		int peer)
 {
 	struct smc_sock *smc;
+	int rc = -EBADF;
 
 	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
 	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
@@ -2796,7 +2797,11 @@ int smc_getname(struct socket *sock, str
 
 	smc = smc_sk(sock->sk);
 
-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)


