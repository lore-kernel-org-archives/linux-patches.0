Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2903876AA;
	Tue, 10 Mar 2026 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141956; cv=none; b=eVvDC79FMG7iMSDc02OQCX95PeHNYb4/CEgX44fB8BqWbTLqMWWZMGcNeB35OLtWlQGLmTOFHl0YZLPi/nglgT2EeD161fERRmxQr+MNiBFymX/GhCNz0nLxXhE6iSfA5cS/rsnVhMgcBUx5QkcgwDBIRitmj/sKB8QMhQ3UuX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141956; c=relaxed/simple;
	bh=L6dC5xgoeZhjlszB5fUP0oQoaIXL1D2n8HleLQAt5BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fr0n+fndUCT82Xiv0q1O2uBQv3cTbuQW6u0StDDXXEpcOemdgT4FkEgkMAv5m8p45WCnb7l2dfdCvbf/WOE3tQVDASi2PHWe98nhby/kh4iCafOj0QRg4D0OMTtPllAYSW+lg3KT6uQnHCPYNFoas+7fslWksN/AdAfiYLggSuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9ZULhvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9ZULhvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0563C19423;
	Tue, 10 Mar 2026 11:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141956;
	bh=L6dC5xgoeZhjlszB5fUP0oQoaIXL1D2n8HleLQAt5BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9ZULhvfgBp8qHr+4skUp+b3vCaSM8ypTH4LyaWGr95tB/pfcxB22SYqZaAESnUn2
	 lxu1XLVVPLloON3z6mCalH3dw2w/PoeUju4JtcCzSADQsFest5LNpwSdqILUDaaINI
	 dB9NJe0E8/d6+69TUqbLc2LzpikADzwYFzqDx4WgU1gi9i9vErS1aswOsoy4bQTh56
	 Qg6hlNWENf64nCuSKT54n1WvAoXQTZWSo0WNjpGOZEE6bveN1DSRIBbMltE49rtuMo
	 AnZkX0MM1EMS/7GHdRUDn1oPixylPXpRXl4eeBgn/Mswc8BrzRejC1gHMy+XZZKVz5
	 AyMqWXE+/6opQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/314] PCI: dwc: Add L1 Substates context to ltssm_status of debugfs
Date: Tue, 10 Mar 2026 07:15:39 -0400
Message-ID: <63bf8736675868f98e2efdfd426ccf73b78eb56f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit 679ec639f29cbdaf36bd79bf3e98240fffa335ee ]

DWC core couldn't distinguish LTSSM state among L1.0, L1.1 and L1.2. But
the vendor glue driver may implement additional logic to convey this
information. So add two pseudo definitions for vendor glue drivers to
translate their internal L1 Substates for debugfs to show.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/1765503205-22184-1-git-send-email-shawn.lin@rock-chips.com
Stable-dep-of: 180c3cfe3678 ("Revert "PCI: dw-rockchip: Enumerate endpoints based on dll_link_up IRQ"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-debugfs.c | 2 ++
 drivers/pci/controller/dwc/pcie-designware.h         | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-debugfs.c b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
index 0fbf86c0b97e0..df98fee69892b 100644
--- a/drivers/pci/controller/dwc/pcie-designware-debugfs.c
+++ b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
@@ -485,6 +485,8 @@ static const char *ltssm_status_string(enum dw_pcie_ltssm ltssm)
 	DW_PCIE_LTSSM_NAME(DW_PCIE_LTSSM_RCVRY_EQ1);
 	DW_PCIE_LTSSM_NAME(DW_PCIE_LTSSM_RCVRY_EQ2);
 	DW_PCIE_LTSSM_NAME(DW_PCIE_LTSSM_RCVRY_EQ3);
+	DW_PCIE_LTSSM_NAME(DW_PCIE_LTSSM_L1_1);
+	DW_PCIE_LTSSM_NAME(DW_PCIE_LTSSM_L1_2);
 	default:
 		str = "DW_PCIE_LTSSM_UNKNOWN";
 		break;
diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 82336a204569f..6c04ac0196794 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -380,6 +380,10 @@ enum dw_pcie_ltssm {
 	DW_PCIE_LTSSM_RCVRY_EQ2 = 0x22,
 	DW_PCIE_LTSSM_RCVRY_EQ3 = 0x23,
 
+	/* Vendor glue drivers provide pseudo L1 substates from get_ltssm() */
+	DW_PCIE_LTSSM_L1_1 = 0x141,
+	DW_PCIE_LTSSM_L1_2 = 0x142,
+
 	DW_PCIE_LTSSM_UNKNOWN = 0xFFFFFFFF,
 };
 
-- 
2.51.0

