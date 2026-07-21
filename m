Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C34C46EC75;
	Tue, 21 Jul 2026 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661631; cv=none; b=VhyVXj0OSerJk2jlOTTrUiAE14PPeQMI8+PhTtKNDL1093P185X/XuSB7n/+07D+y2PgSIIT2juo4aaR1BfjkQczwTR/aSzw4ne8H586SW+h5cetKKhMCoNwL3LVNv1RQAtpRTxnSPy7qkSH+UPwt/xg3FTs+T8DXKBI/6iojDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661631; c=relaxed/simple;
	bh=K7/GJajnyLw02TsgMtpK3eflpgE2g/JD9uWlJ6aECqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKbg5GPewY7k1D9uIB25a8Fvjzx5ADsraj8Qwfr1bGkrjpLLI6iw+YeLC9U47lwjR4OzEnyM3blSWfMX7a6I6i8OCUECbqMdXB98Qx40KVdjL2jKg4DZAjtewsEFlI/wOZEARw/sP+faBH1aQcEaB5grEvDj479/+QLu4KEpjaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSfxbo6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSfxbo6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC13D1F000E9;
	Tue, 21 Jul 2026 19:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661630;
	bh=C5LQAWC7QJepXxcYk64Qi5W2SjIipBhisttlHcEe9dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSfxbo6hyAe2aha/91DWGpdNgAtx8G12kTd+e92wZheCXjhEAGhuHyBytZPKiaCqL
	 ZDldjBdVMtOv3NrQT8S/9bvxOZfCmkRmGly07R7ol6NyLt8mYBMXMw/KvCyXx8+8x1
	 7JebxdKAAZSgvX/h3KonTra0IVwb8Np/49wnwonM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0096/1276] crypto: ccp - Fix snp_filter_reserved_mem_regions() off-by-one
Date: Tue, 21 Jul 2026 17:08:59 +0200
Message-ID: <20260721152448.242848512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 2258337f1ea44b..106a59c3794bfd 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1066,10 +1066,11 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
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



