Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEA1607B7;
	Mon, 24 Feb 2025 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409249; cv=none; b=a4atAuQrwMwMNueF5uPRJDBdYYzOWt6wXupVq2/eKK1yHaXKAG9z8ME2omqvdEVHQJuh1/odGnOVZzsSiDL24mf6Q4F4cvS9fEDubFvPmv16kI8u/ZoqOKgb2ASQlltcQpU4mXamECZzvPQlXVypuHnYhepMI/47fjmD1A0n3Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409249; c=relaxed/simple;
	bh=0bTxKVeRCBw0jMKZCSVBqUZgJWtFE1BQjLuZ66YL7O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrlJVLGzMpBT5BiCEiUiD2zVLoK60NMv4p2DmjSsjtOGmKK/UczOnv2D5seUOUegupUh2LTnyLjiMB8+1JWSns9mGlx5i/jwuCo/dDWWc3itRJySoCtUp8N4biIVfZKUe0CvDwno1BUzHj7JpAHxCofxPkgXDVYvOHiizbY9j8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STG15ML5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STG15ML5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F050C4CED6;
	Mon, 24 Feb 2025 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409249;
	bh=0bTxKVeRCBw0jMKZCSVBqUZgJWtFE1BQjLuZ66YL7O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STG15ML5ObzuaR53JIjWXuj3q7vkNLR6t5DOoCtv2LTgKfsSJxUEhbGOtteopPqE1
	 FQNlfMWFyBmThFQWv0dXiM0e8+0Lwae+3LwZFVnflCEv/YaHG+05cnnDzJJw7klgYj
	 eEje4Hyt1SjBDg2m+5rjsUBZdeX2CD3E18Ek5kyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	stable@kernel.org
Subject: [PATCH 6.13 130/138] EDAC/qcom: Correct interrupt enable register configuration
Date: Mon, 24 Feb 2025 15:36:00 +0100
Message-ID: <20250224142609.579025385@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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


