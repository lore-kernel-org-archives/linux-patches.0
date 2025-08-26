Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A653418DB2A;
	Tue, 26 Aug 2025 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213363; cv=none; b=hL5sYYjnb28Mktc/cA5Y2c17SnH8hy4X6UKRu8lcFhVTi+AmnK5UNVTVE5e0zj+OUzn3e4j75CI+inCJzIIgPYC5oACcr8ky0rz7xJjX/41rVQAj3wTB/O4CDjcsS57X6VInufmIVHVAY1K0H29IviGNc+PCPHpaCYZHwsX3oSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213363; c=relaxed/simple;
	bh=BLNZt56qHCDqpg8NNap5b25UOwXFnPOU8LTZnA1wlJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW0fnIAzwbgGX0ImaLouy0YYzRpFq3P38jziXfCL2Hphe/j5t//MhaKAzkH/BlnPJxCEaMR11bPB3X2KTiSsL+8J6V65QKmLxsA/QNNokIIQyukkrYv34HcYPkNRjM4QC9blvZExU2FkEBCYC8nGOltRxec/QxBt/TIbKfneX5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFicMUXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFicMUXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C56C4CEF1;
	Tue, 26 Aug 2025 13:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213362;
	bh=BLNZt56qHCDqpg8NNap5b25UOwXFnPOU8LTZnA1wlJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFicMUXuQP1mBqiWjQ4danyr9hNclyuMrEaMX7IPWw1x4CLEYn8n7hZskVxPLJMXx
	 9FP+/6LhV1abd9U/E8CPJsZ2JW7g32+ruGtNVwKra/nGANMh9p26O4ZPEs+iUHM6WQ
	 /np4Xo5dDhayN9l1DtL/Pn5QCvR+YIdU/Z0wVK3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 319/587] mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()
Date: Tue, 26 Aug 2025 13:07:48 +0200
Message-ID: <20250826111001.031185623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

commit d1534ae23c2b6be350c8ab060803fbf6e9682adc upstream.

A soft lockup warning was observed on a relative small system x86-64
system with 16 GB of memory when running a debug kernel with kmemleak
enabled.

  watchdog: BUG: soft lockup - CPU#8 stuck for 33s! [kworker/8:1:134]

The test system was running a workload with hot unplug happening in
parallel.  Then kemleak decided to disable itself due to its inability to
allocate more kmemleak objects.  The debug kernel has its
CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE set to 40,000.

The soft lockup happened in kmemleak_do_cleanup() when the existing
kmemleak objects were being removed and deleted one-by-one in a loop via a
workqueue.  In this particular case, there are at least 40,000 objects
that need to be processed and given the slowness of a debug kernel and the
fact that a raw_spinlock has to be acquired and released in
__delete_object(), it could take a while to properly handle all these
objects.

As kmemleak has been disabled in this case, the object removal and
deletion process can be further optimized as locking isn't really needed.
However, it is probably not worth the effort to optimize for such an edge
case that should rarely happen.  So the simple solution is to call
cond_resched() at periodic interval in the iteration loop to avoid soft
lockup.

Link: https://lkml.kernel.org/r/20250728190248.605750-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2006,6 +2006,7 @@ static const struct file_operations kmem
 static void __kmemleak_do_cleanup(void)
 {
 	struct kmemleak_object *object, *tmp;
+	unsigned int cnt = 0;
 
 	/*
 	 * Kmemleak has already been disabled, no need for RCU list traversal
@@ -2014,6 +2015,10 @@ static void __kmemleak_do_cleanup(void)
 	list_for_each_entry_safe(object, tmp, &object_list, object_list) {
 		__remove_object(object);
 		__delete_object(object);
+
+		/* Call cond_resched() once per 64 iterations to avoid soft lockup */
+		if (!(++cnt & 0x3f))
+			cond_resched();
 	}
 }
 


