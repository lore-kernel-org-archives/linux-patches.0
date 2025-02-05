Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0001957FC;
	Wed,  5 Feb 2025 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767606; cv=none; b=IQ1RNO0CZzoqAv9SvI0sOXRGeduLRJWtovgSaej6C/QcDDUUHX4aoeFQdU07HDQp1mRTFPWAB2qsE+Tzya0gUQs/dI+/Z6zFSB3Ayljx75tYPw9QuM9FXK/46vHUxriVNqaCTO8MKfrOFuzoJLPNJ+JyWYb+XD+xL2t21qSOfPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767606; c=relaxed/simple;
	bh=x7tOIT5v+6vo7PZvYRVcEGyoncc8pb4WKUyFpVp4ql0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ciw4MF78eVFwX7rhmRn247igt29Ba+zqHOGWtEjiMXPk8ppySQ9/0txree0ujrynO9G2vJ0BisugtHrxElUFe0+tieKD1xTiB/tmdKGAdciGON/JAGurLmSe/ap6i5fU/8dLm7Xjb/vv7sdmOKfdiA4HohTscg5BTSvKXpoeoio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2UGQK3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2UGQK3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1DFC4CED1;
	Wed,  5 Feb 2025 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767606;
	bh=x7tOIT5v+6vo7PZvYRVcEGyoncc8pb4WKUyFpVp4ql0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2UGQK3r3tqm8SxyZI5Bkz0IuzRNNl3GHjgCVTflNjymeM4BBZI3wOQHQrjFoVRnq
	 N7Saghc45jbCEJEG0rPpVqliV01EsFpew0RvBllnagPu1N8TvIkJOgJYpoWssRpdP7
	 Zf0ZEDLnTdgJ9veqOXWkTP4uf8gFR2gDW3mLWN7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 481/590] xfrm: Dont disable preemption while looking up cache state.
Date: Wed,  5 Feb 2025 14:43:56 +0100
Message-ID: <20250205134513.662981387@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sebastian Sewior <bigeasy@linutronix.de>

[ Upstream commit 6c9b7db96db62ee9ad8d359d90ff468d462518c4 ]

For the state cache lookup xfrm_input_state_lookup() first disables
preemption, to remain on the CPU and then retrieves a per-CPU pointer.
Within the preempt-disable section it also acquires
netns_xfrm::xfrm_state_lock, a spinlock_t. This lock must not be
acquired with explicit disabled preemption (such as by get_cpu())
because this lock becomes a sleeping lock on PREEMPT_RT.

To remain on the same CPU is just an optimisation for the CPU local
lookup. The actual modification of the per-CPU variable happens with
netns_xfrm::xfrm_state_lock acquired.

Remove get_cpu() and use the state_cache_input on the current CPU.

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Closes: https://lore.kernel.org/all/CAADnVQKkCLaj=roayH=Mjiiqz_svdf1tsC3OE4EC0E=mAD+L1A@mail.gmail.com/
Fixes: 81a331a0e72dd ("xfrm: Add an inbound percpu state cache.")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 567f02ff88597..6441e94233daa 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1150,9 +1150,8 @@ struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
 	struct xfrm_hash_state_ptrs state_ptrs;
 	struct hlist_head *state_cache_input;
 	struct xfrm_state *x = NULL;
-	int cpu = get_cpu();
 
-	state_cache_input =  per_cpu_ptr(net->xfrm.state_cache_input, cpu);
+	state_cache_input = raw_cpu_ptr(net->xfrm.state_cache_input);
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(x, state_cache_input, state_cache_input) {
@@ -1186,7 +1185,6 @@ struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
 
 out:
 	rcu_read_unlock();
-	put_cpu();
 	return x;
 }
 EXPORT_SYMBOL(xfrm_input_state_lookup);
-- 
2.39.5



