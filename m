Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187AF502573;
	Thu, 17 Sep 2026 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668173; cv=none; b=i77CugTxLM/JYMtF4T7fu3HU0VQV/Mx2pNX7x+13rtcl8i4tU8Pjqie19LEUUy7k9ihP9poEj2o7z7y8yzb2/E4LPbtkhBj3WtvWYy4pypaS36BtwzkUdnd9j87FNfyksWL4RXBwtBGfqjtVQqIAD/tcwCH8CZjePBQrhZKab5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668173; c=relaxed/simple;
	bh=QbLrI5NNncBmhfDU8QQ0+wFcUUS/G6aAfZjlCPnrz0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJCCnSVqwgmO/5Nk68l1QdafpUaG+sRHokUgGYK9+zK1MTlAGFLpf3hrVoTanQNcZ+Tms/d0nDwKQV8TDaQb2cYLZURGcW6BCb6YwxHfRG4hgsC7GoTGkMPiEVxdwiGKQdH0ivMRvb/k2bR13R4XJSzly392quPSzA5D6JzfFKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2hQ1r43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2hQ1r43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669111F000FF;
	Thu, 17 Sep 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668172;
	bh=pCOU4AWH5bB1wbIAMi+2v9EXrHnmTcrUa0/H4QSb2x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2hQ1r438fU+CsnzahIvtmWVg1a4ROpHTRdy/nX+InAAvJiyiciEiFFLJUvzOz0Wx
	 tGuegu/8cb7+d9y3If7kwTtjO+5Ck9jKhz9Pi0Sv9ZwJlL+Do5gzWE2TpHrO58WxjN
	 oKW5B3Jk5TLVwiA6DPfb1astdvBiVqULoYG9grtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0338/1102] PCI: plda: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:04:41 +0100
Message-ID: <20260917151548.121085702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 4e4f9745f016c1631d00a4035b06f6e75d449e01 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-10-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/plda/pcie-plda-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/plda/pcie-plda-host.c b/drivers/pci/controller/plda/pcie-plda-host.c
index c45e37bdc54ff..9eaf565056fcb 100644
--- a/drivers/pci/controller/plda/pcie-plda-host.c
+++ b/drivers/pci/controller/plda/pcie-plda-host.c
@@ -676,8 +676,10 @@ EXPORT_SYMBOL_GPL(plda_pcie_host_init);
 
 void plda_pcie_host_deinit(struct plda_pcie_rp *port)
 {
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(port->bridge->bus);
 	pci_remove_root_bus(port->bridge->bus);
+	pci_unlock_rescan_remove();
 
 	plda_pcie_irq_domain_deinit(port);
 
-- 
2.53.0



