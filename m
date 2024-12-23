Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C9617A597;
	Mon, 23 Dec 2024 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970676; cv=none; b=LZqtpChh7UtbzkWmMSSg+I6DFnmx084VpVYQjpJvM3I+Sun5G/WyyVD0Axh/hVaYY4RniLFv0TotKkrjFJdpcdO8qftwqMsA/3teC4vPv2hc3vP2papLc0HBKI+hThhgSDyVKK7eJ4y5ErqRF2r1jzvqoSCAbsqSSII22CW16eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970676; c=relaxed/simple;
	bh=E+POcQj9O8gUZhC2/2otL8cPM4k7tL6r9A/3/hd4w44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EKAFi5rFD+5z5yY1xNqFyCQP6dJU7OYdQ9a2tsWnU6oXvhRn+irFOc9MzCstLGbEMTQpsVPh0DpFw8c77HrwjtAJhnpXBRfRJsqnitw9RRar1yUUi9rW71I6nianuTc05gBHqOHiNHuOLW+uo+yzgfUvs46HZV4RZKiHoe+PmzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWh180LD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWh180LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A02C4CED3;
	Mon, 23 Dec 2024 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970675;
	bh=E+POcQj9O8gUZhC2/2otL8cPM4k7tL6r9A/3/hd4w44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWh180LDIKBapu5t/fYsMTbsQli+KakUPwteHqoNbheDj6zFuO4AIlJI51BuJrEAw
	 Ykm4d2NSa3EWKx5D8LpGJ9/xifh2ijCw48u4Z4RLJna24sFvXxuv9doa7YlIgTmToG
	 hyv1/4N5cme+zHZmsLJjtoOckzx3wjRzDPsHRyFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andy Gospodarek <gospo@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/83] PCI: Add ACS quirk for Broadcom BCM5760X NIC
Date: Mon, 23 Dec 2024 16:58:47 +0100
Message-ID: <20241223155353.964022454@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajit Khaparde <ajit.khaparde@broadcom.com>

[ Upstream commit 524e057b2d66b61f9b63b6db30467ab7b0bb4796 ]

The Broadcom BCM5760X NIC may be a multi-function device.

While it does not advertise an ACS capability, peer-to-peer transactions
are not possible between the individual functions. So it is ok to treat
them as fully isolated.

Add an ACS quirk for this device so the functions can be in independent
IOMMU groups and attached individually to userspace applications using
VFIO.

[kwilczynski: commit log]
Link: https://lore.kernel.org/linux-pci/20240510204228.73435-1-ajit.khaparde@broadcom.com
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d0da564ac94b..2b3df65005ca 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5008,6 +5008,10 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_BROADCOM, 0x1750, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0x1751, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0x1752, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1760, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1761, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1762, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_BROADCOM, 0x1763, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
-- 
2.39.5



