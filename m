Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7351C326;
	Wed, 30 Sep 2026 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784722; cv=none; b=IBWcR3966tbniRZoomWPNHfpb8Iiumum2V2a6R0JE4RN97h7FF5hTzpdvq1OeXOEhuyzFHzHuqsTIJsT4eOKZLf3JN5MlCMc2bIjCjQaUT3PGLkblRXZgXjJIN/bnVwSME9076lnICmJw8ETAXfFnAZIfj+5jBRIg0sK8debVrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784722; c=relaxed/simple;
	bh=zHXj4gWaPP87EQDr1Y1PIu23VNdmEt+fAW/dcHylBzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z97Mb7HQgxx26wSkiU/CLeMmXzqfuWEvvjzaHehyhhFEZcPeZi4lwYkBU3OlmaztOrMgfNWjdM3EFN0al8prE/PHihq6tmUe4OhApIBjUy0wdlLGpbv79c9rdK059g0dmN0F5tKH3iQdxIHr/Gjrk2qVeSk9LtxEHQ586BfTqbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJRGKB+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJRGKB+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A440C1F000FF;
	Wed, 30 Sep 2026 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784717;
	bh=NQLkztnTIaLgujqWP7s4/JCM4dY+e6dgtr2HMEPYeDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJRGKB+hvR3EAcfBpxNsm87ZjyvS6LTc3bSJB16eaYOb+yPbsy30VeBKMi1L3Hoko
	 Wcbq9XDalcJ0lJ9OW8YeKOkOYRKi6KTHEPDUTsqWsgagYyrNhvu9z1fbfLT95mfr4n
	 kwW/jjNPzBTFcpWgLplAQFvUATeFapQAECLFx1jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/982] PCI: iproc: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:15:45 +0200
Message-ID: <20260930152421.297396731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit a6a64e150f12ad5391e0a0d60f6a3d119b06ce50 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-6-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-iproc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/pcie-iproc.c b/drivers/pci/controller/pcie-iproc.c
index 6525c7ded5c40..2eae2d1859d34 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1541,8 +1541,10 @@ int iproc_pcie_remove(struct iproc_pcie *pcie)
 {
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 
 	iproc_pcie_msi_disable(pcie);
 
-- 
2.53.0



