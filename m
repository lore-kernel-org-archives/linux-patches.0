Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8BF5A79B;
	Thu, 16 Jul 2026 14:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210722; cv=none; b=bP8thPMjG33UGJRds54nh7/B7TN+prP0l6FLdeZrxxstcwJWRg0InVlPBrx5aF22DjZPf17uDGbjpms14G18zCw87PPWGBjHTj6DPa2aLsQlROswcK0dFNwGtoCy3DXed5lVSXJ96ILi66iHuqHXW3CsQHroI24if5bGAfqeTws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210722; c=relaxed/simple;
	bh=AnLcd9W5eNZf+8pP4ohDWvRbhO5npbUu/qR2nKlwG9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r85wmw7j+pH98qAVIT0lBNU5wRFlKxVzurwirQeSxZtzaLvGrx8y7Yqb6gpGzfTDSGG6iLt76gXpqsOFB3kETebyEgGe6Ufussfm4sdxPQ0K9iutbT/60mfewt8xqFOUl+/cpyUEgjPvkog1ILgEvMgRDgCvPRUjmC97RGixvas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIhaf1o+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIhaf1o+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A510D1F000E9;
	Thu, 16 Jul 2026 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210721;
	bh=7utAeZdQ1JbsJ7LhwHVKPAibtCI78U1Nb19ir6BBBnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIhaf1o+HPJGleiBqqgnf/FjGxzUOQaAdphvoZacw5khkztQ1YggJxqpAec8HC6bM
	 xyjlTruYjQnepHVQnrEFKINokWTVnri4uTyKn1jOtOdz/qkkIi22bCp3tFzA6Je1Hq
	 PZ6SU0gb4aM8JfMQt+/shacLcSp26In7vz0DC0cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>
Subject: [PATCH 6.18 138/480] PCI: Always lift 2.5GT/s restriction in PCIe failed link retraining
Date: Thu, 16 Jul 2026 15:28:05 +0200
Message-ID: <20260716133047.695533720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 72780f7964684939d7d2f69c348876213b184484 upstream.

Discard Vendor:Device ID matching in the PCIe failed link retraining quirk
and ignore the link status for the removal of the 2.5GT/s speed clamp,
whether applied by the quirk itself or the firmware earlier on.  Revert to
the original target link speed if this final link retraining has failed.

This is so that link training noise in hot-plug scenarios does not make a
link remain clamped to the 2.5GT/s speed where an event race has led the
quirk to apply the speed clamp for one device, only to leave it in place
for a subsequent device to be plugged in.

Refer to the Link Capabilities register directly for the maximum link speed
determination so as to streamline backporting.

Fixes: a89c82249c37 ("PCI: Work around PCIe link training failures")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: stable@vger.kernel.org # v6.5+
Link: https://patch.msgid.link/alpine.DEB.2.21.2512080331530.49654@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   51 ++++++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 33 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -79,11 +79,10 @@ static bool pcie_lbms_seen(struct pci_de
  * Restrict the speed to 2.5GT/s then with the Target Link Speed field,
  * request a retrain and check the result.
  *
- * If this turns out successful and we know by the Vendor:Device ID it is
- * safe to do so, then lift the restriction, letting the devices negotiate
- * a higher speed.  Also check for a similar 2.5GT/s speed restriction the
- * firmware may have already arranged and lift it with ports that already
- * report their data link being up.
+ * If this turns out successful, or where a 2.5GT/s speed restriction has
+ * been previously arranged by the firmware and the port reports its link
+ * already being up, lift the restriction, in a hope it is safe to do so,
+ * letting the devices negotiate a higher speed.
  *
  * Otherwise revert the speed to the original setting and request a retrain
  * again to remove any residual state, ignoring the result as it's supposed
@@ -94,52 +93,38 @@ static bool pcie_lbms_seen(struct pci_de
  */
 int pcie_failed_link_retrain(struct pci_dev *dev)
 {
-	static const struct pci_device_id ids[] = {
-		{ PCI_VDEVICE(ASMEDIA, 0x2824) }, /* ASMedia ASM2824 */
-		{}
-	};
-	u16 lnksta, lnkctl2;
+	u16 lnksta, lnkctl2, oldlnkctl2;
 	int ret = -ENOTTY;
+	u32 lnkcap;
 
 	if (!pci_is_pcie(dev) || !pcie_downstream_port(dev) ||
 	    !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
 		return ret;
 
 	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
+	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &oldlnkctl2);
 	if (!(lnksta & PCI_EXP_LNKSTA_DLLLA) && pcie_lbms_seen(dev, lnksta)) {
-		u16 oldlnkctl2;
-
 		pci_info(dev, "broken device, retraining non-functional downstream link at 2.5GT/s\n");
-
-		pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &oldlnkctl2);
 		ret = pcie_set_target_speed(dev, PCIE_SPEED_2_5GT, false);
-		if (ret) {
-			pci_info(dev, "retraining failed\n");
-			pcie_set_target_speed(dev, PCIE_LNKCTL2_TLS2SPEED(oldlnkctl2),
-					      true);
-			return ret;
-		}
-
-		pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
+		if (ret)
+			goto err;
 	}
 
 	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
-
-	if ((lnksta & PCI_EXP_LNKSTA_DLLLA) &&
-	    (lnkctl2 & PCI_EXP_LNKCTL2_TLS) == PCI_EXP_LNKCTL2_TLS_2_5GT &&
-	    pci_match_id(ids, dev)) {
-		u32 lnkcap;
-
+	pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
+	if ((lnkctl2 & PCI_EXP_LNKCTL2_TLS) == PCI_EXP_LNKCTL2_TLS_2_5GT &&
+	    (lnkcap & PCI_EXP_LNKCAP_SLS) != PCI_EXP_LNKCAP_SLS_2_5GB) {
 		pci_info(dev, "removing 2.5GT/s downstream link speed restriction\n");
-		pcie_capability_read_dword(dev, PCI_EXP_LNKCAP, &lnkcap);
 		ret = pcie_set_target_speed(dev, PCIE_LNKCAP_SLS2SPEED(lnkcap), false);
-		if (ret) {
-			pci_info(dev, "retraining failed\n");
-			return ret;
-		}
+		if (ret)
+			goto err;
 	}
 
 	return ret;
+err:
+	pci_info(dev, "retraining failed\n");
+	pcie_set_target_speed(dev, PCIE_LNKCTL2_TLS2SPEED(oldlnkctl2), true);
+	return ret;
 }
 
 static ktime_t fixup_debug_start(struct pci_dev *dev,


