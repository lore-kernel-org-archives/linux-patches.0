Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DCA235358;
	Sat, 12 Sep 2026 07:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198308; cv=none; b=HeTcrXwIM20UptWUSxVmGdlL+dN/dbDWbmEbEt1cWWY1xDTXUC3jZFVTByEpqOO98i/Irt87b3dhwF+t7Zk5xdMpjqb+44XaR0vwpWqCq3vsZNlmGQBXn2Js5jtanPeTwdmTFA9D+/LUuXSolYNM/XEOWB5UpL95ENPeSXbr25g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198308; c=relaxed/simple;
	bh=0LWOSXqbZ6s8XwhwpGwkG3qi3hz7DMb8tquR9NJSiKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBrj20Rvzou2rSq1TuZBHAcStoNJQyatQlG47Dx1YDo85GkFtbqiYoPRIFGHkQP+xZm2yUfyF0Z11ikoEx4kprUogFQ+MWCtsL8UiILolZSAOp5BtJyMhFISsN1BP2TmJbNNrVu/NKwbwnOzGFW/fn9pO+Da4yAMRx9alypAjzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI8Z7bEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI8Z7bEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A351C1F000FF;
	Sat, 12 Sep 2026 07:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198306;
	bh=kSVLaISLwhucokfacSSSH2HSZgkpME5ns2GquErvEMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qI8Z7bEiEYOz1h/1tFusPuWs2F5AXgiZgjA63DZdswMpHKJsRfh2BA8bbQPumFpLU
	 sYFK6IQU4dcttggnmrtWgkZZaz1iXgd6eHGIWynrWpQGpzxIa6ty51xaN+yMmb578p
	 kMPvHnIRLJryTY6k+6SoNbq6hsd9fLONHLG/4Lhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0352/1815] crypto: ccp - Fix memory leak in SEV INIT_EX path
Date: Sat, 12 Sep 2026 08:35:02 +0200
Message-ID: <20260912065657.175094578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atish Patra <atishp@meta.com>

[ Upstream commit c8e53ada20d352b0f1bdc3e58405a9edab897a2e ]

allocated pages in _init_ext_path are never freed and sev_init_ex_buffer
is left pointing at the leaked memory in case of any failures during the
function..

Fix by adding an error path that frees the pages and clears
sev_init_ex_buffer. Make sure we only free the memory if the failure
happens before the conversion. Otherwise, we may end up trying to free
up converted pages in case of reclaim failure. rmp_mark_pages_firmware
failures should be rare enough to avoid more code complexity to track
down which pages were reclaimed/leaked vs which are not.

Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")

Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 46ea24be22d04..e7db638c25276 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1545,7 +1545,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 	if (sev_init_ex_buffer)
 		return 0;
 
-	page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(NV_LENGTH));
 	if (!page) {
 		dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
 		return -ENOMEM;
@@ -1555,7 +1555,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 
 	rc = sev_read_init_ex_file();
 	if (rc)
-		return rc;
+		goto err_free;
 
 	/* If SEV-SNP is initialized, transition to firmware page. */
 	if (sev->snp_initialized) {
@@ -1564,11 +1564,22 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 		npages = 1UL << get_order(NV_LENGTH);
 		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, true)) {
 			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
-			return -ENOMEM;
+			rc = -ENOMEM;
+			/*
+			 * Pages can be in an inconsistent state, don't release them back to the
+			 * system.
+			 */
+			goto err_reset;
 		}
 	}
 
 	return 0;
+
+err_free:
+	__free_pages(page, get_order(NV_LENGTH));
+err_reset:
+	sev_init_ex_buffer = NULL;
+	return rc;
 }
 
 static int __sev_platform_init_locked(int *error)
-- 
2.53.0



