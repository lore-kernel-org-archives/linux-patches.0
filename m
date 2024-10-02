Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8011CF5EE;
	Wed,  2 Oct 2024 13:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875258; cv=none; b=Ilgo+Jf2ja0vpymF59AN+1YNtLLz7KqgaEzhPFFO+J6ItWGmFEg+GLsTDaEj2TIxuc7KGsU/cpp4bvMBD8cLSiPlvpWSl9WO1GPGdU6l33XFGaduSNd3LBbL28G8AvwT92Fu0lpMYeqgocVcBVp+DeU9hBaEZrwz2T4gobOpaMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875258; c=relaxed/simple;
	bh=mC2f/p2emuvbmVk0iIbhlWgOt1Mftq1mezRr3M/FSIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt92opy/E0iZTlOoLFHTeBKbr4R5PpPvuL0X388HCMpxtENpK4VxJufs25dupnIiui0ZNBeVPK9JjzM1AT+6eo9eEU4x2SLYwqxvGI5yNscws8V2asPnB9pmBpoYbHZX88hhV2ZzValW4jUwy/Ot9gCI9HvzzUJ1qboxGSXNnlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tM8l/95O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM8l/95O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88816C4CEC5;
	Wed,  2 Oct 2024 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875257;
	bh=mC2f/p2emuvbmVk0iIbhlWgOt1Mftq1mezRr3M/FSIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tM8l/95OBhTLxFUWRaR+OT6hIlXQikGZb8SyBOmMZxc/XeBSjCWc6GT5+HR05Bq1B
	 P++E4SXK9iZB2T71Q0DSmFcwkuFszmkdYm4fvG8QplRQEtbjOgXfxjUEiuu/xh1TO+
	 It595VmQzCYy+nxzozUYLrLDMu4W6tsEaJS1PPN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 042/695] perf/dwc_pcie: Always register for PCIe bus notifier
Date: Wed,  2 Oct 2024 14:50:40 +0200
Message-ID: <20241002125824.170018049@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

[ Upstream commit b94b05478fb6a09033bf70c6edd03f8930a0fe24 ]

When the PCIe devices are discovered late, the driver can't find
the PCIe devices and returns in the init without registering with
the bus notifier. Due to that the devices which are discovered late
the driver can't register for this.

Register for bus notifier & driver even if the device is not found
as part of init.

Fixes: af9597adc2f1 ("drivers/perf: add DesignWare PCIe PMU driver")
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Reviewed-by: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240816-dwc_pmu_fix-v2-3-198b8ab1077c@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/dwc_pcie_pmu.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index 85a5155d60180..f205ecad2e4c0 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -726,7 +726,6 @@ static struct platform_driver dwc_pcie_pmu_driver = {
 static int __init dwc_pcie_pmu_init(void)
 {
 	struct pci_dev *pdev = NULL;
-	bool found = false;
 	int ret;
 
 	for_each_pci_dev(pdev) {
@@ -738,11 +737,7 @@ static int __init dwc_pcie_pmu_init(void)
 			pci_dev_put(pdev);
 			return ret;
 		}
-
-		found = true;
 	}
-	if (!found)
-		return -ENODEV;
 
 	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 				      "perf/dwc_pcie_pmu:online",
-- 
2.43.0



