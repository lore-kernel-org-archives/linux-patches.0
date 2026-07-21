Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44D7432E9C;
	Tue, 21 Jul 2026 20:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664502; cv=none; b=ITsS0mUUHehoGKGltwsq6lJ4dQUvL1dKURFlMbW1kaK/WsZPB7SkMcQk4GGeD3NAJVoIqgEVrihR1Wm+Hcc8HUenhyfgl1o915Md+v516pqDAy0sLn565SwNp077rNQiQkoG0J+ExV8G2wJc9vQ8FfMG46NcebKXnZ44WQtWjIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664502; c=relaxed/simple;
	bh=tkXyJGFRa7Ux56y8rX8Y37uRvjHIVIpgFiXqcxxNEmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYdAWR3qCFJ8vhRcmnWbmkmKnEciv2rZFbvbLovO0oUH+HtOSj6GFlrDRob+WAZg8vLahPl50gB7E7zWr08rWLw+VSpGnjz256DxOn3uT+339Rc31/QR60JDNr6OMpF7G1qDlkETcwgJUiZLxov2h2ewLqRdMtKZlqouYYI0JHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKGIFrbj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKGIFrbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442D01F00ADE;
	Tue, 21 Jul 2026 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664498;
	bh=K486Wdrup9iSbjzZTcxkUZPAKWAXuHXXbiX57ZEuqDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YKGIFrbjLs5g6hTAOplytNqHz8YpnTVFKMmnMFxpWvVUFACdsQzKWWPyZwauRrA19
	 f0l6c++VNOTcfyUSyHCyZFDC8WEoahzzHkP11ZU+nl34W3zt7OCq+nUcKqSrF1HtzB
	 fYPth5hWF2Pg/WSxpcL5ydWqeyYcD//AexYgJGY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1223/1276] crypto: ccp - Fix a case where SNP_SHUTDOWN is missed
Date: Tue, 21 Jul 2026 17:27:46 +0200
Message-ID: <20260721152513.446874168@linuxfoundation.org>
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
Stable-dep-of: 08f0e65e784c ("crypto: ccp - Do not initialize SNP for ioctl(SNP_CONFIG)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   46 +++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2071,11 +2071,10 @@ e_free_pdh:
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
@@ -2086,31 +2085,35 @@ static int sev_ioctl_do_snp_platform_sta
 
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
@@ -2120,9 +2123,6 @@ static int sev_ioctl_do_snp_platform_sta
 		ret = -EFAULT;
 
 cleanup:
-	if (shutdown_required)
-		__sev_snp_shutdown_locked(&error, false);
-
 	__free_pages(status_page, 0);
 	return ret;
 }


