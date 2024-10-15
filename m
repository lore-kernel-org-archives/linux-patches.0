Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A1A1C07C2;
	Tue, 15 Oct 2024 12:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997037; cv=none; b=IEFaE96vWgtIDlZnT1H+ynRLPXOhUuvQDCod28cRVfIrIpTs8DB473VGzmz1qNKwSZ+IvzsHkBYyf6zxFM5q83Ctyh7j6yv+VSdq/PChyxQzVnje+5+J9chpOvbMtA5T8K88gR0/UfvCH/iCrrQuWsO0iVVUumu3SAAPdsP0cuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997037; c=relaxed/simple;
	bh=fX0mq54fhcIKE7VXr79FR/ZY6gjEDReVd/FAVuBOtS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvXjNBtL0Ceprat3ABOmHxLcWRK6G5JK1zFEMrwy0hN5n08TVinBurhitgfs0WXcranL5yYVsT2gYKkSlcL/oEaJh/2MyLA7VtT6cDiQG/f0agarUYpRQxUchWORdhx+zYSPkgUaT7yBChmceHXNEiyfZ3o0Qy7m4kBFnOFI2TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrHiqlQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrHiqlQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C557C4CEC6;
	Tue, 15 Oct 2024 12:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997036;
	bh=fX0mq54fhcIKE7VXr79FR/ZY6gjEDReVd/FAVuBOtS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrHiqlQZ63lNqbVJ80g0bh/CiOOvAcIIiLd7txjTy1HtSh5+AGvHELQ4y4iA+9s6c
	 ubGN3Fd+4RtUaGzZhqgeMt0XM/wlJ9i5XX+5MLWQZN7Sa+07h1cbC9jadF4IHrPJEJ
	 JdfzPlSSQuLMRonXM+ip8KoPnuYwc9g7aSfXqpPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	John Stultz <jstultz@google.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 5.10 028/518] dma-buf: heaps: Fix off-by-one in CMA heap fault handler
Date: Tue, 15 Oct 2024 14:38:52 +0200
Message-ID: <20241015123918.092767297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

commit ea5ff5d351b520524019f7ff7f9ce418de2dad87 upstream.

Until VM_DONTEXPAND was added in commit 1c1914d6e8c6 ("dma-buf: heaps:
Don't track CMA dma-buf pages under RssFile") it was possible to obtain
a mapping larger than the buffer size via mremap and bypass the overflow
check in dma_buf_mmap_internal. When using such a mapping to attempt to
fault past the end of the buffer, the CMA heap fault handler also checks
the fault offset against the buffer size, but gets the boundary wrong by
1. Fix the boundary check so that we don't read off the end of the pages
array and insert an arbitrary page in the mapping.

Reported-by: Xingyu Jin <xingyuj@google.com>
Fixes: a5d2d29e24be ("dma-buf: heaps: Move heap-helper logic into the cma_heap implementation")
Cc: stable@vger.kernel.org # Applicable >= 5.10. Needs adjustments only for 5.10.
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Acked-by: John Stultz <jstultz@google.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240830192627.2546033-1-tjmercier@google.com
[ TJ: Backport to 5.10. On this kernel the bug is located in
  dma_heap_vm_fault which is used by both the CMA and system heaps. ]
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/heaps/heap-helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/heaps/heap-helpers.c
+++ b/drivers/dma-buf/heaps/heap-helpers.c
@@ -161,7 +161,7 @@ static vm_fault_t dma_heap_vm_fault(stru
 	struct vm_area_struct *vma = vmf->vma;
 	struct heap_helper_buffer *buffer = vma->vm_private_data;
 
-	if (vmf->pgoff > buffer->pagecount)
+	if (vmf->pgoff >= buffer->pagecount)
 		return VM_FAULT_SIGBUS;
 
 	vmf->page = buffer->pages[vmf->pgoff];


