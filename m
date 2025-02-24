Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629121345;
	Mon, 24 Feb 2025 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408205; cv=none; b=dV5ghS42SwRnHOrrf8j2URhRIp+COuae8w6+i+zlqEFgnj8b//l6d0izs0dlLoSQavSaVNR9wQ6Ip5C7mvxoDgr66J7chvH0/vku+DpB+FkdtZL4vvm2Ug0NU8lD3ZgySe9oSFmq6FSxKbnCRNfJ0pufCqwvWX9t7XSFQ/ogZ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408205; c=relaxed/simple;
	bh=nSUXYiTO2SU2R9+5m3JfyUZ3CczYvi3Rcn6UW7mTcFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqRAsL8IePjFAfgMhCLWGoQnyBq1Y4+LTQycNGnKCLAQxJ1Uz0SfgTa5pW0dXUUYeKA6O297gWABZmT85Q8rbhlml9VcqiVbukG+4Tp7QZ9YhX72/hOu3J13fZ8bKVb2ESh/Qf8XvfGltXdgtnw0L79avY/INnAiMW5cynyf5Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBwkJBAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBwkJBAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E84C4CEE6;
	Mon, 24 Feb 2025 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408205;
	bh=nSUXYiTO2SU2R9+5m3JfyUZ3CczYvi3Rcn6UW7mTcFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBwkJBAQYcjaCZ5seuWlP1Lsz/g0eZFA3FVVx/eVmfUCQ+QrIwwYCAi+G1wYyZrY/
	 oYm0jJ6e1j0cHRpSxGqF/Ca/SJgZpXsIBhvVLoX63JKUGv2/tKYKtPi0upF4MbDfkx
	 MeFzgsuyLlQLhbte5KNfmUabszqmfWRcu6ViMhu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Komal Bajaj <quic_kbajaj@quicinc.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	stable@kernel.org
Subject: [PATCH 6.6 129/140] EDAC/qcom: Correct interrupt enable register configuration
Date: Mon, 24 Feb 2025 15:35:28 +0100
Message-ID: <20250224142608.077758109@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


