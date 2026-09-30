Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9BB50B435;
	Wed, 30 Sep 2026 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791044; cv=none; b=ar6rJkj9JOQwd98t+lRJv6SQ3swBxqdgAwjuGg+ZguDuUe+RaqD+DqDSxnHwFdh2kEu5kaFWUN+N5HMK/RSok7e3GNz6vuqkQlyJWIJ0tlbpHBjjF7VFOL3ary9PgluTydXpR99r8Kv1kKW8SX1ZGxGPjpedwaDZTEkxUFg3eRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791044; c=relaxed/simple;
	bh=FTrvG5uNTG0X1OIMwvj67nLsY5Mju3PYGhdgThIJsFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJL6lTWotoAmMqF7CjzIhKHXbfc2GzXFtWjgCeG6qZHmZis9fF4GrzVnh1+FLT5It+RU8PlK5ujqB7KoWJd2YDBWwxHWQsS8fhjFvukGdQfpZwm4fAk1C8Hvti8dcEFs9y/3fuS9iPj8rn59IhqqGlnCgCrCGcTQ3OopXuwAnbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOlnTl0S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOlnTl0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5731F000FF;
	Wed, 30 Sep 2026 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791042;
	bh=PUciYFWp0F868jDELOdckZ53mweJT7RrUKKM0Z59NCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOlnTl0SAWiHIafBBOnu330Jzyud8arypaqcnO8qEKvHwjzdbDJnJeHI7etmvUGZt
	 faW2/MHx29jumpvPMCBpXG4+atJPukpTmFAkuHPZVtF9FOwuOwhFL2AmNpht908lLo
	 5YRG1D70GGOPrsi4x+W6UjlAkzMNkhjJZfzmCwd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/752] PCI: iproc: Protect root bus removal with rescan lock
Date: Wed, 30 Sep 2026 17:20:33 +0200
Message-ID: <20260930152401.725424937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 30ac5fbefbbff..90923046f04f5 100644
--- a/drivers/pci/controller/pcie-iproc.c
+++ b/drivers/pci/controller/pcie-iproc.c
@@ -1545,8 +1545,10 @@ int iproc_pcie_remove(struct iproc_pcie *pcie)
 {
 	struct pci_host_bridge *host = pci_host_bridge_from_priv(pcie);
 
+	pci_lock_rescan_remove();
 	pci_stop_root_bus(host->bus);
 	pci_remove_root_bus(host->bus);
+	pci_unlock_rescan_remove();
 
 	iproc_pcie_msi_disable(pcie);
 
-- 
2.53.0



