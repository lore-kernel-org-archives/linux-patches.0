Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DDC144D13;
	Thu, 13 Jun 2024 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279593; cv=none; b=dA1PrW1/4bltBsrfC9e09Bnnzatfz8RDpalQsu2m2M8pCilwB+58hWgNkhsKx1q6vjNgTgC2jkVvx2IDkjtgABg9SvR3L/3QPf+NBpfZK8g5dS8v0LvqWKvmv7sauJsfBraBalWYHv9tcOiZMEIwjWQwb3GQxfsM8HBHMO7f36E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279593; c=relaxed/simple;
	bh=zMfVX9yoL6hdzZYQdQRaxicqUWw8wjh2CrQfljW6wos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1vhS9V4rehjTXhfZ8QPhj/x0Cro0RPcd/Z5qTwexu7ljmyLztHrPu6GtVyQfi+oXu5OOJ/TRcv+Ocwc63oS4+snwgcCLTCNI5uwzDJhUeH8SCbcgivWcSHmTOYaLSguawAf4omenUDzjLunh3DvHQGOlpuGssF8WiGuktCvTLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iB4ZtLzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iB4ZtLzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42B0C2BBFC;
	Thu, 13 Jun 2024 11:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279593;
	bh=zMfVX9yoL6hdzZYQdQRaxicqUWw8wjh2CrQfljW6wos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iB4ZtLzUSTu8Ei4LmZTsnAsN7kFxUAMoaSxtOBZ1I69miSFWsh5XbhpFOUQkVZe/S
	 uww2H/gwjh8FnFgs9q+baDLAAiiLZUEV954L19qu/NZ8w+g36t0xTTNhwZI3Zb3Uid
	 URYPMH4s2sEl5LGkiX5Gr+ta/el1XtFa05VtPpho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanyuan Zhong <yzhong@purestorage.com>,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 098/157] mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again
Date: Thu, 13 Jun 2024 13:33:43 +0200
Message-ID: <20240613113231.214879354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanyuan Zhong <yzhong@purestorage.com>

commit 6d065f507d82307d6161ac75c025111fb8b08a46 upstream.

After switching smaps_rollup to use VMA iterator, searching for next entry
is part of the condition expression of the do-while loop.  So the current
VMA needs to be addressed before the continue statement.

Otherwise, with some VMAs skipped, userspace observed memory
consumption from /proc/pid/smaps_rollup will be smaller than the sum of
the corresponding fields from /proc/pid/smaps.

Link: https://lkml.kernel.org/r/20240523183531.2535436-1-yzhong@purestorage.com
Fixes: c4c84f06285e ("fs/proc/task_mmu: stop using linked list and highest_vm_end")
Signed-off-by: Yuanyuan Zhong <yzhong@purestorage.com>
Reviewed-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -965,12 +965,17 @@ static int show_smaps_rollup(struct seq_
 				break;
 
 			/* Case 1 and 2 above */
-			if (vma->vm_start >= last_vma_end)
+			if (vma->vm_start >= last_vma_end) {
+				smap_gather_stats(vma, &mss, 0);
+				last_vma_end = vma->vm_end;
 				continue;
+			}
 
 			/* Case 4 above */
-			if (vma->vm_end > last_vma_end)
+			if (vma->vm_end > last_vma_end) {
 				smap_gather_stats(vma, &mss, last_vma_end);
+				last_vma_end = vma->vm_end;
+			}
 		}
 	} for_each_vma(vmi, vma);
 


