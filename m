Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DA83603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300964; cv=none; b=fH5vcgWvEPbJ7Xt7HV3ZdrutLCrOQdLd5aRe50EPxwmq7dh9CGdnCfQsGmgfsVOhD/lfW6PKmbUo9Zb3M2iId/WCUQw46Bd9xqjGh3QCkSmQoM0ufjW9tCAjRlzJsqDU5tXnf1c+AeghnsWb/y8j8lpB/VfdO6mkRbzpu9wyES4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300964; c=relaxed/simple;
	bh=dnKOTn7uV2wDaoLtoSPJID9JuTwR5i5ibtM0JG+68U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ref2vtDLJct20Tw5FdHMgyPEqhzqyz7k3xNL81OrXJIX8UkcEBSDbEZqzpnxZcYGtlnGmqy6YuABZuyuZi7M8JbLCqPQymnvo26mReK0bBlOL+YR86EpJ8QdMUdRiySxTvKQACvReaIE/ZBQsL1f2wdGtZzxYQSYWEbosJDZbIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uKw1HQJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uKw1HQJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F585C116D0;
	Sat, 28 Feb 2026 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300964;
	bh=dnKOTn7uV2wDaoLtoSPJID9JuTwR5i5ibtM0JG+68U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKw1HQJJ+fZ3Ne2aREY0h04HtoNIH/E0mT3e9X0CnX15vr0q0yf+nDqcxTjjD9vSo
	 tK6Vq2FFKliEIS6Jp4wnoT2dbxmbYtwYC2Xk3tvQ5ASFjllsphkzVg5z34kxI1i68k
	 9jVfGWP9QpspEcAtyrabZ/sLfKnzatSYbqOCEREAL7sHHlEpMAKpxI/59ev2DdPdjR
	 abPZdPh14eUrE7cNwHocJY6VE5K6rTdEAQVg2toWSiITuGZeQ6EYG53+44EZEf5UpR
	 B947eAZGFg9BjUfiKDJlXraX4KZWBm/2kyvHe560d8tep5OHs3HRAcmDDHxHbIMSHV
	 EV0HyX064VJPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/752] PCI/MSI: Unmap MSI-X region on error
Date: Sat, 28 Feb 2026 12:36:41 -0500
Message-ID: <20260228174750.1542406-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 1a8d4c6ecb4c81261bcdf13556abd4a958eca202 ]

msix_capability_init() fails to unmap the MSI-X region if
msix_setup_interrupts() fails.

Add the missing iounmap() for that error path.

[ tglx: Massaged change log ]

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260125144452.2103812-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/msi/msi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 34d664139f48f..e010ecd9f90dd 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -737,7 +737,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	ret = msix_setup_interrupts(dev, entries, nvec, affd);
 	if (ret)
-		goto out_disable;
+		goto out_unmap;
 
 	/* Disable INTX */
 	pci_intx_for_msi(dev, 0);
@@ -758,6 +758,8 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	pcibios_free_irq(dev);
 	return 0;
 
+out_unmap:
+	iounmap(dev->msix_base);
 out_disable:
 	dev->msix_enabled = 0;
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE, 0);
-- 
2.51.0

