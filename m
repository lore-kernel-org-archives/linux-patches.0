Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8987913EFE4;
	Tue, 27 Feb 2024 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043191; cv=none; b=d4Z0XrP7S66dJMqOUzR7Ibq/c+yAJ98JMtxTUaMkojPlEaTmoKCrDpJs4LD4xoLvQlZIQ3C/CIu8acJ7F4rw/ovKgp2zaTDK0CIO43csXSj+XobpxPxaYFhth2Os4xm28QKH66M1jfA9z03wDk4hzGBWEuwN4G8k489BZH1QTA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043191; c=relaxed/simple;
	bh=oEF8GhL3AzgRXef4NRiHJDa8QK0AsWNnsVmaFUtKJaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3cvq+/JKaATfy6miw0Q+30WKFnZkL7JVtewrwfk7Wm8Lr1lmUQNSmIeIHzNCc6rHG2b+BYgQHHZm1rKbIarhppaB5K+nSkOB4MK+RYgcP/Xt8emuoHaiOiS2QH2qbqDyHQW19uN9TNTizmo39r3QZfHini0ijeNi31fkf6qrkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1sz6G/Vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1sz6G/Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7814C433F1;
	Tue, 27 Feb 2024 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043191;
	bh=oEF8GhL3AzgRXef4NRiHJDa8QK0AsWNnsVmaFUtKJaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1sz6G/VmRH02izfiHReLo7c2IUmlU1ElcCfVF1mO+SxSS3A47oS76LzPnyGNME1bf
	 +CN9NJm68d8eKzFOW1mDsO818ci9Me9kBWnB7MafseS+ahULBhhG80i1SpM5gf4gyA
	 298TmVVhWF+j6ZBBTRtyOrtUL1M/cExn0f+H7apE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conrad Kostecki <conikost@gentoo.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/195] ahci: asm1166: correct count of reported ports
Date: Tue, 27 Feb 2024 14:24:42 +0100
Message-ID: <20240227131611.093577518@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 805645efb3ccf..e22124f42183f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -658,6 +658,11 @@ MODULE_PARM_DESC(mobile_lpm_policy, "Default LPM policy for mobile chipsets");
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



