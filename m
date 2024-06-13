Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3CC144D31;
	Thu, 13 Jun 2024 11:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279888; cv=none; b=dOBNwMs0SoRwFsZVaj8rcLUs9BR7otNoRfh3r9kkh6NtpBcjFgHizF6z8KLWbJjAUi4e6w27SJacjEcbrwCoWdZf3cRpZ0LfokhJvitW+tAkhf2yZVjyvmhJobrrkoTPNUWi2ZSHBr2D8ZT6FVFtYMzysGY6A9nbBJh/rDCO3S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279888; c=relaxed/simple;
	bh=8jMM2/SJ0Ze+AmVOPCLcL9H0rwmiODsMKCLetZFSxWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHrnsuQJfgpfu2vuDuqZLM/ZZwdbak8VE8Ivw+g2v2MmDvSrA89d1BaSzVuabFx5M/KdxCHAt71YTffYq93U0IKK4hSk8NhzoL//gjzYDIFi3hjsQD/iQy/fbRE5tvCQbXO+LJMlj4rrE27l6gISLjEuWI8Khzf1YzvpDYOebMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWUNVOZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWUNVOZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30186C2BBFC;
	Thu, 13 Jun 2024 11:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279888;
	bh=8jMM2/SJ0Ze+AmVOPCLcL9H0rwmiODsMKCLetZFSxWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWUNVOZlQxm1XZD8A5LAs+K/slF0aoAAetIPYux4BD+AlC4yne6aR2MvNbk66H84H
	 0sOxpnI36S4WN2rE0Pj4mpQM3Zmqoz4qUzQi4OvFUVZyHjzneT7iDSAnp6MfrNa9t0
	 16zKbP99JqTkaUfpgmkI4e2D0kEnULe0HHGsCYf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 053/202] HID: intel-ish-hid: ipc: Add check for pci_alloc_irq_vectors
Date: Thu, 13 Jun 2024 13:32:31 +0200
Message-ID: <20240613113229.822379551@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 6baa4524027fd64d7ca524e1717c88c91a354b93 ]

Add a check for the return value of pci_alloc_irq_vectors() and return
error if it fails.

[jkosina@suse.com: reworded changelog based on Srinivas' suggestion]
Fixes: 74fbc7d371d9 ("HID: intel-ish-hid: add MSI interrupt support")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index f491d8b4e24c7..05134ee802778 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -159,6 +159,11 @@ static int ish_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* request and enable interrupt */
 	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0) {
+		dev_err(dev, "ISH: Failed to allocate IRQ vectors\n");
+		return ret;
+	}
+
 	if (!pdev->msi_enabled && !pdev->msix_enabled)
 		irq_flag = IRQF_SHARED;
 
-- 
2.43.0



