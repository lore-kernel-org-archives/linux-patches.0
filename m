Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8779364E89;
	Wed, 20 May 2026 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297860; cv=none; b=GTtXRIWXSF1VpMtDU0IT8h8uYlWBXuIpTy+EHRayWE8HdlEOTngkX2lGNIoXdLf2aoFBy86RLgMLrN9H2CHhndP0SMtH/x4yFa3QidWOoTk1PLdUDihKUoKgKkxeBSIS6LZM+03WKo/fkjy0jl7TitanULck4eC0ebMLa/RpkUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297860; c=relaxed/simple;
	bh=hVWVk4GMR3sF6xnpBg0shYlnP9G2CJoUIqoTS/lxUnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tE6SOvGUyLoJJfandSgRsbTHUFAFWt24rN6N627PtMTx0i5/g8BMREyteWpuDTLID2Yz1EGuQEnnEKdaYKL3dW2C4E5vXsWAeTubvOoKiAqHHWE17RYw+9vycMmZDPZnYOkYEMT5LBt25uNZiOGs2PWeDYuEEc0Ap4WN0IzY2p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKdan3r5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKdan3r5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110EE1F000E9;
	Wed, 20 May 2026 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297859;
	bh=D6Z6IdiX8neHTJDU5kLo59QxITdBEUsh5/uIqU9z5+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKdan3r5fzvTWERDuhZwfU0WMQH5eRJvbjr5FKvdRxsnuTmsmmrjANpTLf5/DLvPd
	 7SE8trgBoFQjOm98mwvYw+UQFNLBD9iL3eIu43pS7DTorkTd1xqIhkJmSB9czDAf5H
	 elhoGuEJI/VXrPpFaz7zRkO+N5+3lPaNA0rKLX94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 191/957] PCI: endpoint: pci-ep-msi: Fix error unwind and prevent double alloc
Date: Wed, 20 May 2026 18:11:14 +0200
Message-ID: <20260520162138.693169121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 1cba96c0a795124c3229293ed7b5b5765e66f259 ]

pci_epf_alloc_doorbell() stores the allocated doorbell message array in
epf->db_msg/epf->num_db before requesting MSI vectors. If MSI allocation
fails, the array is freed but the EPF state may still point to freed
memory.

Clear epf->db_msg and epf->num_db on the MSI allocation failure path so
that later cleanup cannot double-free the array and callers can retry
allocation.

Also return -EBUSY when doorbells have already been allocated to prevent
leaking or overwriting an existing allocation.

Fixes: 1c3b002c6bf6 ("PCI: endpoint: Add RC-to-EP doorbell support using platform MSI controller")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260217063856.3759713-4-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/pci-ep-msi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/endpoint/pci-ep-msi.c b/drivers/pci/endpoint/pci-ep-msi.c
index 1b58357b905fa..ad8a81d6ad773 100644
--- a/drivers/pci/endpoint/pci-ep-msi.c
+++ b/drivers/pci/endpoint/pci-ep-msi.c
@@ -50,6 +50,9 @@ int pci_epf_alloc_doorbell(struct pci_epf *epf, u16 num_db)
 		return -EINVAL;
 	}
 
+	if (epf->db_msg)
+		return -EBUSY;
+
 	domain = of_msi_map_get_device_domain(epc->dev.parent, 0,
 					      DOMAIN_BUS_PLATFORM_MSI);
 	if (!domain) {
@@ -79,6 +82,8 @@ int pci_epf_alloc_doorbell(struct pci_epf *epf, u16 num_db)
 	if (ret) {
 		dev_err(dev, "Failed to allocate MSI\n");
 		kfree(msg);
+		epf->db_msg = NULL;
+		epf->num_db = 0;
 		return ret;
 	}
 
-- 
2.53.0



