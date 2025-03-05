Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84878250C02;
	Wed,  5 Mar 2025 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197239; cv=none; b=jx0LX2i8ijau1gw0SU5l+D/zFiCvJvHUgIte2UhzUwtoCtksOfQ4EanHTJWzk1pgNTOqkT02s8zcst3vQhU6PFZTCFl1XEzA8BZfqgE65evWuvY4zOhoQISQ0YWua14fxDmAzOCaSTHwl/S2SkMmUZyHEcGqtnEwTQjWhniWbcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197239; c=relaxed/simple;
	bh=j74BuON+Xi7UaE8JsT4uJehGLBONIbx+kiCRlXln1T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjWDGwm4vdtP1/bbfG20JDJNc2zMjAQcn11kVXBZ5ZUqgT7cieEwYcGCdbZ3/lbRMiLzk/VXB3ftlxdDHDD8aICsmtc5bOIRxmVOY6HhHe8uxaLqCv2rVY1iGSLvkYk3+4o2CSH43q4dVOB3Oo5tXUSTkU4mAfp4BWiDuHGqZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsVU5QOT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsVU5QOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C816C4CED1;
	Wed,  5 Mar 2025 17:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197239;
	bh=j74BuON+Xi7UaE8JsT4uJehGLBONIbx+kiCRlXln1T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsVU5QOTMprfh0VdEKOphMJsehvip0rXOrpf6xYHaQ3iTlfBnYEcXByLiuedlALUN
	 A5O9/th4fmY+fpUfMGW1W5kQbWC9dtbH+7oRRbRHHRAZvNR6EQ10wjcYM/Qapj55Wt
	 Cd+2/d/MFuilVGz9xEFyihl1WPCZJdInU85gBXV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	stable@kernel.org
Subject: [PATCH 6.1 087/176] EDAC/qcom: Correct interrupt enable register configuration
Date: Wed,  5 Mar 2025 18:47:36 +0100
Message-ID: <20250305174508.956587840@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Komal Bajaj <quic_kbajaj@quicinc.com>

commit c158647c107358bf1be579f98e4bb705c1953292 upstream.

The previous implementation incorrectly configured the cmn_interrupt_2_enable
register for interrupt handling. Using cmn_interrupt_2_enable to configure
Tag, Data RAM ECC interrupts would lead to issues like double handling of the
interrupts (EL1 and EL3) as cmn_interrupt_2_enable is meant to be configured
for interrupts which needs to be handled by EL3.

EL1 LLCC EDAC driver needs to use cmn_interrupt_0_enable register to configure
Tag, Data RAM ECC interrupts instead of cmn_interrupt_2_enable.

Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
Signed-off-by: Komal Bajaj <quic_kbajaj@quicinc.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20241119064608.12326-1-quic_kbajaj@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/qcom_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/qcom_edac.c
+++ b/drivers/edac/qcom_edac.c
@@ -95,7 +95,7 @@ static int qcom_llcc_core_setup(struct l
 	 * Configure interrupt enable registers such that Tag, Data RAM related
 	 * interrupts are propagated to interrupt controller for servicing
 	 */
-	ret = regmap_update_bits(llcc_bcast_regmap, drv->edac_reg_offset->cmn_interrupt_2_enable,
+	ret = regmap_update_bits(llcc_bcast_regmap, drv->edac_reg_offset->cmn_interrupt_0_enable,
 				 TRP0_INTERRUPT_ENABLE,
 				 TRP0_INTERRUPT_ENABLE);
 	if (ret)
@@ -113,7 +113,7 @@ static int qcom_llcc_core_setup(struct l
 	if (ret)
 		return ret;
 
-	ret = regmap_update_bits(llcc_bcast_regmap, drv->edac_reg_offset->cmn_interrupt_2_enable,
+	ret = regmap_update_bits(llcc_bcast_regmap, drv->edac_reg_offset->cmn_interrupt_0_enable,
 				 DRP0_INTERRUPT_ENABLE,
 				 DRP0_INTERRUPT_ENABLE);
 	if (ret)


