Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4BA13AA2F;
	Tue, 27 Feb 2024 13:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041660; cv=none; b=uQfPO/LS+3tvzuptOzVtYlW2xtjyzmUYkaFNjd4rTQ7lEHesd1+6vNPv8ce+yGeSk6zAxpyQhk8HV6YzGZrgavUgr0hzjhUmhwS0Gn7S2eZnaSLJzrXvYoHb7r9E1dSWn0gwFUyM/RKPXxzRRd1vgHDZf/1099CyujtLoFwx9Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041660; c=relaxed/simple;
	bh=SPpYxrQ15L9B/MMPtWjFwaUNuWGlFkEFb5c7OIwWrkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOq/wGLYtd7zjhShUo5OA4vWql16YRy8PUqfI99vP6t6e56ocw+63IRGkIusVwusIZjsYRx4dSGPEq5m6Ia3qlgoorJQgy2xHVizFnlXz6WkDWHN7QB2TaeL7nZSXYA8XO8e2QiDwJ/KtCJldX0u2ItpBEtUpvbTwRIYUuShbyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpL5ApFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpL5ApFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8A5C433F1;
	Tue, 27 Feb 2024 13:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041660;
	bh=SPpYxrQ15L9B/MMPtWjFwaUNuWGlFkEFb5c7OIwWrkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpL5ApFe0HkMGpIskvc3w/+yICqBIqSfZtQfD7lTOLmv+cXxljUezybGYTL7+2V2b
	 2z3JeACCrUwpMavX6iHsV3UuJ1gNdf3/x8HVO2Q+Hzj0I2iuzirfa34y899NspamMF
	 vhXajCLyaHUEloA6A1PzCH9Gx3NHT1OGgMFcarD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conrad Kostecki <conikost@gentoo.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/299] ahci: asm1166: correct count of reported ports
Date: Tue, 27 Feb 2024 14:22:17 +0100
Message-ID: <20240227131626.666263794@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 08745e7db8201..2b8f0c3c3879a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -657,6 +657,11 @@ MODULE_PARM_DESC(mobile_lpm_policy, "Default LPM policy for mobile chipsets");
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
 		hpriv->saved_port_map = 1;
-- 
2.43.0



