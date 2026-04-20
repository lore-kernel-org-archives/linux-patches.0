Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDDB3A785A;
	Mon, 20 Apr 2026 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691883; cv=none; b=e+IsQ+OiExJBxQXueR6jKc7LoqXoLeRjQCIcG5Kq6k3B5uvDLibEsaMyT1pNCkf1Nw+/W0CCCekBBnLZ8Ao2brIUAZ7iwotMfuHT09RFUbwF8Oqth8/68hdM3up6P8ZakIrYo7/G10sra64KZpsYk4PqLIp6eM/Kz9982hKJLNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691883; c=relaxed/simple;
	bh=daNxusGK2zC/hQrKEScJBi4trm+F7e7RYwlUjtVpuj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qan4qtIrDg4l/tAVJP9aDU9A8JNz84P2D2/OFPIaNcD8fEvseKCfxvXjGRTpOsWGVtJaJYV9utZgPej335OtpFyXswiCqzf50ob/p/rgW13n4uTiNxT2/cv8yasOZbNPjSRzQihqdyjM7CT7YmNQPWBpB5GY6a5iDz0yCHTA/fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kL2cXJ1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kL2cXJ1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3429DC2BCB4;
	Mon, 20 Apr 2026 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691883;
	bh=daNxusGK2zC/hQrKEScJBi4trm+F7e7RYwlUjtVpuj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kL2cXJ1DodipSppND/Luk862mzDbvS1lfm1c1WLO6/peUbi94gpfgIX4MpO1c9mIK
	 pB37Gc4VZbdNFbQxWtgd/sDnW/GMpjDbwIyN9FJH3A5KlcW7Capwz414lG/0+QDJv8
	 qj+wM4S7fPWLlpRvVtzvPUzXVnTzH15XlrOYb166q+Hz5WCnEYubMXCarWotJviQS7
	 rDXUJ8K9rYmoYx8DuBL0kq51Y5UXTQiMNxeeTU6SEwOBPjoC/oZmMUszr1/hLKrcRp
	 y1LybowXB67VjxkI1kJniFXlxhzrex4kasujnfBZ+PVXQWUUN5z4YuraGlikoVXQ1Z
	 EFRYoGXvl6DdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luke Wang <ziniu.wang_1@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	shawnguo@kernel.org,
	peng.fan@nxp.com,
	devicetree@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] arm64: dts: imx93-9x9-qsb: change usdhc tuning step for eMMC and SD
Date: Mon, 20 Apr 2026 09:20:44 -0400
Message-ID: <20260420132314.1023554-250-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit 08903184553def7ba1ad6ba4fa8afe1ba2ee0a21 ]

During system resume, the following errors occurred:

  [  430.638625] mmc1: error -84 writing Cache Enable bit
  [  430.643618] mmc1: error -84 doing runtime resume

For eMMC and SD, there are two tuning pass windows and the gap between
those two windows may only have one cell. If tuning step > 1, the gap may
just be skipped and host assumes those two windows as a continuous
windows. This will cause a wrong delay cell near the gap to be selected.

Set the tuning step to 1 to avoid selecting the wrong delay cell.

For SDIO, the gap is sufficiently large, so the default tuning step does
not cause this issue.

Fixes: 0565d20cd8c2 ("arm64: dts: freescale: Support i.MX93 9x9 Quick Start Board")
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
index 0852067eab2cb..197c8f8b7f669 100644
--- a/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
+++ b/arch/arm64/boot/dts/freescale/imx93-9x9-qsb.dts
@@ -507,6 +507,7 @@ &usdhc1 {
 	pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
 	bus-width = <8>;
 	non-removable;
+	fsl,tuning-step = <1>;
 	status = "okay";
 };
 
@@ -519,6 +520,7 @@ &usdhc2 {
 	vmmc-supply = <&reg_usdhc2_vmmc>;
 	bus-width = <4>;
 	no-mmc;
+	fsl,tuning-step = <1>;
 	status = "okay";
 };
 
-- 
2.53.0

