Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFDBBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEDFC433EF;
	Tue,  7 Mar 2023 18:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215109;
	bh=FJwzaRGvi22DhldFOVCQXUfTJamIcFu8xOx7A9K9nVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZ5oeVrm8/yJYxpJip9ey+wFlyNEmEsIjYKpF4TVEcLgu32RF3hg6NvGsL5tJZgO/
	 tyj/8dvVcPWiGEEjh1CzpzzRXYSPGtM9CFbBAkzR+kJaa3j/yo0dmAIBF2/YZoYIHH
	 HTsNQppVmHYpIw4olnfYJ8KYHslc+Y0dHTI+wcI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/567] crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware
Date: Tue,  7 Mar 2023 17:57:39 +0100
Message-Id: <20230307165911.220468033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 46a334a98f585ef78d51d8f5736596887bdd7f54 ]

Perform a cache flush on the SEV-ES TMR memory after allocation to prevent
any possibility of the firmware encountering an error should dirty cache
lines be present. Use clflush_cache_range() to flush the SEV-ES TMR memory.

Fixes: 97f9ac3db661 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7c9149492970d..70174a9118b19 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -24,6 +24,7 @@
 #include <linux/cpufeature.h>
 
 #include <asm/smp.h>
+#include <asm/cacheflush.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -1114,7 +1115,10 @@ void sev_pci_init(void)
 
 	/* Obtain the TMR memory area for SEV-ES use */
 	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
-	if (!sev_es_tmr)
+	if (sev_es_tmr)
+		/* Must flush the cache before giving it to the firmware */
+		clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
+	else
 		dev_warn(sev->dev,
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
 
-- 
2.39.2



