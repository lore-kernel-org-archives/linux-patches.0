Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFCC1553AB;
	Mon, 16 Sep 2024 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488478; cv=none; b=l36MVPS2e1IWiEMJimIiN1v+3KGdKGRGEA3IL18z8BG3hXOWl3vg78Es/0UTRcyZ3EeH92VJT9ecTLHrGEHH7CetZzzrSRWvS9cHpOFu7TLI2bGhn/LwL/apH59i+PxelKUNtCIVzwaCjrcEejZuHJOIVw/LdipSKq98bKHsnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488478; c=relaxed/simple;
	bh=+6xfKA1VoTD3ZYFeSB+OhCOLV1+1qETpkG5pW2WNADg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSBhR0t8QTtqSlFHncuOMkNFaAa+6wjP8NIly6lbsEg+VXtJFaV9acq36RlA4Bh+jw2uFzzapC+dwkTOh8secLH816dGQY506b4eVaY3+NwvH0dJKqG4LEXV957wVLaBilmYjdODKY91N+qc36NxBheWXNXndMNbA3qIvztLUDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMtX/sU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMtX/sU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D59C4CEC4;
	Mon, 16 Sep 2024 12:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488478;
	bh=+6xfKA1VoTD3ZYFeSB+OhCOLV1+1qETpkG5pW2WNADg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMtX/sU/cHoSCR3tlYmQ9pJbQLy9UvHwQOeqYImYDg/HcSLbH+CKYKZkD1Ms7DBa5
	 5+Q7JWetdsPdCEninDNbdrbHuJh/JOUyWLq8VgEzcCxIfvHjN6cjBGxzIi7ddx7luI
	 Fn39de5J08EpwQV96R8gcZjJ/JDfN1+3if9H/bPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	John Stultz <jstultz@google.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 6.10 101/121] dma-buf: heaps: Fix off-by-one in CMA heap fault handler
Date: Mon, 16 Sep 2024 13:44:35 +0200
Message-ID: <20240916114232.461267494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/heaps/cma_heap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -165,7 +165,7 @@ static vm_fault_t cma_heap_vm_fault(stru
 	struct vm_area_struct *vma = vmf->vma;
 	struct cma_heap_buffer *buffer = vma->vm_private_data;
 
-	if (vmf->pgoff > buffer->pagecount)
+	if (vmf->pgoff >= buffer->pagecount)
 		return VM_FAULT_SIGBUS;
 
 	return vmf_insert_pfn(vma, vmf->address, page_to_pfn(buffer->pages[vmf->pgoff]));


