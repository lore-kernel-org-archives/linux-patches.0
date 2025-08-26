Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A8F35A283;
	Tue, 26 Aug 2025 14:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219464; cv=none; b=a7v6RiamyHx/NAUP5t5rkIl5OINHGl/z/b0yBGp3FlJ4ipouxMR1a4cc83Yy0fSs/L2Xsl/AU1tlrqAgBokAuzEHcB/SDS6JGK55HYnczUrGVH7BK6XYEspUeuWI7cWRKuzGaXGdCICSTmB22R3id+mw1RAzv9zSRnr2Ixcu36s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219464; c=relaxed/simple;
	bh=kQgXb7vPRG/Dr0TULDBZZ3eYbnCm4e7Y/NPQ6GGYs2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmYKqBEWPt6kERnZSZXotTxFD552/nif2bLor2QECDidytQD8a1xPWRN+52a4NweNQxZXd5D8I1BLOJK7ZVkaB3JeIz00OKFcLpvWN74L3wyMo20uZuQx2T3O++RnVO3mzOWVPUW8jmFQyrMsByPBKaOE9LVDoyQNM7zOr4nq7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nxwq0Hk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nxwq0Hk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F073C113CF;
	Tue, 26 Aug 2025 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219463;
	bh=kQgXb7vPRG/Dr0TULDBZZ3eYbnCm4e7Y/NPQ6GGYs2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nxwq0Hk6ezjwwzV+mGLSBgwX79jbe9QfUG7BC5KMFbUj5QzIeAiR17Wg96QSOEE/k
	 G+KnvBJMrVzhjI/dEjBB3v5Jo4ykiB7SaocLiEe9qtyOJkRuhe3dT10lvXD0zK+/JN
	 ayw4lCK2Mdz5bYIYBQUvkKfL/I0qsIUlptEehlu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 351/403] mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock
Date: Tue, 26 Aug 2025 13:11:17 +0200
Message-ID: <20250826110916.573300869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 47b0f6d8f0d2be4d311a49e13d2fd5f152f492b2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -417,6 +417,7 @@ static struct kmemleak_object *mem_pool_
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
+	bool warn = false;
 
 	/* try the slab allocator first */
 	if (object_cache) {
@@ -434,8 +435,10 @@ static struct kmemleak_object *mem_pool_
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


