Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C271EB5E1;
	Wed, 25 Feb 2026 01:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982920; cv=none; b=AYVexs3owU5MhCpmEkKDHeELzMoxqkXRq4nTX5OS8hrUAvv2VA5nz0Y3uk36tckOvi7himgsT/khFOk1iVF4PzdY9WIU6F64oFlFPzvFvXYx+4B5qRJX15Zbkirps7YI2Ho0w6xTYIAuoOGWPX18jxrO9qw2EzVAGf8RrDG6jzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982920; c=relaxed/simple;
	bh=/g0vkepwE32IDCYO+duetn5egv43I2dwjGHiNyUFp08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NispCpLyifLdtcuVZtl7+18Iz4dtqLiTDqHgshXyx0LWyD1K8pDIoG1jSzOaUOgqRWKZgBr0KXfrO7H3Vlk0yqqzYa7+4Ud4ZbEkw1htakEmwTKi01+7lAJL8EHf4KqfdFaB8IvUkSofEiaw0RvhC3MrSMxXT0LMZz7q/dSXs6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfiJzm3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfiJzm3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F93C116D0;
	Wed, 25 Feb 2026 01:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982920;
	bh=/g0vkepwE32IDCYO+duetn5egv43I2dwjGHiNyUFp08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfiJzm3+6mDFCe+OmFtgj4wMMTmO9OfQAUm6Hi3WDvYD989GCnBtPOaDf9LHGIQ9j
	 EAu2O5qQi7ol5FTuSL6Zo6R6PmTnZlccyovSRIk6hKFtn0YVjrB8v2OEx8jFGt6v4s
	 l+KAjY3o13G6WH2Kf31J9ogzFwRQO6Ec4oxOY06M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 099/781] crypto: ccp - narrow scope of snp_range_list
Date: Tue, 24 Feb 2026 17:13:28 -0800
Message-ID: <20260225012402.116858509@linuxfoundation.org>
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
index 6e6011e363e3b..1cdadddb744ed 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -127,13 +127,6 @@ static size_t sev_es_tmr_size = SEV_TMR_SIZE;
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
@@ -1361,6 +1354,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 
 static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
+	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
 	struct psp_device *psp = psp_master;
 	struct sev_data_snp_init_ex data;
 	struct sev_device *sev;
@@ -2780,11 +2774,6 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
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



