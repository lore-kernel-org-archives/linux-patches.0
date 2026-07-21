Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887D243E066;
	Tue, 21 Jul 2026 22:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672842; cv=none; b=lcw+oJIGPjVS+VwGbbGf0dMZQXHPy3QGx5gUwiA8H3yiJflLg5RSPWywzK0YHUjmtVpD4VbdI0QEWWwC0u+NtPG/JMBQCcsNg6zgJF2rDRuGFlyviIy4muqNBmNFk58oS0+x/MmpmkYe4901en+SiOFNbVWjuvF5QHc9TK+7jrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672842; c=relaxed/simple;
	bh=1ipKSzo9m4KF9k9pjdci+MSArptwjVBuMl0wC7/DME8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPXsBbqq/VqsXmiVt+TYV1rDM1YP9ECQyq+mgjT8uR/cvgGOnEiz1ZV8901JkLs6EhYO7nGW70RsioYZUfVtN6tVcGAlEamjqb34TE+JAcdagrxBsCUOg2clEy55l8lY+kr+moGqKMm78x7el4zM0ellVQgtmJKFjkUBX6TwEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCaPM2DG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCaPM2DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76E61F000E9;
	Tue, 21 Jul 2026 22:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672841;
	bh=srMXHurondJ33cMHjXJ1bjwBpelMYrZjizOEBrn8sJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCaPM2DGpWn7ksNklD8yfM6R5d6lE2yvUJAg4SFrRM04nln5qU3nQCa8LaznNdPZL
	 TqEI/tH+4N3f69rSsLLdgHIHQ9I/yoW3k714cbnBqvrhuPnf93LRPGVT+nVuFIl42i
	 FZB0aJaiOG03thJUyFRhhHZcuH6DKZHdhQZTmTOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nenciarini <mnencia@kcore.it>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 770/843] PCI: Skip Resizable BAR restore on read error
Date: Tue, 21 Jul 2026 17:26:45 +0200
Message-ID: <20260721152423.373754937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -131,6 +131,9 @@ void pci_restore_rebar_state(struct pci_
 		return;
 
 	pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+	if (PCI_POSSIBLE_ERROR(ctrl))
+		return;
+
 	nbars = FIELD_GET(PCI_REBAR_CTRL_NBAR_MASK, ctrl);
 
 	for (i = 0; i < nbars; i++, pos += 8) {
@@ -138,6 +141,9 @@ void pci_restore_rebar_state(struct pci_
 		int bar_idx, size;
 
 		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+		if (PCI_POSSIBLE_ERROR(ctrl))
+			return;
+
 		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
 		res = pdev->resource + bar_idx;
 		size = pci_rebar_bytes_to_size(resource_size(res));


