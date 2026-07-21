Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDF4470452;
	Tue, 21 Jul 2026 19:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660576; cv=none; b=Yysf0fHiqCeCSnE74z6s51XIecwhTB6YKYCg+sNDsg2sMzAQpSIanID4wsM0SBo2rtpDW+15oSTuHbXDcod72U21cS75NEkRhtcd4mCkUZwwuuSrvy9WRwO/xvzJxSIeZkKB55VJ+lvoHSo30Xjhgu3BFAuHDYQWcG0Gzz1YdyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660576; c=relaxed/simple;
	bh=b4u7UU/v8TG5G5EBMyQV+RSZB440RBSYNezziozVy/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pd34I1GuzRrjyxWMpeNdcLadpmOSuDq4jfgs5EWx4njEcXInp2olJTuaKNvc76Ip6cgrDLp1EjifVDSdlCNoUDchF/etaQMq9iuILTmJB/8bnLQ1LArBs3PSFvNa1/Futp8OP71lVud/wYVvxNwQlYVOMYixBup9786nvE7x17I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jr5Ur+4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jr5Ur+4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4B71F00ACF;
	Tue, 21 Jul 2026 19:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660573;
	bh=JIbtW7od5RsQaYuY0LLiSxmJbW79+3s5o/Ai7SK8dmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jr5Ur+4eMZArJC3oXLFjg6Z/iJOG8dWlnPGvpr+iZHxFC+Zgz4+eKn6t4kSVKwslm
	 zWggZevKyK5bu8MXIaV4E+wjBUN+dT6SVcyytNeCKyahZ8LIuqUe5M+W/PiTpm8jYp
	 28VSdLnvPjRFdN9AO4dTvn2bt6lOSOjZebhXEWg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1031/2077] PCI: dwc: Avoid dwc_pcie_rasdes_debugfs_deinit() NULL dereference when no RAS DES capability
Date: Tue, 21 Jul 2026 17:11:44 +0200
Message-ID: <20260721152617.133892039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4bfc1748f2d737..449c67e7930d3f 100644
--- a/drivers/pci/controller/dwc/pcie-designware-debugfs.c
+++ b/drivers/pci/controller/dwc/pcie-designware-debugfs.c
@@ -558,6 +558,9 @@ static void dwc_pcie_rasdes_debugfs_deinit(struct dw_pcie *pci)
 {
 	struct dwc_pcie_rasdes_info *rinfo = pci->debugfs->rasdes_info;
 
+	if (!rinfo)
+		return;
+
 	mutex_destroy(&rinfo->reg_event_lock);
 }
 
-- 
2.53.0



