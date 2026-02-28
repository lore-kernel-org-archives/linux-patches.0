Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D175037702D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301662; cv=none; b=XgL/UOpIxbiOYyQsc/JDhILqVGiODto5rxsNJrA96o6vEHpsW0RkNiESNzNKWiOE1y5iKz+ZMl8o3ypIr8yc7OoNppV23zxmx2p2D3L+gPxMdbURSF3eIWpw8NKUEWy8AW0ZHmu0iBVUN1Or4sDeuxHkpgfc3L/tT05cJ/slcxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301662; c=relaxed/simple;
	bh=YnvugZu/wQy3w3Msn1buiY1fAPJG0nFHcg0pVGaI9U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxxZABw41knyVISJ62JBeApK4YtEGfZszaYoLEjsogXaN0ks9W+QH1cJCJP+ANokxkb6Ry84fUsRHs1ROWMAIG4+0VDqG0nTnKX+auVavl/kh2ztGUYrbHB4LETlgeTg2bzDtEBuUG6YfkR8c4dGhk0V8rQ2ObWIHC+sGdLwbZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1DyX4NS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1DyX4NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FC8C116D0;
	Sat, 28 Feb 2026 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301662;
	bh=YnvugZu/wQy3w3Msn1buiY1fAPJG0nFHcg0pVGaI9U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1DyX4NSbkKBONcXum0Ool2/JVmYyOTa1Pd7BCnO7Ie9j3IloXdR5+RIPnbmXV/GT
	 jWpOCu0p6oa89uWmlBoD1o5ztbBlQIL5qOLJVRDCB2+UXF/vk2rZr1ZH9Y7qIs/MBB
	 AWtwJoUu3JbhJ6MhKki1wMzeEeGrd28fMWtk7sAkTCAS2qXrdSmYRahvyve9QkUzAV
	 PMe/tCh1XIFI3PdT5gv0Mjm+3K8l+7b8vHToTJh18AWExTXV/XjGwJQtAWY/an+gr7
	 UNOmq5+w0YqmqMPOZWpJmwQSeXafyXnNG0NaNyUIzaW/pp+CxWEMClyA63msikmSHr
	 2RubxxT4o9EBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Tycho Andersen (AMD)" <tycho@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/385] crypto: ccp - narrow scope of snp_range_list
Date: Sat, 28 Feb 2026 12:54:43 -0500
Message-ID: <20260228180011.1568201-61-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

[ Upstream commit dc8ccab15081efc4f2c5a9fc7b209cd641d29177 ]

snp_range_list is only used in __sev_snp_init_locked() in the SNP_INIT_EX
case, move the declaration there and add a __free() cleanup helper for it
instead of waiting until shutdown.

Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3e08df45a8bdb..3016d1369ac51 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -103,13 +103,6 @@ static size_t sev_es_tmr_size = SEV_TMR_SIZE;
 #define NV_LENGTH (32 * 1024)
 static void *sev_init_ex_buffer;
 
-/*
- * SEV_DATA_RANGE_LIST:
- *   Array containing range of pages that firmware transitions to HV-fixed
- *   page state.
- */
-static struct sev_data_range_list *snp_range_list;
-
 static void __sev_firmware_shutdown(struct sev_device *sev, bool panic);
 
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
@@ -1098,6 +1091,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 
 static int __sev_snp_init_locked(int *error)
 {
+	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
 	struct sev_device *sev;
@@ -2430,11 +2424,6 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 		sev_init_ex_buffer = NULL;
 	}
 
-	if (snp_range_list) {
-		kfree(snp_range_list);
-		snp_range_list = NULL;
-	}
-
 	__sev_snp_shutdown_locked(&error, panic);
 }
 
-- 
2.51.0

