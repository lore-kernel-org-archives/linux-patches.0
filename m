Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5121519B4;
	Wed,  5 Feb 2025 15:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768206; cv=none; b=ZO7W9MM8GqgCnZGe1IIyn7059hJ8nRdi4YFt2Fx4eRW1kKVNvFapjJtw1TrC7mju206edYpYsUfLiJ9EuYovw+XjFJb56atxQ9BxhwGbLhmKTPpIfKLyshWRGQErJGJCYUQg+PaExv2OMsk7rNvLzTvCcipXPcwTJJOCPKMiyZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768206; c=relaxed/simple;
	bh=5zZaRcu3xMSYCGMJ+9U1bx0oFEndWEHFxGo11arrTgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUZkPJoVMBainsHmxhJORJLQu7jrYhP5ChWHyaP02Akf+KOQgwvq2q4rgDmmJf41sYf2Bmy58PkDftdvcMFe4KznMb3/+HW9srKAwllKaWS55a7UtS6RQJv6wuaupW6QCz4Wo5joKRi2kEfF6okUHObKOr9NXtSwVDOkllsWo/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqrAIxR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqrAIxR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EAEC4CED1;
	Wed,  5 Feb 2025 15:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768205;
	bh=5zZaRcu3xMSYCGMJ+9U1bx0oFEndWEHFxGo11arrTgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqrAIxR3o6JEmD+aJIm4526DzpnP9/NkYodHMvz2gZhQ+XRYPKO2fDa8O1Sr/wwNE
	 Dve6kKnHMoV+g9ZdWuZTPAJVnKdHM0jmlV6k/suQS3eMuqR5evrpsSGRTPDGv//7Ju
	 bivj2oi8jMmq0ars8m0xn6Xd7pQIu5J3xmd78yZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 512/623] xfrm: Dont disable preemption while looking up cache state.
Date: Wed,  5 Feb 2025 14:44:14 +0100
Message-ID: <20250205134515.814613931@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1781728ca4285..711e816fc4041 100644
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



