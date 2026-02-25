Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7250279DB3;
	Wed, 25 Feb 2026 01:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983836; cv=none; b=JD7J1t2x5U+Bsjtw/XeMsUp5hcnEkk9pUdjxY6b9y3nAVT8ETORbaB0HqP8uRSfFZ773+9WRuX9+GhYyYIxtAXxJ5dKmSoF/wcTQ3DHBS+UK29r1eq3OFl0Q5XI/mN0PbsA8BoZAvIJZkIYBiW3z9Z5RLrcWK/MM8TiE+T5qD5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983836; c=relaxed/simple;
	bh=Nj8YMcytXTp6sp3HzDR4Z5G8XQOnWiu9obFtk6EpfnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaD+LD9+H5weMKTzh3F+UTxdceNMSOsz40aJL5HhiX3mcyTj37uMbpup83mNXCX0+Dsvy7MpyAEnJlbs70JWQSK9NSvHMVpXLDkIwRP/J5Vx9ARf5ipA5rSc/8ubVZh4fhUfff3XHptrqkJK1DynHkcBMhKLp3f51OdWHhfTC4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUs781aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUs781aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D49CC116D0;
	Wed, 25 Feb 2026 01:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983836;
	bh=Nj8YMcytXTp6sp3HzDR4Z5G8XQOnWiu9obFtk6EpfnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUs781aaiTOxHpSb+cCfsExKAVV8kHtR2adI2YWX03wv1HGVGNAhXwG7IBrSTL0kd
	 g3GOS+MPRW7cfWGcZUVbRTPjXVH355EenSrkOQI4zMJIOPL2sfLojNcd/MQ49/sTbM
	 81O5wOd0b3jtAmmLaBc1gehXRDZvB+SZTSfmQW74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/641] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
Date: Tue, 24 Feb 2026 17:16:55 -0800
Message-ID: <20260225012351.255405826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 0d13d47c164bb..3c6ee8b4e4487 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2351,11 +2351,10 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
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
@@ -2366,31 +2365,35 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 
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
@@ -2400,9 +2403,6 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
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



