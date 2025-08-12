Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07582FDC49;
	Tue, 12 Aug 2025 18:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024298; cv=none; b=hO6GX0CSm6t+L9MS+FKIIXWYrUS/SKYUcbgq5lac7/4I0N9BO8Djf02q+Z8l4DFXxEsGg3/oSEO9ShfeGW0mxExV6Rz6L6T7Ih4ZdkRRVS41tCJ9cWwizLx8ww7zzKhgxaX2I3QQAFeoqj0a8OdnUCJMQx0RaxBFlNz3RLDVFMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024298; c=relaxed/simple;
	bh=nBpQO9yDoX6qW6LUMKkEZ2tWR9KwGwf9BfSLMI2ZAs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fY68EGvM6ORhhbOMoNpuFQC2L0ZNl69vSTLY/2Sy9BTHkdYORfsC34HZwVEROy/HED5HJPFu4V7B6+tQNw9ha2onpuB37+9Yc1MeKNT9zrjiyDHYuU1L0WAhY+TXMNoTCWSOBdJcEhnUC0Pd5ppUh7gnggxO4ydz+LhdUJQN7A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaVde2Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaVde2Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E808AC4CEF0;
	Tue, 12 Aug 2025 18:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024297;
	bh=nBpQO9yDoX6qW6LUMKkEZ2tWR9KwGwf9BfSLMI2ZAs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaVde2UveLrENRhh+mXeCcNxcg74kE89NSzDfMvIS+xLw/P0SD2w13Xa2a45QR3f3
	 IvtpylVxHLyNQY8jQg7n1/PHLk59G8/s6nRxozFpgWN7JoIyh3C+DlWJtHf4Smn/30
	 A04/WP0zjkqtYIPTxZ80aCfjDg9Dh3SxtrJWa6GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jiwei Sun <sunjw10@lenovo.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 331/627] PCI: Adjust the position of reading the Link Control 2 register
Date: Tue, 12 Aug 2025 19:30:26 +0200
Message-ID: <20250812173431.884697024@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d7f4ee634263..db6e142b082d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -105,13 +105,13 @@ int pcie_failed_link_retrain(struct pci_dev *dev)
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
@@ -123,6 +123,8 @@ int pcie_failed_link_retrain(struct pci_dev *dev)
 		pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
 	}
 
+	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
+
 	if ((lnksta & PCI_EXP_LNKSTA_DLLLA) &&
 	    (lnkctl2 & PCI_EXP_LNKCTL2_TLS) == PCI_EXP_LNKCTL2_TLS_2_5GT &&
 	    pci_match_id(ids, dev)) {
-- 
2.39.5



