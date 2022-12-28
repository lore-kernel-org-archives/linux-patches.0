Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6BD1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD14C433D2;
	Wed, 28 Dec 2022 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242140;
	bh=/aSOXQAJeiMzlBd22jGkYJcM9R+JGnV9U3LrwlbBwO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxPMOqeVeR+GACiB4xxAgQDe19bSUN5R0MfsSp91GDrMkE9Bwnze9MXAun3ZpZgki
	 ZU1YPUbb0WGojR/RzReTAb8UtYPLaUIZqZ/mwVBKhnORsYn3QUeDRjk4h2J1sNNArf
	 zvK8OtZ3K0jIzAN9E2A6memTMgHGPFz1iCOlixp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0372/1073] mtd: core: Fix refcount error in del_mtd_device()
Date: Wed, 28 Dec 2022 15:32:40 +0100
Message-Id: <20221228144338.107672013@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 56570bdad5e31c5c538cd6efff5c4510256e1bb4 ]

del_mtd_device() will call of_node_put() to mtd_get_of_node(mtd), which
is mtd->dev.of_node. However, memset(&mtd->dev, 0) is called before
of_node_put(). As the result, of_node_put() won't do anything in
del_mtd_device(), and causes the refcount leak.

del_mtd_device()
    memset(&mtd->dev, 0, sizeof(mtd->dev) # clear mtd->dev
    of_node_put()
        mtd_get_of_node(mtd) # mtd->dev is cleared, can't locate of_node
                             # of_node_put(NULL) won't do anything

Fix the error by caching the pointer of the device_node.

OF: ERROR: memory leak, expected refcount 1 instead of 2,
of_node_get()/of_node_put() unbalanced - destroy cset entry: attach
overlay node /spi/spi-sram@0
CPU: 3 PID: 275 Comm: python3 Tainted: G N 6.1.0-rc3+ #54
    0d8a1edddf51f172ff5226989a7565c6313b08e2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
Call Trace:
<TASK>
    dump_stack_lvl+0x67/0x83
    kobject_get+0x155/0x160
    of_node_get+0x1f/0x30
    of_fwnode_get+0x43/0x70
    fwnode_handle_get+0x54/0x80
    fwnode_get_nth_parent+0xc9/0xe0
    fwnode_full_name_string+0x3f/0xa0
    device_node_string+0x30f/0x750
    pointer+0x598/0x7a0
    vsnprintf+0x62d/0x9b0
    ...
    cfs_overlay_release+0x30/0x90
    config_item_release+0xbe/0x1a0
    config_item_put+0x5e/0x80
    configfs_rmdir+0x3bd/0x540
    vfs_rmdir+0x18c/0x320
    do_rmdir+0x198/0x330
    __x64_sys_rmdir+0x2c/0x40
    do_syscall_64+0x37/0x90
    entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 00596576a051 ("mtd: core: clear out unregistered devices a bit more")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
[<miquel.raynal@bootlin.com>: Light reword of the commit log]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221119063915.11108-1-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 37050c551880..c14196bbf008 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -776,6 +776,7 @@ int del_mtd_device(struct mtd_info *mtd)
 {
 	int ret;
 	struct mtd_notifier *not;
+	struct device_node *mtd_of_node;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -794,6 +795,7 @@ int del_mtd_device(struct mtd_info *mtd)
 		       mtd->index, mtd->name, mtd->usecount);
 		ret = -EBUSY;
 	} else {
+		mtd_of_node = mtd_get_of_node(mtd);
 		debugfs_remove_recursive(mtd->dbg.dfs_dir);
 
 		/* Try to remove the NVMEM provider */
@@ -805,7 +807,7 @@ int del_mtd_device(struct mtd_info *mtd)
 		memset(&mtd->dev, 0, sizeof(mtd->dev));
 
 		idr_remove(&mtd_idr, mtd->index);
-		of_node_put(mtd_get_of_node(mtd));
+		of_node_put(mtd_of_node);
 
 		module_put(THIS_MODULE);
 		ret = 0;
-- 
2.35.1



