Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE9544BCBE;
	Tue, 16 Jun 2026 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624185; cv=none; b=IaVLNnFxXMvjteyf612olzLlhPHBGr/KvYCgKMYrH3hsiednopAz99GeVDNyMOnICiB3raEs+1Hj1Mu3dfp56Ssq67k9/mPLiC5UnEkCGWetKIuKc/5YPiiDTax5YnMYOuFGRyb6bTImGtEvty1OPodAxuqTyPLntPhGxiWZNjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624185; c=relaxed/simple;
	bh=N5GfS5MoxKMppC+zOetQGGBm1SfrOSgTBUhpdSxuuek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjViVTy1I+x8glKSEVOwHmpFBiX5561Vm8TZB7229js1d9f84fTX7AV7g6HGDxafoBjkto3M1+gO3FPiCL/XXZTQ91nlL+3tHFBM3SMr3d/vUn0PyT40yNORvcdWnvyVsUdZpIncCF5J6Z3NlFSRM1tqDtn8k6ckPh4If3VNuiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osxMTrN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osxMTrN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D2B1F000E9;
	Tue, 16 Jun 2026 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624183;
	bh=n4CfhnNKpW0MamUTgTSCVHxkBXDJDubqexnqIDpV1cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osxMTrN2gjiV+s0yQDYM7SVtwIhaqZbetKuLkiSkzpHbVY0xKIP4CBtxgzZBrUhdV
	 bpNL1g6LDTIOv/+DsZ5geeAsnIIm568vfSbNJJUswMpD7oOkVveD1Q0fzCXjNB9Bte
	 2S8choGJhrCUz+/e6eNvSVpmjWIjARu8+x6ePbiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 288/378] net: airoha: Add NULL check for of_reserved_mem_lookup() in airoha_qdma_init_hfwd_queues()
Date: Tue, 16 Jun 2026 20:28:39 +0530
Message-ID: <20260616145125.239968123@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhaoJinming <zhaojinming@uniontech.com>

commit f9f25118faa4dd2b6e3d14a03d123bbdbd59925d upstream.

of_reserved_mem_lookup() may return NULL if the reserved memory region
referenced by the "memory-region" phandle is not found in the reserved
memory table (e.g. due to a misconfigured DTS or a removed
memory-region node).  The current code dereferences the returned
pointer without checking for NULL, leading to a kernel NULL pointer
dereference at the following lines:

    dma_addr = rmem->base;                          // line 1156
    num_desc = div_u64(rmem->size, buf_size);       // line 1160

Add a NULL check after of_reserved_mem_lookup() and return -ENODEV if
the lookup fails, which is consistent with the existing error handling
for of_parse_phandle() failure in the same code block.

Fixes: 3a1ce9e3d01b ("net: airoha: Add the capability to allocate hwfd buffers via reserved-memory")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1153,6 +1153,9 @@ static int airoha_qdma_init_hfwd_queues(
 
 		rmem = of_reserved_mem_lookup(np);
 		of_node_put(np);
+		if (!rmem)
+			return -ENODEV;
+
 		dma_addr = rmem->base;
 		/* Compute the number of hw descriptors according to the
 		 * reserved memory size and the payload buffer size


