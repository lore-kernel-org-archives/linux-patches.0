Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF4471268;
	Tue, 21 Jul 2026 18:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657609; cv=none; b=N0fbcUoqhgqCcI5u+dnUU9udRtmUy5pgByT8j0cnvRV7MSUf7Q8K2/gzpoBIrqbNtTiLv5Do9/b4R0aLhCshdoFL2KrjEAHdTEijJU7kq/WWN56Q00FwYjQ+U8fPZNZYrlNm8Bo5mPsvsjVpvb3neh6JD2gZz3dQVrU36htUb9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657609; c=relaxed/simple;
	bh=wLNvQmDojpvxR3HCNVNz/LvTdvBkvi/1LimEHElihng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UorFOXwMDVJHtAqRO1QoyCKjJGeG1dMhn+YvnQSFk0vCHYEhkM/QzMmAngsdk3iph3NopQVKBD8Y4q21FqnC93d9s1GlYdpyZhYmNtGNCMVc7MxjnyPiAHi/mX8l9/RbSy8G4BJSZX8ebYbiBjRrPfmEKeaeOdWqAO93TWl/GuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8FDXq7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8FDXq7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06531F000E9;
	Tue, 21 Jul 2026 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657608;
	bh=N3UokzCZJDspPU4ejhdBtY8zL6PKJIPWtcaSkOijR6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8FDXq7XmqJ9DoVvYlIYIjIIxWIIKnj8eWailcyNIYPJZu20UxaS8XmnzUJj7U5vy
	 AILLGXRYHszYQS7CNpI2cmR5Sb42Ag/g/os/VJEaRFeHoSHn0myMZ4mlTwTaZI5Z/1
	 fN3YiIG0uEcXFPHsyuMAOwIPPG1rS+JO0lpvduHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0792/1611] xfrm: Fix xfrm state cache insertion race
Date: Tue, 21 Jul 2026 17:15:08 +0200
Message-ID: <20260721152533.202090147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit ddd3d0132920319ac426e12456013eadbae67e15 ]

The xfrm input state cache insertion code checks the validity of
the state before acquiring the global xfrm_state_lock.  Thus it's
possible for someone else to kill the state after it passed the
validity check, and then the insertion will add the dead state
to the cache.

Fix this by moving the validity check inside the lock.

This entire function is called on the input path, where BH must
be off (e.g., the caller of this function xfrm_input acquires
its spinlocks without disabling BH).

So there is no need to disable BH here or take the RCU read lock.
Remove both and replace them with an assertion that trips if BH
is accidentally enabled on some future calling path.

Fixes: 81a331a0e72d ("xfrm: Add an inbound percpu state cache.")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index efbe0135d27764..7fc6727e75c5ac 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1207,9 +1207,11 @@ struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
 	struct hlist_head *state_cache_input;
 	struct xfrm_state *x = NULL;
 
+	/* BH is always disabled on the input path. */
+	lockdep_assert_in_softirq();
+
 	state_cache_input = raw_cpu_ptr(net->xfrm.state_cache_input);
 
-	rcu_read_lock();
 	hlist_for_each_entry_rcu(x, state_cache_input, state_cache_input) {
 		if (x->props.family != family ||
 		    x->id.spi       != spi ||
@@ -1227,20 +1229,25 @@ struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
 	xfrm_hash_ptrs_get(net, &state_ptrs);
 
 	x = __xfrm_state_lookup(&state_ptrs, mark, daddr, spi, proto, family);
-
-	if (x && x->km.state == XFRM_STATE_VALID) {
-		spin_lock_bh(&net->xfrm.xfrm_state_lock);
-		if (hlist_unhashed(&x->state_cache_input)) {
+	if (x) {
+		spin_lock(&net->xfrm.xfrm_state_lock);
+		if (x->km.state != XFRM_STATE_VALID) {
+			/*
+			 * The state is about to be destroyed.
+			 *
+			 * Don't add it to the cache but still
+			 * return it to the caller.
+			 */
+		} else if (hlist_unhashed(&x->state_cache_input)) {
 			hlist_add_head_rcu(&x->state_cache_input, state_cache_input);
 		} else {
 			hlist_del_rcu(&x->state_cache_input);
 			hlist_add_head_rcu(&x->state_cache_input, state_cache_input);
 		}
-		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
+		spin_unlock(&net->xfrm.xfrm_state_lock);
 	}
 
 out:
-	rcu_read_unlock();
 	return x;
 }
 EXPORT_SYMBOL(xfrm_input_state_lookup);
-- 
2.53.0



