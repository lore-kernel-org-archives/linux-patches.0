Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F652737EE;
	Fri,  9 Jan 2026 12:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961208; cv=none; b=L9we2eMLj9hmoTm9Mb0BPegTMxqfbO4kY5+3cd4hYXKIJbiqBNxnZNOpJGQx98fxxyGb+zTcMEoLjU1+Fk6j1oBQuwHMidnaWuBCJ2umbj5oTWHaSz/bz37Kfumru/eLAE3v+z0Ow8KEfSrybQNUz4j2z/NSqAilnCrvElvFoo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961208; c=relaxed/simple;
	bh=LwkaHipD2NWcfnMNjCih0zrEajvzuiV2d9mYFMvT9mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOhXgbpx5x/fb2/suvOyiNpXJ0YvxHHXtw9WVDt7FWWPB3T3Xe/q0HX/TYZWhZJfOQxW+g2Yi+0T5ozKo+KwJiWNB3xh7FaWSHb/UjposhBiTJBT6AcHjTOU5t2wbhK1ZTMmvQ17Yyyytqgu+tkScJl9rp8X4twDT9Y/V/yyVTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bo6GsQYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bo6GsQYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80D8C4CEF1;
	Fri,  9 Jan 2026 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961208;
	bh=LwkaHipD2NWcfnMNjCih0zrEajvzuiV2d9mYFMvT9mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo6GsQYQz/ymla04opY5BCq7svQzFkAnP78nTFzPtJ3zsyKVXnNCq8YAQhybd1Wtc
	 UV3ps50t+yZvj+3myWbhKl4zUtqgp+vGdp8YGBHmRXLEJAqxSK7ZU6KPfjZe+5Gcyb
	 c3bZ+HvzbmjT/GnBuAuBmA2UMCqEuTOOqgFFkuJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xu xin <xu.xin16@zte.com.cn>,
	Stefan Roesch <shr@devkernel.io>,
	David Hildenbrand <david@redhat.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Wang Yaxin <wang.yaxin@zte.com.cn>,
	Yang Yang <yang.yang29@zte.com.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 640/737] mm/ksm: fix exec/fork inheritance support for prctl
Date: Fri,  9 Jan 2026 12:42:59 +0100
Message-ID: <20260109112158.086767461@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xu xin <xu.xin16@zte.com.cn>

[ Upstream commit 590c03ca6a3fbb114396673314e2aa483839608b ]

Patch series "ksm: fix exec/fork inheritance", v2.

This series fixes exec/fork inheritance.  See the detailed description of
the issue below.

This patch (of 2):

Background
==========

commit d7597f59d1d33 ("mm: add new api to enable ksm per process")
introduced MMF_VM_MERGE_ANY for mm->flags, and allowed user to set it by
prctl() so that the process's VMAs are forcibly scanned by ksmd.

Subsequently, the 3c6f33b7273a ("mm/ksm: support fork/exec for prctl")
supported inheriting the MMF_VM_MERGE_ANY flag when a task calls execve().

Finally, commit 3a9e567ca45fb ("mm/ksm: fix ksm exec support for prctl")
fixed the issue that ksmd doesn't scan the mm_struct with MMF_VM_MERGE_ANY
by adding the mm_slot to ksm_mm_head in __bprm_mm_init().

Problem
=======

In some extreme scenarios, however, this inheritance of MMF_VM_MERGE_ANY
during exec/fork can fail.  For example, when the scanning frequency of
ksmd is tuned extremely high, a process carrying MMF_VM_MERGE_ANY may
still fail to pass it to the newly exec'd process.  This happens because
ksm_execve() is executed too early in the do_execve flow (prematurely
adding the new mm_struct to the ksm_mm_slot list).

As a result, before do_execve completes, ksmd may have already performed a
scan and found that this new mm_struct has no VM_MERGEABLE VMAs, thus
clearing its MMF_VM_MERGE_ANY flag.  Consequently, when the new program
executes, the flag MMF_VM_MERGE_ANY inheritance missed.

Root reason
===========

commit d7597f59d1d33 ("mm: add new api to enable ksm per process") clear
the flag MMF_VM_MERGE_ANY when ksmd found no VM_MERGEABLE VMAs.

Solution
========

Firstly, Don't clear MMF_VM_MERGE_ANY when ksmd found no VM_MERGEABLE
VMAs, because perhaps their mm_struct has just been added to ksm_mm_slot
list, and its process has not yet officially started running or has not
yet performed mmap/brk to allocate anonymous VMAS.

Secondly, recheck MMF_VM_MERGEABLE again if a process takes
MMF_VM_MERGE_ANY, and create a mm_slot and join it into ksm_scan_list
again.

Link: https://lkml.kernel.org/r/20251007182504440BJgK8VXRHh8TD7IGSUIY4@zte.com.cn
Link: https://lkml.kernel.org/r/20251007182821572h_SoFqYZXEP1mvWI4n9VL@zte.com.cn
Fixes: 3c6f33b7273a ("mm/ksm: support fork/exec for prctl")
Fixes: d7597f59d1d3 ("mm: add new api to enable ksm per process")
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ changed mm_flags_test() and mm_flags_clear() calls to test_bit() and clear_bit() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/ksm.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2451,8 +2451,14 @@ no_vmas:
 		spin_unlock(&ksm_mmlist_lock);
 
 		mm_slot_free(mm_slot_cache, mm_slot);
+		/*
+		 * Only clear MMF_VM_MERGEABLE. We must not clear
+		 * MMF_VM_MERGE_ANY, because for those MMF_VM_MERGE_ANY process,
+		 * perhaps their mm_struct has just been added to ksm_mm_slot
+		 * list, and its process has not yet officially started running
+		 * or has not yet performed mmap/brk to allocate anonymous VMAS.
+		 */
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
-		clear_bit(MMF_VM_MERGE_ANY, &mm->flags);
 		mmap_read_unlock(mm);
 		mmdrop(mm);
 	} else {
@@ -2567,8 +2573,16 @@ void ksm_add_vma(struct vm_area_struct *
 {
 	struct mm_struct *mm = vma->vm_mm;
 
-	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags))
+	if (test_bit(MMF_VM_MERGE_ANY, &mm->flags)) {
 		__ksm_add_vma(vma);
+		/*
+		 * Generally, the flags here always include MMF_VM_MERGEABLE.
+		 * However, in rare cases, this flag may be cleared by ksmd who
+		 * scans a cycle without finding any mergeable vma.
+		 */
+		if (unlikely(!test_bit(MMF_VM_MERGEABLE, &mm->flags)))
+			__ksm_enter(mm);
+	}
 }
 
 static void ksm_add_vmas(struct mm_struct *mm)


