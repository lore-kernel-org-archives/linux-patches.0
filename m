Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231392837B;
	Mon, 24 Feb 2025 14:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408734; cv=none; b=SotTjm+sXmSmXei2VKiX+JM3m1i3KiJ6oAYj6L1nH+aRxeFhcB5ZTZVu1SU5aWTp3gSIwYEu4ylKjT03LhXU4QjZojNRpdqXtSFnyCPXDuqiCzyqr51etU9EwhhdC6s4vIM+Ue6QDw7FHuf/P0uJnXIHpvELN39dJ78eBsZCs34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408734; c=relaxed/simple;
	bh=o01WfcWPSS0yrohvRg8hOi4lQIo6TAIa9rKnGUObxGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHfUsg1/Q28CEZ7UbM5QfG8MtTK3AqLZ6HuqVhGyOQ00m8L+SthY5QWnLRtHSdU/tSA+LIefrceqDKdj43sI2KDSeOTvBctPmo5IZOHz/cXtCxsriCZRnPudwmQO2H2zTh+WA6VD/p1nNrYsbm1WOHhaIYy2knrnAWKdSuwSpr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZSzHCzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZSzHCzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EC4C4CED6;
	Mon, 24 Feb 2025 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408734;
	bh=o01WfcWPSS0yrohvRg8hOi4lQIo6TAIa9rKnGUObxGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZSzHCzUj0n055YQO9y+yTOBVQrjxbQVe7KdWxop9uq4/gf5Op9aM13GJzNC3PLM5
	 LcpK9NDJvH2BwJm1zF1+2XC7wvHZbyRR2W4hPYG/hNqLqPGkj7NOHNOpsATeShKaJL
	 eVg+AVQdkytfi9zxEdam/LAWDsNJli/RDis5UDrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	stable@kernel.org
Subject: [PATCH 6.12 144/154] EDAC/qcom: Correct interrupt enable register configuration
Date: Mon, 24 Feb 2025 15:35:43 +0100
Message-ID: <20250224142612.686956380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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


