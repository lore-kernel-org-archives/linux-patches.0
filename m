Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB414369A;
	Wed, 25 Feb 2026 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982919; cv=none; b=hGtM8+FWLKP69jRG15k1yQqd7zvY3YoUcaVTgoXzte5PNZJJtA4W54e1IVcJtgcj/l6p5IV2bny1WVyjKE1jLJ7ljcFbV0fii0PNk24USoJjMxu6yQCTm95TF47pGbiOI3w0fRxbGs0Cip9VuwTgmwAuUDP1W+7FeRTCRJ7Nni0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982919; c=relaxed/simple;
	bh=qruMBNUhG7K57Z2jL8k9AYXwot7lr7tmdX2EyqoO708=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fn6SRtO9cjF7D77TKVQqPfPiN0H8o8jSL7UL9I307Ei0n9tnJ95to4OwBAMob3BmOFONbyG87iCP06dZt6BndVeMzqLjcOx30Se2xKCxA5LkEl5ovfHG9++zwNvkIIn1PoAghWuO9U9hYPgmJNgG1VGx7879S/Jf6G+9rngqkJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOXSYqsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOXSYqsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA27FC116D0;
	Wed, 25 Feb 2026 01:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982918;
	bh=qruMBNUhG7K57Z2jL8k9AYXwot7lr7tmdX2EyqoO708=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOXSYqsYYmO9AjcuD576TRLi0JMrXRaKUd7RFG/COERsu0OfYCe8qngVv9NUT68Yj
	 w8ubM9sTy3YGku+ci+M2tjFdyQUoqIEeOZ672uJZwayiZox3PrwUmissFU7cf5irE9
	 bZlJ831j9joFF2Nz/VxWnStIRH9C1Jrvnhfuevls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 098/781] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
Date: Tue, 24 Feb 2026 17:13:27 -0800
Message-ID: <20260225012402.092557986@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 551120148b67e04527b405c5ec33a31593846ba4 ]

If page reclaim fails in sev_ioctl_do_snp_platform_status() and SNP was
moved from UNINIT to INIT for the function, SNP is not moved back to
UNINIT state. Additionally, SNP is not required to be initialized in order
to execute the SNP_PLATFORM_STATUS command, so don't attempt to move to
INIT state and let SNP_PLATFORM_STATUS report the status as is.

Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 46 ++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 956ea609d0cce..6e6011e363e3b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2378,11 +2378,10 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	bool shutdown_required = false;
 	struct sev_data_snp_addr buf;
 	struct page *status_page;
-	int ret, error;
 	void *data;
+	int ret;
 
 	if (!argp->data)
 		return -EINVAL;
@@ -2393,31 +2392,35 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
 	data = page_address(status_page);
 
-	if (!sev->snp_initialized) {
-		ret = snp_move_to_init_state(argp, &shutdown_required);
-		if (ret)
-			goto cleanup;
-	}
-
 	/*
-	 * Firmware expects status page to be in firmware-owned state, otherwise
-	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
+	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
+	 * when SNP has been initialized, the status page must be firmware-owned.
 	 */
-	if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
-		ret = -EFAULT;
-		goto cleanup;
+	if (sev->snp_initialized) {
+		/*
+		 * Firmware expects the status page to be in Firmware state,
+		 * otherwise it will report an error INVALID_PAGE_STATE.
+		 */
+		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
+			ret = -EFAULT;
+			goto cleanup;
+		}
 	}
 
 	buf.address = __psp_pa(data);
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
 
-	/*
-	 * Status page will be transitioned to Reclaim state upon success, or
-	 * left in Firmware state in failure. Use snp_reclaim_pages() to
-	 * transition either case back to Hypervisor-owned state.
-	 */
-	if (snp_reclaim_pages(__pa(data), 1, true))
-		return -EFAULT;
+	if (sev->snp_initialized) {
+		/*
+		 * The status page will be in Reclaim state on success, or left
+		 * in Firmware state on failure. Use snp_reclaim_pages() to
+		 * transition either case back to Hypervisor-owned state.
+		 */
+		if (snp_reclaim_pages(__pa(data), 1, true)) {
+			snp_leak_pages(__page_to_pfn(status_page), 1);
+			return -EFAULT;
+		}
+	}
 
 	if (ret)
 		goto cleanup;
@@ -2427,9 +2430,6 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		ret = -EFAULT;
 
 cleanup:
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
 	__free_pages(status_page, 0);
 	return ret;
 }
-- 
2.51.0



