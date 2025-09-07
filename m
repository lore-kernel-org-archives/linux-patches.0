Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A0D20E00B;
	Sun,  7 Sep 2025 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277745; cv=none; b=njezJhbmzdsCGVI9tSAFx1Hjkrt56i7zfzkwhf+xh4G8F7B16r8dDweGGQU/4v6yagA2Wv4q7YiVXAQB5ovNO6uvvHRxbtQoPs/nTtfq7klCxAf3/b5qS87WKR3ywwIJgq89VvZpkS0cTzS6AgUWJwo7JWDn6Jhz/ClL2OgMm2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277745; c=relaxed/simple;
	bh=7HCUe+SVUOcNAZavS0hKpLwVs5iiUkOfqknvsXDJiLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=our5DiCH/NAN/rVCQzUhljeOdIwetwOmvHE9emS2jTYhBXr3zBB3i66kCrzm0B5tKrc9PFjPV+jKtIRgt3dylxL9s16KBj5gZlvwvlpLdKicQP2XqtdQr5BnPgiVQBgdB13J8IPWKuqc+oeDWGFwQHfYCc4WeU0dJ4kLC89I9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/SIegyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/SIegyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2FEC4CEF0;
	Sun,  7 Sep 2025 20:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277745;
	bh=7HCUe+SVUOcNAZavS0hKpLwVs5iiUkOfqknvsXDJiLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/SIegyw1c0A0SZdszGCJqmLM8/MzPxQ+6qmKLPwnfxcMdvOwL+BVBKJbJKMiidVM
	 uB9Z6Ixje9w6e0Kyfto6BogJBDCfnEnzMFVNxp5IrzQ8frs1wtQt9/JKY3fmFjydeR
	 luD8YjkhDs3UB+tSEd82Frg8rFA2HqWsXAga5NCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gu Bowen <gubowen5@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>,
	Petr Mladek <pmladek@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 108/183] mm: fix possible deadlock in kmemleak
Date: Sun,  7 Sep 2025 21:58:55 +0200
Message-ID: <20250907195618.357580623@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gu Bowen <gubowen5@huawei.com>

commit c873ccbb2f8db46ad9b4a989ea924b6d8f19abf1 upstream.

There are some AA deadlock issues in kmemleak, similar to the situation
reported by Breno [1].  The deadlock path is as follows:

mem_pool_alloc()
  -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
      -> pr_warn()
          -> netconsole subsystem
	     -> netpoll
	         -> __alloc_skb
		   -> __create_object
		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);

To solve this problem, switch to printk_safe mode before printing warning
message, this will redirect all printk()-s to a special per-CPU buffer,
which will be flushed later from a safe context (irq work), and this
deadlock problem can be avoided.  The proper API to use should be
printk_deferred_enter()/printk_deferred_exit() [2].  Another way is to
place the warn print after kmemleak is released.

Link: https://lkml.kernel.org/r/20250822073541.1886469-1-gubowen5@huawei.com
Link: https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t [1]
Link: https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/ [2]
Signed-off-by: Gu Bowen <gubowen5@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Lu Jialin <lujialin4@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -437,9 +437,15 @@ static struct kmemleak_object *__lookup_
 		else if (untagged_objp == untagged_ptr || alias)
 			return object;
 		else {
+			/*
+			 * Printk deferring due to the kmemleak_lock held.
+			 * This is done to avoid deadlock.
+			 */
+			printk_deferred_enter();
 			kmemleak_warn("Found object by alias at 0x%08lx\n",
 				      ptr);
 			dump_object_info(object);
+			printk_deferred_exit();
 			break;
 		}
 	}
@@ -736,6 +742,11 @@ static int __link_object(struct kmemleak
 		else if (untagged_objp + parent->size <= untagged_ptr)
 			link = &parent->rb_node.rb_right;
 		else {
+			/*
+			 * Printk deferring due to the kmemleak_lock held.
+			 * This is done to avoid deadlock.
+			 */
+			printk_deferred_enter();
 			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
 				      ptr);
 			/*
@@ -743,6 +754,7 @@ static int __link_object(struct kmemleak
 			 * be freed while the kmemleak_lock is held.
 			 */
 			dump_object_info(parent);
+			printk_deferred_exit();
 			return -EEXIST;
 		}
 	}
@@ -856,13 +868,8 @@ static void delete_object_part(unsigned
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	object = __find_and_remove_object(ptr, 1, objflags);
-	if (!object) {
-#ifdef DEBUG
-		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
-			      ptr, size);
-#endif
+	if (!object)
 		goto unlock;
-	}
 
 	/*
 	 * Create one or two objects that may result from the memory block
@@ -882,8 +889,14 @@ static void delete_object_part(unsigned
 
 unlock:
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
-	if (object)
+	if (object) {
 		__delete_object(object);
+	} else {
+#ifdef DEBUG
+		kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
+			      ptr, size);
+#endif
+	}
 
 out:
 	if (object_l)


