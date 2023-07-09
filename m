Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376E4522D
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BD7C433C7;
	Sun,  9 Jul 2023 11:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901287;
	bh=TXdyKbUgf13XY3EU8v7zY3HU3a45Pxaq7itkdHG7sN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlpezaRxJoRzgD0f96S71FTdyriWoihGx8iekLlHDNWMNG/N8yTWE1642yBpoVc9s
	 o+tz/eFm/5RUe7Pw3LA6uqLP97AoBwVdwpKhx5Bdz1RUwpu5KAFOM2QESJVZKMZD7i
	 N+a5ANRRyZ/Ebbp0LVoWgvLJXMlfDmhGxjpeRcwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Jacob Young <jacobly.alt@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.4 8/8] fork: lock VMAs of the parent process when forking, again
Date: Sun,  9 Jul 2023 13:14:14 +0200
Message-ID: <20230709111345.543400132@linuxfoundation.org>
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

commit fb49c455323ff8319a123dd312be9082c49a23a5 upstream.

When forking a child process, the parent write-protects anonymous pages
and COW-shares them with the child being forked using copy_present_pte().

We must not take any concurrent page faults on the source vma's as they
are being processed, as we expect both the vma and the pte's behind it
to be stable.  For example, the anon_vma_fork() expects the parents
vma->anon_vma to not change during the vma copy.

A concurrent page fault on a page newly marked read-only by the page
copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on the
source vma, defeating the anon_vma_clone() that wasn't done because the
parent vma originally didn't have an anon_vma, but we now might end up
copying a pte entry for a page that has one.

Before the per-vma lock based changes, the mmap_lock guaranteed
exclusion with concurrent page faults.  But now we need to do a
vma_start_write() to make sure no concurrent faults happen on this vma
while it is being processed.

This fix can potentially regress some fork-heavy workloads.  Kernel
build time did not show noticeable regression on a 56-core machine while
a stress test mapping 10000 VMAs and forking 5000 times in a tight loop
shows ~5% regression.  If such fork time regression is unacceptable,
disabling CONFIG_PER_VMA_LOCK should restore its performance.  Further
optimizations are possible if this regression proves to be problematic.

Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Closes: https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel.org/
Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Closes: https://lore.kernel.org/all/b198d649-f4bf-b971-31d0-e8433ec2a34c@applied-asynchrony.com/
Reported-by: Jacob Young <jacobly.alt@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217624
Fixes: 0bff0aaea03e ("x86/mm: try VMA lock-based page fault handling first")
Cc: stable@vger.kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -696,6 +696,7 @@ static __latent_entropy int dup_mmap(str
 	for_each_vma(old_vmi, mpnt) {
 		struct file *file;
 
+		vma_start_write(mpnt);
 		if (mpnt->vm_flags & VM_DONTCOPY) {
 			vm_stat_account(mm, mpnt->vm_flags, -vma_pages(mpnt));
 			continue;


