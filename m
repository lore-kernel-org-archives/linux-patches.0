Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AD11A6192;
	Tue, 30 Jul 2024 17:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359182; cv=none; b=bZgfe3NJc0x1hkDuLeVWRrg8S0FgTTz2azXgaCd1mMrU/Gb57GBxnZ6AcXTpwyLTfeOcBukBh7GYNLSRMtS+Wf8SXbJyaP2iLyj8jHiBKDjXTyW4IfxC/9GEz8Hn8OKhMxruWUi5C9Mv8/YS79i3Bvfr98U8PcZsD2jBv2Z5uug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359182; c=relaxed/simple;
	bh=Bnlpm4SYYG5PnA7qr2GCIXezY/NST39E8iH7SCtCYgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpmZ0e6iZ9/vIvw/IWJ6QFtj54cGneRUlFnwRra4MpAd9i4hiGsFPLl8yXrx1GVWp4BbPcTnrRmIIJ+BdhbqB6hhtTpgzg7SQSdD04rkSdgamir74vLPEl2m37jswROOUshS41dgW4LULINmBQ8LtMadET54H2odKIgQStn3tcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn7iMolS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn7iMolS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6CDC32782;
	Tue, 30 Jul 2024 17:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359181;
	bh=Bnlpm4SYYG5PnA7qr2GCIXezY/NST39E8iH7SCtCYgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kn7iMolSv1QuFdPXYnIu3jMPdFQtrQPJ6/HOJWhbZGJWr0a8O4BvX7jlCvOuxVLdR
	 kMXAJ2Ge8IZsN/6lrxsiyWvsKQbRK3LVBq4iNWS9Z3PGs8TVu7fbD5I11cy+GS90W8
	 4QX1KCyJ9HJGECE88eMfUyvD4ZGQyw9Ius+UbQ4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ram Tummala <rtummala@nvidia.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 444/568] mm: fix old/young bit handling in the faulting path
Date: Tue, 30 Jul 2024 17:49:11 +0200
Message-ID: <20240730151657.225555292@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Ram Tummala <rtummala@nvidia.com>

commit 4cd7ba16a0afb36550eed7690e73d3e7a743fa96 upstream.

Commit 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
replaced do_set_pte() with set_pte_range() and that introduced a
regression in the following faulting path of non-anonymous vmas which
caused the PTE for the faulting address to be marked as old instead of
young.

handle_pte_fault()
  do_pte_missing()
    do_fault()
      do_read_fault() || do_cow_fault() || do_shared_fault()
        finish_fault()
          set_pte_range()

The polarity of prefault calculation is incorrect.  This leads to prefault
being incorrectly set for the faulting address.  The following check will
incorrectly mark the PTE old rather than young.  On some architectures
this will cause a double fault to mark it young when the access is
retried.

    if (prefault && arch_wants_old_prefaulted_pte())
        entry = pte_mkold(entry);

On a subsequent fault on the same address, the faulting path will see a
non NULL vmf->pte and instead of reaching the do_pte_missing() path, PTE
will then be correctly marked young in handle_pte_fault() itself.

Due to this bug, performance degradation in the fault handling path will
be observed due to unnecessary double faulting.

Link: https://lkml.kernel.org/r/20240710014539.746200-1-rtummala@nvidia.com
Fixes: 3bd786f76de2 ("mm: convert do_set_pte() to set_pte_range()")
Signed-off-by: Ram Tummala <rtummala@nvidia.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4353,7 +4353,7 @@ void set_pte_range(struct vm_fault *vmf,
 	struct vm_area_struct *vma = vmf->vma;
 	bool uffd_wp = vmf_orig_pte_uffd_wp(vmf);
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool prefault = in_range(vmf->address, addr, nr * PAGE_SIZE);
+	bool prefault = !in_range(vmf->address, addr, nr * PAGE_SIZE);
 	pte_t entry;
 
 	flush_icache_pages(vma, page, nr);


