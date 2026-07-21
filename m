Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93F946AA6B;
	Tue, 21 Jul 2026 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648342; cv=none; b=pAm2nTG+dkoZUySjwg2Mmnk8QKWwi2mtuhu3H0SWDr/CHi+uYwwxzwLMnj/uWbAGbtabEsORDaxlNfMUtkI23bNneCMZmotV/3KqICSzuKUKzrRm5xiVBV7GsFSBKEKaEbqyxtVXD97x0U98NLlfUhG99WYlfDygY2bGglcXq8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648342; c=relaxed/simple;
	bh=az/JsmLUDhTuOr8zabjoDUnfBAyXJcWA0HKPQWvsUho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tP4LKEEvIrmGaMqT2/0aOR5bexJz4apzNCXWGcyqIXkzh4Hkef1laH7BM22Vzmex+TE/PoHBB7qeQV5lb6/xcz85Q35ALn1bH+wJY0V0Ux8xDDh1ehOxQgZeKw/qgG0cZzlEaJyoa1Xza3BQggICzuM5z0hC6P++Xkcd0+EtXQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqWJqy9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqWJqy9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBDE1F000E9;
	Tue, 21 Jul 2026 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648341;
	bh=y8x1aeAa1FsZycpmgYl4YWY81JbdlbaBxs/MYojPO3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqWJqy9/2pZGGZyfsOYQeoAzNnCy574FmB0ghmZ03Kf48R2bFq0ibmDzX0POYVMAv
	 ObTcgSdLFWiZwhNSSZhOmGh1cCeTy/fNoLyhH0SeKznqMMzuhvE3+4dxnzfr10hcUu
	 PiiBsMt31A8scdOcLX8TeKvvfmIj++sS2yvQLnkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0162/2077] crypto: ccp - Fix snp_filter_reserved_mem_regions() off-by-one
Date: Tue, 21 Jul 2026 16:57:15 +0200
Message-ID: <20260721152556.507346998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tycho Andersen (AMD) <tycho@kernel.org>

[ Upstream commit 1b864b6cb213bbd7b406e9b2e98c962077f300df ]

Sashiko notes:

> regarding the bounds check in snp_filter_reserved_mem_regions()
> called via walk_iomem_res_desc(): does the check
> if ((range_list->num_elements * 16 + 8) > PAGE_SIZE)
> allow an off-by-one heap buffer overflow?
>
> If range_list->num_elements is 255, 255 * 16 + 8 = 4088, which is <= 4096.
> Writing range->base (8 bytes) fills 4088-4095, but writing range->page_count
> (4 bytes) would write to 4096-4099, overflowing the kzalloc-allocated
> PAGE_SIZE buffer.

Fix this by accounting for the entry about to be written to, in addition to
the entries that are already allocated.

Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7c4dd57fabb91e..b0290f8491f59a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1328,10 +1328,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	size_t size;
 
 	/*
-	 * Ensure the list of HV_FIXED pages that will be passed to firmware
-	 * do not exceed the page-sized argument buffer.
+	 * Ensure the list of HV_FIXED pages passed to the firmware including
+	 * the one about to be written to do not exceed the page-sized argument
+	 * buffer.
 	 */
-	if ((range_list->num_elements * sizeof(struct sev_data_range) +
+	if (((range_list->num_elements + 1) * sizeof(struct sev_data_range) +
 	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
 		return -E2BIG;
 
-- 
2.53.0



