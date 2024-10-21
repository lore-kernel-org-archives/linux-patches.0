Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612661E6DD5;
	Mon, 21 Oct 2024 10:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506510; cv=none; b=gQ1aiB+hGS+r59mmxngKyC5wpcIMDmCDpqnK/5r5X8PRdE0sBAt+HRf48AJdEyfHvILOP+mfyQvYHDvMDsIc+JVmP8C3T/IzkRzppeZb/qs6PbUWd1CK0oEA3jN8PX3lF/xdrb6hdU7d2kMlM68c5Ea40K8i8ApufuDeXE88hpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506510; c=relaxed/simple;
	bh=fv1cXGQbQvBm7mvZNbCzV0LP1zkfpO+Y3s1FmiIskH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBWr25XwVdP9Cm7mAhwtbtKcWxMyMqGb4DjEyDwiXBGHHzyHZbnju1bQRXN3VKZFmXveykQgJ6BToBAN1WdyZy0F9kJut+it7VcsT0jnut3g37V5fIFfGhqrwGWGGYq0OVsdVBUirBt15W+/K/TaN2Y2Wt2NQH2MeyFkX0mVr7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIdJA8BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIdJA8BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B729C4CEC3;
	Mon, 21 Oct 2024 10:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506510;
	bh=fv1cXGQbQvBm7mvZNbCzV0LP1zkfpO+Y3s1FmiIskH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIdJA8BZmv0nyhVad+nUwfDoRGKC9UN+D1RqiZ64sbAArw7fYbj5G/+Nro6s0GYlE
	 nC70y8Lq1Qx6cSM7HEB1RDB2ESH3lNLVFlbkuVGC1y2OX4tep9b9VK4+30gIe4zn+h
	 KSt1ZkLYrHCxt6a/b6hPl060wwX8tDoowWzahKrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Gautam Menghani <gautammenghani201@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 028/135] mm: khugepaged: fix the arguments order in khugepaged_collapse_file trace point
Date: Mon, 21 Oct 2024 12:23:04 +0200
Message-ID: <20241021102300.435722848@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang@os.amperecomputing.com>

commit 37f0b47c5143c2957909ced44fc09ffb118c99f7 upstream.

The "addr" and "is_shmem" arguments have different order in TP_PROTO and
TP_ARGS.  This resulted in the incorrect trace result:

text-hugepage-644429 [276] 392092.878683: mm_khugepaged_collapse_file:
mm=0xffff20025d52c440, hpage_pfn=0x200678c00, index=512, addr=1, is_shmem=0,
filename=text-hugepage, nr=512, result=failed

The value of "addr" is wrong because it was treated as bool value, the
type of is_shmem.

Fix the order in TP_PROTO to keep "addr" is before "is_shmem" since the
original patch review suggested this order to achieve best packing.

And use "lx" for "addr" instead of "ld" in TP_printk because address is
typically shown in hex.

After the fix, the trace result looks correct:

text-hugepage-7291  [004]   128.627251: mm_khugepaged_collapse_file:
mm=0xffff0001328f9500, hpage_pfn=0x20016ea00, index=512, addr=0x400000,
is_shmem=0, filename=text-hugepage, nr=512, result=failed

Link: https://lkml.kernel.org/r/20241012011702.1084846-1-yang@os.amperecomputing.com
Fixes: 4c9473e87e75 ("mm/khugepaged: add tracepoint to collapse_file()")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Cc: Gautam Menghani <gautammenghani201@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>    [6.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/huge_memory.h |    4 ++--
 mm/khugepaged.c                    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -208,7 +208,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
 	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
-			bool is_shmem, unsigned long addr, struct file *file,
+			unsigned long addr, bool is_shmem, struct file *file,
 			int nr, int result),
 	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
@@ -233,7 +233,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__entry->result = result;
 	),
 
-	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, addr=%ld, is_shmem=%d, filename=%s, nr=%d, result=%s",
+	TP_printk("mm=%p, hpage_pfn=0x%lx, index=%ld, addr=%lx, is_shmem=%d, filename=%s, nr=%d, result=%s",
 		__entry->mm,
 		__entry->hpfn,
 		__entry->index,
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2219,7 +2219,7 @@ rollback:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, new_folio, index, is_shmem, addr, file, HPAGE_PMD_NR, result);
+	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
 }
 


