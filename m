Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4207D1A3029;
	Tue, 21 Oct 2025 20:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077107; cv=none; b=dbHCZ2VeGg5AND7BCiM4f4u9oc4xXE+iNWyuJ972aoXYaD0BHohMGkz1McxNzUOynWzJ2LGwgkumdcOocnB4r/cs6/80BN6Y8HLd1ZCWWhczUJxbAO6VVUvdkulMxiCbyahz2BRxeGl4/ZY8pi5k0DUVuKnGs0AMNGg/4M7qZBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077107; c=relaxed/simple;
	bh=Ki37LKY74cxHO8z3Q9niKY9yKBlyak/cJcngQ5quCaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kh9Pg2zE4r47ZZy68Ku2dadpCepIyq6uz0LOeqRyFZpv43mkibXRKblr+zrO8eswzN04H8KysIZqHPVtbLilZuC78HbfksAzOjpOOGnqDOGzAcKwBkiwGYRMAo4tMRCVbI1kN931wo4yHR98RNgF6OGVTkOOoLzdJjXJytoOGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNV3pfeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNV3pfeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8631C4CEF5;
	Tue, 21 Oct 2025 20:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077107;
	bh=Ki37LKY74cxHO8z3Q9niKY9yKBlyak/cJcngQ5quCaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNV3pfeQku0Y49fXtB6CBF/D2JzPXDd/tLmvE3p/S2eDrCC76AKx4nHVb9GhjCfy0
	 cPs0qOWjG53kEhGqGBSXmcCFYK5Q/VK+RWQwxgBD+P8AQzmtgaA1U6q/Tx4MipZMCt
	 oCZB3aTZ5n22zxwJZ/QcOLA4Xjs4IGart1+REYdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 136/136] dmaengine: Add missing cleanup on module unload
Date: Tue, 21 Oct 2025 21:52:04 +0200
Message-ID: <20251021195039.259115260@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

Upstream commit b7cb9a034305 ("dmaengine: idxd: Fix refcount underflow
on module unload") fixes a refcount underflow by replacing the call to
idxd_cleanup() in the remove function with direct cleanup calls. That works
fine upstream. However, upstream removed support for IOMMU_DEV_FEAT_IOPF,
which is still supported in v6.12.y. The backport of commit b7cb9a034305
into v6.12.y misses the call to disable it. This results in a warning
backtrace when unloading and reloading the module.

WARNING: CPU: 0 PID: 665849 at drivers/pci/ats.c:337 pci_reset_pri+0x4c/0x60
...
RIP: 0010:pci_reset_pri+0xa7/0x130

Add the missing cleanup call to fix the problem.

Fixes: ce81905bec91 ("dmaengine: idxd: Fix refcount underflow on module unload")
Cc: Yi Sun <yi.sun@intel.com>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -923,6 +923,8 @@ static void idxd_remove(struct pci_dev *
 	idxd_cleanup_interrupts(idxd);
 	if (device_pasid_enabled(idxd))
 		idxd_disable_system_pasid(idxd);
+	if (device_user_pasid_enabled(idxd))
+		idxd_disable_sva(idxd->pdev);
 	pci_iounmap(pdev, idxd->reg_base);
 	put_device(idxd_confdev(idxd));
 	pci_disable_device(pdev);


