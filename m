Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9383A137910;
	Wed,  3 Jul 2024 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004080; cv=none; b=sW/5oeaaIEv52j/7+OPZZvki1WcMf3cbmwRkMRcnwo1pajioGJWem79l4kGYRPsnFKudbvdNbqqRwlpAq+4VSNbi5SihiF592KCkWaQnmeOLyWldLqoAOa5rIF1VvnPVom9AV1OUrlmeI4F5W4Jv//ISwtvMsMz8amy4E4cnQYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004080; c=relaxed/simple;
	bh=UCTOzkI8gNMTiJkXLB+pAbBrerR+/VWUJQmQE624JR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB4j5X7N0fyDbAgbDVssFjIFn3QlyP8DfYDB/lq7lwhpI1scXs4n38IgqaO/HeRBrixxPoPFV6MUiHfTRl8+d/OUXEb6k2eElqJJ7MZuQgmb9p6KEEaH83HqJI2pgHJHRcsWb7GyKrku9X0iO2zOuFoH0Dw8tYCu6+xbNmUwNQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OeJEeanI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OeJEeanI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D66C2BD10;
	Wed,  3 Jul 2024 10:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004080;
	bh=UCTOzkI8gNMTiJkXLB+pAbBrerR+/VWUJQmQE624JR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OeJEeanIPimA/yzgzI78gewdIlvb9Kg30I63sc9p9DiL2K7i0mDlUIjtVqaYNQ5A6
	 dliOwUjb6VJdCsstPs9qpWGR0esvWSY7f/awt9KdFgV+ZdF5AsARjb1EPAfXaeswu+
	 xXng/dHIT0jUm3/X8hKVgGDYcb8c+T8ocNa45NNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 115/189] dmaengine: ioatdma: Fix missing kmem_cache_destroy()
Date: Wed,  3 Jul 2024 12:39:36 +0200
Message-ID: <20240703102845.839088040@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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
index a6a6dc432db82..de1ac910464e5 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1446,6 +1446,7 @@ module_init(ioat_init_module);
 static void __exit ioat_exit_module(void)
 {
 	pci_unregister_driver(&ioat_pci_driver);
+	kmem_cache_destroy(ioat_sed_cache);
 	kmem_cache_destroy(ioat_cache);
 }
 module_exit(ioat_exit_module);
-- 
2.43.0



