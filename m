Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04931A9B58;
	Tue, 17 Mar 2026 17:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767776; cv=none; b=GJjY5A0FOJ6XnxSHFD9jdiX/QzNRyBfFnuLBNgNNSNz/pMhCc2Kjt5JCKh/Z7CdiGvls1CK6u04VpY0SDHlK5nlN8y9eN75XPJJxWjhHVXin1tvE9ki7LXjBC9isfao1aLFUtP76/2CXOMs+DWFapxPuY7CRdU7f3+iToxlbWAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767776; c=relaxed/simple;
	bh=l++l+rw1mqmA2z7y8XzB5UEqCjMwgpUBMM3M7l5T6/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nfg5ZjfvmauN2KHz9nWq9EK2VagPsTjyS6zlZGZbc7Figruvt0GdcKIQ+CRSpUecGkykL9reJ0wU/oproPaFMjOPJ5pzg2l3ZZ4cQUVOCL3Kpo4nbJmgAmuN7f9yzcB3U1WEKdI3t/cY2Tb8+ZFt2n6/IRrYbPTwspteYWju0Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLk74DnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLk74DnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7979C4CEF7;
	Tue, 17 Mar 2026 17:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767776;
	bh=l++l+rw1mqmA2z7y8XzB5UEqCjMwgpUBMM3M7l5T6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLk74DnUaBIfuZ52tsAoKVZtKIQ6JU8NAAmhbGhMZaPP9K4DX82F6iwLpdJIdwdj5
	 umzNbvp7AsoG00yR1q3INmqZTAoga0xRx4r1utQQAdNdbwJUCn+gYVAmkSae+xnFDP
	 AVhkP1qChJGfPPiEXu1YjekveAnA1MYhiZbwNvQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh Singh <kaleshsingh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	SeongJae Park <sj@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Minchan Kim <minchan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 156/333] mm/tracing: rss_stat: ensure curr is false from kthread context
Date: Tue, 17 Mar 2026 17:33:05 +0100
Message-ID: <20260317163005.144680485@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh Singh <kaleshsingh@google.com>

commit 079c24d5690262e83ee476e2a548e416f3237511 upstream.

The rss_stat trace event allows userspace tools, like Perfetto [1], to
inspect per-process RSS metric changes over time.

The curr field was introduced to rss_stat in commit e4dcad204d3a
("rss_stat: add support to detect RSS updates of external mm").  Its
intent is to indicate whether the RSS update is for the mm_struct of the
current execution context; and is set to false when operating on a remote
mm_struct (e.g., via kswapd or a direct reclaimer).

However, an issue arises when a kernel thread temporarily adopts a user
process's mm_struct.  Kernel threads do not have their own mm_struct and
normally have current->mm set to NULL.  To operate on user memory, they
can "borrow" a memory context using kthread_use_mm(), which sets
current->mm to the user process's mm.

This can be observed, for example, in the USB Function Filesystem (FFS)
driver.  The ffs_user_copy_worker() handles AIO completions and uses
kthread_use_mm() to copy data to a user-space buffer.  If a page fault
occurs during this copy, the fault handler executes in the kthread's
context.

At this point, current is the kthread, but current->mm points to the user
process's mm.  Since the rss_stat event (from the page fault) is for that
same mm, the condition current->mm == mm becomes true, causing curr to be
incorrectly set to true when the trace event is emitted.

This is misleading because it suggests the mm belongs to the kthread,
confusing userspace tools that track per-process RSS changes and
corrupting their mm_id-to-process association.

Fix this by ensuring curr is always false when the trace event is emitted
from a kthread context by checking for the PF_KTHREAD flag.

Link: https://lkml.kernel.org/r/20260219233708.1971199-1-kaleshsingh@google.com
Link: https://perfetto.dev/ [1]
Fixes: e4dcad204d3a ("rss_stat: add support to detect RSS updates of external mm")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/kmem.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -440,7 +440,13 @@ TRACE_EVENT(rss_stat,
 
 	TP_fast_assign(
 		__entry->mm_id = mm_ptr_to_hash(mm);
-		__entry->curr = !!(current->mm == mm);
+		/*
+		 * curr is true if the mm matches the current task's mm_struct.
+		 * Since kthreads (PF_KTHREAD) have no mm_struct of their own
+		 * but can borrow one via kthread_use_mm(), we must filter them
+		 * out to avoid incorrectly attributing the RSS update to them.
+		 */
+		__entry->curr = current->mm == mm && !(current->flags & PF_KTHREAD);
 		__entry->member = member;
 		__entry->size = (percpu_counter_sum_positive(&mm->rss_stat[member])
 							    << PAGE_SHIFT);


