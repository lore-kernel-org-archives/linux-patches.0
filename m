Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA193DAAB7;
	Fri,  4 Sep 2026 05:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499648; cv=none; b=Y7X7wro2bkF9ddIEXVdSNhB6aUyKvd5ApsnqQBIuaUO8xcQU+vEPvcMRq+epB9YzuXnDxEsJr4umBbvsGEb5lB2KUhAEyXckWkG2jbQ2vVcDMRshUF82JwPSss2UIPmtPfdio/N2vkgNezuZXM5aKW/cDRFlSE3zY3k+bqjnNdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499648; c=relaxed/simple;
	bh=DTWOPIHYjfw+KfNWKt1FRsOYj9K0pWpC665C2JJgAHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5o+c6gWHAya4HTVFATAGuLJ86ralr4FBT4hdKrKddbGR6WY34vcZDM/IoNFqvMGHRvWI0SDnIn02Lh5isf/xJ3/eWOiXTZnag91u9LC7B/wbX5XWe7g6Cgk6l28YBpFykl+PCX9yULd2QFWO6VVujjOPe6DDSu6kUYAPHa5+zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXlk9i+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXlk9i+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA61F00A3D;
	Fri,  4 Sep 2026 05:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499646;
	bh=ubefjrk31iPP/Dklzzio+//MURmQz8KTWNVXtkY1G7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXlk9i+CVHhgR5cRN8E8756Pzz21gbslfiCvBO5OxTGaTVCN1AVgskrYJ1uFoK1fT
	 FOrVXkW2vHKWfeHl9n/WmUn3vAP7C1Nmgif5FSKXKkXYQSopzAIfYFB81uhqXh7Y+O
	 zBvER6ECErF7g4kaCNbsolJNLWqPTA2+QiMIocRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 489/713] nvme-pci: disable controller on admin queue IRQ setup failure
Date: Fri,  4 Sep 2026 06:57:37 +0200
Message-ID: <20260904045814.788123826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 08660a5c8d497f43191635d97efd31cd35051f15 upstream.

nvme_pci_configure_admin_queue() enables the controller and then requests
the admin queue interrupt. If queue_request_irq() fails it returns without
disabling the controller, and no caller compensates: nvme_pci_enable() only
frees the IRQ vectors and calls pci_disable_device(), after which
nvme_dev_disable() treats the controller as dead and skips nvme_disable_ctrl().
The controller is left enabled (CC.EN set) on this error path.

Disable it in the failure path, while the PCI device is still enabled so the
CC.EN clear handshake completes.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: b60503ba432b ("NVMe: New driver")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2400,6 +2400,7 @@ static int nvme_pci_configure_admin_queu
 	result = queue_request_irq(nvmeq);
 	if (result) {
 		dev->online_queues--;
+		nvme_disable_ctrl(&dev->ctrl, false);
 		return result;
 	}
 


