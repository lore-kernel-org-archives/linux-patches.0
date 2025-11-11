Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4B914286;
	Tue, 11 Nov 2025 01:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823705; cv=none; b=EOM/hsRiOpMYvq0+M7oWbDrPWZSlCHqMwyWQEA/K3tFklQC+cP4RHwC8wdWlXGiQLycqlbNBOyH5bm6jbEZSW5nzECV0UHuPaTff9hMG4LWvlcNoqG4iRlz3zFoeVl0H0c8y7mj+KaaTBV1wYO2CUjdClSOGqZmX7rRj1YPJpsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823705; c=relaxed/simple;
	bh=u3Exfn8eGBfjyjk/AX7PBhY+Lc2IrzDBLlUVttk37rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N48hvBqim7rIqD3+YQ4JgIVg4v+AkV/bKdD0svrKf5KwiHVCiCgytyOdpT9krm07izXudhINCqqtu9z0+7EGz8RHvrdtLkU0OeT3G0IDMFOjchW1oZG5w4bkWa8ERtnBfUdDiDfp0ZOqoqivis2Kbj9oPiHQrmlIbGGkV3wznzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0/ROJ/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0/ROJ/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37809C4CEFB;
	Tue, 11 Nov 2025 01:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823705;
	bh=u3Exfn8eGBfjyjk/AX7PBhY+Lc2IrzDBLlUVttk37rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0/ROJ/YtfmPyCmTVCPr4Zl9NNreInxnLjKTe7s15MQ9qWEaSwcS8pokMeQdZDFmV
	 yTTSj6WNxYRQtB1sjsYLFa3laExSHZB6dE2sDUfYFxoiH4FQ+9XMZkB3dyJwSwBiCR
	 RaqTuZZDUnERkh6/LHqnGeLFZ05i50eixr8iWqz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/565] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Tue, 11 Nov 2025 09:42:40 +0900
Message-ID: <20251111004533.717957057@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 4d072c084d7b0..bc0ecdb5c79e5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -28,6 +28,7 @@
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
+#include <linux/crash_dump.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1314,6 +1315,15 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
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



