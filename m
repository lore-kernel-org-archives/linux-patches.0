Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310C6346AC6;
	Tue, 17 Mar 2026 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766603; cv=none; b=g3oPNPXOdvPfEmpgw94Mc2rHvHPAhRLBhn8cD9BiEZ4z9jsO/PD3SdNvNWJmrfflM45Xifu4KXLw/kCwgypZl6l+GQYyOka9EcfZfqHqbxBlYoyfSyq+4I048emjag8PWZrZlmzsHYhyXCaPO6FN93WrbIL3JbBuHstt/YulIgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766603; c=relaxed/simple;
	bh=tSkNcYw8hpTLyttWmXgWtJ/TcOhp+CfUYwVfT2ev5PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5okcAJf9OlnCIlnhqJ4mmnnoSd4oOP/VeOqV/fWGIl47WhsuMkb7VBNz84jCHXkapoJcKoyRbEliFbhHl4uKPQGd0ol++O2ldBfWt4q68JQo010AwG8RbJdURIpDhFzfNF0YCd74dOkLg8vN987UkKXJqBhq4+qS6cBg6CkDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXxdi4/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXxdi4/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E92C4CEF7;
	Tue, 17 Mar 2026 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766602;
	bh=tSkNcYw8hpTLyttWmXgWtJ/TcOhp+CfUYwVfT2ev5PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXxdi4/0PhEaKfdJMKZQ+kZIgfFhmLCjcfF6+e69Ut46JNJB8vldQEosCKQk7dsDj
	 EKJk+TEkULlcvWFf1nJAWJHbh16fvWFO3qIYkgOukOh2llV1QmQ2K56SvouXvwJJJn
	 CghkUJr3Sw/CGewF98ly364Q0AdchZEDyPSHzHyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.19 282/378] crypto: ccp - allow callers to use HV-Fixed page API when SEV is disabled
Date: Tue, 17 Mar 2026 17:33:59 +0100
Message-ID: <20260317163017.379604587@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1105,15 +1105,12 @@ struct page *snp_alloc_hv_fixed_pages(un
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
@@ -1126,7 +1123,8 @@ struct page *snp_alloc_hv_fixed_pages(un
 	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
 	 * page state, fail if SNP is already initialized.
 	 */
-	if (sev->snp_initialized)
+	if (psp_master->sev_data &&
+	    ((struct sev_device *)psp_master->sev_data)->snp_initialized)
 		return NULL;
 
 	/* Re-use freed pages that match the request */
@@ -1162,7 +1160,7 @@ void snp_free_hv_fixed_pages(struct page
 	struct psp_device *psp_master = psp_get_master_device();
 	struct snp_hv_fixed_pages_entry *entry, *nentry;
 
-	if (!psp_master || !psp_master->sev_data)
+	if (!psp_master)
 		return;
 
 	/*


