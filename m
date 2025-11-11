Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D134305E15;
	Tue, 11 Nov 2025 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824431; cv=none; b=Jyy/UwYPm00aALRcx3KOykhqc5k97/xrQYtV2riRWPTu36qav9LaNa7BspzUxd1Q+r61LvJAzdadTo+K/6CPFaY/rVjkAGSUY0Sgvh3l58h7oTgITsrlg0yvU7wzBRo1IAuHL9Kd/WnObn9Cap1j/OnokkZ6vZ35VHAPaIFzhjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824431; c=relaxed/simple;
	bh=rrSyG3QnM23Kp4w/9W55iriQpK5mQmkdsLq2P+1eAmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oll+RIlqZ7LDpaMLmZXkICRjoPA15DciEf5ZZ9W2CPTj35wCcQQR5sMGjE+twyumUMcHyMb7l44SfPfq/3xk9f8Wou/NKXAvfgQ1d1oDIYjB2I88KerLVbCN3Hxi193lnF/RYUlYSkfbuRjXobPf/kkXxqhGCcAdZZlIgeTosMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Okso9HLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Okso9HLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B405C116D0;
	Tue, 11 Nov 2025 01:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824431;
	bh=rrSyG3QnM23Kp4w/9W55iriQpK5mQmkdsLq2P+1eAmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Okso9HLX2Ti9FTFAOKZqgS0L1R3X4hf+hl4qckRbEGMEztVfVbVns3IbRtzB/VAps
	 hM+bPuWz6o+8y4M4L9rcmtRb291hY1Vlh4F/0PQX3KmkswJb6xsnnIXAaF4vezktvw
	 oQUPxTaVkpGVMeRdEtjjLKyblvZRBbpP/g+xS7zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 450/849] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Tue, 11 Nov 2025 09:40:20 +0900
Message-ID: <20251111004547.311251250@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 8c571019d8a817b701888926529a5d7a826b947b ]

Since SEV or SNP may already be initialized in the previous kernel,
attempting to initialize them again in the kdump kernel can result
in SNP initialization failures, which in turn lead to IOMMU
initialization failures. Moreover, SNP/SEV guests are not run under a
kdump kernel, so there is no need to initialize SEV or SNP during
kdump boot.

Skip SNP and SEV INIT if doing kdump boot.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9f5ccc1720cbc..651346db6909d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -28,6 +28,7 @@
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
+#include <linux/crash_dump.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1345,6 +1346,15 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
+	/*
+	 * Skip SNP/SEV initialization under a kdump kernel as SEV/SNP
+	 * may already be initialized in the previous kernel. Since no
+	 * SNP/SEV guests are run under a kdump kernel, there is no
+	 * need to initialize SNP or SEV during kdump boot.
+	 */
+	if (is_kdump_kernel())
+		return 0;
+
 	sev = psp_master->sev_data;
 
 	if (sev->state == SEV_STATE_INIT)
-- 
2.51.0



