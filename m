Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062069;
	b=2v9wwqsMrZQfV5AmKI/Rix6FomFMANm0Ok8MLur252izLHYy8HwUvPnJLU3AmgotBIY8
	 ZR1puL1SG+BVrTseeeOuaWcDUHDxH2pb/pLndNR8m4QwDFuaL6HmroUc4XWNyjyTszos8
	 sjaUHgibM7L0mg3BTB46mxtDk83X9NOR85/lAjMK4tLwF9pFvt6ROGoQ6NEC+lCNjwOvy
	 216rAJvIBXLpflWgz+I5h2pnXt6XSR25dWI+2bdsVxbUzs+xfTY9UheAUuD71NfjPbQ74
	 sEVihzN2kf9R3r82XpOZZHydvOO2IEEJytxsh7d2m2vr1E2mNDLMCO9Cx7kXZxRrBrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5aF5A9OQAzSZfR1ltnEv/PrpwCqSvelLZJGxswRSAS8=;
	b=aq/fYq5aFNUZnpc69+T9SDd1n45H+j/Do9xdK34FrrA4dLBm6ElMWG2lMHKwC/sHTZsD
	 GNa7HUSRrSffkS5Z0yjML3C2Oa9L+LPU6G4+xoxmT6VpPqxqLt8jVxR8pPLJIibE5TvP7
	 bQOqJaB4rVlr4IdN9xtTUneUB7VYggISyb2fNUYN2sTZNJbHnVpaPyOt+0nalbWveR6fL
	 lhpgnGJynyZ11FDiwt4TGtFRbUfzkBfZgWNKbf43dqmY0cdna3dcEb8L2Sb45X5Czu4VL
	 ORVouccsw76Px8XeBZV8l3iUMg0J4MUvYHrKf0Kaktjf2CrhvULwIXvVL4EmpFwRwRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvjVdEol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED01C606A330;
	Thu, 19 Nov 2026 04:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvjVdEol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505761F000C4;
	Thu, 19 Nov 2026 04:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062068;
	bh=5aF5A9OQAzSZfR1ltnEv/PrpwCqSvelLZJGxswRSAS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvjVdEolAc9Dfm1iOsqCOXEgDgJvdbtwOKEVS+fikRPx6VgSWSZj15MTw1xcjuu8H
	 5r7IHiVzpEMxYh5eqCncWrFofa65PgBaZvsxIRqFRzwf2qvOXYy/cUcPQdi/IU9aGS
	 nC501yoqsQYSQcV0q5PWBgf13EJoRb+Q4WAjry2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1736/1848] tls: device: protect async RX resync state during device-down
Date: Wed, 18 Nov 2026 16:02:54 +0100
Message-ID: <20261118150032.233985148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Rishikesh Jethwani <rjethwani@purestorage.com>

[ Upstream commit f89a228125238f8d4c7e2b8161e2a85fe35307b6 ]

tls_device_rx_resync_new_rec() can run in process context with the
socket lock held, but without an RCU read lock: from the strparser work
item (tls_strp_work()) and from the receive paths (tls_rx_rec_wait(),
tls_rx_rec_done()). The resync_async pointer belongs to the driver RX
context, which tls_device_down() tears down from the netdev notifier
without taking the socket lock; only the softirq entry to the parser is
implicitly inside an RCU section.

If the parser passes the TLS_RX_DEV_DEGRADED check before device-down
sets it, tls_device_down() can complete synchronize_net() and delete the
driver context before the parser accesses resync_async->req or its
record log. In the asynchronous stage the parser also writes the record
log, so this is a write to freed memory, not only a stale read. The RCU
section in tls_device_resync_rx() starts after those accesses and
therefore does not prevent the use-after-free.

Found by code inspection; not reproduced. Hitting the window requires
the parser to be preempted between the DEGRADED check and the
resync_async access across the device-down grace period and the
driver's teardown.

Fixes: ed9b7646b06a ("net/tls: Add asynchronous resync")
Signed-off-by: Rishikesh Jethwani <rjethwani@purestorage.com>
Link: https://patch.msgid.link/20261013213517.2219663-1-rjethwani@purestorage.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 943378e075cfb..de9f63bb76f0b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -767,8 +767,15 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 
 	if (tls_ctx->rx_conf != TLS_HW)
 		return;
+
+	/* The parser also runs in process context, without an RCU read lock.
+	 * Protect the driver's resync_async state before checking the flags:
+	 * device-down sets DEGRADED and waits for synchronize_net() before
+	 * freeing it, without taking the socket lock.
+	 */
+	rcu_read_lock();
 	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags)))
-		return;
+		goto out;
 
 	prot = &tls_ctx->prot_info;
 	rx_ctx = tls_offload_ctx_rx(tls_ctx);
@@ -783,11 +790,11 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 
 		if (likely(!is_req_pending) || req_seq != seq ||
 		    !atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
-			return;
+			goto out;
 		break;
 	case TLS_OFFLOAD_SYNC_TYPE_CORE_NEXT_HINT:
 		if (likely(!rx_ctx->resync_nh_do_now))
-			return;
+			goto out;
 
 		/* head of next rec is already in, note that the sock_inq will
 		 * include the currently parsed message when called from parser
@@ -796,7 +803,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		if (sock_data > rcd_len) {
 			trace_tls_device_rx_resync_nh_delay(sk, sock_data,
 							    rcd_len);
-			return;
+			goto out;
 		}
 
 		rx_ctx->resync_nh_do_now = 0;
@@ -807,16 +814,18 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		resync_req = atomic64_read(&rx_ctx->resync_async->req);
 		is_req_pending = resync_req;
 		if (likely(!is_req_pending))
-			return;
+			goto out;
 
 		if (!tls_device_rx_resync_async(rx_ctx->resync_async,
 						resync_req, &seq, &rcd_delta))
-			return;
+			goto out;
 		tls_bigint_subtract(rcd_sn, rcd_delta);
 		break;
 	}
 
 	tls_device_resync_rx(tls_ctx, sk, seq, rcd_sn);
+out:
+	rcu_read_unlock();
 }
 
 static void tls_device_core_ctrl_rx_resync(struct tls_context *tls_ctx,
-- 
2.53.0



