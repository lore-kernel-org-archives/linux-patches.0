Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865AC17966F;
	Wed,  3 Jul 2024 11:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004895; cv=none; b=hDrb8Rlh0KjOoWXT3QJ296AFU6uyYwX3MR7LyCsaVUNewF48fuVbcBx7pV0tnHONJtjYuz8exxwMkXjN4tIuekg+RmWnhaprGa0IlC5I0+fzRly4ye4C6XiAaeHoNZOugs4tvsLM0eKNjeMK3EmZ2QD4syKs398doB8rU/AqHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004895; c=relaxed/simple;
	bh=pbZShA5zJcTYGDVjn7yQyInI8/zno+JC2Sj52JC0KNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcCOvT3EyoUucNFd0HLw52Qf9SbA2BWoj4mnRLlvWhnBYGwVD2Ee3Xh3Tq9zUqyWNGz2FhDWrq141FnQRDFP89s6EAd+rMrvhSaVUiDCu1UtchuB0fI2Niore2AIYeGB+R2QomzUeVXFqI2ZYnxh6TzSKcBzbRDVEHZ+hjQa56Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fa+niCQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fa+niCQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2B2C2BD10;
	Wed,  3 Jul 2024 11:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004895;
	bh=pbZShA5zJcTYGDVjn7yQyInI8/zno+JC2Sj52JC0KNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fa+niCQ7nIrG1qSHaOnZHWH/NBRH3Y5J7eXxeiBYzZYELo6fuSNaYhao3VPCC9T6U
	 wLBj4Jk8qM97CZAUJ9NgPWNWgyuEUCUKKEK3jeES7aN+wWKZTjz989MMlhwytXMuGZ
	 78cX2QxZsVX7tcJ3mUaw+fecVLB724F9Kt5uWgcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/290] dmaengine: ioatdma: Fix missing kmem_cache_destroy()
Date: Wed,  3 Jul 2024 12:39:02 +0200
Message-ID: <20240703102910.260077236@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



