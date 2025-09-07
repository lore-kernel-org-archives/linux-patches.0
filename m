Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771B315C158;
	Sun,  7 Sep 2025 20:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277147; cv=none; b=OL7BWd9FGS+DtJOgbe8g4R5mVX596YrD9r6UWQVmhO6v0xM7+P+SANfh1m7DlOSc+yauIo3jxENj+UcS58GUc0KKJV7q7PHn9wsnddCfHz647loyQ6+AqJgRFq5+TJfp+a7mB9Fo4sEeCrxDYT6tJG07EmHdK33pkDyWPYgbeu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277147; c=relaxed/simple;
	bh=bWAO+ze6NWmsIEvV9Axx9oJJkOJqlXM1deZOwOGnLNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFAT6gjbXbukBA9O0y3RE5vPSer6meLBRbXh7R8P/WMTIvD4/o4ky0TxjwiVZvLiGGtMJX9LXJqFWJ2UB+yGUTulhQL154eR2OUQCOHTNr1+D5A5dMEW1d1/cYlwFD0spQJb3D+cqDM8+uHASSMkfMpP2+CM1z6a+jdl2eEgh8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4gwJOzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4gwJOzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFA6C4CEF0;
	Sun,  7 Sep 2025 20:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277147;
	bh=bWAO+ze6NWmsIEvV9Axx9oJJkOJqlXM1deZOwOGnLNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4gwJOzCfwFM8sWit7OZPLc+MFBgQQv2/eH36BCw+36oThk61SsHSukoUD19Msb6h
	 i4CVpgseVfZPBUn8xJRfKmJm9nqyVlckyhgK3Sd8U3/KHX2SQOPvZk3ylf1Am8d/l2
	 u5RDrF2RkAZJbRB96pJ6xP9uCR+8wz0BsINuVEtE=
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
Subject: [PATCH 6.12 100/175] mm: fix possible deadlock in kmemleak
Date: Sun,  7 Sep 2025 21:58:15 +0200
Message-ID: <20250907195617.217293935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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
@@ -432,9 +432,15 @@ static struct kmemleak_object *__lookup_
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
@@ -731,6 +737,11 @@ static int __link_object(struct kmemleak
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
@@ -738,6 +749,7 @@ static int __link_object(struct kmemleak
 			 * be freed while the kmemleak_lock is held.
 			 */
 			dump_object_info(parent);
+			printk_deferred_exit();
 			return -EEXIST;
 		}
 	}
@@ -851,13 +863,8 @@ static void delete_object_part(unsigned
 
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
@@ -877,8 +884,14 @@ static void delete_object_part(unsigned
 
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


