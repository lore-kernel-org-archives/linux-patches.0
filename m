Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB7E38FA3;
	Fri,  9 Jan 2026 12:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961722; cv=none; b=sa45XyysXJCfT0bFAfAI+HCpKCrlqdkw739VsatuyF8yBiB94omJStQkyqVTqk8LxXUxubhva7ENoKJ693QH1BYJLn0U/+v6shx+ISI83uyjq7WbWxmBZV1Tf33Q2tKoCKSt73FZC65lEcnZgx1ACie0pwRnOpnsoUIGqUuYLPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961722; c=relaxed/simple;
	bh=RUFlViskqYxmWMiatZGV+X30SdBxgUKjFVyF70cUf2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9qY+YkLgqLgXQ/iRWULvjE1SpXZD1jgQtUgfo0a39sqcHz9o/ScH2x3Jsg7L7o28ygeWxZcj4veiMvjJc6qPvMCnZzgmxvpdl9KVrSJ9iw0uD5rFnUHLosEwxldcv12rBV+iVni4VyhlNf1MspFIWXYN/SdKuZODrKVbgHo0fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIUbT0Tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIUbT0Tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCF2C4CEF1;
	Fri,  9 Jan 2026 12:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961722;
	bh=RUFlViskqYxmWMiatZGV+X30SdBxgUKjFVyF70cUf2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIUbT0Tvmlx/RMZ3uTHal/W3SJ/xHBRtEuL64oCTEWvU9MJaipqTGloyN6DwYCtdO
	 bh+xk2bscnlsRFj9qyajKRbMkrtYg+6vyZ13Tu0+JEzCaZU7gXr72h6stf22fc2103
	 o1sRCOP8jEbfo6Id5SvOa4/eDwOU2puDrptJVvUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/634] PCI: keystone: Exit ks_pcie_probe() for invalid mode
Date: Fri,  9 Jan 2026 12:36:32 +0100
Message-ID: <20260109112121.723619623@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 95d9c3f0e4546eaec0977f3b387549a8463cd49f ]

Commit under Fixes introduced support for PCIe EP mode on AM654x platforms.
When the mode happens to be either "DW_PCIE_RC_TYPE" or "DW_PCIE_EP_TYPE",
the PCIe Controller is configured accordingly. However, when the mode is
neither of them, an error message is displayed, but the driver probe
succeeds. Since this "invalid" mode is not associated with a functional
PCIe Controller, the probe should fail.

Fix the behavior by exiting "ks_pcie_probe()" with the return value of
"-EINVAL" in addition to displaying the existing error message when the
mode is invalid.

Fixes: 23284ad677a9 ("PCI: keystone: Add support for PCIe EP in AM654x Platforms")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251029080547.1253757-4-s-vadapalli@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index c868d36f1177b..35f807524f56f 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1342,6 +1342,8 @@ static int ks_pcie_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(dev, "INVALID device type %d\n", mode);
+		ret = -EINVAL;
+		goto err_get_sync;
 	}
 
 	ks_pcie_enable_error_irq(ks_pcie);
-- 
2.51.0



