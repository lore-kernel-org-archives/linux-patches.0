Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9272BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284B9C4339B;
	Tue,  7 Mar 2023 18:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212458;
	bh=qHmSWk2fsXakE+6VQR91QuT6TF3b7id7uajB53IzM5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdcB5FsMmH/+xKmNgFa8syWkd9e4kXRQg+IL29rQvBW4yOb+bIPrplGP5zD9zObvD
	 HvYw7YfufvZwzYQV1Y7NqGC5Xt3Aka1OujodE0JY059z+FXcPezRNy1Ie2g+rWgYAi
	 AOnY3KWsHr99+n0P91VtDfvewmRwiBp8yNDbIxO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/885] crypto: ccp - Flush the SEV-ES TMR memory before giving it to firmware
Date: Tue,  7 Mar 2023 17:52:05 +0100
Message-Id: <20230307170010.316200132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 56998bc579d67..3e583f0324874 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -26,6 +26,7 @@
 #include <linux/fs_struct.h>
 
 #include <asm/smp.h>
+#include <asm/cacheflush.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -1334,7 +1335,10 @@ void sev_pci_init(void)
 
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



