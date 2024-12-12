Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B6821578E;
	Thu, 12 Dec 2024 15:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017253; cv=none; b=YwIV+wFLabx2o8wMRCjEO9ZMkduEaHZFvgRkP4hb4pWmU/XUuZylNbJJxtF3zI8ApuFzIgN61J7ugr6moyq1R6TOAGsPQzLnGjqPLLqMZ3dLroHaV4JIh1NfrdZ9YwMubOwf7gXjrn/XBKxOdWZGw/htxG2MymVskhoUklh+3QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017253; c=relaxed/simple;
	bh=S/iB0917nK56neTx0osRJHBXNA81TWPx6COc9+SJcOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYNHEzJkniw89H8pgOAEBlPO8To3qaeoHGPthnfIbwA7bRQYYMpYsqFbq2S1d+S/kTdvPY5FUXfafWRu2+g0VJoNimJBe5uBOlQAKoTk8GDa9DcEA2KpsXiMbPojz7/Arf40T+3gj5hzQNvatwJecun5EH47+d1eDMkvlHd4fHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtENqdv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtENqdv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3F9C4CECE;
	Thu, 12 Dec 2024 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017253;
	bh=S/iB0917nK56neTx0osRJHBXNA81TWPx6COc9+SJcOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtENqdv2oxVGYDoTOgSvK4HzIWfbTYQWT86dVTm8H2c/IsxiWOAMJK+FFMhLWsO8c
	 GMvdt8mRmUMtBYsNF+HPoxG9SMwgzMdLkKJSv1K27pWxcdFwbYiXgwAJix27pjQnN7
	 7IZaDkOEJZzsZo+nMGUOb7MLh27Rarr/eIs2/RvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mayank Rana <quic_mrana@quicinc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 395/466] PCI: starfive: Enable controller runtime PM before probing host bridge
Date: Thu, 12 Dec 2024 15:59:24 +0100
Message-ID: <20241212144322.371235839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mayank Rana <quic_mrana@quicinc.com>

[ Upstream commit 6168efbebace0db443185d4c6701ca8170a8788d ]

A PCI controller device, e.g., StarFive, is parent to PCI host bridge
device. We must enable runtime PM of the controller before enabling runtime
PM of the host bridge, which will happen in pci_host_probe(), to avoid this
warning:

  pcie-starfive 940000000.pcie: Enabling runtime PM for inactive device with active children

Fix this issue by enabling StarFive controller device's runtime PM before
calling pci_host_probe() in plda_pcie_host_init().

Link: https://lore.kernel.org/r/20241111-runtime_pm-v7-1-9c164eefcd87@quicinc.com
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mayank Rana <quic_mrana@quicinc.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/plda/pcie-starfive.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/plda/pcie-starfive.c b/drivers/pci/controller/plda/pcie-starfive.c
index c9933ecf68338..0564fdce47c2a 100644
--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -404,6 +404,9 @@ static int starfive_pcie_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	plda->host_ops = &sf_host_ops;
 	plda->num_events = PLDA_MAX_EVENT_NUM;
 	/* mask doorbell event */
@@ -413,11 +416,12 @@ static int starfive_pcie_probe(struct platform_device *pdev)
 	plda->events_bitmap <<= PLDA_NUM_DMA_EVENTS;
 	ret = plda_pcie_host_init(&pcie->plda, &starfive_pcie_ops,
 				  &stf_pcie_event);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync(&pdev->dev);
+		pm_runtime_disable(&pdev->dev);
 		return ret;
+	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
 	platform_set_drvdata(pdev, pcie);
 
 	return 0;
-- 
2.43.0



