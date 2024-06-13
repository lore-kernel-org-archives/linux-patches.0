Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A4F1448DD;
	Thu, 13 Jun 2024 12:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280547; cv=none; b=O57olow6JHAEljsCZ/0e5nfAiAZr49SRk/8vCox/zJkhKcXvScp0JaS3vrxdRVtTLFEDTLwvckIw5xTSuF9eYuTd4ftG4FrOXpcUVpMtCgNYa7S0j3HGf/0+ohZTtrehYTC8nRxrq0hJlW2m+Hjq+Of1J5BGcsCe8K3toKBsUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280547; c=relaxed/simple;
	bh=mizYFAY7BciW2jqY9M3Dhm7RtJFQa+bMtaWxW2HKVrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njZ1ZzpPnAWmZ9YZp7OoVq9rl7lTyUk96zvXVblleFzfaPepz4f368LMCoXRO60rH6NQ2OeKIDJrn2sSjm3bMzbILV3suXsmuS9xUUzisPzab3OTf9DIVw+rxCD9JYN/ko7smtnG4hsPzvgTjddBD7zUIKrb1KNVC+hZF/QIDV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6UyQx3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6UyQx3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5F7C2BBFC;
	Thu, 13 Jun 2024 12:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280547;
	bh=mizYFAY7BciW2jqY9M3Dhm7RtJFQa+bMtaWxW2HKVrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6UyQx3Eenk7uBq3Mw8RFjO/+NwZCBHgRuOGnk/yd6G1VJyivQbez+fbfmz6aq/OT
	 aQojOkwdUOkd+XW3K83l9+l+oyLEFuyQJEMe9vFHfZf3C1i1AVTms+u1p/XSiL+fFh
	 Wj/jdKZ2BobwkTW1vDC9uZo8dZPjrPDBLAWcIJWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanyuan Zhong <yzhong@purestorage.com>,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 091/137] mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again
Date: Thu, 13 Jun 2024 13:34:31 +0200
Message-ID: <20240613113226.826888135@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


