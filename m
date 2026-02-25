Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C56518B0A;
	Wed, 25 Feb 2026 01:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983253; cv=none; b=Ycu6REtmB+lRbIxhhmGmPcPHQ4gBzu3QQBmTHxaCV/0fba7rL329MpjXdkRch6h+yt9qH7DX2ReI4gn/kllK7auA1uvCP/ii0vhrDQdzCMOKWvfeVvh58rIE58YV0V2L+6Bb4pST37fCqSQ4htcoj/aJxL5EWeZlFonDbxCmEFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983253; c=relaxed/simple;
	bh=oiV+6hP4qiLfIIakgEP9oTy3euNBKq6IGlqIrAclvmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pDvynrGP4smm+Du8uGAlEtge0v2c2oA33MpLI1/9z7gMc9zraCXkgyGis/HP/ViaPig0nebSwLrY9skP+k83HyN85hGY2R2Krodbi+/YDBMAtbITWf4YvNH1M1NKkVActESOxQTHU7RgBPMDEosU2hecmQhBHRcL87aE/Y55jc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epa4DPY7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epa4DPY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16105C116D0;
	Wed, 25 Feb 2026 01:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983253;
	bh=oiV+6hP4qiLfIIakgEP9oTy3euNBKq6IGlqIrAclvmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epa4DPY7yYVSRinTR9fmyDGps3ez/uBFiHLTyOtkFEroZ3Cw9SC64X2oG/C1fVzyE
	 NNKCj/bsTOEjMmrU35imUgAUvlAJ+QlKAXW5Sv5ERr+jK/+jzeOIPYS9q0R+Jyw5ty
	 I2sAPcA/GH+M7sBZC0EHAh+YsjI5Vj080spU4Rt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=B6rg=20Wedekind?= <joerg@wedekind.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 352/781] PCI: Mark 3ware-9650SA Root Port Extended Tags as broken
Date: Tue, 24 Feb 2026 17:17:41 -0800
Message-ID: <20260225012408.323772659@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jörg Wedekind <joerg@wedekind.de>

[ Upstream commit 959ac08a2c2811305be8c2779779e8b0932e5a99 ]

Per PCIe r7.0, sec 2.2.6.2.1 and 7.5.3.4, a Requester may not use 8-bit Tags
unless its Extended Tag Field Enable is set, but all Receivers/Completers
must handle 8-bit Tags correctly regardless of their Extended Tag Field
Enable.

Some devices do not handle 8-bit Tags as Completers, so add a quirk for
them.  If we find such a device, we disable Extended Tags for the entire
hierarchy to make peer-to-peer DMA possible.

The 3ware 9650SA seems to have issues with handling 8-bit tags. Mark it as
broken.

This fixes PCI Parity Errors like :

  3w-9xxx: scsi0: ERROR: (0x06:0x000C): PCI Parity Error: clearing.
  3w-9xxx: scsi0: ERROR: (0x06:0x000D): PCI Abort: clearing.
  3w-9xxx: scsi0: ERROR: (0x06:0x000E): Controller Queue Error: clearing.
  3w-9xxx: scsi0: ERROR: (0x06:0x0010): Microcontroller Error: clearing.

Fixes: 60db3a4d8cc9 ("PCI: Enable PCIe Extended Tags if supported")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=202425
Signed-off-by: Jörg Wedekind <joerg@wedekind.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260119143114.21948-1-joerg@wedekind.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 280cd50d693bd..211b7f72d103e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5581,6 +5581,7 @@ static void quirk_no_ext_tags(struct pci_dev *pdev)
 	pci_walk_bus(bridge->bus, pci_configure_extended_tags, NULL);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1004, quirk_no_ext_tags);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_3WARE, 0x1005, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0132, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0140, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0141, quirk_no_ext_tags);
-- 
2.51.0



