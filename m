Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8D33793AC;
	Mon,  9 Feb 2026 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647168; cv=none; b=PmKFho5pl178BTotyJlzsCVy3HRk0S0Hxke0IsSpp+Bnq5eyBPkU3BfboIPCHjGa8/dxGHEt50smXIebewD4XQoYw7/FisQCHYn19kJQCeJEzIFoyJsMoKUxomD5E82K3ptSaNayXri9/rq7KZp2YMMPVmJvJ0Mv42Gk82/a//o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647168; c=relaxed/simple;
	bh=G28e/2TigncFgWCpDGvSrF+vxbzE/0MvskJIe40M1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgZORAQXQPP5uQkKywMR61a79OH6zTHwdL+5rJ69d9f6976jd6ypowG/hZTfUwIdBRaBLJx8GdOA++pOu2KIJs4Xxcqg28cpfYeeOGADMY5x3PYTDMcwvoyUrP+8cVPMNtdXQVUZOY+22O5/EJPs503sVRH48OsD50eAKN+y/z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C00ik4JQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C00ik4JQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2104AC19423;
	Mon,  9 Feb 2026 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647168;
	bh=G28e/2TigncFgWCpDGvSrF+vxbzE/0MvskJIe40M1xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C00ik4JQNMVXgM2/YHBUnep13xjFghA6WQwnac+F579/wrCl+aqv5RjIrSwRgTio7
	 aaBxZmxgrV2bv/4iF7HtsFLv8MA2U7nK3vxMrX8Y+vCxd9ecR8LBIglCvTghWw/NMh
	 bB7Wqrf6VN1syrmfFpUY9aEajEqXubZfNgQJ/lME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Jacky Bai <ping.bai@nxp.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 009/175] pmdomain: imx: gpcv2: Fix the imx8mm gpu hang due to wrong adb400 reset
Date: Mon,  9 Feb 2026 15:21:22 +0100
Message-ID: <20260209142320.812516859@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

commit ae0a24c5a8dcea20bf8e344eadf6593e6d1959c3 upstream.

On i.MX8MM, the GPUMIX, GPU2D, and GPU3D blocks share a common reset
domain. Due to this hardware limitation, powering off/on GPU2D or GPU3D
also triggers a reset of the GPUMIX domain, including its ADB400 port.
However, the ADB400 interface must always be placed into power‑down mode
before being reset.

Currently the GPUMIX and GPU2D/3D power domains rely on runtime PM to
handle dependency ordering. In some corner cases, the GPUMIX power off
sequence is skipped, leaving the ADB400 port active when GPU2D/3D reset.
This causes the GPUMIX ADB400 port to be reset while still active,
leading to unpredictable bus behavior and GPU hangs.

To avoid this, refine the power‑domain control logic so that the GPUMIX
ADB400 port is explicitly powered down and powered up as part of the GPU
power domain on/off sequence. This ensures proper ordering and prevents
incorrect ADB400 reset.

Suggested-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpcv2.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/pmdomain/imx/gpcv2.c
+++ b/drivers/pmdomain/imx/gpcv2.c
@@ -165,13 +165,11 @@
 #define IMX8M_VPU_HSK_PWRDNREQN			BIT(5)
 #define IMX8M_DISP_HSK_PWRDNREQN		BIT(4)
 
-#define IMX8MM_GPUMIX_HSK_PWRDNACKN		BIT(29)
-#define IMX8MM_GPU_HSK_PWRDNACKN		(BIT(27) | BIT(28))
+#define IMX8MM_GPU_HSK_PWRDNACKN		GENMASK(29, 27)
 #define IMX8MM_VPUMIX_HSK_PWRDNACKN		BIT(26)
 #define IMX8MM_DISPMIX_HSK_PWRDNACKN		BIT(25)
 #define IMX8MM_HSIO_HSK_PWRDNACKN		(BIT(23) | BIT(24))
-#define IMX8MM_GPUMIX_HSK_PWRDNREQN		BIT(11)
-#define IMX8MM_GPU_HSK_PWRDNREQN		(BIT(9) | BIT(10))
+#define IMX8MM_GPU_HSK_PWRDNREQN		GENMASK(11, 9)
 #define IMX8MM_VPUMIX_HSK_PWRDNREQN		BIT(8)
 #define IMX8MM_DISPMIX_HSK_PWRDNREQN		BIT(7)
 #define IMX8MM_HSIO_HSK_PWRDNREQN		(BIT(5) | BIT(6))
@@ -794,8 +792,6 @@ static const struct imx_pgc_domain imx8m
 		.bits  = {
 			.pxx = IMX8MM_GPUMIX_SW_Pxx_REQ,
 			.map = IMX8MM_GPUMIX_A53_DOMAIN,
-			.hskreq = IMX8MM_GPUMIX_HSK_PWRDNREQN,
-			.hskack = IMX8MM_GPUMIX_HSK_PWRDNACKN,
 		},
 		.pgc   = BIT(IMX8MM_PGC_GPUMIX),
 		.keep_clocks = true,


