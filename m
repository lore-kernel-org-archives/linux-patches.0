Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7938B142903;
	Mon, 16 Sep 2024 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488732; cv=none; b=ccyLrVfBnJ9cXdcFdfLHpk0UPrgtkGjPlm/jFoWGmmzMjDozotRtzgWtlqaRPm3gXk1UiwfyiFQbX3b9LWMq1We+cVIuwJTZyDj143PlLQoTkdnd8RC8rxSDL0yuHFOFcJJCg7rpxCITL4jp9H35AChSZJuCed6beoiGa1sLcKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488732; c=relaxed/simple;
	bh=wCJAMPzJT4MMQ6HuEUUdq+7YO2GUHyj/yJrDLBt1hgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0S0M+QZWrEMDEqZoVJSPmJpcH7pWs8SHMZpn+k0+LRI8bHsa/t9/2HlV3Q+ApT0UsCZO3SoT18T0bBE4/Sy6Lgx7X45TTpZfDS9BIqIQ0e+4WgqCTOVsyQilfKmmzx0lnKJaFLm1jVQNwm8smNiqMyO60DAbNHbEIAcBGSDnsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFGK3yvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFGK3yvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B65C4CEC4;
	Mon, 16 Sep 2024 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488732;
	bh=wCJAMPzJT4MMQ6HuEUUdq+7YO2GUHyj/yJrDLBt1hgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFGK3yvf89mIKFTvmQ0oJDxHNMAlfsKJf86kZkCZii1ldnhqw/K6HVNYpQHZ24dPQ
	 P5I+bVgY+PqxK28F3QC6rggy05QInixFI4rcpqAUOa1TaJCsGkdYylatIEOXJWyPtS
	 xvltXnVRbk47AjMPmYX4a3pGXdDMrBWlqnPSTztI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyu Jin <xingyuj@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	John Stultz <jstultz@google.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 6.6 80/91] dma-buf: heaps: Fix off-by-one in CMA heap fault handler
Date: Mon, 16 Sep 2024 13:44:56 +0200
Message-ID: <20240916114227.096883445@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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
 
 	vmf->page = buffer->pages[vmf->pgoff];


