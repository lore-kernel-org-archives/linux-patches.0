Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8FD364049;
	Sat, 12 Sep 2026 08:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201315; cv=none; b=QxnZ+kTbi0tbAN89ORuScwUXDDd++OfIKFvAq3EHnUDkNwLV3BOM56gO1cpjo1qJtYB4ennPqLiDZ5TKo+vN+YgwyETbGQQsNbkoC4alOIVBq96QmgRG2C7WsRPTefjJR1ofScIo/MIG2X9/Abv9LvzYd6UGtx4ZBZvexPQGcF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201315; c=relaxed/simple;
	bh=3Y/eBpa/B3iNSj/PjnyXVJ/ck5Vy5LfBIfDI3vv7lA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm4jkDMIWZ4ilt6CyjwrUcYBM9IyN7vFFUTdxrN2p9Idbs5FCzKm4fHnyOqFvRAL4iLOUDQZBgtEbeCyxoyAxza01A8W4gKY1r8MAtE2HHDj6CrhVVA779OlvMO4mrBwAnDBTj9oPpL3ZbUpKtlisMRE+TFt+/d3Zr/QZ3wyByQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4rL9Vq7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4rL9Vq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773911F000FF;
	Sat, 12 Sep 2026 08:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201314;
	bh=YiqztmrolFaOutVAwriech/yTdQDkVAfd6tdPySWv60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4rL9Vq766LeAwqrabEJ3t05NbPimMUqF51pQ1GKjx9oyMEKVUoHKQUch1EtF8Fjd
	 IGTJCGIpRZ2QXu4ZP+KBcYvcKDbXnpdQPnc+vOy8sm+bhm0w2C+oAXzfmy7GI5NyWT
	 a/n9+H1IMtEiMKLFkY+S8k/p1hNvoNhRIrxWYTQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0972/1815] bpf: Fix mmap_lock deadlock on arena lock failure
Date: Sat, 12 Sep 2026 08:45:22 +0200
Message-ID: <20260912065711.794184430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 0b10b945479c954393d62ee3229d2f224a4ca91c ]

Reported by the Sashiko AI review.

arena_vm_fault() returns VM_FAULT_RETRY when it can't take
arena->spinlock, but it never took mmap_lock. The fault path assumes a
VM_FAULT_RETRY handler already dropped mmap_lock and re-takes it on the
retry, so mmap_lock gets taken twice and can deadlock:

	do_user_addr_fault()
	{
		fault = handle_mm_fault(...);   // calls arena_vm_fault()
		if (fault & VM_FAULT_RETRY)
			goto retry;   // re-locks mmap_lock
		mmap_read_unlock(mm);
	}

Return VM_FAULT_SIGBUS instead, for two reasons:

1. We could keep VM_FAULT_RETRY, but then we'd have to drop the fault
   lock first and cap the retry ourselves, the way __folio_lock_or_retry()
   does.

2. A failed raw_res_spin_lock_irqsave() already means a possible deadlock
   was detected, so retrying just hits the same lock again.

So returning VM_FAULT_RETRY here is overkill.

Fixes: b8467290edab ("bpf: arena: make arena kfuncs any context safe")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260728060517.95183-1-jiayuan.chen@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arena.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 97a5d8d212955..529c0f6d7d0a8 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -484,8 +484,12 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 	kaddr = kbase + (u32)(vmf->address);
 
 	if (raw_res_spin_lock_irqsave(&arena->spinlock, flags))
-		/* Make a reasonable effort to address impossible case */
-		return VM_FAULT_RETRY;
+		/*
+		 * A failed lock means a possible deadlock was detected. Don't
+		 * return VM_FAULT_RETRY: this handler never took mmap_lock, but
+		 * the fault path would re-take it on retry and deadlock. Fail.
+		 */
+		return VM_FAULT_SIGBUS;
 
 	page = vmalloc_to_page((void *)kaddr);
 	if (page) {
-- 
2.53.0



