Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B03B20C488;
	Tue, 29 Apr 2025 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950663; cv=none; b=OdXrIutZkyfzeuyuE/OOpyZ1hpYXgJ4SgkQ2vOudERUkDFdMWMwz6F3Xd4Zb/e7ElQhaSlTeKV7Zr1WjVMz8GF5leuyOQWU4U3OEag+/1dD7XDUfab4XMcZhGi5CVQBPJvNwZXQGLwxWrl3Hbs/dH8TaIAXHXMTc9tyyMFatBSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950663; c=relaxed/simple;
	bh=rGMdd8G4od1LZMjca9T0e9gTFk573njSeFyW4PrBd+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZGFvM8pyAYZ84oSni3WJx9VH8LKp0PHw1I5yJcPhDb/5yEWoFF8MXsT1YeUkXAgIaqgrcmRJqvW00bK/w8JOTlnErzyqjo3XYV09Y5Ltz/80DGQwudfMpJdwPcJ7CTSvw5O1DyzOLApU9jeVH3ubqqhWDEHhTKigi4bTQEmPpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dL5j4xC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dL5j4xC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF445C4CEE3;
	Tue, 29 Apr 2025 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950663;
	bh=rGMdd8G4od1LZMjca9T0e9gTFk573njSeFyW4PrBd+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dL5j4xC77+l1z2P61EAB93Re637eIdyjIr3hOkvo0dlrdbzX/OlPwWUUEVVlcvoel
	 0kNkP+/Y2jv5nYFDSVvXGaSuMFJKvQt6eGye1y0hyecT/4SjE7osVa0/BHk32jalBY
	 pk85+sqlm+YFQvjvCWkA50vNsTq6HqTic9jA8mj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/204] bpf: Only fails the busy counter check in bpf_cgrp_storage_get if it creates storage
Date: Tue, 29 Apr 2025 18:43:35 +0200
Message-ID: <20250429161104.627891272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ee1c7b77096e7..fbbf3b6b9f835 100644
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



