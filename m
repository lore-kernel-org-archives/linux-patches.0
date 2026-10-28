Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210823;
	b=PaPYKN7Drm8kwy3r56gEuCXhXj0CYxkk4nN+zWlhfSwnJWsJ/znbTfytvW3gqOwpi3Pj
	 PDVM63CxburBNhH69jpEVBImVt1XBG++hjzJoxEBhIIYVwpFAhypJYS1oLGDqs2BcNgE/
	 rGz8GwJiMTOM9A5Prl08ndIauCYlNyBBxC/dKpIoVQUyQA+Zbrp00Qr2sT0FPXEQbyslO
	 uf7O7/We12VK822gGNsEFMH9lq9g0BOWpZcaaAoyY0cqZYEqJ1Jf/L6LVTE8yJNyf9xmo
	 kcfhoQyZWMPPd+bRj54A5tkuYpwjaQxLvp9UshpC75V2UKLdns7QRG0Y1qYbfCANxfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HiFjJIXXz4jPB7QMRssnzaIiGe1FoR12Bwtb+dmM7fQ=;
	b=eHfL50MllyYEKiazGR23bHPHyYRoc9Bsb8VGm5O4D5xM6hQ5q0V2pjEQ0VrQUkvGA+nH
	 Kg37IKTLC7GIYDIWD6gJR90RpzhNhUfVKGk3CO6zbjtXpt+CL0WPIwP0VukDJsdf2igVx
	 C451PKKC1g3WGb8FeHRRBF/NEpcitjp+ZB0C79g0AIOck+t4If+Y0bmDvoSQmUeNiVMJH
	 a3xIlTbx+iviTjlwzIqdb7BAnzjV4waxQg7JMLqx2dO/9dTBv7Ll99Y9DP7yfOtG0DMk5
	 jEYcfkdBpIpFmFBZuyheRuLuDzN9E3Rnek+QbNMz+n/0hBt5BvRdmYnjGONhaeWUNAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v57ph1nm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D244C606A31A;
	Wed, 28 Oct 2026 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v57ph1nm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AACC1F01829;
	Wed, 28 Oct 2026 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210822;
	bh=HiFjJIXXz4jPB7QMRssnzaIiGe1FoR12Bwtb+dmM7fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v57ph1nmtINeSpp96Yo0A+K3yWNgu9QGT1zLmPjGUPufu2leqWCwDMYN5w4E1DMtJ
	 +nVHkmgbJ5A/YHG/PwoG1qJQvlc1tcSYP6dIHW62hk/iqu5Da1xoGtNdSEtbTQtItT
	 gTcbzzBd5JMJ89iXHvi2w2s6N+Y/zGUm7vS/iFJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/571] mtd: core: Fix refcount error in del_mtd_device()
Date: Wed, 28 Oct 2026 17:55:07 +0100
Message-ID: <20261028170011.815065510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Stable-dep-of: 12b31d1acd20 ("mtd: core: call _get_device() with the master MTD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 74e449db33ac3..69cc4a66ea151 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -724,6 +724,7 @@ int del_mtd_device(struct mtd_info *mtd)
 {
 	int ret;
 	struct mtd_notifier *not;
+	struct device_node *mtd_of_node;
 
 	mutex_lock(&mtd_table_mutex);
 
@@ -742,6 +743,7 @@ int del_mtd_device(struct mtd_info *mtd)
 		       mtd->index, mtd->name, mtd->usecount);
 		ret = -EBUSY;
 	} else {
+		mtd_of_node = mtd_get_of_node(mtd);
 		debugfs_remove_recursive(mtd->dbg.dfs_dir);
 
 		/* Try to remove the NVMEM provider */
@@ -753,7 +755,7 @@ int del_mtd_device(struct mtd_info *mtd)
 		memset(&mtd->dev, 0, sizeof(mtd->dev));
 
 		idr_remove(&mtd_idr, mtd->index);
-		of_node_put(mtd_get_of_node(mtd));
+		of_node_put(mtd_of_node);
 
 		module_put(THIS_MODULE);
 		ret = 0;
-- 
2.53.0



