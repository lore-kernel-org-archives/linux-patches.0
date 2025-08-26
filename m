Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7493019A3;
	Tue, 26 Aug 2025 13:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214764; cv=none; b=iN0CLxgI5LT0XzjqnitLELjYfKCvs4BWZGg7E47E/3XSsY5eq2U0m62SP2qdn2dTGlX0FAxVKtjl1D4zJBwL6an6WJ25YRwIlbTU+eSM54+F3kK0iHBb5fTuSi3rA8tN1G+KlmIKksNkU7qSfKOc3HZFsUrgsdFC6z+zYvdQ6i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214764; c=relaxed/simple;
	bh=l6M4+hzqphpXagZnL4UxsvknRBYSZMlzv97Ho36bplg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OBNi2Z6QbH5AUSbALT5tQJD3m/PtXiWj4K2yGcOFtOOtg2unOfcIol2HDN9MLw+iu4VF7MI/qZcdDfFnVdJJrOiG0wZsAttW6KyZFWd6+/andZqoFtt4kmRrKeDPvtKAQ3CFf00Oy4a7K5K+c1Q7UPZUcrcA0FLV5y0aur2T3Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHd6xl+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHd6xl+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75B7C4CEF1;
	Tue, 26 Aug 2025 13:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214764;
	bh=l6M4+hzqphpXagZnL4UxsvknRBYSZMlzv97Ho36bplg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHd6xl+P+EavprdofeNryqMYOGxPJzN61tco8aaFRfm5GZzqrYu9pPEW7iJvLw5sB
	 Tt0VcemWMOetMo1DPlHAeuwXqdIXPA4hvxg8az3QiGlG//PmnHvzH3WW9IfUe/5eCp
	 7RNYukmSNBEaDzMAxA1n96bx5nteHZN5TUp4xPi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 261/482] mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock
Date: Tue, 26 Aug 2025 13:08:34 +0200
Message-ID: <20250826110937.217929042@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 47b0f6d8f0d2be4d311a49e13d2fd5f152f492b2 upstream.

When netpoll is enabled, calling pr_warn_once() while holding
kmemleak_lock in mem_pool_alloc() can cause a deadlock due to lock
inversion with the netconsole subsystem.  This occurs because
pr_warn_once() may trigger netpoll, which eventually leads to
__alloc_skb() and back into kmemleak code, attempting to reacquire
kmemleak_lock.

This is the path for the deadlock.

mem_pool_alloc()
  -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
      -> pr_warn_once()
          -> netconsole subsystem
	     -> netpoll
	         -> __alloc_skb
		   -> __create_object
		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);

Fix this by setting a flag and issuing the pr_warn_once() after
kmemleak_lock is released.

Link: https://lkml.kernel.org/r/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org
Fixes: c5665868183f ("mm: kmemleak: use the memory pool for early allocations")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reported-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -441,6 +441,7 @@ static struct kmemleak_object *mem_pool_
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
+	bool warn = false;
 
 	/* try the slab allocator first */
 	if (object_cache) {
@@ -458,8 +459,10 @@ static struct kmemleak_object *mem_pool_
 	else if (mem_pool_free_count)
 		object = &mem_pool[--mem_pool_free_count];
 	else
-		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
+		warn = true;
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+	if (warn)
+		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
 
 	return object;
 }


