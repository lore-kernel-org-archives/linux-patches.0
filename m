Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC27337EB9;
	Wed, 17 Sep 2025 12:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113085; cv=none; b=bsQRD/M9gjCcei2pWm3xeKkc052INh44NSm7PV1jJvx9fp2kLLAS/AypcZDpE/+yopBfU2z7nmME4lY3QYQENSZjXaUALhL40kD6DpTmX17bO0vrRtT1m5GrvJLPUh3NqbUTeAXGqYbYyfEyvh9mwfYyAapG4Qmr6rBAA+HuaBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113085; c=relaxed/simple;
	bh=K2xAFLmFRmLep8SyAfyS/VVHLe76mjMXfSAklKfuapM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfA2oy3LqSoPxPCseN/73+H4oa+LLX2FUENrCB6khJ1pJCY/JEMDi59SwMwj23MNF+XiQ4/KnO1+a7n5g/W/lSiYfjqhhG39BhaSmMNJxwPT4DRRDEACx1vH3skbhoUP32VL9hQKpZMw2LOFwzoinne5YaX5aI83S4VD3PIJsCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Neqe7qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Neqe7qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9A1C4CEF5;
	Wed, 17 Sep 2025 12:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113085;
	bh=K2xAFLmFRmLep8SyAfyS/VVHLe76mjMXfSAklKfuapM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Neqe7qp2NccWTZ5SyOQndbD/MjgSdtzp2bc8GKwZvDIlvPP90+d8lCyYMTM3AqSm
	 cTPn8EH+0Z/ZXQCDnRsJGmmqd1LjqwQAVByfgPBUdKFpqiBuZ+XRIWKuGW47GJ460O
	 4B50kmJ0smTP8L0sMw//rk/DzCcQ8OLViZexuMAY=
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
Subject: [PATCH 6.16 168/189] dmaengine: idxd: Fix refcount underflow on module unload
Date: Wed, 17 Sep 2025 14:34:38 +0200
Message-ID: <20250917123355.984540306@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 40cc9c070081f..40f4bf4467638 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1292,7 +1292,10 @@ static void idxd_remove(struct pci_dev *pdev)
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



