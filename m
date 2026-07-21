Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E5D47255C;
	Tue, 21 Jul 2026 18:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659482; cv=none; b=Rh+CMzBL6aIHQlGSgaF0fp+n72otL7FNyHMBv+ne0Q51L2ylliGX1g1n0mCxRArjpeZhkcLysAeegWWwUZIq8VE32TG/7KRczJsMgbS1RRBn5JgLMbCmVCWnuA8Eb5LUrljSzByoiRHOfh9vwkPRYtBa1fjdhmfyJvq4T90a+M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659482; c=relaxed/simple;
	bh=WZcmY8V/qfWEFUb/5m9fleul/TR3bW4iWcCsaJ8JTDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlhuI+wmY3pGYhA63qD1SUF6OakC6+v1BEg4gBGJt6rU4pjgYMkPjwodDTFwnYV8kcjvH1CNFFKn5BOZ3j5YSP+nN4b+ayAoGtrwcgiFujDJz+k86NeHyM9z0fM2rKhhoixYBqb6SGQ8x/J+NVfuLoIolFxun8C/2C6zh2Gu0W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SA21cz6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SA21cz6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F731F00A3D;
	Tue, 21 Jul 2026 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659481;
	bh=UVaFV40cm15qfnWxNvXy6HZwBpUXj46tAp2Arl92xw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SA21cz6CTycZD0ZZg8e+WK3FGNrAj/GznuwIicKTQ6n4jzv/NiUPxiWOenhwAyerZ
	 s89BHDTHfOTU1rnOh/+Z+rua/KGaXUsEPhmYX8LL0cBCVkx5jjOCBbqEMbrBAhTSxg
	 n59i2MEweJe8M6wgmfWMoK11/3UMmCb2L34WKWYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nenciarini <mnencia@kcore.it>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1538/1611] PCI: Skip Resizable BAR restore on read error
Date: Tue, 21 Jul 2026 17:27:34 +0200
Message-ID: <20260721152550.042145831@linuxfoundation.org>
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
@@ -145,6 +145,9 @@ void pci_restore_rebar_state(struct pci_
 		return;
 
 	pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+	if (PCI_POSSIBLE_ERROR(ctrl))
+		return;
+
 	nbars = FIELD_GET(PCI_REBAR_CTRL_NBAR_MASK, ctrl);
 
 	for (i = 0; i < nbars; i++, pos += 8) {
@@ -152,6 +155,9 @@ void pci_restore_rebar_state(struct pci_
 		int bar_idx, size;
 
 		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+		if (PCI_POSSIBLE_ERROR(ctrl))
+			return;
+
 		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
 		res = pci_resource_n(pdev, bar_idx);
 		size = pci_rebar_bytes_to_size(resource_size(res));


