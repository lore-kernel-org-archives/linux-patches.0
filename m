Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA9233E5
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 19:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F393C385A7;
	Wed, 27 Apr 2022 19:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1651088517;
	bh=FzMaEt0ORKT14V9HyN2A3rQwOPnyIJUsEAiiAUmn1ow=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=AYxhAu9GR1UaXIaH8b+lS1CD0FklXZaCqihT922cdBzzEhD2SC8sbgUMPRUcBpkdX
	 WP8thrukZpFvzkgiTArjsG4/e7MmLH3w6Fm4e1aZJ1ndY+TeNAGoS3+Lbx9cniZPNW
	 giz/O0dkyoVzouuL+pH6n1Q2Km30wKNKESmTwPr8=
Date: Wed, 27 Apr 2022 12:41:56 -0700
To: stable@vger.kernel.org,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,qiang1.zhang@intel.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220427124133.cc115bc8acb8de3dda921836@linux-foundation.org>
Subject: [patch 1/2] kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time
Message-Id: <20220427194157.8F393C385A7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Zqiang <qiang1.zhang@intel.com>
Subject: kasan: prevent cpu_quarantine corruption when CPU offline and cache shrink occur at same time

kasan_quarantine_remove_cache() is called in kmem_cache_shrink()/
destroy().  The kasan_quarantine_remove_cache() call is protected by
cpuslock in kmem_cache_destroy() to ensure serialization with
kasan_cpu_offline().

However the kasan_quarantine_remove_cache() call is not protected by
cpuslock in kmem_cache_shrink().  When a CPU is going offline and cache
shrink occurs at same time, the cpu_quarantine may be corrupted by
interrupt (per_cpu_remove_cache operation).

So add a cpu_quarantine offline flags check in per_cpu_remove_cache().

[akpm@linux-foundation.org: add comment, per Zqiang]
Link: https://lkml.kernel.org/r/20220414025925.2423818-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/kasan/quarantine.c~kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time
+++ a/mm/kasan/quarantine.c
@@ -315,6 +315,13 @@ static void per_cpu_remove_cache(void *a
 	struct qlist_head *q;
 
 	q = this_cpu_ptr(&cpu_quarantine);
+	/*
+	 * Ensure the ordering between the writing to q->offline and
+	 * per_cpu_remove_cache.  Prevent cpu_quarantine from being corrupted
+	 * by interrupt.
+	 */
+	if (READ_ONCE(q->offline))
+		return;
 	qlist_move_cache(q, &to_free, cache);
 	qlist_free_all(&to_free, cache);
 }
_
