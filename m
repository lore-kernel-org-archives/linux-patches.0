Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330556FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B2AC433D6;
	Wed, 30 Nov 2022 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832842;
	bh=fzpA+MbyfrK49x1thdSWdgrba0goxHCPS1gwm65PVkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWNG/nwEW3B13r4v8tUq9++ZucRbz/XJzXUaHruQ16+AgyQWjR2BKzjJ0L5QrYi/8
	 kS5mpmvXUoiwh3DwpZVzNYC0hzTF6vRvddia0N7kzLVxMcsKPqJcaYBhcQq3ba5S4h
	 1F9RVuDhwOUG1NkGXLcZqHD2hIYKuWHcU0BjU2RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/162] regulator: core: fix UAF in destroy_regulator()
Date: Wed, 30 Nov 2022 19:22:03 +0100
Message-Id: <20221130180529.647591788@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 1f386d6894d0f1b7de8ef640c41622ddd698e7ab ]

I got a UAF report as following:

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x935/0x2060
Read of size 8 at addr ffff88810e838220 by task python3/268
Call Trace:
 <TASK>
 dump_stack_lvl+0x67/0x83
 print_report+0x178/0x4b0
 kasan_report+0x90/0x190
 __lock_acquire+0x935/0x2060
 lock_acquire+0x156/0x400
 _raw_spin_lock+0x2a/0x40
 lockref_get+0x11/0x30
 simple_recursive_removal+0x41/0x440
 debugfs_remove.part.12+0x32/0x50
 debugfs_remove+0x29/0x30
 _regulator_put.cold.54+0x3e/0x27f
 regulator_put+0x1f/0x30
 release_nodes+0x6a/0xa0
 devres_release_all+0xf8/0x150

Allocated by task 37:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 __kasan_slab_alloc+0x5d/0x70
 slab_post_alloc_hook+0x62/0x510
 kmem_cache_alloc_lru+0x222/0x5a0
 __d_alloc+0x31/0x440
 d_alloc+0x30/0xf0
 d_alloc_parallel+0xc4/0xd20
 __lookup_slow+0x15e/0x2f0
 lookup_one_len+0x13a/0x150
 start_creating+0xea/0x190
 debugfs_create_dir+0x1e/0x210
 create_regulator+0x254/0x4e0
 _regulator_get+0x2a1/0x467
 _devm_regulator_get+0x5a/0xb0
 regulator_virtual_probe+0xb9/0x1a0

Freed by task 30:
 kasan_save_stack+0x1c/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x50
 __kasan_slab_free+0x102/0x190
 kmem_cache_free+0xf6/0x600
 rcu_core+0x54c/0x12b0
 __do_softirq+0xf2/0x5e3

Last potentially related work creation:
 kasan_save_stack+0x1c/0x40
 __kasan_record_aux_stack+0x98/0xb0
 call_rcu+0x42/0x700
 dentry_free+0x6c/0xd0
 __dentry_kill+0x23b/0x2d0
 dput.part.31+0x431/0x780
 simple_recursive_removal+0xa9/0x440
 debugfs_remove.part.12+0x32/0x50
 debugfs_remove+0x29/0x30
 regulator_unregister+0xe3/0x230
 release_nodes+0x6a/0xa0

==================================================================

Here is how happened:

processor A					processor B
regulator_register()
  rdev_init_debugfs()
    rdev->debugfs = debugfs_create_dir()
						devm_regulator_get()
						  rdev = regulator_dev_lookup()
						  create_regulator(rdev)
						    // using rdev->debugfs as parent
						    debugfs_create_dir(rdev->debugfs)

mfd_remove_devices_fn()
  release_nodes()
    regulator_unregister()
      // free rdev->debugfs
      debugfs_remove_recursive(rdev->debugfs)
						release_nodes()
						  destroy_regulator()
						    debugfs_remove_recursive() <- causes UAF

In devm_regulator_get(), after getting rdev, the refcount
is get, so fix this by moving debugfs_remove_recursive()
to regulator_dev_release(), then it can be proctected by
the refcount, the 'rdev->debugfs' can not be freed until
the refcount is 0.

Fixes: 5de705194e98 ("regulator: Add basic per consumer debugfs")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221116033706.3595812-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f43c668e1630..eb083b26ab4f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4928,6 +4928,7 @@ static void regulator_dev_release(struct device *dev)
 {
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 
+	debugfs_remove_recursive(rdev->debugfs);
 	kfree(rdev->constraints);
 	of_node_put(rdev->dev.of_node);
 	kfree(rdev);
@@ -5438,7 +5439,6 @@ void regulator_unregister(struct regulator_dev *rdev)
 
 	mutex_lock(&regulator_list_mutex);
 
-	debugfs_remove_recursive(rdev->debugfs);
 	WARN_ON(rdev->open_count);
 	regulator_remove_coupling(rdev);
 	unset_regulator_supplies(rdev);
-- 
2.35.1



