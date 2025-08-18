Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA237270ED2;
	Mon, 18 Aug 2025 13:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524509; cv=none; b=RhBOk0Pjbo3d6vKZfJbIcHnPqIhLkMefoAEUxSfv2B8JaDdgcqUhzkcT0z3wAZBOho8cuiCe83d2HdcMfsHZLrKFJUzj6hLB5NPS8/03Ga0aX5oclAoCNcmhW2YOvqfCCPZ0E9FqZvz48OpH0uwrjs52ttvl6UwHCrneQrqySLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524509; c=relaxed/simple;
	bh=coaKHVem68sIk50sVTp7mCpA7BlO37zu65Z6iraK3rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYGjAP6VaV7BSUtdBssx9K19QJ6QvKOzKrsvZJneaUm41Djto/lDC2Cre71MYb/gTZ8hxtq+XjGL0mwTyEU+x8NnTd5vyh/MNuOSczwXvy64cZfP20zbhT9J0FSEhe2G/I6WvnYkuRU+wBQlGaTqvb4rnj6wEX95BPkQrBrOY5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqlYc2uu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqlYc2uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A9C4CEEB;
	Mon, 18 Aug 2025 13:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524509;
	bh=coaKHVem68sIk50sVTp7mCpA7BlO37zu65Z6iraK3rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqlYc2uuut/jujTfIY1GaxB0SsbfaVAIzOUPnLINFExsPBYqjeEM8gdHxPbuQ7VZM
	 MpwgFB7LDIW7ehMb+IndPXjc9VAx6ELZmRkD7NpyAB9px/mvaBvClUbqGb9RbpPoof
	 o8/vMkBPAQ4KkSiVU9KAT5LWGQ4qNH2GrCp9GXeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 494/515] mm/kmemleak: avoid soft lockup in __kmemleak_do_cleanup()
Date: Mon, 18 Aug 2025 14:48:00 +0200
Message-ID: <20250818124517.454567116@linuxfoundation.org>
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
@@ -2172,6 +2172,7 @@ static const struct file_operations kmem
 static void __kmemleak_do_cleanup(void)
 {
 	struct kmemleak_object *object, *tmp;
+	unsigned int cnt = 0;
 
 	/*
 	 * Kmemleak has already been disabled, no need for RCU list traversal
@@ -2180,6 +2181,10 @@ static void __kmemleak_do_cleanup(void)
 	list_for_each_entry_safe(object, tmp, &object_list, object_list) {
 		__remove_object(object);
 		__delete_object(object);
+
+		/* Call cond_resched() once per 64 iterations to avoid soft lockup */
+		if (!(++cnt & 0x3f))
+			cond_resched();
 	}
 }
 


