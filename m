Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209968;
	b=Ub90CIWYt966GSNoErAbfTXYvwLB3O1aEc+OOkNrfcE0eZ63A185NOPiVHJSoAvoF+w6
	 QG2sQyVEYy10r37SMp7JMRnNowlAWi2BqxhA1CbLJDenX+0LelHyBr8mg9g0B7EOU25H+
	 pWr+16uu4vncDmT6k5TOmPZX9v01rpBIi+bK8mZHUZFYi3DnzxeLdc5/ZGSaSiSIN+HOB
	 8elz1ctMFH7ecUtE1X3JcvX4i7BveuMR4c/wEas/TMZhQ/c3EY/zd7hwcYviMKkWDkaiG
	 nGZYVRrw9ZdljJFgGy2l3GuhliYHa6p78pSMOtoq4fau+odHY3AwCU8mTuSGXQth9gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3w3Wno76o+yEVWfP7/i6bE5B6xJxPLXa/i8jkxa41A=;
	b=SHssMAj1esdKOVDXrLzPhzGlYOq9g21X+/HurRcsjXdU0kPBqp0x5w12j7yl/mBm8HrD
	 m1d3HB8/6iZ6BeJdW2HUh6hbF9R2L1bfZcp/XecKHqpPOBH/fAn2hPkVxFGH9Q+dcm18C
	 cqn+Z7qdh4mgfQsm4uDohhkPCYWd1FTrH2qPYmslqY7uMSysOvRtmJZxN2PqS/jxAc2cv
	 ZqPgzwW8jj4ClZwZ45sfJcmTeyucVX9kQte+Ab5gng62SGxh3GQprVsXlo7mWbrvUDvIi
	 Bx89i+CmfvLrPf9x6hb08ecfLMQpzSflcviVF5MgsPeMLrSq09PcprkpoUkXjXXN4lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AM+4ZtKQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2F7606A31C;
	Wed, 28 Oct 2026 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AM+4ZtKQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AC81F01825;
	Wed, 28 Oct 2026 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209968;
	bh=b3w3Wno76o+yEVWfP7/i6bE5B6xJxPLXa/i8jkxa41A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AM+4ZtKQO6BOGHL73dNHYd5vUnbcVjwJ+YvjhQ+0MPNaEYSFBssrt9KtsRVAZVYRl
	 +zOfUdTfthtMqXjmkIm9CQ6Wtivgyei0CMZYkcHngPzOSU3rU/bOJfIS6GKgTdBn4U
	 tQm2/k9/fDcdzcRrcGhihLCmRSaUtt0bTGBI3HNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdul Wasey <w453y.me@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/168] mptcp: move the OoO check back into __mptcp_try_fallback()
Date: Wed, 28 Oct 2026 17:58:59 +0100
Message-ID: <20261028165943.175887406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdul Wasey <w453y.me@gmail.com>

The 6.6.y backport of upstream commit 1bba3f219c5e ("mptcp: do not
fallback when OoO is present") put the out-of-order queue check
in __mptcp_finish_join() instead of __mptcp_try_fallback().

So the fix itself is missing, as fallback still happens with OoO data
queued. Worse, the passive side now refuses every MP_JOIN while its
OoO queue is not empty, which is the normal state of a connection
already sending data over more than one subflow. The joining subflow
is reset, so such a connection can't add a new path, and a path that
comes back after an outage can't rejoin while data is in flight.

Move the check to __mptcp_try_fallback(), as upstream does. On this
branch that function is in protocol.h.

Tested on 6.6.159 in netns: 6 connections (5 uploading) over two paths,
then a third endpoint added mid-transfer. Without this patch only the
idle connection gets a subflow on the new path and the other 5 joins
are reset. With it, all 6 join. Same result in 3 of 3 runs each.

Fixes: 642561238c98 ("mptcp: do not fallback when OoO is present")
Signed-off-by: Abdul Wasey <w453y.me@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 7 -------
 net/mptcp/protocol.h | 8 ++++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3e8e5aae4dc4f..7b08b5899ef39 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -923,13 +923,6 @@ static bool __mptcp_finish_join(struct mptcp_sock *msk, struct sock *ssk)
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return false;
 
-	/* The caller possibly is not holding the msk socket lock, but
-	 * in the fallback case only the current subflow is touching
-	 * the OoO queue.
-	 */
-	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
-		return false;
-
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_subflows) {
 		spin_unlock_bh(&msk->fallback_lock);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 64c6a6cb3d99c..1cf67a557ff0d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1127,6 +1127,14 @@ static inline bool __mptcp_try_fallback(struct mptcp_sock *msk)
 		pr_debug("TCP fallback already done (msk=%p)\n", msk);
 		return true;
 	}
+
+	/* The caller possibly is not holding the msk socket lock, but
+	 * in the fallback case only the current subflow is touching
+	 * the OoO queue.
+	 */
+	if (!RB_EMPTY_ROOT(&msk->out_of_order_queue))
+		return false;
+
 	spin_lock_bh(&msk->fallback_lock);
 	if (!msk->allow_infinite_fallback) {
 		spin_unlock_bh(&msk->fallback_lock);
-- 
2.53.0



