Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E6733B6CC;
	Tue, 12 May 2026 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609515; cv=none; b=pUeR8/1zcG0Y6ZwC/7rbor5km1vfjVNz0ChpZN9FEuGKFWZk5HlauKWkUfbGLPVfjQWWpvRuRamFanMC/FRZy1qEn2ii61oTcur3R6bn7kmy/V4zRZX59w6vEMM36HcltqbGS3Z+3nzgbigsnI2Jv++1g2xC7ha8ZCayJ307YL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609515; c=relaxed/simple;
	bh=yxsLDP+dMaDlk++U6xa1cMcQRQdIUTPBoAjrSdJ8SMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qrJPMa6oblWxp9wjAukGEF6JviKP3laCda1z8tqDOzjBSEp1wawsCaX44Rx0hXshPDwZ6VQXknKfSGZyOdRP6Mqm6Qu1nGEFxty7lkPIlby6YzxW9sahkMT3jX7uXC5nLXUooZzIJDRhAHsciFcihGrx7OMVjGbgfpeClrK5P6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCJtftaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCJtftaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0444C2BCB0;
	Tue, 12 May 2026 18:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609515;
	bh=yxsLDP+dMaDlk++U6xa1cMcQRQdIUTPBoAjrSdJ8SMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCJtftaAxdCFFVulFwyjwsxOtQTA9c+PvHmqVT6yuy0BrVu85JkAzPptaVHKTVWJH
	 8qps+2Q1iaLMicK9k6IzuB+4XLksN76xQltYVtqpM9dTzpWKnrht1aBt7Ok8wdFYU3
	 5/2Zuw1DEYfIrdl1fCrp7JkJJrYlecvsBKVr2upo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Adri=C3=A0=20Vilanova=20Mart=C3=ADnez?= <me@avm99963.com>
Subject: [PATCH 7.0 225/307] PCI/ASPM: Fix pci_clear_and_set_config_dword() usage
Date: Tue, 12 May 2026 19:40:20 +0200
Message-ID: <20260512173944.866739713@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit cc33985d26c92a5c908c0185239c59ec35b8637c upstream.

When aspm_calc_l12_info() programs the L1 PM Substates Control 1 register
fields Common_Mode_Restore_Time, LTR_L1.2_THRESHOLD_Value and _Scale, it
invokes pci_clear_and_set_config_dword() in an incorrect way:

For the bits to clear it selects those corresponding to the field.  So far
so good.  But for the bits to set it passes a full register value.
pci_clear_and_set_config_dword() performs a boolean OR operation which
sets all bits of that value, not just the ones that were just cleared.

Thus, when setting the LTR_L1.2_THRESHOLD_Value and _Scale on the child of
an ASPM link, aspm_calc_l12_info() also sets the Common_Mode_Restore_Time.
That's a spec violation:  PCIe r7.0 sec 7.8.3.3 says this field is RsvdP
for Upstream Ports.  On Adrià's Pixelbook Eve, Common_Mode_Restore_Time
of the Intel 7265 "Stone Peak" wifi card is zero, yet aspm_calc_l12_info()
does not preserve the zero bits but instead programs the value calculated
for the Root Port into the wifi card.

Likewise, when setting the Common_Mode_Restore_Time on the Root Port,
aspm_calc_l12_info() also changes the LTR_L1.2_THRESHOLD_Value and _Scale
from the initial 163840 nsec to 237568 nsec (due to ORing those fields),
only to reduce it afterwards to 106496 nsec.

Amend all invocations of pci_clear_and_set_config_dword() to only set bits
which are cleared.

Finally, when setting the T_POWER_ON_Value and _Scale on the Root Port and
the wifi card, aspm_calc_l12_info() fails to preserve bits declared RsvdP
and instead overwrites them with zeroes.  Replace pci_write_config_dword()
with pci_clear_and_set_config_dword() to avoid this.

Fixes: aeda9adebab8 ("PCI/ASPM: Configure L1 substate settings")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220705#c22
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Adrià Vilanova Martínez <me@avm99963.com>
Cc: stable@vger.kernel.org # v4.11+
Link: https://patch.msgid.link/5c1752d7512eed0f4ea57b84b12d7ee08ca61fc5.1771226659.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aspm.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -706,22 +706,29 @@ static void aspm_calc_l12_info(struct pc
 	}
 
 	/* Program T_POWER_ON times in both ports */
-	pci_write_config_dword(parent, parent->l1ss + PCI_L1SS_CTL2, ctl2);
-	pci_write_config_dword(child, child->l1ss + PCI_L1SS_CTL2, ctl2);
+	pci_clear_and_set_config_dword(parent, parent->l1ss + PCI_L1SS_CTL2,
+				       PCI_L1SS_CTL2_T_PWR_ON_VALUE |
+				       PCI_L1SS_CTL2_T_PWR_ON_SCALE, ctl2);
+	pci_clear_and_set_config_dword(child, child->l1ss + PCI_L1SS_CTL2,
+				       PCI_L1SS_CTL2_T_PWR_ON_VALUE |
+				       PCI_L1SS_CTL2_T_PWR_ON_SCALE, ctl2);
 
 	/* Program Common_Mode_Restore_Time in upstream device */
 	pci_clear_and_set_config_dword(parent, parent->l1ss + PCI_L1SS_CTL1,
-				       PCI_L1SS_CTL1_CM_RESTORE_TIME, ctl1);
+				       PCI_L1SS_CTL1_CM_RESTORE_TIME,
+				       ctl1 & PCI_L1SS_CTL1_CM_RESTORE_TIME);
 
 	/* Program LTR_L1.2_THRESHOLD time in both ports */
 	pci_clear_and_set_config_dword(parent, parent->l1ss + PCI_L1SS_CTL1,
 				       PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
 				       PCI_L1SS_CTL1_LTR_L12_TH_SCALE,
-				       ctl1);
+				       ctl1 & (PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
+					       PCI_L1SS_CTL1_LTR_L12_TH_SCALE));
 	pci_clear_and_set_config_dword(child, child->l1ss + PCI_L1SS_CTL1,
 				       PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
 				       PCI_L1SS_CTL1_LTR_L12_TH_SCALE,
-				       ctl1);
+				       ctl1 & (PCI_L1SS_CTL1_LTR_L12_TH_VALUE |
+					       PCI_L1SS_CTL1_LTR_L12_TH_SCALE));
 
 	if (pl1_2_enables || cl1_2_enables) {
 		pci_clear_and_set_config_dword(parent,


