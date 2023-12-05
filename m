Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269F86FAF;
	Tue,  5 Dec 2023 03:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQBSrWbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95908C433C7;
	Tue,  5 Dec 2023 03:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746887;
	bh=ge3ezNGkyCvnwKUYIsmlQB7nu1WErq+LsY8ZXXvl25k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQBSrWbmRW3kFA//4zyinw/VyaPnoTfwW5fot7bHXEA57cyQ8cqD4MZ0LESG3kjBf
	 Tk5/RpWm8DpSoHAbx1qWFOCx50pX//LyYSedKUrNbBbLvpeuO/Rm9tdnaQ0Dc65Zwg
	 hT6nLi0iu/u8+mp7GhuJe2M3Mk2amf3BK2oIAGz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/71] Revert "PCI/ASPM: Disable only ASPM_STATE_L1 when driver, disables L1"
Date: Tue,  5 Dec 2023 12:16:54 +0900
Message-ID: <20231205031521.132882208@linuxfoundation.org>
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 3cb4f534bac010258b2688395c2f13459a932be9 ]

This reverts commit fb097dcd5a28c0a2325632405c76a66777a6bed9.

After fb097dcd5a28 ("PCI/ASPM: Disable only ASPM_STATE_L1 when driver
disables L1"), disabling L1 via pci_disable_link_state(PCIE_LINK_STATE_L1),
then enabling one substate, e.g., L1.1, via sysfs actually enables *all*
the substates.

For example, r8169 disables L1 because of hardware issues on a number of
systems, which implicitly disables the L1.1 and L1.2 substates.

On some systems, L1 and L1.1 work fine, but L1.2 causes missed rx packets.
Enabling L1.1 via the sysfs "aspm_l1_1" attribute unexpectedly enables L1.2
as well as L1.1.

After fb097dcd5a28, pci_disable_link_state(PCIE_LINK_STATE_L1) adds only
ASPM_L1 (but not any of the L1.x substates) to the "aspm_disable" mask:

  --- Before fb097dcd5a28
  +++ After fb097dcd5a28

  # r8169 disables L1:
    pci_disable_link_state(PCIE_LINK_STATE_L1)
  -   disable |= ASPM_L1 | ASPM_L1_1 | ASPM_L1_2 | ...  # disable L1, L1.x
  +   disable |= ASPM_L1                                # disable L1 only

  # write "1" to sysfs "aspm_l1_1" attribute:
    l1_1_aspm
      aspm_attr_store_common(state = ASPM_L1_1)
        disable &= ~ASPM_L1_1              # enable L1.1
        if (state & (ASPM_L1_1 | ...))     # if enabling any substate
          disable &= ~ASPM_L1              # enable L1

  # final state:
  - disable = ASPM_L1_2 | ...              # L1, L1.1 enabled; L1.2 disabled
  + disable = 0                            # L1, L1.1, L1.2 all enabled

Enabling an L1.x substate removes the substate and L1 from the
"aspm_disable" mask.  After fb097dcd5a28, the substates were not added to
the mask when disabling L1, so enabling one substate implicitly enables all
of them.

Revert fb097dcd5a28 so enabling one substate doesn't enable the others.

Link: https://lore.kernel.org/r/c75931ac-7208-4200-9ca1-821629cf5e28@gmail.com
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
[bhelgaas: work through example in commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 8db6a9084a12a..8f934c88dcd76 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1110,7 +1110,8 @@ static int __pci_disable_link_state(struct pci_dev *pdev, int state, bool sem)
 	if (state & PCIE_LINK_STATE_L0S)
 		link->aspm_disable |= ASPM_STATE_L0S;
 	if (state & PCIE_LINK_STATE_L1)
-		link->aspm_disable |= ASPM_STATE_L1;
+		/* L1 PM substates require L1 */
+		link->aspm_disable |= ASPM_STATE_L1 | ASPM_STATE_L1SS;
 	if (state & PCIE_LINK_STATE_L1_1)
 		link->aspm_disable |= ASPM_STATE_L1_1;
 	if (state & PCIE_LINK_STATE_L1_2)
-- 
2.42.0



