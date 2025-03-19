Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAC11E991B;
	Wed, 19 Mar 2025 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395124; cv=none; b=lgMOTLnTjO7cIEWmOV82S0OEhoMJtUVnkXS59UD6PhJpUC84XcKkDOkIfjUVjUP836nWjg9jLn/9eaGVzZzKH2YbBPZLyUHK9naeKFeWE89AdUWcZVuNfpa+u22ZjFfy+SFJLU597oPtHOksRjap4cVzcbjhijI9Kiswz8AZnZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395124; c=relaxed/simple;
	bh=TfSp9Kz/7C2gx/Klqt1ChBrdl/lJzdGc2Y3b3vkapWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VcpjaaV/dGXLkrBZS6JKJ5taPUXwOJWlxUSPPRGW+fWxIvUBCULMFxIXxM7um24502YG5zIodKFRVgmRs2FcuChLTuN4/k/dPCW2hqXdoURayTwqiw4GxUAbs2Mvrsmy8pLVTjlhB+XWz9sAsG42zi47AW6+/REql45Z08oMHZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7yumteE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7yumteE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DE5C4CEE4;
	Wed, 19 Mar 2025 14:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395123;
	bh=TfSp9Kz/7C2gx/Klqt1ChBrdl/lJzdGc2Y3b3vkapWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7yumteEqbnf6tT0R+Oax9UgHjnvfHrBvPZGenKqJh7/q/7Q0x5dhsfbb1C4ZeNYt
	 /feWFoJdLTxU4uq4aPtbnnCVgPCXHjVpV3G9y31qim1qUMPwqUQf4QRPzoReGBhYsV
	 2bCwq4SmjC68JqVyrfxDjPIc60WbzvIKUV3hGDxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.12 186/231] clk: samsung: gs101: fix synchronous external abort in samsung_clk_save()
Date: Wed, 19 Mar 2025 07:31:19 -0700
Message-ID: <20250319143031.428385880@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Peter Griffin <peter.griffin@linaro.org>

commit f2052a4a62465c0037aef7ea7426bffdb3531e41 upstream.

EARLY_WAKEUP_SW_TRIG_*_SET and EARLY_WAKEUP_SW_TRIG_*_CLEAR
registers are only writeable. Attempting to read these registers
during samsung_clk_save() causes a synchronous external abort.

Remove these 8 registers from cmu_top_clk_regs[] array so that
system suspend gets further.

Note: the code path can be exercised using the following command:
echo mem > /sys/power/state

Fixes: 2c597bb7d66a ("clk: samsung: clk-gs101: Add cmu_top, cmu_misc and cmu_apm support")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250303-clk-suspend-fix-v1-1-c2edaf66260f@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/samsung/clk-gs101.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/clk/samsung/clk-gs101.c
+++ b/drivers/clk/samsung/clk-gs101.c
@@ -382,17 +382,9 @@ static const unsigned long cmu_top_clk_r
 	EARLY_WAKEUP_DPU_DEST,
 	EARLY_WAKEUP_CSIS_DEST,
 	EARLY_WAKEUP_SW_TRIG_APM,
-	EARLY_WAKEUP_SW_TRIG_APM_SET,
-	EARLY_WAKEUP_SW_TRIG_APM_CLEAR,
 	EARLY_WAKEUP_SW_TRIG_CLUSTER0,
-	EARLY_WAKEUP_SW_TRIG_CLUSTER0_SET,
-	EARLY_WAKEUP_SW_TRIG_CLUSTER0_CLEAR,
 	EARLY_WAKEUP_SW_TRIG_DPU,
-	EARLY_WAKEUP_SW_TRIG_DPU_SET,
-	EARLY_WAKEUP_SW_TRIG_DPU_CLEAR,
 	EARLY_WAKEUP_SW_TRIG_CSIS,
-	EARLY_WAKEUP_SW_TRIG_CSIS_SET,
-	EARLY_WAKEUP_SW_TRIG_CSIS_CLEAR,
 	CLK_CON_MUX_MUX_CLKCMU_BO_BUS,
 	CLK_CON_MUX_MUX_CLKCMU_BUS0_BUS,
 	CLK_CON_MUX_MUX_CLKCMU_BUS1_BUS,


