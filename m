Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8481F4283;
	Tue,  3 Dec 2024 14:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237982; cv=none; b=jDgiZqJyTpj6p6agq3+I9Ut69ZlbbJfu2LDky/kSf59/+YOxLcVcM+hvJq64v1QHryoLbG1wXcFy6PGeogT6tmThG4oFm+UcOUrgOiQGfC7naPOQswDU3wreyUW2V1jBK55L1enWw0Yvza/1T4tF2g+xzRua3vEoBsTRZjeSTsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237982; c=relaxed/simple;
	bh=tBC+0/oqGH14jg007fSij66WyBqJMFu26F0QrRWtiOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A++BIg/blp8PvIMNU+uHvKS+BC0VIDQ/9IRbShwQwjL3gy36CgFCbAGe9G/U1P4K7qa+rIMyloZD26ENjuyQkbfB0i+7jHUg5FP5kQbfaWDNFMnGmyHvIudMfdQOkAsfDXLmKfKvdzHCZrO9dWQf90mKkNbLSBt/nEKkm1oGULg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKpXntD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKpXntD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B50C4CECF;
	Tue,  3 Dec 2024 14:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237982;
	bh=tBC+0/oqGH14jg007fSij66WyBqJMFu26F0QrRWtiOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKpXntD/R/oA1zCbfQmvmfIhhRlg2r820RgNWvLyNV2A/TxpEWMuCzlLnEVYiEtdY
	 Tb7EyS4klmUT0JcppyNxJkkBLAHkDcE85UZkLEl7U7ihMT2ALXjpRHm6/EJCX4Ia1H
	 HWDtmE48x10P10gNL+3YANYd1uxASUKR7iBjmhTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Stange <nstange@suse.com>,
	Michal Suchanek <msuchanek@suse.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.11 124/817] crypto: aes-gcm-p10 - Use the correct bit to test for P10
Date: Tue,  3 Dec 2024 15:34:56 +0100
Message-ID: <20241203144000.554716881@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 3574a5168ff3b6bddc4cd235878491f75967c8d4 ]

A hwcap feature bit is passed to cpu_has_feature, resulting in testing
for CPU_FTR_MMCRA instead of the 3.1 platform revision.

Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")
Reported-by: Nicolai Stange <nstange@suse.com>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index e52629334cf80..1f8b677756582 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -414,7 +414,7 @@ static int __init p10_init(void)
 {
 	int ret;
 
-	if (!cpu_has_feature(PPC_FEATURE2_ARCH_3_1))
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
 		return 0;
 
 	ret = simd_register_aeads_compat(gcm_aes_algs,
-- 
2.43.0



