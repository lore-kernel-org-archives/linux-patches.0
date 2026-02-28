Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60112383C77
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302119; cv=none; b=fdp3ExIs7juOPEA1QK0AdzlcowA3nWBetx8lgIRDkj1VG3OGQ21z9sFO34G7eVpcUzesriQcGN5D0ahNaZjmuVxFiUmegcdJ+jpShCWaatyMEBh3jZrWkAdBz1N+D2+MQc76uZDYmGdoLphQ7CN1yQctnRtsvxr6/nG/xsyrT2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302119; c=relaxed/simple;
	bh=/XDierQ22nZEwmL5z+KfcGczeQWhQi7wh42Ii5BnCZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QAco4TlS/s9r4nkwmt1RpW9/sqTJaAFLkUoPu2nz4X5oS4k+duUyB0KCzuwANZSGod9OTxJ9+M03jCY3u6a6yJKA2UpkEnW8s4/AoHIyZzneV5Uj9IZ/y1+YOP745i+4FUhRbxht4AuG7iq1BvhXgCtKRR22nvOI6X/EwMIQ8mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxwWPah+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxwWPah+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF32CC19425;
	Sat, 28 Feb 2026 18:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302119;
	bh=/XDierQ22nZEwmL5z+KfcGczeQWhQi7wh42Ii5BnCZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxwWPah+vmKI84oaaFPrnQxh/X8eIrwqsJ6bbY14vK/1mXCmWzhd5bz01ahshL8ez
	 y68GnT5/qxeycBAuGwhzIPVeU8w2ZrrAei2S4s9jjn7bMcQVADWcLmBC6f2lpiwNTY
	 4MHJYaqUM/94415rdYIcXQZum/SvV3yHUq1fAILE1Tb6vjIcAmh/Thv7+e0jDTZWKH
	 BYLb4YTjtQggHg9GtzYOy/+R2p0/mOYnzK1uSDo/Us8U3kPbtu4M+y0UBKaPLFbAgy
	 hDeLMo1gpkp8yx+ggl64gMG1L+D0Y0hMY5KLXu/0MHh4PWlsqCTuF6ZoXeIooCBwPn
	 saA+FKhyXWnKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/283] PCI: Do not attempt to set ExtTag for VFs
Date: Sat, 28 Feb 2026 13:04:11 -0500
Message-ID: <20260228180709.1583486-109-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 5557290b63dc1..9b277a91d0cb4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2101,7 +2101,8 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
 	u16 ctl;
 	int ret;
 
-	if (!pci_is_pcie(dev))
+	/* PCI_EXP_DEVCTL_EXT_TAG is RsvdP in VFs */
+	if (!pci_is_pcie(dev) || dev->is_virtfn)
 		return 0;
 
 	ret = pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &cap);
-- 
2.51.0

