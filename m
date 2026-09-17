Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D82519E0C;
	Thu, 17 Sep 2026 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664649; cv=none; b=lnjnH7oJSjnXYHSJnjXB3pqQaWd93afDPJDVsc7rXljIYl2EIQKiAccMXYlCrtxjjuRel2EPlEBKkYskYggEGQQF76tt4cKMbKm6xexjBKj0GCki0FJMFaVwaMbO17LFDNeWmOW+meQukH4Bzd6VEt9pImu0rYhAhZpXrfdUMoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664649; c=relaxed/simple;
	bh=2wIGdMuN93UD39mpKzPFHWFMdVZE01R43jT2QxyFpd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZgAvTvMxaQeVXRLJ4XSjOIWneSVbVUytSBy8nPV9oPdvObx0rYyZ185kCMCx1vLOmGUeIozdfoKh4gLQ8wau9Pp9DZqatwjxUzRXPrrABEafsxz8LwwDUz5ZYAd4XvMGZmR8npWwWNmPJ1E/uz6Q925en+7JmYqE853vikEckc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjZQv8yU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjZQv8yU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AD41F000FF;
	Thu, 17 Sep 2026 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664648;
	bh=ySUXtFUr6DzQa5BsPpv5rYgTotxWBwgv9B/ieE7O7BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjZQv8yUcMDFkBuEtUIxqh+sVQ4EqHExvPIhxo2g3TQM6+FxB0/bs0mf+/sjJvs1e
	 UxkwZrfpDUiJ8Ww0BKitjMBdNRBiu+sBYa6iRqtfcs6hdMWASrdr6Oc72hjHkuUNzo
	 w3tCF2KOiRojOhKkaLKhE5NYAcATQiY3pTcU++IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0443/1250] PCI: plda: Protect root bus removal with rescan lock
Date: Thu, 17 Sep 2026 16:03:58 +0100
Message-ID: <20260917151604.011666609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Hans Zhang <18255117159@163.com>

[ Upstream commit 4e4f9745f016c1631d00a4035b06f6e75d449e01 ]

Hold the pci_rescan_remove_lock lock while stopping and removing a root bus
to avoid racing with concurrent rescan or hotplug operations triggered via
sysfs.  Such races may lead to use-after-free issues or system crashes.

Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260521161822.132996-10-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/plda/pcie-plda-host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/plda/pcie-plda-host.c b/drivers/pci/controller/plda/pcie-plda-host.c
index dea3d443434cb..fd1a11b4c8eb8 100644
--- a/drivers/pci/controller/plda/pcie-plda-host.c
+++ b/drivers/pci/controller/plda/pcie-plda-host.c
@@ -672,8 +672,10 @@ EXPORT_SYMBOL_GPL(plda_pcie_host_init);
 
 void plda_pcie_host_deinit(struct plda_pcie_rp *port)
 {
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(port->bridge->bus);
 	pci_remove_root_bus(port->bridge->bus);
+	pci_unlock_rescan_remove();
 
 	plda_pcie_irq_domain_deinit(port);
 
-- 
2.53.0



