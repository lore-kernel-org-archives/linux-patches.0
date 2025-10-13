Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC9C243969;
	Mon, 13 Oct 2025 15:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368973; cv=none; b=NOJ4r/qa3kZAjtukQT3CqPPvbglzy9rhH4emGQ36EVcyymFIIvM76r0UP9sOphjP6nvKkHsBc2sIp91Q8mXxZ3XfYy55AbKDi/+1QbT5ZhHNFM2D5E1SZe9+Pq1ngs/ek9ZcWHydnp4rK7dsJQSGq5POYKT0uDmV/qMijO4SPFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368973; c=relaxed/simple;
	bh=EeQSzAsx2khvZnIDmJ92PqldPKw47wL8c1Jxns+z5UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHqHKCTKNj7MOxwhhGXdfiwlwICCSAIfqrQRp0rtGi9mtfhBXPtJesylIlqpQ0g6IqatvZlBUiTqA3p04JSKAcj8uhvnpuwWe0S0Sov0ZtvoPoLg7drdIUSf6DVY6phhKaY806EsgtR8bcKjwldw6sCEpXRAQQSBjktmmbFvj/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8ZJbjjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8ZJbjjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A35C4CEE7;
	Mon, 13 Oct 2025 15:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368972;
	bh=EeQSzAsx2khvZnIDmJ92PqldPKw47wL8c1Jxns+z5UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8ZJbjjQ42m3kd1HrMX8D3TNhn9SWT3chL4XCf4yu450fUHSWnqyTFq2eitrvY1im
	 csR02/6ilYnapjZBv6wzaH75NK40ntFKUP9gNmtf8NRG+mkO4svyW5zg/BpGn4zSf3
	 2EGUYysaszKpah3zxi+Gel0Vqg95FoM873daHC6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Inochi Amaoto <inochiama@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jon Hunter <jonathanh@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Chen Wang <unicorn_wang@outlook.com>
Subject: [PATCH 6.17 082/563] PCI/MSI: Check MSI_FLAG_PCI_MSI_MASK_PARENT in cond_[startup|shutdown]_parent()
Date: Mon, 13 Oct 2025 16:39:03 +0200
Message-ID: <20251013144414.267007528@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 727e914bbfbbda9e6efa5cb1abe4e96a949d576f ]

For MSI controllers which only support MSI_FLAG_PCI_MSI_MASK_PARENT, the
newly added callback irq_startup() and irq_shutdown() for
pci_msi[x]_template will not unmask or mask the interrupt when startup()
resp.  shutdown() is invoked. This prevents the interrupt from being
enabled resp. disabled.

Invoke irq_[un]mask_parent() in cond_[startup|shutdown]_parent(), when the
interrupt has the MSI_FLAG_PCI_MSI_MASK_PARENT flag set.

Fixes: 54f45a30c0d0 ("PCI/MSI: Add startup/shutdown for per device domains")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Wei Fang <wei.fang@nxp.com>
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Wei Fang <wei.fang@nxp.com>
Tested-by: Chen Wang <unicorn_wang@outlook.com> # Pioneerbox/SG2042
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/all/20250827230943.17829-1-inochiama@gmail.com
Closes: https://lore.kernel.org/regressions/aK4O7Hl8NCVEMznB@monster/
Closes: https://lore.kernel.org/regressions/20250826220959.GA4119563@ax162/
Closes: https://lore.kernel.org/all/20250827093911.1218640-1-wei.fang@nxp.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/msi/irqdomain.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/msi/irqdomain.c b/drivers/pci/msi/irqdomain.c
index e0a800f918e81..b11b7f63f0d6f 100644
--- a/drivers/pci/msi/irqdomain.c
+++ b/drivers/pci/msi/irqdomain.c
@@ -154,6 +154,8 @@ static void cond_shutdown_parent(struct irq_data *data)
 
 	if (unlikely(info->flags & MSI_FLAG_PCI_MSI_STARTUP_PARENT))
 		irq_chip_shutdown_parent(data);
+	else if (unlikely(info->flags & MSI_FLAG_PCI_MSI_MASK_PARENT))
+		irq_chip_mask_parent(data);
 }
 
 static unsigned int cond_startup_parent(struct irq_data *data)
@@ -162,6 +164,9 @@ static unsigned int cond_startup_parent(struct irq_data *data)
 
 	if (unlikely(info->flags & MSI_FLAG_PCI_MSI_STARTUP_PARENT))
 		return irq_chip_startup_parent(data);
+	else if (unlikely(info->flags & MSI_FLAG_PCI_MSI_MASK_PARENT))
+		irq_chip_unmask_parent(data);
+
 	return 0;
 }
 
-- 
2.51.0



