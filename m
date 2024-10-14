Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCDB26296;
	Mon, 14 Oct 2024 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918510; cv=none; b=Faip2xw15IhK+kMHPVbqOUHb6Wz/TkPJilW71GrxcO+58hXA+LC/1J4012AqCtT0LbX2GmzHncUN6Q5lGC+z3jGFOqlXgqjcQF1qQvFhTSyqp8iYIULGkeu6hbCkCe2V1kzSEEjIXk0RR1N9a45viErdlNE59yDdsSFZgndBIXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918510; c=relaxed/simple;
	bh=9JSNdU7JzAM6/WOUwQDhBjgwKbTXdMv8yIBsFhBskaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Doo9LM3G+6FqDXm3JcIY0ht0oaAAPyJXg7fkFuD1thTuXOD3hR/m5LLK+oCb1AP3G6ChdxShGDffoqpLP5f/FuqIemxZNj1Ls3eomsc+mbsndq6hlgz4cc/WfChXOB+FbN3lVfpZSUWLbtCiXpYGaRRH0/Hl20OfspMipKXLwKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhS/CCsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhS/CCsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E57C4CECF;
	Mon, 14 Oct 2024 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918510;
	bh=9JSNdU7JzAM6/WOUwQDhBjgwKbTXdMv8yIBsFhBskaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhS/CCsbOQm5TDeelNU13P+6c8XQh/LY+r0msHdXWSzb0dWWF/iZeM8dwlie/2pLw
	 fQReMnWxzMPEJ54TZSDosGLroeBaIwocbFKvl77VfHOlnSsHjmdjOD5B/gCo6PGEaJ
	 R7qwB9sU21wL8uYrhvf07lpegzkeM9NygBYCFn3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 326/798] debugobjects: Fix conditions in fill_pool()
Date: Mon, 14 Oct 2024 16:14:40 +0200
Message-ID: <20241014141230.760235717@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

commit 684d28feb8546d1e9597aa363c3bfcf52fe250b7 upstream.

fill_pool() uses 'obj_pool_min_free' to decide whether objects should be
handed back to the kmem cache. But 'obj_pool_min_free' records the lowest
historical value of the number of objects in the object pool and not the
minimum number of objects which should be kept in the pool.

Use 'debug_objects_pool_min_level' instead, which holds the minimum number
which was scaled to the number of CPUs at boot time.

[ tglx: Massage change log ]

Fixes: d26bf5056fc0 ("debugobjects: Reduce number of pool_lock acquisitions in fill_pool()")
Fixes: 36c4ead6f6df ("debugobjects: Add global free list and the counter")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240904133944.2124-3-thunder.leizhen@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/debugobjects.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -141,13 +141,14 @@ static void fill_pool(void)
 	 * READ_ONCE()s pair with the WRITE_ONCE()s in pool_lock critical
 	 * sections.
 	 */
-	while (READ_ONCE(obj_nr_tofree) && (READ_ONCE(obj_pool_free) < obj_pool_min_free)) {
+	while (READ_ONCE(obj_nr_tofree) &&
+	       READ_ONCE(obj_pool_free) < debug_objects_pool_min_level) {
 		raw_spin_lock_irqsave(&pool_lock, flags);
 		/*
 		 * Recheck with the lock held as the worker thread might have
 		 * won the race and freed the global free list already.
 		 */
-		while (obj_nr_tofree && (obj_pool_free < obj_pool_min_free)) {
+		while (obj_nr_tofree && (obj_pool_free < debug_objects_pool_min_level)) {
 			obj = hlist_entry(obj_to_free.first, typeof(*obj), node);
 			hlist_del(&obj->node);
 			WRITE_ONCE(obj_nr_tofree, obj_nr_tofree - 1);


