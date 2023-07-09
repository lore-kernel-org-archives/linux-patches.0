Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66142522D
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACBC433C7;
	Sun,  9 Jul 2023 11:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901284;
	bh=sV4YBn+G8ZizGGXiQwRVyGZfVtTXbdvSWs2u/sc5Ifs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVLL28inRhCtT6//kbX20C0qPKSRtOhCFirzsQipkSlxuW6EBzjJ3rWeeQ+D1Xh0A
	 CSYAhGxKMbpLXa7+3N26gIeU6CK95Q8essRdx+ISJl4Xn/I9SAMNRbf0TKPj7A4xB5
	 VbaCc2wn4Rx1OLdnWLepmYQGx7Wj6b2OIkVxD8WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Jacob Young <jacobly.alt@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.4 7/8] fork: lock VMAs of the parent process when forking
Date: Sun,  9 Jul 2023 13:14:13 +0200
Message-ID: <20230709111345.516444847@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111345.297026264@linuxfoundation.org>
References: <20230709111345.297026264@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Suren Baghdasaryan <surenb@google.com>

commit 2b4f3b4987b56365b981f44a7e843efa5b6619b9 upstream.

Patch series "Avoid memory corruption caused by per-VMA locks", v4.

A memory corruption was reported in [1] with bisection pointing to the
patch [2] enabling per-VMA locks for x86.  Based on the reproducer
provided in [1] we suspect this is caused by the lack of VMA locking while
forking a child process.

Patch 1/2 in the series implements proper VMA locking during fork.  I
tested the fix locally using the reproducer and was unable to reproduce
the memory corruption problem.

This fix can potentially regress some fork-heavy workloads.  Kernel build
time did not show noticeable regression on a 56-core machine while a
stress test mapping 10000 VMAs and forking 5000 times in a tight loop
shows ~7% regression.  If such fork time regression is unacceptable,
disabling CONFIG_PER_VMA_LOCK should restore its performance.  Further
optimizations are possible if this regression proves to be problematic.

Patch 2/2 disables per-VMA locks until the fix is tested and verified.


This patch (of 2):

When forking a child process, parent write-protects an anonymous page and
COW-shares it with the child being forked using copy_present_pte().
Parent's TLB is flushed right before we drop the parent's mmap_lock in
dup_mmap().  If we get a write-fault before that TLB flush in the parent,
and we end up replacing that anonymous page in the parent process in
do_wp_page() (because, COW-shared with the child), this might lead to some
stale writable TLB entries targeting the wrong (old) page.  Similar issue
happened in the past with userfaultfd (see flush_tlb_page() call inside
do_wp_page()).

Lock VMAs of the parent process when forking a child, which prevents
concurrent page faults during fork operation and avoids this issue.  This
fix can potentially regress some fork-heavy workloads.  Kernel build time
did not show noticeable regression on a 56-core machine while a stress
test mapping 10000 VMAs and forking 5000 times in a tight loop shows ~7%
regression.  If such fork time regression is unacceptable, disabling
CONFIG_PER_VMA_LOCK should restore its performance.  Further optimizations
are possible if this regression proves to be problematic.

Link: https://lkml.kernel.org/r/20230706011400.2949242-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230706011400.2949242-2-surenb@google.com
Fixes: 0bff0aaea03e ("x86/mm: try VMA lock-based page fault handling first")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel.org/
Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Closes: https://lore.kernel.org/all/b198d649-f4bf-b971-31d0-e8433ec2a34c@applied-asynchrony.com/
Reported-by: Jacob Young <jacobly.alt@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217624
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Holger Hoffsttte <holger@applied-asynchrony.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -662,6 +662,12 @@ static __latent_entropy int dup_mmap(str
 		retval = -EINTR;
 		goto fail_uprobe_end;
 	}
+#ifdef CONFIG_PER_VMA_LOCK
+	/* Disallow any page faults before calling flush_cache_dup_mm */
+	for_each_vma(old_vmi, mpnt)
+		vma_start_write(mpnt);
+	vma_iter_set(&old_vmi, 0);
+#endif
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
 	/*


