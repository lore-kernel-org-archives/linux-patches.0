Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3DC434E2C;
	Tue, 21 Jul 2026 20:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664438; cv=none; b=l3RIotEb0YKLlSByw28HM4iuVWbGlaYC7WqW5bmp0LEkVvITuXbPWxo1oQraW6OE0pMbEWw9fh9iDqNAeMi+64K6RZpLLDLzNRetrb6HLXceTAjhMEQmFSrjqsvFAwecAcTHkI2owCm1K7psHr+lG0t6XWcj+vMg88mkyQi8Tq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664438; c=relaxed/simple;
	bh=wgfFzryfr3czG83kSLfR+8ifsxNJyeW8jgbZYkWqSdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiFWZobjExnImanS12C8sT2v2Yw8LVs9r5a0g8ZO+ingXI5AZl2riA+IFbOxCYPSMFs9ik+K3SYubJTxOXJf7ifOAbjnSOt2Lm0hezn/atzPYt8xSJdZvdYFaZwUYybhRDQIBEXtpQQW9LHQ0iTWic+oYG3G3LaBfoEhKgCkrA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9LRQprD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9LRQprD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3121F000E9;
	Tue, 21 Jul 2026 20:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664437;
	bh=8SIG2qHA1MBkxymSRZGcbgofOrS6inN6gKVjbnyZrJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9LRQprDkpekYVFT0dPg2VBbz06f3u5PQyGUpyze699x7fqD0FONFBAz99I+K2qRS
	 Q79pxqi5S6dGD0IY0Ij/KkhJddWG+mOnqGY7zlNj8adpJ8ZDf+Lvx+W+BS7O9La7Zt
	 trAGaL4H+OKk+vdK+VlxgQBNqtII7dzF4bKT+CEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nenciarini <mnencia@kcore.it>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1157/1276] PCI: Skip Resizable BAR restore on read error
Date: Tue, 21 Jul 2026 17:26:40 +0200
Message-ID: <20260721152511.908269320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Marco Nenciarini <mnencia@kcore.it>

[ Upstream commit ee7471fe968d210939be9046089a924cd23c8c3b ]

pci_restore_rebar_state() uses the Resizable BAR Control register to decide
how many BARs to restore (nbars) and which BAR each iteration addresses
(bar_idx).

When a device does not respond, config reads typically return
PCI_ERROR_RESPONSE (~0).  Both fields are 3 bits wide, so nbars and bar_idx
both evaluate to 7, past the spec's valid ranges for both fields.
pci_resource_n() then returns an unrelated resource slot, whose size is
used to derive a nonsensical value written back to the Resizable BAR
Control register.

Bail out if any Resizable BAR Control read returns PCI_ERROR_RESPONSE. No
further BARs are touched, which is safe because a config read that returns
PCI_ERROR_RESPONSE indicates the device is unreachable and restoration is
pointless.

Fixes: d3252ace0bc6 ("PCI: Restore resized BAR state on resume")
Signed-off-by: Marco Nenciarini <mnencia@kcore.it>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/666cac19b5daa0ab0e0ab64454e76b4d24465dbd.1776429882.git.mnencia@kcore.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/rebar.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/rebar.c
+++ b/drivers/pci/rebar.c
@@ -130,6 +130,9 @@ void pci_restore_rebar_state(struct pci_
 		return;
 
 	pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+	if (PCI_POSSIBLE_ERROR(ctrl))
+		return;
+
 	nbars = FIELD_GET(PCI_REBAR_CTRL_NBAR_MASK, ctrl);
 
 	for (i = 0; i < nbars; i++, pos += 8) {
@@ -137,6 +140,9 @@ void pci_restore_rebar_state(struct pci_
 		int bar_idx, size;
 
 		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+		if (PCI_POSSIBLE_ERROR(ctrl))
+			return;
+
 		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
 		res = pci_resource_n(pdev, bar_idx);
 		size = pci_rebar_bytes_to_size(resource_size(res));


