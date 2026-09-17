Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6526450256E;
	Thu, 17 Sep 2026 18:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668160; cv=none; b=pTRFMHnnsEyL4uNkGU0M+94sm2eOBBvzIt5xwV73iRDub93/WYZvTPZ9Vcn7NSrdpCN2yZdOpg4b+IZb5upPsQeugOzkUxtOHToI7Sk0jEb8HE49ZE9u+kYPe793H8NXMyAzQyePQct5mLlQwn25ehhuNxSYrJsqUGGLyUIwTfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668160; c=relaxed/simple;
	bh=wnlzwI7ZOS6zB69kGqWy0EvPvvjtCtNixI7fBq3s7sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAkST2rKQArf2U7q1tGpLk4z58/U/c2M6cp0Hx0AJ/MujV9vRNSOPbXtrHZ5/cm9aM1Ie0u1TDdGHv1zwdxp8qxAok4ej1X0OtMzWW4gLQ8tR1utbHtsWTHwFBheyvhyUGsX1qA9ttctwOaw+RNI8T15O4zfAY5U6axqxV8KIrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7WS07lr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7WS07lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA8B1F000FF;
	Thu, 17 Sep 2026 18:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668159;
	bh=G0heSJRUk+VyltlqumRzeywnwrKjOjDByG2ErQbtH8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7WS07lr7zF/+xeSQ2j9cpwM0DhVUdZY8/6pivQWCOn2KUjHIjgRRGWF780b6wWts
	 InkX3KhOJNjGb0O63dT+nePIQDJxOiseFGHQes2UOOH2CBxJQ7z1kPJUV/BUuRoBnH
	 XGQsmlwFecYCfJV+M2QtBj5x+JSPpZjrDT4+KHDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0334/1102] PCI: iproc: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:04:37 +0100
Message-ID: <20260917151548.019818352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 5aa677f81e4fa..61dcb232757fb 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1540,8 +1540,10 @@ void iproc_pcie_remove(struct iproc_pcie *pcie)
 {
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 
 	iproc_pcie_msi_disable(pcie);
 
-- 
2.53.0



