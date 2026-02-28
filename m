Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C59637524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302556; cv=none; b=Z7O8P+3ccM0aZnu6Q1A0XMKHdq34+jTtBsqfgvOp3ZckbVIMG2UFMdDgxlDwKxm9v9ZhW8EUVyDL6kTY+j0HQ2kdwz8G0hwfJ1NoYuzzHWSog+mlVQNnN1wGx+GCWP8pPQw9MIGtqc+mxHg0Lqzmy1MFlI05AttTg4yEK3TJ7Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302556; c=relaxed/simple;
	bh=YoQp5zRFeMxXNM3b4/BbKRAXYYYmXjymMw+hCe7Aqec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AufqBESm83ffqlbrIseJdGVI3vvojILyaIwga7XXfteFMWjGWAmJlsQK1NyNp4RxPWM1zo10CKLR2O1+lQgTOTXXvNgnmZ/Q62XMWR+/y/w5cp/7XPGsiH6CDRSGkTY+3/9aplQTipFKFKVQxqzsM+P/S35W93Q26K7tHfKUAHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSomE6zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSomE6zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5571DC116D0;
	Sat, 28 Feb 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302555;
	bh=YoQp5zRFeMxXNM3b4/BbKRAXYYYmXjymMw+hCe7Aqec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSomE6zffzDOaBEdVpwyVt3GIz1amjBsWW6jQ6ylym3FM9qSiF4K+U5ZCLrrNe5Fc
	 3xtz4wzw18okf3hvS9FgNQmhBAzn//yI2bgAd0SDGyvoNKsv74w/CJy2CiHV7aOej/
	 bFMtDv9oMU6NVlGJa9Lyzt+LTykEaAOpYT/QrqLQ/kh/4PYcly6B9Bb0ClErQI+mq5
	 IhIbaeC3HD1C4AqxKCliWDsJvC+0H5om8E2TwDveYdX3DsFc74uEpyRnvQRcKnVrqj
	 6rUzZ0OB2Cehy17z+K/I714nGtF88gDDlsRaKchudnEl/Tyu0k4rTzJbKPWRZkRuAu
	 0Os+h7NCjCRrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/164] PCI: Do not attempt to set ExtTag for VFs
Date: Sat, 28 Feb 2026 13:13:19 -0500
Message-ID: <20260228181505.1600663-60-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 73711730a1128d91ebca1a6994ceeb18f36cb0cd ]

The bit for enabling extended tags is Reserved and Preserved (RsvdP) for
VFs, according to PCIe r7.0 section 7.5.3.4 table 7.21.  Hence, bail out
early from pci_configure_extended_tags() if the device is a VF.

Otherwise, we may see incorrect log messages such as:

  kernel: pci 0000:af:00.2: enabling Extended Tags

(af:00.2 is a VF)

Fixes: 60db3a4d8cc9 ("PCI: Enable PCIe Extended Tags if supported")
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Link: https://patch.msgid.link/20251112095442.1913258-1-haakon.bugge@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a8d431731d22b..b54474ae17477 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2103,7 +2103,8 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	u16 ctl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
+	/* PCI_EXP_DEVCTL_EXT_TAG is RsvdP in VFs */
+	if (!pci_is_pcie(dev) || dev->is_virtfn)
 		return 0;
 
 	ret = pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-- 
2.51.0

