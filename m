Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050269;
	b=miKIuPDig3Cjgdelz68KSygE72SIiS+EQCfO4ozKLMymb7/moB7+9OkZBinX4y9TnUDe
	 ErY0ywHBKTfhbyUU1wYF+miqYyS3a6eq7SoH9+lWhycOFm8Pkdb0UnUr2dI9nrDAK/YYJ
	 2eoJwryyRDFHKZJmESlRtJ7DP1PnQCt/Jb+Q0VXskpmGet7HERbzlhmMenY5pFGEHHpGO
	 VIgx2rlA936d6h2T3Iu+mus2bCspvJARG0f0BnBAkBLGdNK5qidNA0rI7YVsDhKTtBuli
	 RQVcz0p6vXQZZkPCZCJ/PPtecgW0T9Xp0Vky49XnrXCnkggt+crAjJlSKaZZ2fwNZCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i70+1Qa/bQvdIQO1E204wuUsrGXZDvCSEcbMdxm+5po=;
	b=KxuSMQLa7VMZkbmQxjo6b7sXJh8ODuKN5PhdQqMCLJ/Rt3ak1w/J36NNGg3C69GDVzpy
	 WnAffqyLUGrivXwTkAF+t8h83LEFYyzKmzlLGDrypyyxyEP2NGHW9nYZsgFQ+vKDgl5+b
	 niHBlnHy9TnnWNKbngqZ/HGIaBE54iqirqhnh56Ymaw1fZIY+zyWRVoTMGnIbC2pdOQIN
	 +AFdrLt8f7Bi6OumTNlMM4xN2R2UI44RzUGl9OVA7K4jI1iag92ANEJiRit2M2mMlOJLo
	 PXYk/IgMefW6mlQ8caFJ8yNEzc8BJ06LnXC2rDq0OY7rJ3C5Aa5VLv+4zRP/YL2rPdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rF3OepA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65213606A31C;
	Thu, 19 Nov 2026 01:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rF3OepA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D671F000C4;
	Thu, 19 Nov 2026 01:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050269;
	bh=i70+1Qa/bQvdIQO1E204wuUsrGXZDvCSEcbMdxm+5po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rF3OepAGRbuA369LOQmKGZeFkHdNEp1uG19ddOuu1MLWydQBgjbT/qprgvElriCt
	 tv2bT5V8SCq8ljPWAZln+NYbRKZd/F2Gogwar0hmrfAVkE2s7SqMcTJqxX4RJ3W5bS
	 geGlWlGOuGmSfNNHm6anu/gbKdXErgW6cjT8p8G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2648/2857] tls: device: protect async RX resync state during device-down
Date: Wed, 18 Nov 2026 16:01:22 +0100
Message-ID: <20261118150336.932411189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 74b61318a60ac..8dd9d3a94aba9 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -798,8 +798,15 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 
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
@@ -814,11 +821,11 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 
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
@@ -827,7 +834,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 		if (sock_data > rcd_len) {
 			trace_tls_device_rx_resync_nh_delay(sk, sock_data,
 							    rcd_len);
-			return;
+			goto out;
 		}
 
 		rx_ctx->resync_nh_do_now = 0;
@@ -838,16 +845,18 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
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



