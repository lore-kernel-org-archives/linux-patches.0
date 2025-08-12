Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5CD2CA9;
	Tue, 12 Aug 2025 18:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025132; cv=none; b=F29ZnYOmyTl3oqdSiAzSF+pSSckdD8ta8GPZGWoNPMkAxLWhYOLFNE2Xt6EnR15b+vqs3mcwvjh4d0y54KlhtDaxjKyY0Owg8q4e+TyxLOe7pESZaL8xNZ3usI5uv2lBQtLU34RRfDmLI9/oNDdy7ClmijHUjYiH7pc2CF1nldQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025132; c=relaxed/simple;
	bh=qL4W/rtBFS7AN4y8Bg1AgbKFOBmEsP77Fe+4vOvyn+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxsomG/CZE86CWWRO0Bup2J3GYbONKzM4UoHaJEKJExOQVa79uDv2o4m89ixZtPure3ebwVoS5pPL1l4gmMbqYPuA5fXJ0BrKiVfXLT+H34UHiIfSDIam7nD4k4sJeS48QkfSsdD9KrttapqXc91o8nyyJkiol87JL5qcAQunbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SSyDdUWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SSyDdUWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68078C4CEF0;
	Tue, 12 Aug 2025 18:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025131;
	bh=qL4W/rtBFS7AN4y8Bg1AgbKFOBmEsP77Fe+4vOvyn+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SSyDdUWx7V4lJdQYMibuXFs2m8MpcKS5pTo5rcX0PquCYRM/U/rAsk/rPDHLefSBs
	 pu/hwjsFob/02/8uM01hGOSBVTUy101K4VNyOTM9uN+WDYytMmx9hJZutrelES02N2
	 lmB25k0wQ7BVeiEZEH3/mJan2ksqPo3ynt8FZymw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 6.16 579/627] perf/core: Handle buffer mapping fail correctly in perf_mmap()
Date: Tue, 12 Aug 2025 19:34:34 +0200
Message-ID: <20250812173453.896888821@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit f74b9f4ba63ffdf597aaaa6cad7e284cb8e04820 upstream.

After successful allocation of a buffer or a successful attachment to an
existing buffer perf_mmap() tries to map the buffer read only into the page
table. If that fails, the already set up page table entries are zapped, but
the other perf specific side effects of that failure are not handled.  The
calling code just cleans up the VMA and does not invoke perf_mmap_close().

This leaks reference counts, corrupts user->vm accounting and also results
in an unbalanced invocation of event::event_mapped().

Cure this by moving the event::event_mapped() invocation before the
map_range() call so that on map_range() failure perf_mmap_close() can be
invoked without causing an unbalanced event::event_unmapped() call.

perf_mmap_close() undoes the reference counts and eventually frees buffers.

Fixes: b709eb872e19 ("perf/core: map pages in advance")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7148,12 +7148,20 @@ aux_unlock:
 	vm_flags_set(vma, VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &perf_mmap_vmops;
 
-	ret = map_range(rb, vma);
-
 	mapped = get_mapped(event, event_mapped);
 	if (mapped)
 		mapped(event, vma->vm_mm);
 
+	/*
+	 * Try to map it into the page table. On fail, invoke
+	 * perf_mmap_close() to undo the above, as the callsite expects
+	 * full cleanup in this case and therefore does not invoke
+	 * vmops::close().
+	 */
+	ret = map_range(rb, vma);
+	if (ret)
+		perf_mmap_close(vma);
+
 	return ret;
 }
 


