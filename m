Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF161A76AB;
	Tue, 30 Jul 2024 17:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360421; cv=none; b=qkjQWZTntjp5f3B9CtfBFyJpo9anzNtnxJ/EGQdwVz0udweaOq7zUp10UWOWA6e79YaLl9MZS31URYAWSr+ZJHo8LPU1yTC/oUO0sPdqbCMevoGcR5qQLsU+xYYcmWCfIqSedoecZtVcenRyD0mWmVfkD+FCuOaNsQIaDUudajU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360421; c=relaxed/simple;
	bh=f/ZQD4tj4LLD21zwCpV9aryLw8tjwdqwQpIcz2s8Rhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2zJok2DlUaTJS2UYndpet9WTigH03j88NqZEiW7q2LpYgWGwIRGHO/h1gST2KGhwNJVjlpYAd3QoWRmYCFj9jjgzvJo+zSJFVHWsUEjI4Ugpw7Kvu0IIWJ/gj59ZboAf98ctlypw8bpzPkQ+y0Eyj6IjAnlD1O6i4/ck5Buito=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kh+VW6Rt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kh+VW6Rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649DCC4AF0C;
	Tue, 30 Jul 2024 17:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360420;
	bh=f/ZQD4tj4LLD21zwCpV9aryLw8tjwdqwQpIcz2s8Rhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kh+VW6RtR0ZwKE/M4PPsHNQhKYcDz6T8lydGjjNBod1yS7xvayFjmi9latbV/d9e4
	 CWbet1klNPERY8hvGqX/UkqVQ/AHLSOx5kEjVdGLr4RQ8/e5xvceeVL0dmgDTVBUSl
	 UgHxNQd2GDg5xk6yrTzvA+yKKrSYzGjhHleFzxJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ram Tummala <rtummala@nvidia.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 663/809] mm: fix old/young bit handling in the faulting path
Date: Tue, 30 Jul 2024 17:48:59 +0200
Message-ID: <20240730151751.088384681@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4681,7 +4681,7 @@ void set_pte_range(struct vm_fault *vmf,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool prefault = in_range(vmf->address, addr, nr * PAGE_SIZE);
+	bool prefault = !in_range(vmf->address, addr, nr * PAGE_SIZE);
 	pte_t entry;
 
 	flush_icache_pages(vma, page, nr);


