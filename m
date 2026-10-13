Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3602503BD4;
	Tue, 13 Oct 2026 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892994; cv=none; b=drKT8LQt71LQxDYDM3imkH6j0izeEYllQhksfhUBP3ij874HWvW1mWAN9bDEoO8X4Qw3w2VKd1UcIHFKMXh/rRShXfgF8NIgRxr1bkoT9/umN/jJMzxrcP/bczv+W3AYtNC+Hk2v9YBhYCLg3rhI59llV/v3RWLN6shfoXZfCdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892994; c=relaxed/simple;
	bh=QxtmpWPtyX6ZXYAec9MMxIDrFGxeDHSs9ElTcSGmf48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az5TG7VIuuDRRqTjndc8oH7LHzTDwBsf/VfemCD0JL7o11ZpS84BdVbs+jr4tX50rJ0GXYQq/JO9xbUcigd9boE7OSpq/3BqvAQwfAUDqIVRAxl8F+6V3+AJIKgzMywXMyY0XWuSwx3VzW6zkdWyMZ7ng+UVrzpK1QALx4jVh/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwSv3p1h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwSv3p1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5BC1F00898;
	Tue, 13 Oct 2026 12:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892993;
	bh=84qSvAROtPheboTNkH1PT1DksIDt0wOTyiz4uiPW7o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwSv3p1hxksb+aj4gpD4bzKMqPUZd6xiJfdrJWI1JL/4zWrROuLTejPQCaJ8VS52h
	 cr80+6NOJENTzMKSEFeTEZGm+7xTNhvcmpJ8MC0Tz+q3tRfm40vEvycSsayEQIUp9q
	 ba7LKNVUifuDJoHVhGugXv4JBxASmbptzaTJD+0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 078/621] net/smc: protect clcsock lifetime in smc_getname
Date: Tue, 13 Oct 2026 13:31:13 +0200
Message-ID: <20261013112922.706059163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2788,6 +2788,7 @@ int smc_getname(struct socket *sock, str
 		int peer)
 {
 	struct smc_sock *smc;
+	int rc = -EBADF;
 
 	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
 	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
@@ -2795,7 +2796,11 @@ int smc_getname(struct socket *sock, str
 
 	smc = smc_sk(sock->sk);
 
-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)


