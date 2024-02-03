Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045161B28D;
	Sat,  3 Feb 2024 04:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933721; cv=none; b=ACUBYrxuCzgjaC9egjZqzA2wzQdKqHVNwljIIbgHIGvaXX6mJpth2i8fJJLRS7sSPJM9y81pqx5Cc6qtsqAdpuUlqGAyhYq1yvBo1Fz8MBIZZlVIX1QsHcGjSbS/kl6hjcLspB/nkxpAcnWd78bfZJX52aPyGh+cBGwlJJ1ChFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933721; c=relaxed/simple;
	bh=GV1WsWLmqxOcJe6aXYc2pJ4TpUmVZ/G8E8TSIbyn8tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHL802qd4J90gbkXkJBNPebTLQNQYSvkuDHMiS1mxX/eNuOVc0tgAdjHmJGTG36IYoAvZH0qKSM+O9lkSenWXc01ph2mOIxduO2FdPNVaUC0/gXtL9uCSpZCEnrBiBil9lPePjmAdQVMgQZwYfplKl1zRnVwjdpAwMRw2AyP58Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1gQ4tCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1gQ4tCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61633C433B2;
	Sat,  3 Feb 2024 04:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933720;
	bh=GV1WsWLmqxOcJe6aXYc2pJ4TpUmVZ/G8E8TSIbyn8tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1gQ4tCfr9Dl252Ug0KSMs3OgYDc/i4biu04mBpnTFb389eEah/ArD9qMu/mkYN2X
	 4eUUOIKdue6L4MastODNs6VfkGAkxOtdv5qEA0yNCerM2P6Ep2qs/TRCJEH2emzHTf
	 pbWfW55ZJ9X+ArkmxzV1/9wBPg74zGNxlMDjM4Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 6.6 319/322] drm/msm/dsi: Enable runtime PM
Date: Fri,  2 Feb 2024 20:06:56 -0800
Message-ID: <20240203035409.345415744@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit 6ab502bc1cf3147ea1d8540d04b83a7a4cb6d1f1 upstream.

Some devices power the DSI PHY/PLL through a power rail that we model
as a GENPD. Enable runtime PM to make it suspendable.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/543352/
Link: https://lore.kernel.org/r/20230620-topic-dsiphy_rpm-v2-2-a11a751f34f0@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -691,6 +691,10 @@ static int dsi_phy_driver_probe(struct p
 		return dev_err_probe(dev, PTR_ERR(phy->ahb_clk),
 				     "Unable to get ahb clk\n");
 
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
+
 	/* PLL init will call into clk_register which requires
 	 * register access, so we need to enable power and ahb clock.
 	 */


