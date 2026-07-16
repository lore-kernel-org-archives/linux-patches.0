Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87D330D3F6;
	Thu, 16 Jul 2026 14:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210803; cv=none; b=gsfqWRN4BppOaKbyjRbLNFPfwUf0zeiF3GvFE2nLBM5h8ERSvlXaikziSkl4ryZ1annwPdv1tIbu19Irj4tPDTKrp6j/8bcOcO4Ems7Jw4b377D1e3Azq8PwGLNjnj4FE1gQtQ+yw7LlXD3qQRaKSPzPw1+yhVy8rkc6r784oQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210803; c=relaxed/simple;
	bh=36G4ZF2gjInB/yni2u1pNkcL45mslG3216G0oVk+Lv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ui4pr+A3/nNw3LKVgbKZ4GM0VVad6c4C9WR8MvMamtb/dDAyq99yBaMXwLxrcjjDZZLJVXjEvLP63lN3qRLOnwI8nHY1JkgGoxAfCEzwmJj2cODnnWmbOJ1mlUdjPCg62cTzYAmyGDZRNUj4nFTa4Uog6h1E74Jeu0Yzx41b1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uq8n0Zg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uq8n0Zg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0421F000E9;
	Thu, 16 Jul 2026 14:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210802;
	bh=UponpdID9acz3trBAefbZE5J/5u0DCX9m6uYzhRIX8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uq8n0Zg5PyuD5vkQTOBWg3dxicRl4R56AhaIXavhmbO/Me3ktEvCVFZ4jRBLTbvro
	 qLrlYTojfZ+EOdM0fcY6oDKYu52tCP+HtxzrOrHnkqs5zGu7gbJw+b1VC2NrChh5UD
	 c7DNNQ+HBv8OTSnwZkl5kp/Jo2sO4/+QRK6OLgmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nenciarini <mnencia@kcore.it>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 143/480] PCI/IOV: Skip VF Resizable BAR restore on read error
Date: Thu, 16 Jul 2026 15:28:10 +0200
Message-ID: <20260716133047.805268620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit f34f1712229d71ce4286440fef12526fd4590b37 upstream.

sriov_restore_vf_rebar_state() uses the VF Resizable BAR Control register
to decide how many VF BARs to restore (nbars) and which VF BAR each
iteration addresses (bar_idx). bar_idx indexes into dev->sriov->barsz[],
which has only PCI_SRIOV_NUM_BARS (6) entries.

When a device does not respond, config reads typically return
PCI_ERROR_RESPONSE (~0).  Both fields are 3 bits wide, so nbars and bar_idx
both evaluate to 7. The barsz[] access then goes out of bounds.  UBSAN
reports this as:

  UBSAN: array-index-out-of-bounds in drivers/pci/iov.c:948:51 index 7 is out of range for type 'resource_size_t [6]'

Observed on an NVIDIA RTX PRO 1000 GPU (GB207GLM) that stopped responding
during a failed GC6 power state exit. The subsequent pci_restore_state()
invoked sriov_restore_vf_rebar_state() while config reads returned
0xffffffff, triggering the splat.

Bail out if any VF Resizable BAR Control read returns PCI_ERROR_RESPONSE.
No further VF BARs are touched, which is safe because a config read that
returns PCI_ERROR_RESPONSE indicates the device is unreachable and
restoration is pointless. This mirrors the guard in
pci_restore_rebar_state().

Fixes: 5a8f77e24a30 ("PCI/IOV: Restore VF resizable BAR state after reset")
Signed-off-by: Marco Nenciarini <mnencia@kcore.it>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/44a4ae53ec2825816b816c85cd378430d9a95cc6.1776429882.git.mnencia@kcore.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/iov.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -938,12 +938,18 @@ static void sriov_restore_vf_rebar_state
 		return;
 
 	pci_read_config_dword(dev, pos + PCI_VF_REBAR_CTRL, &ctrl);
+	if (PCI_POSSIBLE_ERROR(ctrl))
+		return;
+
 	nbars = FIELD_GET(PCI_VF_REBAR_CTRL_NBAR_MASK, ctrl);
 
 	for (i = 0; i < nbars; i++, pos += 8) {
 		int bar_idx, size;
 
 		pci_read_config_dword(dev, pos + PCI_VF_REBAR_CTRL, &ctrl);
+		if (PCI_POSSIBLE_ERROR(ctrl))
+			return;
+
 		bar_idx = FIELD_GET(PCI_VF_REBAR_CTRL_BAR_IDX, ctrl);
 		size = pci_rebar_bytes_to_size(dev->sriov->barsz[bar_idx]);
 		ctrl &= ~PCI_VF_REBAR_CTRL_BAR_SIZE;


