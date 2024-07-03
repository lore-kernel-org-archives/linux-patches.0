Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5964176ADB;
	Wed,  3 Jul 2024 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005936; cv=none; b=F/jeuceT6Q/QIfBx8N8HPJCGsL2HpJqjGT8IMpSUw5uz38ShjWpRAi2Oodm0MbCs2bVoFjZPGHVaSB2bzezt2O+j45O1Ak6IH219fFMn1eAwYGnJ9/VwBl/hWEMwnfSYUmwuNuXTQzMaRaKAnDD2OOaB0InQAKaC8fxBxXaipPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005936; c=relaxed/simple;
	bh=VWDRoMvDDvZN1xfhOsUvzDkvuSWI6h6SLnIhUdtr+4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTVeuEAXQCPAY8pS4JFy6U/hqs3fNO/DdQgDJb52/wWEzLrFNHa1BTdBPB9ZiSPJWKNjUxi1/6aetjUcr9fYjbPHpVHmK6bLMJGjACVmjbyUV1+uqg6bIDJexjt529JOpcsVhiXQRFFWZZ7i+BpVx3L1i6tl3fbr52lbFGSPoFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0YOM0aA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0YOM0aA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32B5C2BD10;
	Wed,  3 Jul 2024 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005936;
	bh=VWDRoMvDDvZN1xfhOsUvzDkvuSWI6h6SLnIhUdtr+4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0YOM0aAf3K7wnk6adwor5/Xz9VLG9r5WwGTUwbVJZgVuBCIrB9K7Y/NpAbTknf6b
	 ndS9HKfYLTUI0ce+C7pEDbhcWDevIeba46imuZIVOEI16Y0SSBWuBuNDo6awKY1nE/
	 lVUBe56YHAjpSOh/9n4LgRlywkmcBLOuY9MIflBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/356] dmaengine: ioatdma: Fix missing kmem_cache_destroy()
Date: Wed,  3 Jul 2024 12:39:10 +0200
Message-ID: <20240703102921.208628698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 5422145d0b749ad554ada772133b9b20f9fb0ec8 ]

Fix missing kmem_cache_destroy() for ioat_sed_cache in
ioat_exit_module().

Noticed via:

```
modprobe ioatdma
rmmod ioatdma
modprobe ioatdma
debugfs: Directory 'ioat_sed_ent' with parent 'slab' already present!
```

Fixes: c0f28ce66ecf ("dmaengine: ioatdma: move all the init routines")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240514-ioatdma_fixes-v1-1-2776a0913254@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index 8a115bafab6ab..2a47b9053bad8 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1450,6 +1450,7 @@ module_init(ioat_init_module);
 static void __exit ioat_exit_module(void)
 {
 	pci_unregister_driver(&ioat_pci_driver);
+	kmem_cache_destroy(ioat_sed_cache);
 	kmem_cache_destroy(ioat_cache);
 }
 module_exit(ioat_exit_module);
-- 
2.43.0



