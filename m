Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A77A72610;
	Thu,  3 Jul 2025 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554048; cv=none; b=HD8j4Oe+alSk7vNFW0KRC3gBi9L0XGwlMYKC02VLGwIVDAvSt+UFp26FliygrkpqOAyRMUY1VUdii3/U3AXayYQ3AoqJomSNo8xi0pVTFFGeqRms56v/lDjhDTMOJNNldcY91Q4AXAUaWbs1HCdv2tRBXg5sayRNm9dle+NUWeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554048; c=relaxed/simple;
	bh=YlCq9w9nei1xBQF+Vib7T/0XaXOE+lG+pO+oV9XvGKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjbOmbpJM83MD0pC3L3EFdyBMqy3EDkAmWtJtIUvRsrHaFW1hAX8BOOM9ThayzEAInz92eo65+7zfSgQlB0tbVsjsQIylcHf1jjHtuVIK4/dAZ6/JNCQGQ6ps6i8qQV4PaXeP3wCl+3rSgygy+en1I7fLYJ5EG61hKnH9wogFH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mgzxAss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mgzxAss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE71BC4CEE3;
	Thu,  3 Jul 2025 14:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554048;
	bh=YlCq9w9nei1xBQF+Vib7T/0XaXOE+lG+pO+oV9XvGKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mgzxAssLLVyzgLKE1LfffF1Z/3pkhJv/IS0iEz6sSKNBSMfOTBjZXVGnFVPBpJ8v
	 tbfhjrfCrSJu7wtMJSTr43msSV1MRJGWL9O5VdJwgHfyqLiiSjKdMWen4qwkHx9rSk
	 Xwx6DUPDQwdxo/3tMfe5b20FzR7dnioFH3cClwBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <quic_qianyu@quicinc.com>,
	Wenbin Yao <quic_wenbyao@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/218] PCI: dwc: Make link training more robust by setting PORT_LOGIC_LINK_WIDTH to one lane
Date: Thu,  3 Jul 2025 16:39:31 +0200
Message-ID: <20250703143956.887628736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wenbin Yao <quic_wenbyao@quicinc.com>

[ Upstream commit af3c6eacce0c464f28fe0e3d365b3860aba07931 ]

As per DWC PCIe registers description 4.30a, section 1.13.43, NUM_OF_LANES
named as PORT_LOGIC_LINK_WIDTH in PCIe DWC driver, is referred to as the
"Predetermined Number of Lanes" in PCIe r6.0, sec 4.2.7.2.1, which explains
the conditions required to enter Polling.Configuration:

  Next state is Polling.Configuration after at least 1024 TS1 Ordered Sets
  were transmitted, and all Lanes that detected a Receiver during Detect
  receive eight consecutive training sequences ...

  Otherwise, after a 24 ms timeout the next state is:

    Polling.Configuration if,

      (i) Any Lane, which detected a Receiver during Detect, received eight
      consecutive training sequences ... and a minimum of 1024 TS1 Ordered
      Sets are transmitted after receiving one TS1 or TS2 Ordered Set.

      And

      (ii) At least a predetermined set of Lanes that detected a Receiver
      during Detect have detected an exit from Electrical Idle at least
      once since entering Polling.Active.

	Note: This may prevent one or more bad Receivers or Transmitters
	from holding up a valid Link from being configured, and allow for
	additional training in Polling.Configuration. The exact set of
	predetermined Lanes is implementation specific.

	Note: Any Lane that receives eight consecutive TS1 or TS2 Ordered
	Sets should have detected an exit from Electrical Idle at least
	once since entering Polling.Active.

In a PCIe link supporting multiple lanes, if PORT_LOGIC_LINK_WIDTH is set
to lane width the hardware supports, all lanes that detect a receiver
during the Detect phase must receive eight consecutive training sequences.
Otherwise, LTSSM will not enter Polling.Configuration and link training
will fail.

Therefore, always set PORT_LOGIC_LINK_WIDTH to 1, regardless of the number
of lanes the port actually supports, to make link up more robust. This
setting will not affect the intended link width if all lanes are
functional. Additionally, the link can still be established with at least
one lane if other lanes are faulty.

Co-developed-by: Qiang Yu <quic_qianyu@quicinc.com>
Signed-off-by: Qiang Yu <quic_qianyu@quicinc.com>
Signed-off-by: Wenbin Yao <quic_wenbyao@quicinc.com>
[mani: subject change]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[bhelgaas: update PCIe spec citation, format quote]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20250422103623.462277-1-quic_wenbyao@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.c b/drivers/pci/controller/dwc/pcie-designware.c
index 6d6cbc8b5b2c6..d40afe74ddd1a 100644
--- a/drivers/pci/controller/dwc/pcie-designware.c
+++ b/drivers/pci/controller/dwc/pcie-designware.c
@@ -752,22 +752,19 @@ static void dw_pcie_link_set_max_link_width(struct dw_pcie *pci, u32 num_lanes)
 	/* Set link width speed control register */
 	lwsc = dw_pcie_readl_dbi(pci, PCIE_LINK_WIDTH_SPEED_CONTROL);
 	lwsc &= ~PORT_LOGIC_LINK_WIDTH_MASK;
+	lwsc |= PORT_LOGIC_LINK_WIDTH_1_LANES;
 	switch (num_lanes) {
 	case 1:
 		plc |= PORT_LINK_MODE_1_LANES;
-		lwsc |= PORT_LOGIC_LINK_WIDTH_1_LANES;
 		break;
 	case 2:
 		plc |= PORT_LINK_MODE_2_LANES;
-		lwsc |= PORT_LOGIC_LINK_WIDTH_2_LANES;
 		break;
 	case 4:
 		plc |= PORT_LINK_MODE_4_LANES;
-		lwsc |= PORT_LOGIC_LINK_WIDTH_4_LANES;
 		break;
 	case 8:
 		plc |= PORT_LINK_MODE_8_LANES;
-		lwsc |= PORT_LOGIC_LINK_WIDTH_8_LANES;
 		break;
 	default:
 		dev_err(pci->dev, "num-lanes %u: invalid value\n", num_lanes);
-- 
2.39.5



