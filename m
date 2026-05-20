Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491F436CE19;
	Wed, 20 May 2026 16:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294954; cv=none; b=XmNOLuJi2ca8Tr3Ova3fRKwH3bUO9C0er24u/0tm6Da0UrCgCyhrdLeZq3LRQoa+FtZbuEwytYtX/Hfva+zGG1DGASdLEec3qHyVqdT4CmgI+8YRGHw8dRhynOcToQHb8wCyOJlxEEUzu1B+Y666nDcPMzhyG2r6AB4VgizqbnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294954; c=relaxed/simple;
	bh=co7Ft017AoLTb5K7Hf2Q48MVOvgi154QybTuHGVXLCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVzOtGKmNssb8zrK7VIjEGfn96PiDfIpNDZRVisvugjitAPYDy75MuHA/y1f4ePuxZeJHpDzTL6JoCEWjj6LBEwmjs8a/qSp/3Bz18OINZp2pRrcfDCS6Gms4xZK9XLyWKdfwOPATwF2hf/NUv7mgiv+rGrkBL1IVa63XUpjwKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N54OXk53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N54OXk53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF72C1F000E9;
	Wed, 20 May 2026 16:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294953;
	bh=TI9T/9/nQ/fUsKhKBT8g7a7uSFDZ83sM5e7eAVBPnxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N54OXk53DNK155LEjEJNp8c3WDOYQDdMdzxFZucibr7UVtSBqlA49s2m2nypL3OpY
	 MW1FGnK0Jcpu5Awmu5t6fgUFTzUgpRVG3iUGXUMojZkolGKQ+CX3m/DRZFAQeVucb3
	 ezed3T6aGlgW6NwsDJ48Ng3+iR/ogIwQBB5fwhyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0235/1146] PCI: endpoint: pci-ep-msi: Fix error unwind and prevent double alloc
Date: Wed, 20 May 2026 18:08:05 +0200
Message-ID: <20260520162153.565377045@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 51c19942a81ef..1395919571f83 100644
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



