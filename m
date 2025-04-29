Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFAAC148;
	Tue, 29 Apr 2025 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948786; cv=none; b=hi2vUtU7+Smej+FGHZhG0Rm83nspLeF684mNBXdDSPEAMddPTVSx0Xo5JpjjVVY0H/TSz25rDm8Nc5FPOZ+AkhtsC3JO6AKsXnCavO26CVuRDtFv30u2Xz3lg9hYUAMSZ8V6HAU3v6wDJvHneAzxieoRHfXgJZ7XwPRYF9UsplM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948786; c=relaxed/simple;
	bh=T7TG7atGx9jJ4q/dYUpaJg7DPzFbuFwk3Fqnyysmqzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/eYwvsjYzf1D1u12pqhcm3QL7GnEagy2Ljq0AmbZ1xCse3cl6x7f5D0ozbUUvzvyBU42jLQiCfwNVGPttzSUSjhnmqf2vrjQtn7KubB3sihiy1F5KWZIhS4GVqJSyyKrZFeerB0bAxqfHGjndMEkL01p9I/ds7Tcfy2m3RVhTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkQb7+qS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkQb7+qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12583C4CEE3;
	Tue, 29 Apr 2025 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948786;
	bh=T7TG7atGx9jJ4q/dYUpaJg7DPzFbuFwk3Fqnyysmqzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkQb7+qSxJVlH8I/hhl18Uh5lM9pPy/GRP7G37JEooDAbq6fBsNOFfu3cEgwEyMNR
	 4ucE0oXwEdYtH8bVYkLSWmwg7p32RLAbZzNCXMMJBT4xak/vjZiK4jxrbj27StM1wC
	 23TQppLiJZ4RKo51GZD2nmPjZ3OLk9/YBzEpSBTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 5.15 112/373] PCI: brcmstb: Fix missing of_node_put() in brcm_pcie_probe()
Date: Tue, 29 Apr 2025 18:39:49 +0200
Message-ID: <20250429161127.779266856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <svarbanov@suse.de>

commit 2df181e1aea4628a8fd257f866026625d0519627 upstream.

A call to of_parse_phandle() is incrementing the refcount, and as such,
the of_node_put() must be called when the reference is no longer needed.

Thus, refactor the existing code and add a missing of_node_put() call
following the check to ensure that "msi_np" matches "pcie->np" and after
MSI initialization, but only if the MSI support is enabled system-wide.

Cc: stable@vger.kernel.org # v5.10+
Fixes: 40ca1bf580ef ("PCI: brcmstb: Add MSI support")
Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250122222955.1752778-1-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-brcmstb.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1231,7 +1231,7 @@ static const struct of_device_id brcm_pc
 
 static int brcm_pcie_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node, *msi_np;
+	struct device_node *np = pdev->dev.of_node;
 	struct pci_host_bridge *bridge;
 	const struct pcie_cfg_data *data;
 	struct brcm_pcie *pcie;
@@ -1306,9 +1306,14 @@ static int brcm_pcie_probe(struct platfo
 		goto fail;
 	}
 
-	msi_np = of_parse_phandle(pcie->np, "msi-parent", 0);
-	if (pci_msi_enabled() && msi_np == pcie->np) {
-		ret = brcm_pcie_enable_msi(pcie);
+	if (pci_msi_enabled()) {
+		struct device_node *msi_np = of_parse_phandle(pcie->np, "msi-parent", 0);
+
+		if (msi_np == pcie->np)
+			ret = brcm_pcie_enable_msi(pcie);
+
+		of_node_put(msi_np);
+
 		if (ret) {
 			dev_err(pcie->dev, "probe of internal MSI failed");
 			goto fail;


