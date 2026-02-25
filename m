Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897A82701B6;
	Wed, 25 Feb 2026 01:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983849; cv=none; b=rae4woIbMJL/gSqqe7U9STy9vTJu1DSLn5HGWGZgESHr7lbxmSGBFUkaXbpaYp0imtvSP0nrEncWFKTSIMRK5e/2HmkTsj+GMROvmqcOu16sCz0ZC2UMBWkWX251ONQe4NaQBkGGlmqwFbO4DGrvidDdXt405lqDR4cOYKr7yFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983849; c=relaxed/simple;
	bh=neOmN+GH3w1/7ZNHe2obiIp+ak9Jj63YetSLeE2arxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPd3RBp9j5hTIXU+oqy6SBoXTnH8mjqyFa3wBQt7NCnA8yaWzhiMZlgW8iDT6iAybW8gvPiQqUbRVMmWZwND5aqxNWmDme8VLYOZyvpcma9+wF+R39ORry6iiVSwenRFac1RZHYG0EyDhkjL7JOu/cp2Ivlh4zNi966XOuDoUWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xk0EPhMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xk0EPhMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B9FC116D0;
	Wed, 25 Feb 2026 01:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983849;
	bh=neOmN+GH3w1/7ZNHe2obiIp+ak9Jj63YetSLeE2arxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xk0EPhMRAktTWr+9bCfHPphqR5o6oep1sIjhkpssMId/tze6Kulb0SgFWTVWpUKa6
	 1jgFxgKOreOirBKieVGxsGmurMWp3lngdf8L82IBj4IdJDNe542rHu1lANdgHcQ7XF
	 n9ccYeQCX67akqSo04G3F72eHVMV+1vj100W5Thc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/641] crypto: ccp - narrow scope of snp_range_list
Date: Tue, 24 Feb 2026 17:16:56 -0800
Message-ID: <20260225012351.281241531@linuxfoundation.org>
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

From: Tycho Andersen (AMD) <tycho@kernel.org>

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
index 3c6ee8b4e4487..5fdba0fe4acce 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -119,13 +119,6 @@ static size_t sev_es_tmr_size = SEV_TMR_SIZE;
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
 
 static int snp_shutdown_on_panic(struct notifier_block *nb,
@@ -1365,6 +1358,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 
 static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
+	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
 	struct sev_device *sev;
@@ -2753,11 +2747,6 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
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



