Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0652206B8;
	Mon, 18 Aug 2025 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524516; cv=none; b=AS6JkkjJuHiYdPprs2xA7dpjPbKBKU7e9VMY4mzkPPMysF4cv1JIhHiSnU43YHx4n8VpJdB9v8szL7gQRdnruyQfMwdbU4WD7k/+1sVK+e8HpTLDdX9OLzFpFyGvouOI9CpedTebTiCWQtrSNWqn6fX8rzhY3KyFrGOZoOkrqD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524516; c=relaxed/simple;
	bh=nSDOXL8ly0lsCRpCrUIAd+gAUdPyUVhnTxmzCMcCy6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsZpufN5Zr9/KGdvKy82Gey5rbvtmWRWAy/M13A6cfh6I7Bmn5igJAxtsu7uuYwxiFHtIMgzt3RJhDlY9AONrWUDYkE5CM1h7JE7PpVZrkhl/VW9bkvIQlwG0/6PebFNbs2NEtUreYC0L2W9VXW/OIpPSHIZ0JO/B1cSWHrVK1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/WtZcyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/WtZcyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BFAC113D0;
	Mon, 18 Aug 2025 13:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524516;
	bh=nSDOXL8ly0lsCRpCrUIAd+gAUdPyUVhnTxmzCMcCy6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/WtZcyiSQhZUvZj0mXV7/00Sx3d6rc/W5nQcNnUDeQ0CCUiPk2qDgbnvHzT43qxZ
	 jsU2N4jPk5cAe+5qXEdBFwYFgGejYN0lWwfXtijV+j2tcRt2YkOqzoxiax27Raycpe
	 uKhMSSNYZrux2HzxKtwdPltnS+7RReiBn8EkGKzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 495/515] mm/kmemleak: avoid deadlock by moving pr_warn() outside kmemleak_lock
Date: Mon, 18 Aug 2025 14:48:01 +0200
Message-ID: <20250818124517.501575473@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -475,6 +475,7 @@ static struct kmemleak_object *mem_pool_
 {
 	unsigned long flags;
 	struct kmemleak_object *object;
+	bool warn = false;
 
 	/* try the slab allocator first */
 	if (object_cache) {
@@ -493,8 +494,10 @@ static struct kmemleak_object *mem_pool_
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


