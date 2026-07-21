Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6611B2DBF75;
	Tue, 21 Jul 2026 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657352; cv=none; b=daeULX+9AkCWIhgpiJsd7Qleou7J1uP8Fe8QCGLKVTmTLCSRCXdk6Caj8ECsZ61qOnUVj48XGZTYM93gOn28igvFsvWyu6Qz1YDF4RZ+YTtnKH+X1sULSJV7VzXX16Wy14kSeTj429i913TmM/xYw7f7mHrh1WEHpj0AOjdfBp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657352; c=relaxed/simple;
	bh=OI38GYRUFTVL+L29G3zLkgm34X4Suib8tvKr8HQH6Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnByRkfkSH6iGTw89stWxpQ8fGpnO0SuEM4ywH0VE55n7ShbbQMnnNwUrjLeStfNeff9XiSRsd0QO8WUYiqJzMYOJnDi6YH7MXkRrqATX/UftKERQ8Is7yO7IN0d4mGW7Q5XCRltQkmZ9cBDEKLyre4Gb+g3p8fK9AhHasrbiVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcZwyFbB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcZwyFbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5B91F000E9;
	Tue, 21 Jul 2026 18:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657351;
	bh=r5L25XZfI0nSGH534CmwJ7qN91ANg+jSeCvwgUV0M4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcZwyFbBr0qsQTQnonn0nfoBPWrX7uv+yb5pPCTIgGp+vBwlqnPpVSle/UntGdI9z
	 SzBmPRdZurrkqPJLWgfNyQ0nqPFWRoCt+Cl5FSHk82zqNfrg8c0WJKbTxLY4SX9uku
	 SGXFeix/l1WkluV9Zq/savVPgRCjL/EGee80jW7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0731/1611] PCI: dwc: Avoid dwc_pcie_rasdes_debugfs_deinit() NULL dereference when no RAS DES capability
Date: Tue, 21 Jul 2026 17:14:07 +0200
Message-ID: <20260721152531.822510713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit 26b67fa10ef84ea667942491b50e6261a45f098d ]

dwc_pcie_rasdes_debugfs_init() returns success when the controller has no
RAS DES capability, leaving pci->debugfs->rasdes_info unset. The common
debugfs teardown path still calls dwc_pcie_rasdes_debugfs_deinit(), which
dereferences rasdes_info unconditionally.

Return early when no RAS DES state was allocated. In that case no RAS DES
mutex was initialized, so there is nothing to destroy.

Fixes: 4fbfa17f9a07 ("PCI: dwc: Add debugfs based Silicon Debug support for DWC")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
[mani: reworded subject]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/0f97352506d8d813f70f441de4d63fcd5b7d1c3e.1779123847.git.shuvampandey1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-debugfs.c b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
index bc741d2261fbbb..0c81058e32fc9f 100644
--- a/drivers/pci/controller/dwc/pcie-designware-debugfs.c
+++ b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
@@ -560,6 +560,9 @@ static void dwc_pcie_rasdes_debugfs_deinit(struct dw_pcie *pci)
 {
 	struct dwc_pcie_rasdes_info *rinfo = pci->debugfs->rasdes_info;
 
+	if (!rinfo)
+		return;
+
 	mutex_destroy(&rinfo->reg_event_lock);
 }
 
-- 
2.53.0



