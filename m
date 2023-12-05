Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536AD6FAF;
	Tue,  5 Dec 2023 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9dbueIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B75C433C7;
	Tue,  5 Dec 2023 03:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746884;
	bh=OLMcxAH3F3oxeZY7ftIBC5Fg1EbOhVgSn0jbdH6Y6sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9dbueIcE+weQ/KuE/b8boTWrGjPeXedAsgnX+hLg/bxiIZROn5GcFPeUQ/asbWZm
	 pC5zLHaBKWAYpVunfX51G/tUSnqndsKP/hO71smf1Dz0We7lnERHz3G6OwgklSKZUF
	 UWBwoCPkdedLIgJflCsfaFif9/0dqpAfb3zdnqRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Agarwal <ajayagarwal@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 55/71] PCI/ASPM: Disable only ASPM_STATE_L1 when driver disables L1
Date: Tue,  5 Dec 2023 12:16:53 +0900
Message-ID: <20231205031521.083189312@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajay Agarwal <ajayagarwal@google.com>

[ Upstream commit fb097dcd5a28c0a2325632405c76a66777a6bed9 ]

Previously pci_disable_link_state(PCIE_LINK_STATE_L1) disabled L1SS as well
as L1.  This is unnecessary since pcie_config_aspm_link() takes care that
L1SS is not enabled if L1 is disabled.

Disable only ASPM_STATE_L1 when the caller disables L1.  No functional
changes intended.

This is consistent with aspm_attr_store_common(), which disables only L1,
not L1SS, when L1 is disabled via the sysfs "l1_aspm" file.

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/20230504111301.229358-2-ajayagarwal@google.com
Signed-off-by: Ajay Agarwal <ajayagarwal@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Stable-dep-of: 3cb4f534bac0 ("Revert "PCI/ASPM: Disable only ASPM_STATE_L1 when driver, disables L1"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 8f934c88dcd76..8db6a9084a12a 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1110,8 +1110,7 @@ static int __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 	if (state & PCIE_LINK_STATE_L0S)
 		link->aspm_disable |= ASPM_STATE_L0S;
 	if (state & PCIE_LINK_STATE_L1)
-		/* L1 PM substates require L1 */
-		link->aspm_disable |= ASPM_STATE_L1 | ASPM_STATE_L1SS;
+		link->aspm_disable |= ASPM_STATE_L1;
 	if (state & PCIE_LINK_STATE_L1_1)
 		link->aspm_disable |= ASPM_STATE_L1_1;
 	if (state & PCIE_LINK_STATE_L1_2)
-- 
2.42.0



