Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808533233FF;
	Wed, 17 Sep 2025 12:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113639; cv=none; b=FVvXTWLrZP+pQQoBAfqL+KJtOs7ah4z/Zeyd5PPQauCdQVNhHRyiONHHo03KoiGQMIYVUa12ZLXchAtzwwiQ9wdjWKDTL42nXjpTqEp2+Mb71SOgaLD/LiHceheyfofDcecL0j2gPCODP6QaJEjSW/DhzlQmM/efixuess27dys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113639; c=relaxed/simple;
	bh=aGPenueTMCTuq8T0pCrpkIczcYaiy3a2R3qUucPv+dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4pX8Z62tY4COlgri0JfRt4/xcQD6QwyZ0IcHNyh0LkMSAOeJJdnxfl/5M2qPYR8kddzsGWJpsRdNWZ4FB2/A2lrlYR1I23M5emg5Td1d92J0k4Olm4A4UKbhCfwmG5SvxYCV4Cp61emIy9sS5ngbre6O1KfEdku9ZVG63xqIGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgJq2LiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgJq2LiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009F3C4CEF0;
	Wed, 17 Sep 2025 12:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113639;
	bh=aGPenueTMCTuq8T0pCrpkIczcYaiy3a2R3qUucPv+dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgJq2LiZQ+8qdDE7D4BkzdrPR5vZ3vWhp3xBHsRE5C/IXYcI+SrJTwIDyMjzRR1Lt
	 a16caSlE104s02kW06K57lrgTmQtY63yODH7rg54L7AIhAW0QCN1tF51xjNeEvvi4E
	 dBCRuR/5SwYRsOXAw7H+/VQ98QYlE+mOQfcKXMdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/140] dmaengine: idxd: Fix refcount underflow on module unload
Date: Wed, 17 Sep 2025 14:34:54 +0200
Message-ID: <20250917123347.291744471@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yi Sun <yi.sun@intel.com>

[ Upstream commit b7cb9a034305d52222433fad10c3de10204f29e7 ]

A recent refactor introduced a misplaced put_device() call, resulting in a
reference count underflow during module unload.

There is no need to add additional put_device() calls for idxd groups,
engines, or workqueues. Although the commit claims: "Note, this also
fixes the missing put_device() for idxd groups, engines, and wqs."

It appears no such omission actually existed. The required cleanup is
already handled by the call chain:
idxd_unregister_devices() -> device_unregister() -> put_device()

Extend idxd_cleanup() to handle the remaining necessary cleanup and
remove idxd_cleanup_internals(), which duplicates deallocation logic
for idxd, engines, groups, and workqueues. Memory management is also
properly handled through the Linux device model.

Fixes: a409e919ca32 ("dmaengine: idxd: Refactor remove call with idxd_cleanup() helper")
Signed-off-by: Yi Sun <yi.sun@intel.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Link: https://lore.kernel.org/r/20250729150313.1934101-3-yi.sun@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index d6308adc4eeb9..a7344aac8dd98 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -918,7 +918,10 @@ static void idxd_remove(struct pci_dev *pdev)
 	device_unregister(idxd_confdev(idxd));
 	idxd_shutdown(pdev);
 	idxd_device_remove_debugfs(idxd);
-	idxd_cleanup(idxd);
+	perfmon_pmu_remove(idxd);
+	idxd_cleanup_interrupts(idxd);
+	if (device_pasid_enabled(idxd))
+		idxd_disable_system_pasid(idxd);
 	pci_iounmap(pdev, idxd->reg_base);
 	put_device(idxd_confdev(idxd));
 	pci_disable_device(pdev);
-- 
2.51.0



