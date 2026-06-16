Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30151E8320;
	Tue, 16 Jun 2026 15:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623274; cv=none; b=QuQ3jfdFDm6yk0qQsWzEc5+mTDFlErZxIQZXkGPE9viAmN4zsVQfwDcbtvOY5aJNRcxvY0GucKAKHsqX2PwjUc0a+5m6XfowQqjSQc4uKykJqKRTOijGlZOHs4922YaaywzTPbMT2X0QQLPKIxnRowTwKan1hGTod45XLR+wKwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623274; c=relaxed/simple;
	bh=wPhjochYu+SLQhvSGPMoWbYr+RFlE/IPLAHK8FebWlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fqm9VzIeOgkT32k40jZFxzgxVVoy35AO/fZGJ+E1VeXIsC3ADRipIwSRFyDFByJogMXDDHjpG9HT+IA019SSftY78PcfRUaztiS4A10o87bG75lPJrSDSrrIdkm89hIJ7tZ/KtyGdLsxqO5N/pR2SNnrNodagEY3cA/MHj2vg+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5HOgiQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5HOgiQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8471F000E9;
	Tue, 16 Jun 2026 15:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623272;
	bh=1HfJ0Vv9qhnSR/IwL1W9SjrDNGzrNdcfB6O6zmCNkag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5HOgiQZ9u1BXPxyQG6P2MoZiAG+SGcIEaibTgTe7rSTVt6tWOuao0HTGdvp1LPOK
	 zWsUyWnBHP3KnXgsCD9gWtT92fjM7kzffgTSZbvcwq9gwW8Jy2UB0z0f3rhWCZHQEZ
	 Xscr32xUlk7MZTAHM+mK65zo6pDvGoBHC0ARyjSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 118/378] net: qrtr: fix refcount saturation and potential UAF in qrtr_port_remove
Date: Tue, 16 Jun 2026 20:25:49 +0530
Message-ID: <20260616145116.567887734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

[ Upstream commit a2171131ecda1ed61a594a1eb715e75fdad0fef5 ]

In qrtr_port_remove(), the socket reference count is decremented via
__sock_put() before the port is removed from the qrtr_ports XArray and
before the RCU grace period elapses.

This breaks the fundamental RCU update paradigm. It exposes a race
window where a concurrent RCU reader (such as qrtr_reset_ports() or
qrtr_port_lookup()) can obtain a pointer to the socket from the XArray,
and attempt to call sock_hold() on a socket whose reference count has
already dropped to zero.

This exact race condition was hit during syzkaller fuzzing, leading to
the following refcount saturation warning and a potential Use-After-Free:

  refcount_t: saturated; leaking memory.
  WARNING: CPU: 3 PID: 1273 at lib/refcount.c:22 refcount_warn_saturate+0xae/0x1d0
  Modules linked in: qrtr(+) bochs drm_shmem_helper ...
  Call Trace:
   <TASK>
   qrtr_reset_ports net/qrtr/af_qrtr.c:768 [inline] [qrtr]
   __qrtr_bind.isra.0+0x48b/0x570 net/qrtr/af_qrtr.c:805 [qrtr]
   qrtr_bind+0x17d/0x210 net/qrtr/af_qrtr.c:901 [qrtr]
   kernel_bind+0xe4/0x120 net/socket.c:3592
   qrtr_ns_init+0x1a6/0x380 net/qrtr/ns.c:715 [qrtr]
   qrtr_proto_init+0x3b/0xff0 net/qrtr/af_qrtr.c:169 [qrtr]
   do_one_initcall+0xf5/0x5e0 init/main.c:1283
   ...
   </TASK>

Fix this by deferring the reference count decrement until after the
xa_erase() and the synchronize_rcu() complete.

(Note: The v1 of this patch incorrectly replaced __sock_put() with
sock_put(). As Simon Horman pointed out, the callers of qrtr_port_remove()
still hold a reference to the socket, so freeing the socket memory here
would lead to a subsequent UAF in the caller. Thus, the __sock_put() is
kept, but only repositioned to close the RCU race.)

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260604064801.1180388-1-w15303746062@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index d77e9c8212da51..7087bb57aeac18 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -707,13 +707,13 @@ static void qrtr_port_remove(struct qrtr_sock *ipc)
 	if (port == QRTR_PORT_CTRL)
 		port = 0;
 
-	__sock_put(&ipc->sk);
-
 	xa_erase(&qrtr_ports, port);
 
 	/* Ensure that if qrtr_port_lookup() did enter the RCU read section we
 	 * wait for it to up increment the refcount */
 	synchronize_rcu();
+
+	__sock_put(&ipc->sk);
 }
 
 /* Assign port number to socket.
-- 
2.53.0



