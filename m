Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931843C65F2;
	Tue, 16 Jun 2026 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632047; cv=none; b=jCvba3FSyFXwD2BQ3fqrNoj5Q4DGbv2DsSlaTlb+lUaMRnCJfHL7N1EQficq0VDlgYDUoaUMRcBIr7BBimE8/UBpVnLgeoQT4mqm57MWBEwhtW+HjmHM2a5ROj120ynRnWpt/DVAdQAGV8l3z9lk4J7Dxfol+fptGphE9j8M8ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632047; c=relaxed/simple;
	bh=eB0j97HsykKXEVeKMQo/G9C9irygeyP7Wi6/UV8tvg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOtIDfIpF4BkpNB5tU/N0TRdErNKNcvEs8PbjUzVi2nTDUXcFGdh6T0D7bgqKpzYU1Kq5JMMEq5zHFAD2+ygR007LR2kmq8PQxfzJN512MSx/DT/ic0XZmhe9SLKT7YBeS+6c/cY7j1F013TPajv5wFjiECSWkL1NGZkTCtwcN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0Apaaz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0Apaaz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F32B1F000E9;
	Tue, 16 Jun 2026 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632046;
	bh=VbhUrvk3212T2wP184Rk0iSC6UOpjJSq5n0VFrkc0WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0Apaaz3LXxKRJyqTSpJoM7inbxO8isVda1SdebUaTVDbGm0sE8fVF/of5iOaP8ma
	 CeJU5ZwyminMDgz7C7aCQ6K4dRO7TGXlAIwxXNocTaziPKK8U/SeMuYf4WjkKdmsed
	 5SKfAanXrzEoGpypnVXv29ZHUtX/o3RQbHhliino=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.1 303/522] misc: fastrpc: fix DMA address corruption due to find_vma misuse
Date: Tue, 16 Jun 2026 20:27:30 +0530
Message-ID: <20260616145140.066954232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 464c6ad2aa16e1e1df9d559289199356493d1e00 upstream.

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
---
 drivers/misc/fastrpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -994,7 +994,7 @@ static int fastrpc_get_args(u32 kernel,
 			pages[i].addr = ctx->maps[i]->phys;
 
 			mmap_read_lock(current->mm);
-			vma = find_vma(current->mm, ctx->args[i].ptr);
+			vma = vma_lookup(current->mm, ctx->args[i].ptr);
 			if (vma)
 				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;


