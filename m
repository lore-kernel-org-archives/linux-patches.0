Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAED3EA6F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eO7jYWzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C09C433CA;
	Wed, 15 Nov 2023 19:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076247;
	bh=TcY6NoWief80AUfbn8lAvMXxenBBZ1+Xtt6imWkE3pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eO7jYWzfgz/H751zc4mlugjmGpYrRfDyNrHIDwxRfXGxndy+gcHlCeSd8N5WoAkod
	 d1kxi+kY8wDSCHBwW6HjOfyiT5F6uGHcLfqfyNJC7qR5E62SOzsATkk4jbxFT6iKXM
	 3hW23fmsPZf2OdHdg9coF2jJP9Q/IztSCo3olb4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Song Liu <song@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 144/550] bpf: Fix unnecessary -EBUSY from htab_lock_bucket
Date: Wed, 15 Nov 2023 14:12:08 -0500
Message-ID: <20231115191610.679262571@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit d35381aa73f7e1e8b25f3ed5283287a64d9ddff5 ]

htab_lock_bucket uses the following logic to avoid recursion:

1. preempt_disable();
2. check percpu counter htab->map_locked[hash] for recursion;
   2.1. if map_lock[hash] is already taken, return -BUSY;
3. raw_spin_lock_irqsave();

However, if an IRQ hits between 2 and 3, BPF programs attached to the IRQ
logic will not able to access the same hash of the hashtab and get -EBUSY.

This -EBUSY is not really necessary. Fix it by disabling IRQ before
checking map_locked:

1. preempt_disable();
2. local_irq_save();
3. check percpu counter htab->map_locked[hash] for recursion;
   3.1. if map_lock[hash] is already taken, return -BUSY;
4. raw_spin_lock().

Similarly, use raw_spin_unlock() and local_irq_restore() in
htab_unlock_bucket().

Fixes: 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/7a9576222aa40b1c84ad3a9ba3e64011d1a04d41.camel@linux.ibm.com
Link: https://lore.kernel.org/bpf/20231012055741.3375999-1-song@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 56d3da7d0bc66..e209e748a8e05 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -155,13 +155,15 @@ static inline int htab_lock_bucket(const struct bpf_htab *htab,
 	hash = hash & min_t(u32, HASHTAB_MAP_LOCK_MASK, htab->n_buckets - 1);
 
 	preempt_disable();
+	local_irq_save(flags);
 	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
 		__this_cpu_dec(*(htab->map_locked[hash]));
+		local_irq_restore(flags);
 		preempt_enable();
 		return -EBUSY;
 	}
 
-	raw_spin_lock_irqsave(&b->raw_lock, flags);
+	raw_spin_lock(&b->raw_lock);
 	*pflags = flags;
 
 	return 0;
@@ -172,8 +174,9 @@ static inline void htab_unlock_bucket(const struct bpf_htab *htab,
 				      unsigned long flags)
 {
 	hash = hash & min_t(u32, HASHTAB_MAP_LOCK_MASK, htab->n_buckets - 1);
-	raw_spin_unlock_irqrestore(&b->raw_lock, flags);
+	raw_spin_unlock(&b->raw_lock);
 	__this_cpu_dec(*(htab->map_locked[hash]));
+	local_irq_restore(flags);
 	preempt_enable();
 }
 
-- 
2.42.0



