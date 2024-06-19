Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30633143757;
	Wed, 19 Jun 2024 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803513; cv=none; b=meU6TV/BmjVZDyaQ/eKvbieq5DWqTm7ozAvr5bY66VdtP9qgXWvqGmjdaqG2Iqu35g5dopwSv8eH0fTGSaF/gIDVjB8sgQUlE8t0qSygegESfAnJ0loNPDLI0CM1r2KJWyytqMCBgB3kCNgSdogui3mH4FDUPptlBg+HtIpmWnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803513; c=relaxed/simple;
	bh=4Sy1YfjqCdmh07AtbNsTTGDPRTIv/8hg2O2cm8b0Y3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxV7CBDv7PMadztsx5Rji6ZuwvDafKdhOcOYFlm1OgtgM4TXmwP2B2KCuRJbe0v2lgRl7aMqFwE/FPEfJrnsCLi0wxz876q8QzOLQZKWp5ZB3SOPUxyQQcUkOpaL4/bSmP1iELKY1LPw7v6Sy4qRHl6NsZiBvQPbJjZkRk6Iw40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycec+v8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycec+v8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DEAC2BBFC;
	Wed, 19 Jun 2024 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803513;
	bh=4Sy1YfjqCdmh07AtbNsTTGDPRTIv/8hg2O2cm8b0Y3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycec+v8NHDpWKXOHHCylGGzEKHwcv6MCeubB483Ul0vlL8jp706nfST4yIiTH6hGs
	 WKVMuPP/FVFHBZWCJD2BBqBeM+phfs9WIcwqO+3P9fIZi/9X4v1RMOXmc7qz7X7m1A
	 3nKFn5JNo6rjNSeK2IPB3cIwfgdUSQ/m/xamcWDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars Kellogg-Stedman <lars@oddbit.com>,
	Duoming Zhou <duoming@zju.edu.cn>,
	Dan Cross <crossd@gmail.com>,
	Chris Maness <christopher.maness@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/217] ax25: Fix refcount imbalance on inbound connections
Date: Wed, 19 Jun 2024 14:54:14 +0200
Message-ID: <20240619125556.941359903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

From: Lars Kellogg-Stedman <lars@oddbit.com>

[ Upstream commit 3c34fb0bd4a4237592c5ecb5b2e2531900c55774 ]

When releasing a socket in ax25_release(), we call netdev_put() to
decrease the refcount on the associated ax.25 device. However, the
execution path for accepting an incoming connection never calls
netdev_hold(). This imbalance leads to refcount errors, and ultimately
to kernel crashes.

A typical call trace for the above situation will start with one of the
following errors:

    refcount_t: decrement hit 0; leaking memory.
    refcount_t: underflow; use-after-free.

And will then have a trace like:

    Call Trace:
    <TASK>
    ? show_regs+0x64/0x70
    ? __warn+0x83/0x120
    ? refcount_warn_saturate+0xb2/0x100
    ? report_bug+0x158/0x190
    ? prb_read_valid+0x20/0x30
    ? handle_bug+0x3e/0x70
    ? exc_invalid_op+0x1c/0x70
    ? asm_exc_invalid_op+0x1f/0x30
    ? refcount_warn_saturate+0xb2/0x100
    ? refcount_warn_saturate+0xb2/0x100
    ax25_release+0x2ad/0x360
    __sock_release+0x35/0xa0
    sock_close+0x19/0x20
    [...]

On reboot (or any attempt to remove the interface), the kernel gets
stuck in an infinite loop:

    unregister_netdevice: waiting for ax0 to become free. Usage count = 0

This patch corrects these issues by ensuring that we call netdev_hold()
and ax25_dev_hold() for new connections in ax25_accept(). This makes the
logic leading to ax25_accept() match the logic for ax25_bind(): in both
cases we increment the refcount, which is ultimately decremented in
ax25_release().

Fixes: 9fd75b66b8f6 ("ax25: Fix refcount leaks caused by ax25_cb_del()")
Signed-off-by: Lars Kellogg-Stedman <lars@oddbit.com>
Tested-by: Duoming Zhou <duoming@zju.edu.cn>
Tested-by: Dan Cross <crossd@gmail.com>
Tested-by: Chris Maness <christopher.maness@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240529210242.3346844-2-lars@oddbit.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 0bffac238b615..a1e0be8716870 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1378,8 +1378,10 @@ static int ax25_accept(struct socket *sock, struct socket *newsock, int flags,
 {
 	struct sk_buff *skb;
 	struct sock *newsk;
+	ax25_dev *ax25_dev;
 	DEFINE_WAIT(wait);
 	struct sock *sk;
+	ax25_cb *ax25;
 	int err = 0;
 
 	if (sock->state != SS_UNCONNECTED)
@@ -1434,6 +1436,10 @@ static int ax25_accept(struct socket *sock, struct socket *newsock, int flags,
 	kfree_skb(skb);
 	sk_acceptq_removed(sk);
 	newsock->state = SS_CONNECTED;
+	ax25 = sk_to_ax25(newsk);
+	ax25_dev = ax25->ax25_dev;
+	netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
+	ax25_dev_hold(ax25_dev);
 
 out:
 	release_sock(sk);
-- 
2.43.0



