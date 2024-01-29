Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595E715705F;
	Mon, 29 Jan 2024 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548119; cv=none; b=oBVpp5Iz29kYvkIjbpjztqsg7HMFq7lIrIxLZWfJAL5qmDcB1LFbohKxQnkucckJc+24mIvnNHAFddMCw9pci2MG+j8DKNQrEThtHY9S/i2Xr0bpd7iVvo4JUcCKYSAx92hOBiPB2i3pw1YWqpIf+lKe9UYb/d1DHP1TaYpD/Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548119; c=relaxed/simple;
	bh=drJ8lor/P9YHejQjOEJ7/9OUi+TQ7dGB4STcQ2jB2Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aARFcckqOFvOSlqdImcZXG4aM5Bp6j+AH/UMcT3ewDZAG9k9yb5qjoHcEG9tVYg9UETRo1TcRq3RafC1WNsyPY8zAOMu8W8Cwcfpg3ggLcgtWCL95kX1JtUY0uZ9br4DLOGJTEKX1xC+p2TSM/XzGynqRnDwtdD4jpQ66KfK4Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCzTlk4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCzTlk4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16933C433F1;
	Mon, 29 Jan 2024 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548119;
	bh=drJ8lor/P9YHejQjOEJ7/9OUi+TQ7dGB4STcQ2jB2Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCzTlk4MN6Ak4huJT2dz/HKHNJO6h33Hli9e4ltwycItE+WVKbGBn5f9wLQvAnE5K
	 4xyV5FVmDW/qqvykGZMVqOxpsoFq3ossLWo5N2RxpblduGtuiAbXOlsa5lWB/dLG+4
	 0zJoS1t7/wJjsfy2Nvq+IJoPCP2OmW63RNJT0eUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	syzbot+81227d2bd69e9dedb802@syzkaller.appspotmail.com,
	Sean Christopherson <seanjc@google.com>,
	Andrei Vagin <avagin@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 120/346] fs/proc/task_mmu: move mmu notification mechanism inside mm lock
Date: Mon, 29 Jan 2024 09:02:31 -0800
Message-ID: <20240129170019.917774527@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 4cccb6221cae6d020270606b9e52b1678fc8b71a upstream.

Move mmu notification mechanism inside mm lock to prevent race condition
in other components which depend on it.  The notifier will invalidate
memory range.  Depending upon the number of iterations, different memory
ranges would be invalidated.

The following warning would be removed by this patch:
WARNING: CPU: 0 PID: 5067 at arch/x86/kvm/../../../virt/kvm/kvm_main.c:734 kvm_mmu_notifier_change_pte+0x860/0x960 arch/x86/kvm/../../../virt/kvm/kvm_main.c:734

There is no behavioural and performance change with this patch when
there is no component registered with the mmu notifier.

[akpm@linux-foundation.org: narrow the scope of `range', per Sean]
Link: https://lkml.kernel.org/r/20240109112445.590736-1-usama.anjum@collabora.com
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reported-by: syzbot+81227d2bd69e9dedb802@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000f6d051060c6785bc@google.com/
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_mmu.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2415,7 +2415,6 @@ static long pagemap_scan_flush_buffer(st
 
 static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 {
-	struct mmu_notifier_range range;
 	struct pagemap_scan_private p = {0};
 	unsigned long walk_start;
 	size_t n_ranges_out = 0;
@@ -2431,15 +2430,9 @@ static long do_pagemap_scan(struct mm_st
 	if (ret)
 		return ret;
 
-	/* Protection change for the range is going to happen. */
-	if (p.arg.flags & PM_SCAN_WP_MATCHING) {
-		mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA, 0,
-					mm, p.arg.start, p.arg.end);
-		mmu_notifier_invalidate_range_start(&range);
-	}
-
 	for (walk_start = p.arg.start; walk_start < p.arg.end;
 			walk_start = p.arg.walk_end) {
+		struct mmu_notifier_range range;
 		long n_out;
 
 		if (fatal_signal_pending(current)) {
@@ -2450,8 +2443,20 @@ static long do_pagemap_scan(struct mm_st
 		ret = mmap_read_lock_killable(mm);
 		if (ret)
 			break;
+
+		/* Protection change for the range is going to happen. */
+		if (p.arg.flags & PM_SCAN_WP_MATCHING) {
+			mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA, 0,
+						mm, walk_start, p.arg.end);
+			mmu_notifier_invalidate_range_start(&range);
+		}
+
 		ret = walk_page_range(mm, walk_start, p.arg.end,
 				      &pagemap_scan_ops, &p);
+
+		if (p.arg.flags & PM_SCAN_WP_MATCHING)
+			mmu_notifier_invalidate_range_end(&range);
+
 		mmap_read_unlock(mm);
 
 		n_out = pagemap_scan_flush_buffer(&p);
@@ -2477,9 +2482,6 @@ static long do_pagemap_scan(struct mm_st
 	if (pagemap_scan_writeback_args(&p.arg, uarg))
 		ret = -EFAULT;
 
-	if (p.arg.flags & PM_SCAN_WP_MATCHING)
-		mmu_notifier_invalidate_range_end(&range);
-
 	kfree(p.vec_buf);
 	return ret;
 }


