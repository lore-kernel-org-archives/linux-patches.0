Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BED1366565;
	Tue,  6 Jan 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722074; cv=none; b=GR+oYuPUiQ/sxeXRWtOlijavwgrVJUuD9HiUcY6RIT63m6+PDMwOtrnxSLrN+d276dL3AlfJOAz5rThrgrgIO1Tr8qdSRhGbaKuDDQuOKTMXBnV+dbCXWd/8jYTYUfoJDX0ewS3sLKZjQp7dz6/AhrAIAVDBlHmayEna6kBMspo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722074; c=relaxed/simple;
	bh=Gy9ukPMZbjMgDptHkw1DLoKV5+Cobd8ul05zJeCsWL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZgi+0+VqL1XczNXYi1yIxyU8jD45WbWRDn9l0vBe5y7lfbLX13f0PeJYXOWawzzUmYd6A4qwW2Ti5XBaVeCL3+dTr7gzAjSi79tJLOXC+jEMNa3C2PtZyXKa0dBroYqCWVPidfKfj+krVg+AA9O+eNGePkOMX05B+cxil9qKiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZcPNjUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZcPNjUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9371FC116C6;
	Tue,  6 Jan 2026 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722074;
	bh=Gy9ukPMZbjMgDptHkw1DLoKV5+Cobd8ul05zJeCsWL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZcPNjUAqflWSjMiyjOzXZrGnwEK3xiWDgP8+aMuuieqs32k+w3tTiilPoj0Zidm7
	 K9qvadLQvGgzTn1VrXXkNQwvJ24q8ZH9btTOmJ1sqnIkvrkMZMAgaM62lMmTb0D864
	 4r5UrNK5/DguMXwvcmxxSqEZeagKXBV+W6dyxlmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 156/312] nvmet: pci-epf: move DMA initialization to EPC init callback
Date: Tue,  6 Jan 2026 18:03:50 +0100
Message-ID: <20260106170553.481123399@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 511b3b644e28d9b66e32515a74c57ff599e89035 upstream.

For DMA initialization to work across all EPC drivers, the DMA
initialization has to be done in the .init() callback.

This is because not all EPC drivers will have a refclock (which is often
needed to access registers of a DMA controller embedded in a PCIe
controller) at the time the .bind() callback is called.

However, all EPC drivers are guaranteed to have a refclock by the time
the .init() callback is called.

Thus, move the DMA initialization to the .init() callback.

This change was already done for other EPF drivers in
commit 60bd3e039aa2 ("PCI: endpoint: pci-epf-{mhi/test}: Move DMA
initialization to EPC init callback").

Cc: stable@vger.kernel.org
Fixes: 0faa0fe6f90e ("nvmet: New NVMe PCI endpoint function target driver")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/pci-epf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -2325,6 +2325,8 @@ static int nvmet_pci_epf_epc_init(struct
 		return ret;
 	}
 
+	nvmet_pci_epf_init_dma(nvme_epf);
+
 	/* Set device ID, class, etc. */
 	epf->header->vendorid = ctrl->tctrl->subsys->vendor_id;
 	epf->header->subsys_vendor_id = ctrl->tctrl->subsys->subsys_vendor_id;
@@ -2422,8 +2424,6 @@ static int nvmet_pci_epf_bind(struct pci
 	if (ret)
 		return ret;
 
-	nvmet_pci_epf_init_dma(nvme_epf);
-
 	return 0;
 }
 


