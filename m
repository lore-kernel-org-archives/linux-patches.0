Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6601620CCD8;
	Tue,  8 Apr 2025 12:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114631; cv=none; b=LVfOx9nSliiABH+7+x9mUF2VR4RvGe/8RCqxwGmpkc8SEYSZYdQEqQU6/WHBMIsLzd1eZw3yk+iaaiVZFjndjZ23xAjZPaNPVms04xiQnb7DdfgUJrERUxDBROvvYm5n9n6rZhC04PM2jj/dJMRPnDJSKJrfnA//Wb87a0a8Ovo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114631; c=relaxed/simple;
	bh=ZIGHX+KDTrubVZUJu1fD+B4cXCAPmtuRBp9qHDbwAqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8y/SaRRHIB+dG1IbsPSlP5Ga0Tq8PMnWBy2+DoWOUhyeKo3TyjMY7DkKkalS+A7JOuUo6r4i75zeCh3xGBzT6FnVbKd09GG+v4zWNyHJTR4dCub1Uml64cQFUSYLx1eEooBTtfZtKyMYYbhEx79bAwTon3LVzdtk2MqJVmBisw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVT0qOYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVT0qOYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB534C4CEE5;
	Tue,  8 Apr 2025 12:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114631;
	bh=ZIGHX+KDTrubVZUJu1fD+B4cXCAPmtuRBp9qHDbwAqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVT0qOYWzyea81xvasI4OWBdtRASdjHZZn53cge3rc/FywFrljgoxBx7XYf4QdeUR
	 ss4TqpXCa/L0lh4Fq+r8iYeplVFlJnJn2LXSpt896f5CUVfyZ+zhabl2gl9bkAQKpl
	 V37Hh32RcT7bIvF6dONz0b2gcvcc4FUQFu25DpWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 179/499] crypto: qat - remove access to parity register for QAT GEN4
Date: Tue,  8 Apr 2025 12:46:31 +0200
Message-ID: <20250408104855.638128967@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

[ Upstream commit 92c6a707d82f0629debf1c21dd87717776d96af2 ]

The firmware already handles parity errors reported by the accelerators
by clearing them through the corresponding SSMSOFTERRORPARITY register.
To ensure consistent behavior and prevent race conditions between the
driver and firmware, remove the logic that checks the SSMSOFTERRORPARITY
registers.

Additionally, change the return type of the function
adf_handle_rf_parr_err() to void, as it consistently returns false.
Parity errors are recoverable and do not necessitate a device reset.

Fixes: 895f7d532c84 ("crypto: qat - add handling of errors from ERRSOU2 for QAT GEN4")
Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/qat/qat_common/adf_gen4_ras.c       | 57 ++-----------------
 1 file changed, 5 insertions(+), 52 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index bf0ea09faa650..0f7f00a19e7dc 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -1043,63 +1043,16 @@ static bool adf_handle_ssmcpppar_err(struct adf_accel_dev *accel_dev,
 	return reset_required;
 }
 
-static bool adf_handle_rf_parr_err(struct adf_accel_dev *accel_dev,
+static void adf_handle_rf_parr_err(struct adf_accel_dev *accel_dev,
 				   void __iomem *csr, u32 iastatssm)
 {
-	struct adf_dev_err_mask *err_mask = GET_ERR_MASK(accel_dev);
-	u32 reg;
-
 	if (!(iastatssm & ADF_GEN4_IAINTSTATSSM_SSMSOFTERRORPARITY_BIT))
-		return false;
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_SRC);
-	reg &= ADF_GEN4_SSMSOFTERRORPARITY_SRC_BIT;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_SRC, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_ATH_CPH);
-	reg &= err_mask->parerr_ath_cph_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_ATH_CPH, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_CPR_XLT);
-	reg &= err_mask->parerr_cpr_xlt_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_CPR_XLT, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_DCPR_UCS);
-	reg &= err_mask->parerr_dcpr_ucs_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_DCPR_UCS, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_PKE);
-	reg &= err_mask->parerr_pke_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_PKE, reg);
-	}
-
-	if (err_mask->parerr_wat_wcp_mask) {
-		reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_WAT_WCP);
-		reg &= err_mask->parerr_wat_wcp_mask;
-		if (reg) {
-			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-			ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_WAT_WCP,
-				   reg);
-		}
-	}
+		return;
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 	dev_err(&GET_DEV(accel_dev), "Slice ssm soft parity error reported");
 
-	return false;
+	return;
 }
 
 static bool adf_handle_ser_err_ssmsh(struct adf_accel_dev *accel_dev,
@@ -1171,8 +1124,8 @@ static bool adf_handle_iaintstatssm(struct adf_accel_dev *accel_dev,
 	reset_required |= adf_handle_slice_hang_error(accel_dev, csr, iastatssm);
 	reset_required |= adf_handle_spppar_err(accel_dev, csr, iastatssm);
 	reset_required |= adf_handle_ssmcpppar_err(accel_dev, csr, iastatssm);
-	reset_required |= adf_handle_rf_parr_err(accel_dev, csr, iastatssm);
 	reset_required |= adf_handle_ser_err_ssmsh(accel_dev, csr, iastatssm);
+	adf_handle_rf_parr_err(accel_dev, csr, iastatssm);
 
 	ADF_CSR_WR(csr, ADF_GEN4_IAINTSTATSSM, iastatssm);
 
-- 
2.39.5



