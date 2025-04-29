Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB584238C21;
	Tue, 29 Apr 2025 17:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948008; cv=none; b=cEwj7X6IJueCN0Zd8UpbLiDESXVqXaFkodTx2dddeCZblsl80XarwhStopJt63LMr97B29beKmMZNHXxfRLAPpbWhJYD2T3K+rvaopCUpt5vTFJk/BduWPPbGAKjiMOGOqd7uBkTu6ve2KVvHorRIrGZO02VZxjgJaqrniOBleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948008; c=relaxed/simple;
	bh=vBuJejzMUjFM3bTjk0/hQYlT43+oC7l/0zR0YoOG+zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrNuGIqXHzQeTt5TWIq+pQvkDiGtf+TfwuYTJxIl4WMxNtBqXymemcYn5hkfKGal39o+zmSfKG2fDNK1YcNaoz4yCUVMU9yihu5YAvmOPjEW9MHGaUeHRV3fWD6QfF3DqlE03ALxbe5MsmPaBGkJTAffc8ec9/EHExA+u1c4Uus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUXuElJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUXuElJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F96FC4CEE3;
	Tue, 29 Apr 2025 17:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948007;
	bh=vBuJejzMUjFM3bTjk0/hQYlT43+oC7l/0zR0YoOG+zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUXuElJcZWeLfWH1Fz4GeLujWXcXfth43urt6UORWQL7qcCT1bx0pyTpzZTACnBwG
	 Su6ATBCMP8otqQ30iKZeCFHnr105nJhmYXO7Zki7dWq8CV3PXViCXrRtMvr3qYmCPQ
	 71NXVHnWtPWSfUr/ROMfsoXtT5MPaBi/fPNQ0ZtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/280] bpf: Only fails the busy counter check in bpf_cgrp_storage_get if it creates storage
Date: Tue, 29 Apr 2025 18:41:47 +0200
Message-ID: <20250429161121.902623754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit f4edc66e48a694b3e6d164cc71f059de542dfaec ]

The current cgrp storage has a percpu counter, bpf_cgrp_storage_busy,
to detect potential deadlock at a spin_lock that the local storage
acquires during new storage creation.

There are false positives. It turns out to be too noisy in
production. For example, a bpf prog may be doing a
bpf_cgrp_storage_get on map_a. An IRQ comes in and triggers
another bpf_cgrp_storage_get on a different map_b. It will then
trigger the false positive deadlock check in the percpu counter.
On top of that, both are doing lookup only and no need to create
new storage, so practically it does not need to acquire
the spin_lock.

The bpf_task_storage_get already has a strategy to minimize this
false positive by only failing if the bpf_task_storage_get needs
to create a new storage and the percpu counter is busy. Creating
a new storage is the only time it must acquire the spin_lock.

This patch borrows the same idea. Unlike task storage that
has a separate variant for tracing (_recur) and non-tracing, this
patch stays with one bpf_cgrp_storage_get helper to keep it simple
for now in light of the upcoming res_spin_lock.

The variable could potentially use a better name noTbusy instead
of nobusy. This patch follows the same naming in
bpf_task_storage_get for now.

I have tested it by temporarily adding noinline to
the cgroup_storage_lookup(), traced it by fentry, and the fentry
program succeeded in calling bpf_cgrp_storage_get().

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20250318182759.3676094-1-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_cgrp_storage.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/bpf_cgrp_storage.c b/kernel/bpf/bpf_cgrp_storage.c
index 6547fb7ac0dcb..129a51b1da1b1 100644
--- a/kernel/bpf/bpf_cgrp_storage.c
+++ b/kernel/bpf/bpf_cgrp_storage.c
@@ -162,6 +162,7 @@ BPF_CALL_5(bpf_cgrp_storage_get, struct bpf_map *, map, struct cgroup *, cgroup,
 	   void *, value, u64, flags, gfp_t, gfp_flags)
 {
 	struct bpf_local_storage_data *sdata;
+	bool nobusy;
 
 	WARN_ON_ONCE(!bpf_rcu_lock_held());
 	if (flags & ~(BPF_LOCAL_STORAGE_GET_F_CREATE))
@@ -170,21 +171,21 @@ BPF_CALL_5(bpf_cgrp_storage_get, struct bpf_map *, map, struct cgroup *, cgroup,
 	if (!cgroup)
 		return (unsigned long)NULL;
 
-	if (!bpf_cgrp_storage_trylock())
-		return (unsigned long)NULL;
+	nobusy = bpf_cgrp_storage_trylock();
 
-	sdata = cgroup_storage_lookup(cgroup, map, true);
+	sdata = cgroup_storage_lookup(cgroup, map, nobusy);
 	if (sdata)
 		goto unlock;
 
 	/* only allocate new storage, when the cgroup is refcounted */
 	if (!percpu_ref_is_dying(&cgroup->self.refcnt) &&
-	    (flags & BPF_LOCAL_STORAGE_GET_F_CREATE))
+	    (flags & BPF_LOCAL_STORAGE_GET_F_CREATE) && nobusy)
 		sdata = bpf_local_storage_update(cgroup, (struct bpf_local_storage_map *)map,
 						 value, BPF_NOEXIST, gfp_flags);
 
 unlock:
-	bpf_cgrp_storage_unlock();
+	if (nobusy)
+		bpf_cgrp_storage_unlock();
 	return IS_ERR_OR_NULL(sdata) ? (unsigned long)NULL : (unsigned long)sdata->data;
 }
 
-- 
2.39.5



