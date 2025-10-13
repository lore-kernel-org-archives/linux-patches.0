Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E883C30BF4B;
	Mon, 13 Oct 2025 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369609; cv=none; b=jRMv1aowIwuFZ4+EyzoLhZoPA1dwyi/bc6t74vJHFZEVGwF7Sd9yg5kFrZxJJjpRXL0aWrYQ5AJI375TzK+mRi/QirE3tAFyqFyy7pUHXkmGufaWU4mV4T+Gf6Yf32SBFTpEpsuhYfF4y6akjRZgh46VdpB5mNFyOM18bTgkqp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369609; c=relaxed/simple;
	bh=5amPIBOXHBEM734YoGWv/dn60dnqVdUAMkvak55mjQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjJsXeIyfBdUhS2BvHUH/fmZL5Vksh2mjNBe4NZ+eq/DzybEh0/Pyx8CPeysp73rjUOhlhXTNFQovw9v3Zy4UHb1OeRDVcVNOG7wtfkQICEsuLkQxqFPzovSM0cTeClvjdc4R0XzPYbjelHlmLAyYE5gdegLIQ4t679ZZFwPdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNOGLE1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNOGLE1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6643CC4CEE7;
	Mon, 13 Oct 2025 15:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369608;
	bh=5amPIBOXHBEM734YoGWv/dn60dnqVdUAMkvak55mjQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNOGLE1tRJsCpHrtAt90JARIaJodIEcod632F8JZc5gKWMm3UjESlK4YptxrKv7Eg
	 Qhf6axCukk5Kzc8DQGDV5LDIF/xo7IPW9VVENDAwbsSgUYOf40szfRL2IliBs6iQUc
	 kezYVz9uDQ31TnwopEiJpCvdFoz6i/gqFKptf/xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 273/563] PCI: qcom: Restrict port parsing only to PCIe bridge child nodes
Date: Mon, 13 Oct 2025 16:42:14 +0200
Message-ID: <20251013144421.163716153@linuxfoundation.org>
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

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit 45df22935bdc6bbddf87f38a57ae7257244cf3cf ]

The qcom_pcie_parse_ports() function currently iterates over all available
child nodes of the PCIe controller's device tree node. This includes
unrelated nodes such as OPP (Operating Performance Points) nodes, which do
not contain the expected 'reset' and 'phy' properties. As a result, parsing
fails and the driver falls back to the legacy method of parsing the
controller node directly. However, this fallback also fails when properties
are shifted to the Root Port node, leading to probe failure.

Fix this by restricting the parsing logic to only consider child nodes with
device_type = "pci", which is the expected and required property for PCIe
bridge nodes as per the pci-bus-common.yaml dtschema.

Fixes: a2fbecdbbb9d ("PCI: qcom: Add support for parsing the new Root Port binding")
Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
[mani: reworded subject and description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250826-pakala-v3-3-721627bd5bb0@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 294babe1816e4..fbed7130d7475 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1740,6 +1740,8 @@ static int qcom_pcie_parse_ports(struct qcom_pcie *pcie)
 	int ret = -ENOENT;
 
 	for_each_available_child_of_node_scoped(dev->of_node, of_port) {
+		if (!of_node_is_type(of_port, "pci"))
+			continue;
 		ret = qcom_pcie_parse_port(pcie, of_port);
 		if (ret)
 			goto err_port_del;
-- 
2.51.0



