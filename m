Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23081AAE08;
	Wed, 20 Nov 2024 13:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107623; cv=none; b=Wr2I8peMh0ihScbTkAjRjeT/SJZDett4oALCMaJyuDs3RcjivtbImEzO8SXLq8ZGof3zzMFQ4PLzeIaTuqe0YLEpur8m07IQtkM1GsQKE6li3TQWn/+VJayM4q6wIQwpBHkMFpDePXRF02cUP58+qh9AOhQ6i0js7bMtuCH5QYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107623; c=relaxed/simple;
	bh=ZXDnJ8nkPKCcRjAyC5h022ywf4OCaAQrUFfrsKBqWt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnGMSkUnzwpJ9Z9w6Lk1ZwgQNGvAm59UEYeSrN0wDK8Hh/uHRY+XAbP6TrlnFfhfran20PfxOwrlSM2+lQvPJ2w8vuf1dHuu7hJoOQ1z53fGxJRupbijx1e9y4xQjSPdbck4YTdycU3P+1jlX5rz2XSdf8uQOCcLryENbJqHUjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQSXjnAW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQSXjnAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A050C4CECD;
	Wed, 20 Nov 2024 13:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107622;
	bh=ZXDnJ8nkPKCcRjAyC5h022ywf4OCaAQrUFfrsKBqWt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQSXjnAWZfYo1bQqtzbd35RiNYMpljc4q57Ibr2CEyMLRcatEJIfKUJAfZWSqu/Kd
	 AVzTG5y1EPhGCkTRhIvSs5oFI917VJItwKpFd4W5/YYYZz8vMZpW0KjSopm+/20TG3
	 juVw9Knu4w3/JGYPQcNqhj/tAsF/HoZqY4KLkxss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Helge Deller <deller@gmx.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Brown <broonie@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 76/82] mm: unconditionally close VMAs on error
Date: Wed, 20 Nov 2024 13:57:26 +0100
Message-ID: <20241120125631.329604062@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 4080ef1579b2413435413988d14ac8c68e4d42c8 ]

Incorrect invocation of VMA callbacks when the VMA is no longer in a
consistent state is bug prone and risky to perform.

With regards to the important vm_ops->close() callback We have gone to
great lengths to try to track whether or not we ought to close VMAs.

Rather than doing so and risking making a mistake somewhere, instead
unconditionally close and reset vma->vm_ops to an empty dummy operations
set with a NULL .close operator.

We introduce a new function to do so - vma_close() - and simplify existing
vms logic which tracked whether we needed to close or not.

This simplifies the logic, avoids incorrect double-calling of the .close()
callback and allows us to update error paths to simply call vma_close()
unconditionally - making VMA closure idempotent.

Link: https://lkml.kernel.org/r/28e89dda96f68c505cb6f8e9fc9b57c3e9f74b42.1730224667.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/internal.h |   18 ++++++++++++++++++
 mm/mmap.c     |    9 +++------
 mm/nommu.c    |    3 +--
 3 files changed, 22 insertions(+), 8 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -110,6 +110,24 @@ static inline int mmap_file(struct file
 	return err;
 }
 
+/*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
 void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
 						int nr_throttled);
 static inline void acct_reclaim_writeback(struct folio *folio)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -137,8 +137,7 @@ void unlink_file_vma(struct vm_area_stru
 static void remove_vma(struct vm_area_struct *vma, bool unreachable)
 {
 	might_sleep();
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
@@ -2899,8 +2898,7 @@ expanded:
 	return addr;
 
 close_and_free_vma:
-	if (file && vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 
 	if (file || vma->vm_file) {
 unmap_and_free_vma:
@@ -3392,8 +3390,7 @@ struct vm_area_struct *copy_vma(struct v
 	return new_vma;
 
 out_vma_link:
-	if (new_vma->vm_ops && new_vma->vm_ops->close)
-		new_vma->vm_ops->close(new_vma);
+	vma_close(new_vma);
 
 	if (new_vma->vm_file)
 		fput(new_vma->vm_file);
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -600,8 +600,7 @@ static int delete_vma_from_mm(struct vm_
  */
 static void delete_vma(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	if (vma->vm_ops && vma->vm_ops->close)
-		vma->vm_ops->close(vma);
+	vma_close(vma);
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	put_nommu_region(vma->vm_region);


