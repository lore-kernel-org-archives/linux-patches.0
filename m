Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5452B381E96;
	Thu,  2 Jul 2026 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009572; cv=none; b=uPDYLHF4vx0mGg/+27Z24gF8SRMbTmmTuO0VuG9FyJSrWlgConRFX8iBwPf9vku96uBuW36V1907owmPIoJW1NoKJoXIkpl3aOzL/0uPCek/mlbGLT8OUgJQ3BsRHK6VPII0fkLAw2DzoN6/Y8d/BnBf2tjNuILYyY5u60F3qXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009572; c=relaxed/simple;
	bh=W5Rf9/9pKdb9E9UWWDCFUoSEozFit4YjodMiwNs8IRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jY9pzLWg7nB2bEfDylROYOcF3A6q9aDRTHhyhv1qVK92JawAkJBrCYA41iJB/ow0dP+WJC/+p4c5dD0Ve3xVdyy61/s1hkQd5WcBKxiqjESD53ptHTr7u8UcZEgClO9iRfap2bDmpiD9s4w27q57fDQLNCzQaxNU9w+oT83u6L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVGeefwA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVGeefwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7236B1F00A3A;
	Thu,  2 Jul 2026 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009570;
	bh=uzfo1sddjAw2kZMnx3oi8AHjI0qF7ySqg/jlkkHBRFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVGeefwAOLekmVQOGFKVAMYwNNvUN+siuRpu11RXa9VDyQz0IIIYf+Mau3vCQC7sl
	 AyMouDX/dMbyj2gk9VR+ba4LyFNL3goC0gquBcB4sJWuYwA7U6k6sUiPAi22dcEGME
	 BDW1ttkt0yDZv3frypW1bXGZy4JtbCdjLGINqyas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 95/96] misc: fastrpc: fix DMA address corruption due to find_vma misuse
Date: Thu,  2 Jul 2026 18:20:27 +0200
Message-ID: <20260702155110.979005426@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 464c6ad2aa16e1e1df9d559289199356493d1e00 ]

fastrpc_get_args() uses find_vma() to look up the VMA for a user-provided
pointer and compute a DMA address offset. When the address falls in a gap
before the returned VMA, (ptr & PAGE_MASK) - vma->vm_start underflows,
corrupting the DMA address sent to the DSP.

Replace find_vma() with vma_lookup(), which returns NULL when the address
is not contained within any VMA.

Cc: stable@vger.kernel.org
Fixes: 80f3afd72bd4 ("misc: fastrpc: consider address offset before sending to DSP")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204528.116920-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adapted `vma_lookup(mm, ptr)` to `find_vma(mm, ptr)` plus a `ptr >= vma->vm_start` guard since `vma_lookup()` does not exist in 5.10 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -875,7 +875,7 @@ static int fastrpc_get_args(u32 kernel,
 
 			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm, ctx->args[i].ptr);
-			if (vma)
+			if (vma && ctx->args[i].ptr >= vma->vm_start)
 				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;
 			mmap_read_unlock(current->mm);


