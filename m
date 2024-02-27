Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B0A13B7AB;
	Tue, 27 Feb 2024 14:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043982; cv=none; b=uTKNRQDBt5eVw+zmFVJ7S68eusQgy5w6fIA4DPWE+oF9RPoTryYXsirswX1xW7ujr7WqUg8g1sJFVy+ULHmQ6OLbV6hRcq5skvHUPDsBWQTHtU4tdA+sLvYbfoN8Wh3fQAFZhulfps7mj6uxqBT81jrrTz8TB/kyJI+5CSd3/R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043982; c=relaxed/simple;
	bh=m70hRhSvsDeq6GMj0XrbsXZ2K5F2xURAb1uggjPG5rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JBYZ6iXVgifSij6XWib4vESLGoPGw7BCrZAz/sO95o6MpZdGMkXNPQQKP4gp7c9FQ4uCMVVRb/qinBOfSvRM1XOMljnyjx2eBfNhgOICnKf4UbJ4pfF+rA3DzpkrXaHxKKNi0uRTYp00wg+dqdzHeCFwmFF55E6OWyiek6Xh8Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nu5Q7V7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nu5Q7V7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F55AC433C7;
	Tue, 27 Feb 2024 14:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043981;
	bh=m70hRhSvsDeq6GMj0XrbsXZ2K5F2xURAb1uggjPG5rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nu5Q7V7Tv6n7LpZFgEGNQWDmWhGh/pRm2ip3dzy4pRyjK461B0p+6/2f0tVNDkUMW
	 qI7JsxUHyYIWFf0LbXmICfOnMjRR0CD9mGpvqGddyBF1t/ofZw6DbMy+E6kn0m75Na
	 YVy7UoWai0kGA12aeLVKbG0qMKG4DDRJmoiZub8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conrad Kostecki <conikost@gentoo.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/122] ahci: asm1166: correct count of reported ports
Date: Tue, 27 Feb 2024 14:26:21 +0100
Message-ID: <20240227131559.367290351@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4297a8d69dbf7..8bfada4843d83 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -654,6 +654,11 @@ MODULE_PARM_DESC(mobile_lpm_policy, "Default LPM policy for mobile chipsets");
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



