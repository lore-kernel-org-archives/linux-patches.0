Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868D4779B8;
	Tue, 16 Jun 2026 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627711; cv=none; b=Up8gJPlyOyQWqXpMjH6BKNNif5uvFh4PH6EgcQfcirYns6B+27uAAi3lCjzg7aHrVpaFaASAk7T9zIFEXBPAPj3a4Ej7rHk53WtCeryTdI2HAcKLyj8Gf5b6JWy7g0ShSLNseF+SIcxL+yzDESQdL/aQRaau1Xb6x69tgqHIOQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627711; c=relaxed/simple;
	bh=XW+GMvGv7dQN+MR7h7PykbUc+IRb/HGWlFo7I+Tm4rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbgdXj8SH0aPZJI8pvzvIQZfuKQ0KhRCpkDsMU/toitpuWDx22w6zvyx56cbfrkaQBrKrLtFk+1q/y7ni4vECM0lYoS+c6S3LTESj5RIVxIMaiLoKNvZzmOui4AXYi453UMNSVdy5QVB4G/UuIB30SCIG2P5spfS93jQ8PVV7wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNXODQsg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNXODQsg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21031F000E9;
	Tue, 16 Jun 2026 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627710;
	bh=pCdVecW8JFhBL6d8vPbZ+kD2mTBfHJmCEier+FFgykY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fNXODQsgxcOukzXTKhkLfXd8ZHNZvN9h1WOP9TGKBBGO5/r8O4HBHqXXAz/o67LBJ
	 axRiRWmPO5xdqTmwvfLliJ/BeEdWKMYYgywMbn0te4vxXxfGK0/qXOmqtjtfQrOXCB
	 Kpk57SR1l5A18cPATPIpnrr3YX4S0fmyPQVBpaMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 180/261] misc: fastrpc: fix DMA address corruption due to find_vma misuse
Date: Tue, 16 Jun 2026 20:30:18 +0530
Message-ID: <20260616145053.414416275@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1061,7 +1061,7 @@ static int fastrpc_get_args(u32 kernel,
 			pages[i].addr = ctx->maps[i]->phys;
 
 			mmap_read_lock(current->mm);
-			vma = find_vma(current->mm, ctx->args[i].ptr);
+			vma = vma_lookup(current->mm, ctx->args[i].ptr);
 			if (vma)
 				pages[i].addr += (ctx->args[i].ptr & PAGE_MASK) -
 						 vma->vm_start;


