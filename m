Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C732C93B;
	Fri, 17 Oct 2025 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714559; cv=none; b=gLi9XcPMCeWIFoDCOxhyiDBB1WTBBNriIpqRdyc6qo6/TIJsurDb1WsFfxHpf74nrztCtnniC627m+xS3fKcD2ig9AIRLPN1YTn4baYOcEftB/V2Z7TyeA3r9Y24calSHowC668KKIkz8QALQgDMoIA4vAej9TcxZCvNgbapftQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714559; c=relaxed/simple;
	bh=6QfVrfxTd2YqMkA2Vw6OuMMkOMdC3ADz3XoyE0CiOHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuZf2pHYmol3A9bN99aYnfl8aS5zjcT+ANbuKHOG86q3nQSNOpvcMeY92H4Xi9OZjbF+WeQ1DfDs16HYjOwBawPHxGiPiv7RCLv26yXiwXw4kMoPfnNMRbrirlOBfJuu6v5fD4so7I/a0A5g14VGvL9qT4MXRI0AS/XkPF8k6OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dvbiyfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dvbiyfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBAFC4CEE7;
	Fri, 17 Oct 2025 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714559;
	bh=6QfVrfxTd2YqMkA2Vw6OuMMkOMdC3ADz3XoyE0CiOHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dvbiyfLSA53YGKkD0jNCxshSs8VR7g63hpxeSas3PUL612i9k+RcpjXjPjHy6yjj
	 V/1aRjxDLLO+MCTyZc/KNJC7JAFkV1bR6H1x+6yHlZwpFrFIRt109yjLl/Pjip/AkL
	 9DxCARR2B2z57/hQ2hirh8Ov4N0v4iEArYLbPfLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.12 188/277] PCI: tegra194: Handle errors in BPMP response
Date: Fri, 17 Oct 2025 16:53:15 +0200
Message-ID: <20251017145153.987376724@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidya Sagar <vidyas@nvidia.com>

commit f8c9ad46b00453a8c075453f3745f8d263f44834 upstream.

The return value from tegra_bpmp_transfer() indicates the success or
failure of the IPC transaction with BPMP. If the transaction succeeded, we
also need to check the actual command's result code.

If we don't have error handling for tegra_bpmp_transfer(), we will set the
pcie->ep_state to EP_STATE_ENABLED even when the tegra_bpmp_transfer()
command fails. Thus, the pcie->ep_state will get out of sync with reality,
and any further PERST# assert + deassert will be a no-op and will not
trigger the hardware initialization sequence.

This is because pex_ep_event_pex_rst_deassert() checks the current
pcie->ep_state, and does nothing if the current state is already
EP_STATE_ENABLED.

Thus, it is important to have error handling for tegra_bpmp_transfer(),
such that the pcie->ep_state can not get out of sync with reality, so that
we will try to initialize the hardware not only during the first PERST#
assert + deassert, but also during any succeeding PERST# assert + deassert.

One example where this fix is needed is when using a rock5b as host.
During the initial PERST# assert + deassert (triggered by the bootloader on
the rock5b) pex_ep_event_pex_rst_deassert() will get called, but for some
unknown reason, the tegra_bpmp_transfer() call to initialize the PHY fails.
Once Linux has been loaded on the rock5b, the PCIe driver will once again
assert + deassert PERST#. However, without tegra_bpmp_transfer() error
handling, this second PERST# assert + deassert will not trigger the
hardware initialization sequence.

With tegra_bpmp_transfer() error handling, the second PERST# assert +
deassert will once again trigger the hardware to be initialized and this
time the tegra_bpmp_transfer() succeeds.

Fixes: c57247f940e8 ("PCI: tegra: Add support for PCIe endpoint mode in Tegra194")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
[cassel: improve commit log]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250922140822.519796-8-cassel@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-tegra194.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -1205,6 +1205,7 @@ static int tegra_pcie_bpmp_set_ctrl_stat
 	struct mrq_uphy_response resp;
 	struct tegra_bpmp_message msg;
 	struct mrq_uphy_request req;
+	int err;
 
 	/*
 	 * Controller-5 doesn't need to have its state set by BPMP-FW in
@@ -1227,7 +1228,13 @@ static int tegra_pcie_bpmp_set_ctrl_stat
 	msg.rx.data = &resp;
 	msg.rx.size = sizeof(resp);
 
-	return tegra_bpmp_transfer(pcie->bpmp, &msg);
+	err = tegra_bpmp_transfer(pcie->bpmp, &msg);
+	if (err)
+		return err;
+	if (msg.rx.ret)
+		return -EINVAL;
+
+	return 0;
 }
 
 static int tegra_pcie_bpmp_set_pll_state(struct tegra_pcie_dw *pcie,
@@ -1236,6 +1243,7 @@ static int tegra_pcie_bpmp_set_pll_state
 	struct mrq_uphy_response resp;
 	struct tegra_bpmp_message msg;
 	struct mrq_uphy_request req;
+	int err;
 
 	memset(&req, 0, sizeof(req));
 	memset(&resp, 0, sizeof(resp));
@@ -1255,7 +1263,13 @@ static int tegra_pcie_bpmp_set_pll_state
 	msg.rx.data = &resp;
 	msg.rx.size = sizeof(resp);
 
-	return tegra_bpmp_transfer(pcie->bpmp, &msg);
+	err = tegra_bpmp_transfer(pcie->bpmp, &msg);
+	if (err)
+		return err;
+	if (msg.rx.ret)
+		return -EINVAL;
+
+	return 0;
 }
 
 static void tegra_pcie_downstream_dev_to_D0(struct tegra_pcie_dw *pcie)


