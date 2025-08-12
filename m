Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED512AE90;
	Tue, 12 Aug 2025 19:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026138; cv=none; b=ALjZ2OXdDHKi8/YKkW46F5YWfvDphHyWhMEbsb0PxDga2mAVWPyAGTpWXzpWwyufdk2i/QaYiQ1y8yjaI5MmiTOdADXIRg52r2qBI49vhe38XZFlK6ncopKstiz+OHLPjqSrndPOV8crqvdhjj6qinwr0Wqo7gPx8mNWgpaL15M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026138; c=relaxed/simple;
	bh=Dc/9CsvCIq2Aq8sVB/hR9lsyWNJYnFxhtP4EICV5o44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0caB2eLdK/T3GUg3JThmSbotiNyPwfTbSPVREK98cQ6OxiBMebrmhMIw2zqSHGNUKYg5foWOEA4jFq0/XaOWb2hXWsakWfZP/T4fUVlHBzJKt+3kQP57q/1KC8i2ZDC5Y+SVEs9IH5gNW61dOGMJnStKvbdBzeFT9aoUEzt57o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vvf4Wv+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vvf4Wv+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A57C4CEF1;
	Tue, 12 Aug 2025 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026138;
	bh=Dc/9CsvCIq2Aq8sVB/hR9lsyWNJYnFxhtP4EICV5o44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vvf4Wv+rIxhBL6P79KONDkMhewZydj+jTJtWjtn/nPNH3VcurYS8eGQJB+eGTb06L
	 9Io8nCLmos9UwWDNCzASsMeZlnW0WY04C0l2fVeJ3W/CuKhHPwJlZfjAFzLgBnss8C
	 uzujsLVUum0SwW3hnxE1o5yHt6vDIu6FhTugbMqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jiwei Sun <sunjw10@lenovo.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 247/480] PCI: Adjust the position of reading the Link Control 2 register
Date: Tue, 12 Aug 2025 19:47:35 +0200
Message-ID: <20250812174407.644371388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiwei Sun <sunjw10@lenovo.com>

[ Upstream commit b85af48de3ece4e5bbdb2248a5360a409991cf67 ]

In a89c82249c37 ("PCI: Work around PCIe link training failures"), if the
speed limit is set to 2.5 GT/s and the retraining is successful, an attempt
will be made to lift the speed limit. One condition for lifting the speed
limit is to check whether the link speed field of the Link Control 2
register is PCI_EXP_LNKCTL2_TLS_2_5GT.

However, since de9a6c8d5dbf ("PCI/bwctrl: Add pcie_set_target_speed() to
set PCIe Link Speed"), the `lnkctl2` local variable does not undergo any
changes during the speed limit setting and retraining process. As a result,
the code intended to lift the speed limit is not executed.

To address this issue, adjust the position of the Link Control 2 register
read operation in the code and place it before its use.

Fixes: de9a6c8d5dbf ("PCI/bwctrl: Add pcie_set_target_speed() to set PCIe Link Speed")
Suggested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20250123055155.22648-3-sjiwei@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d0f7b749b9a6..6e29f2b39dce 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -109,13 +109,13 @@ int pcie_failed_link_retrain(struct pci_dev *dev)
 	    !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
 		return ret;
 
-	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
 	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
 	if (!(lnksta & PCI_EXP_LNKSTA_DLLLA) && pcie_lbms_seen(dev, lnksta)) {
-		u16 oldlnkctl2 = lnkctl2;
+		u16 oldlnkctl2;
 
 		pci_info(dev, "broken device, retraining non-functional downstream link at 2.5GT/s\n");
 
+		pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &oldlnkctl2);
 		ret = pcie_set_target_speed(dev, PCIE_SPEED_2_5GT, false);
 		if (ret) {
 			pci_info(dev, "retraining failed\n");
@@ -127,6 +127,8 @@ int pcie_failed_link_retrain(struct pci_dev *dev)
 		pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
 	}
 
+	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
+
 	if ((lnksta & PCI_EXP_LNKSTA_DLLLA) &&
 	    (lnkctl2 & PCI_EXP_LNKCTL2_TLS) == PCI_EXP_LNKCTL2_TLS_2_5GT &&
 	    pci_match_id(ids, dev)) {
-- 
2.39.5



