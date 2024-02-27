Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F2C13AA55;
	Tue, 27 Feb 2024 13:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041474; cv=none; b=reZZay9ByAMWi5LXNEOicgqYbng6ksWbD0ZT1r9ZPsNGxosaP8/Znh3aBrWO5b7JzJcS2by2HOafikjho5IHu71QtKeWjofEGg6vgIOBUKQP0OluaeR4sn5CueoOmdITLP4pFBsbhsJZKuIabkJ1DFB6g7x0o0h9xM90YftbZgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041474; c=relaxed/simple;
	bh=n0i4uaADD/qZlOD2WWmbEIduLVX3iWuxB6HVjV7uHVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ncj8IYuCI3Bg31cjjQzCatxFAORBmwhaN+/ilrAz9dT+rzve1qg/vgd79ATUorwZHztcBPDuirwPmqHEJxGIrEv3/ADUVSnALFJ55u0vEAk0Jyt0F4XmUfIoBO2cp5z2R1qB5ntS3wWYCyB3XM0Z1WrQBjOjp710jLKjmxCPfjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2d+vBJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2d+vBJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203D7C433F1;
	Tue, 27 Feb 2024 13:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041474;
	bh=n0i4uaADD/qZlOD2WWmbEIduLVX3iWuxB6HVjV7uHVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2d+vBJeyeYDFi+GPlHTE7VYoOlG8DYuZGCF6F60FCldI3ylh5gyKc+0azHhI3GAk
	 xxVe31yDXe3e6utXrQyMQFHfGjQFPiE9nRlNiXBcUX9S0DI5i2em758IxGxT5+vQB1
	 JcyQzIuklgjEfEaZ9ODdtoFQejdKpGpQtIhzMZdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conrad Kostecki <conikost@gentoo.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/52] ahci: asm1166: correct count of reported ports
Date: Tue, 27 Feb 2024 14:26:05 +0100
Message-ID: <20240227131549.132327188@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

From: Conrad Kostecki <conikost@gentoo.org>

[ Upstream commit 0077a504e1a4468669fd2e011108db49133db56e ]

The ASM1166 SATA host controller always reports wrongly,
that it has 32 ports. But in reality, it only has six ports.

This seems to be a hardware issue, as all tested ASM1166
SATA host controllers reports such high count of ports.

Example output: ahci 0000:09:00.0: AHCI 0001.0301
32 slots 32 ports 6 Gbps 0xffffff3f impl SATA mode.

By adjusting the port_map, the count is limited to six ports.

New output: ahci 0000:09:00.0: AHCI 0001.0301
32 slots 32 ports 6 Gbps 0x3f impl SATA mode.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=211873
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218346
Signed-off-by: Conrad Kostecki <conikost@gentoo.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ab3ea47ecce3a..abdfd440987b4 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -634,6 +634,11 @@ MODULE_PARM_DESC(mobile_lpm_policy, "Default LPM policy for mobile chipsets");
 static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 					 struct ahci_host_priv *hpriv)
 {
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA && pdev->device == 0x1166) {
+		dev_info(&pdev->dev, "ASM1166 has only six ports\n");
+		hpriv->saved_port_map = 0x3f;
+	}
+
 	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
 		dev_info(&pdev->dev, "JMB361 has only one port\n");
 		hpriv->force_port_map = 1;
-- 
2.43.0



