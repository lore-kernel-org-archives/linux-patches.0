Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9064A2EF67A;
	Tue, 17 Mar 2026 17:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768118; cv=none; b=Z87y7Mn/jg7I2Y7TVsUk1VNsmlnAx9QJRuFsOByBrqTBlVYup/q/ok5fbcEHY7dVKNWqqDqYyT9/nJfzI/BxgZy4EXZY1rdMauvg2efOizWJcjLWNQqQ9cD2rWvghDjhuntsKdNNluaMeoo2GpMeu8B0OyQNvk5csiuVP/wbcyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768118; c=relaxed/simple;
	bh=2BYqbc/WC6mktt16zcLqYzx3ZjIev7ue8qjzSgWDcwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEH5Wx8r8EQW9OGHC1Htr3LeqVUCVvUokhODi7iRn2y0MzoBK39Wq85soqzgRHdxHhmu3VOe68gMhJvt4BO+yvw+xQW4Xr9ky1l7yzpIANSbHPhkcq1Djavvin3ehTp5l8NrvFef6lpl+0mviCqoKDoknYgCjK9HgnWWRI14glY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTdCjXrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTdCjXrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DB9C4CEF7;
	Tue, 17 Mar 2026 17:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768118;
	bh=2BYqbc/WC6mktt16zcLqYzx3ZjIev7ue8qjzSgWDcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTdCjXrfO+EM0nBKjt+I/66am675sWUmDSB3pN1Ys8Yhbqu8MHU3Pevom4iLAt/C+
	 FpLjUeSBMvuKiMJaDfXpx5bu61prM6k5it2bA+fywVPboqwhHNow04Vl1g5gJ0e4sf
	 LMg0wtJc594KZfWDi+w2BJqC8ScXM5zLJUoJ8J+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.18 234/333] crypto: ccp - allow callers to use HV-Fixed page API when SEV is disabled
Date: Tue, 17 Mar 2026 17:34:23 +0100
Message-ID: <20260317163008.042841633@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

commit 8168a7b72bdee3790b126f63bd30306759206b15 upstream.

When SEV is disabled, the HV-Fixed page allocation call fails, which in
turn causes SFS initialization to fail.

Fix the HV-Fixed API so callers (for example, SFS) can use it even when
SEV is disabled by performing normal page allocation and freeing.

Fixes: e09701dcdd9c ("crypto: ccp - Add new HV-Fixed page allocation/free API")
Cc: stable@vger.kernel.org
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1109,15 +1109,12 @@ struct page *snp_alloc_hv_fixed_pages(un
 {
 	struct psp_device *psp_master = psp_get_master_device();
 	struct snp_hv_fixed_pages_entry *entry;
-	struct sev_device *sev;
 	unsigned int order;
 	struct page *page;
 
-	if (!psp_master || !psp_master->sev_data)
+	if (!psp_master)
 		return NULL;
 
-	sev = psp_master->sev_data;
-
 	order = get_order(PMD_SIZE * num_2mb_pages);
 
 	/*
@@ -1130,7 +1127,8 @@ struct page *snp_alloc_hv_fixed_pages(un
 	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
 	 * page state, fail if SNP is already initialized.
 	 */
-	if (sev->snp_initialized)
+	if (psp_master->sev_data &&
+	    ((struct sev_device *)psp_master->sev_data)->snp_initialized)
 		return NULL;
 
 	/* Re-use freed pages that match the request */
@@ -1166,7 +1164,7 @@ void snp_free_hv_fixed_pages(struct page
 	struct psp_device *psp_master = psp_get_master_device();
 	struct snp_hv_fixed_pages_entry *entry, *nentry;
 
-	if (!psp_master || !psp_master->sev_data)
+	if (!psp_master)
 		return;
 
 	/*


