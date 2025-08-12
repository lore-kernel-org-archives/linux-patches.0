Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E8C2DFA3E;
	Tue, 12 Aug 2025 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022769; cv=none; b=J8rOVJwgzzRrZxWh2oM7bAS3pFHO2vhhSHGchwWf0n9gOZFcGOSqsMi4EbBzchv6+uYgCmg72x2QV7Vawr5RnVF77SR5gb56tcFqJAKTIuNjqjYr5wyPkxWiQNUJzu+TVAm81pbtmV/5/crMviMIBXHJAmr/SckAaOKnGvzHa2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022769; c=relaxed/simple;
	bh=O9bpRJmspuVmBw+jqc5xM9DC6MEWkqgH4GmAKREawXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luwEg7TMEg3gciOd5aVOPOYvw4irlTCS9kOYMMArW7vc96Yku2EIyhpe9q3OxOZukpCLM7a00rQf7tZ8DU2Jtu+CIf/P2uSREBG9NEPlTY01gMHF1TNeAymEou4d4XdqsUhW5axd9z6zMpG7pbNCRVVOEZRqazUndF0HdxF/hbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=moz90FCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="moz90FCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEE2C4CEF6;
	Tue, 12 Aug 2025 18:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022769;
	bh=O9bpRJmspuVmBw+jqc5xM9DC6MEWkqgH4GmAKREawXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=moz90FCGtD4EKNCKj3lww0l0GyC82L25BvzcxLNI4bvUOBgCnFqiOEEVGZ5Jn4zMn
	 o+v7ij/+gwk1ZPvZz29wFtBeoEabCtp1WG04AuvhlBq7tDVHZE/riySxiGy0wbIJ2L
	 nqLt9jR8Wo2DQUFyQP0LXk2mHcWvG2UB8MFKcU6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/369] crypto: qat - disable ZUC-256 capability for QAT GEN5
Date: Tue, 12 Aug 2025 19:28:27 +0200
Message-ID: <20250812173022.659094138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

[ Upstream commit d956692c7dd523b331d4556ee03def8dd02609dc ]

The ZUC-256 EEA (encryption) and EIA (integrity) algorithms are not
supported on QAT GEN5 devices, as their current implementation does not
align with the NIST specification. Earlier versions of the ZUC-256
specification used a different initialization scheme, which has since
been revised to comply with the 5G specification.

Due to this misalignment with the updated specification, remove support
for ZUC-256 EEA and EIA for QAT GEN5 by masking out the ZUC-256
capability.

Fixes: fcf60f4bcf549 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index a17adc4beda2..ef5f03be4190 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -199,7 +199,6 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 			  ICP_ACCEL_CAPABILITIES_SM4 |
 			  ICP_ACCEL_CAPABILITIES_AES_V2 |
 			  ICP_ACCEL_CAPABILITIES_ZUC |
-			  ICP_ACCEL_CAPABILITIES_ZUC_256 |
 			  ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT |
 			  ICP_ACCEL_CAPABILITIES_EXT_ALGCHAIN;
 
@@ -231,17 +230,11 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 	if (fusectl1 & ICP_ACCEL_GEN4_MASK_WCP_WAT_SLICE) {
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC;
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT;
 	}
 
-	if (fusectl1 & ICP_ACCEL_GEN4_MASK_EIA3_SLICE) {
+	if (fusectl1 & ICP_ACCEL_GEN4_MASK_EIA3_SLICE)
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC;
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
-	}
-
-	if (fusectl1 & ICP_ACCEL_GEN4_MASK_ZUC_256_SLICE)
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
 
 	capabilities_asym = ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 			  ICP_ACCEL_CAPABILITIES_SM2 |
-- 
2.39.5



