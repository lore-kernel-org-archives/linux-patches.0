Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB289275B18;
	Fri, 21 Nov 2025 13:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731560; cv=none; b=VEtp+IPCmC8OBgjyB33X9/OyFm+Mw+Pzxrgn++KEEUR0HfkbfGV2rSxDWUwdHWGvPKQz/IJDn9jvDPCflZi2ugwYti/EMbovkfr5AzUhGF3owUlInVCktKR8dzUPRLNDeRfSdsBSNN2lV+x1QQKORwFgQayXY1p2sdC/xBXJ/6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731560; c=relaxed/simple;
	bh=NeztcHSB27qOC6lGCgj7yFKaOeP2pzDDmu6iPFEGmg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTbwr1wCTfr40P0y9Phfo6G655FfeMntut2wtyt5QaO42EXCC2DU7X68O7W8rC1W7tlz1K3uz11txP8U+pXJsbHMijrPqhHk9o7mebYrOVUkDiN2A0Eqzco/SxJbrgeKTUuswQE37la4Q0oeKfeuDpKpRW9A069nmHKa2DDRRrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo30JAm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo30JAm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443A7C4CEF1;
	Fri, 21 Nov 2025 13:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731560;
	bh=NeztcHSB27qOC6lGCgj7yFKaOeP2pzDDmu6iPFEGmg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fo30JAm2anaWbSWp69hqB3dLQR5GPguDUXOr0BCDXnZ1Tf240fRTqhn/mwUNfRTQX
	 ylIFmAYg5IxxRTt1PfzQ3smfxbS+g65o8BK1ANRQ20DNURzCYUBL8CiIK4r50DqBEX
	 fRF8rWpoxD4XqqcNJilIkn8zkv7Pgd4CqhoSDdYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.17 229/247] pmdomain: samsung: Rework legacy splash-screen handover workaround
Date: Fri, 21 Nov 2025 14:12:56 +0100
Message-ID: <20251121130202.953894341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit fccac54b0d3d0602f177bb79f203ae6fbea0e32a upstream.

Limit the workaround for the lack of the proper splash-screen handover
handling to the legacy ARM 32bit systems and replace forcing a sync_state
by explicite power domain shutdown. This approach lets compiler to
optimize it out on newer ARM 64bit systems.

Suggested-by: Ulf Hansson <ulf.hansson@linaro.org>
Fixes: 0745658aebbe ("pmdomain: samsung: Fix splash-screen handover by enforcing a sync_state")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/samsung/exynos-pm-domains.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pmdomain/samsung/exynos-pm-domains.c b/drivers/pmdomain/samsung/exynos-pm-domains.c
index f53e1bd24798..5c3aa8983087 100644
--- a/drivers/pmdomain/samsung/exynos-pm-domains.c
+++ b/drivers/pmdomain/samsung/exynos-pm-domains.c
@@ -128,6 +128,15 @@ static int exynos_pd_probe(struct platform_device *pdev)
 	pd->pd.power_on = exynos_pd_power_on;
 	pd->local_pwr_cfg = pm_domain_cfg->local_pwr_cfg;
 
+	/*
+	 * Some Samsung platforms with bootloaders turning on the splash-screen
+	 * and handing it over to the kernel, requires the power-domains to be
+	 * reset during boot.
+	 */
+	if (IS_ENABLED(CONFIG_ARM) &&
+	    of_device_is_compatible(np, "samsung,exynos4210-pd"))
+		exynos_pd_power_off(&pd->pd);
+
 	on = readl_relaxed(pd->base + 0x4) & pd->local_pwr_cfg;
 
 	pm_genpd_init(&pd->pd, NULL, !on);
@@ -146,15 +155,6 @@ static int exynos_pd_probe(struct platform_device *pdev)
 				parent.np, child.np);
 	}
 
-	/*
-	 * Some Samsung platforms with bootloaders turning on the splash-screen
-	 * and handing it over to the kernel, requires the power-domains to be
-	 * reset during boot. As a temporary hack to manage this, let's enforce
-	 * a sync_state.
-	 */
-	if (!ret)
-		of_genpd_sync_state(np);
-
 	pm_runtime_enable(dev);
 	return ret;
 }
-- 
2.52.0



