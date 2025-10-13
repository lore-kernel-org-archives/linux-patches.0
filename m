Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7AF3081B9;
	Mon, 13 Oct 2025 15:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369961; cv=none; b=YQTg6igx4XEZSXyeTQJgZW815gDdycDcpw+dKI/09nPUWu3NlY5YUwyXBunBIf0CTldC8xaV06RM+VqGXa5PFcF/DDhIjtkJW3jtGL/W+q+OFaMeq19bFxFKIXdnmmDz9/I70CxRApJNW9ruciskuqggihxXWOiF94mWn8Ldh6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369961; c=relaxed/simple;
	bh=ilJBLF0UGSEg9duB76BA+gBBWdFMD92IKWkr/wg47Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD87cVH2YHZ/c287cKbt4Qh55/PLK3Nr/p2t6HyVGjgxSmN0QR97YGVvLjHK6+tBatUTv4aOU7kRDsD9XExNzZVMnJc9u+4NHO+cY5P/3KD12/qCPbBsd/RCEw1RXAuVgsKKA6apHwRMIQmET4If0tNNtNSoX0niB5y8gNW0UW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHO0DBu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHO0DBu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44510C4CEE7;
	Mon, 13 Oct 2025 15:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369961;
	bh=ilJBLF0UGSEg9duB76BA+gBBWdFMD92IKWkr/wg47Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHO0DBu+fdyRi/2ccruoPCSBuxHoP+D3z0OZ9kcqNGB//XYa7CqRq84Dds278HoEZ
	 v7/++tFvaKauJJCSA19Qy3sywlnY3UVrxpKgKpf0FA8XyrtX54JhCPq98Nb4DLxOKk
	 sBC0KsAUJFxE4aNTlUbd8XcoL91cjJ7pZPCB+q+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 430/563] coresight: Avoid enable programming clock duplicately
Date: Mon, 13 Oct 2025 16:44:51 +0200
Message-ID: <20251013144426.863731643@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit d091c6312561821f216ced63a7ad17c946b6d335 ]

The programming clock is enabled by AMBA bus driver before a dynamic
probe. As a result, a CoreSight driver may redundantly enable the same
clock.

To avoid this, add a check for device type and skip enabling the
programming clock for AMBA devices. The returned NULL pointer will be
tolerated by the drivers.

Fixes: 73d779a03a76 ("coresight: etm4x: Change etm4_platform_driver driver for MMIO devices")
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250731-arm_cs_fix_clock_v4-v6-6-1dfe10bb3f6f@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/coresight.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/coresight.h b/include/linux/coresight.h
index 1e652e1578419..bb49080ec8f96 100644
--- a/include/linux/coresight.h
+++ b/include/linux/coresight.h
@@ -481,20 +481,23 @@ static inline bool is_coresight_device(void __iomem *base)
  * Returns:
  *
  * clk   - Clock is found and enabled
- * NULL  - Clock is controlled by firmware (ACPI device only)
+ * NULL  - Clock is controlled by firmware (ACPI device only) or when managed
+ *	   by the AMBA bus driver instead
  * ERROR - Clock is found but failed to enable
  */
 static inline struct clk *coresight_get_enable_apb_pclk(struct device *dev)
 {
-	struct clk *pclk;
+	struct clk *pclk = NULL;
 
 	/* Firmware controls clocks for an ACPI device. */
 	if (has_acpi_companion(dev))
 		return NULL;
 
-	pclk = devm_clk_get_optional_enabled(dev, "apb_pclk");
-	if (!pclk)
-		pclk = devm_clk_get_optional_enabled(dev, "apb");
+	if (!dev_is_amba(dev)) {
+		pclk = devm_clk_get_optional_enabled(dev, "apb_pclk");
+		if (!pclk)
+			pclk = devm_clk_get_optional_enabled(dev, "apb");
+	}
 
 	return pclk;
 }
-- 
2.51.0



