Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1941863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D27C433D2;
	Wed, 28 Dec 2022 15:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241868;
	bh=4wxmTFFM2ifTlmTRmB/Qnje9Zc56oi5muRoYkLJ4SDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrYPGmJRnvX0x7ByVIFDf9VP5Owh62c1y4mhrRINjq7lIHs2NlmB0YafgtOUMRHc+
	 RjpXv9bOVqFKfOIghClPWwE4ak8pf5zp+Ea7UlHX0ZbBAeKEo6or++grpJa/3CQiap
	 06BXOryNEwVCXCwFHA3as2J+KvAVGqDrFT4jZUno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0299/1146] mtd: core: fix possible resource leak in init_mtd()
Date: Wed, 28 Dec 2022 15:30:38 +0100
Message-Id: <20221228144338.263431438@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 1aadf01e5076b9ab6bf294b9622335c651314895 ]

I got the error report while inject fault in init_mtd():

sysfs: cannot create duplicate filename '/devices/virtual/bdi/mtd-0'
Call Trace:
 <TASK>
 dump_stack_lvl+0x67/0x83
 sysfs_warn_dup+0x60/0x70
 sysfs_create_dir_ns+0x109/0x120
 kobject_add_internal+0xce/0x2f0
 kobject_add+0x98/0x110
 device_add+0x179/0xc00
 device_create_groups_vargs+0xf4/0x100
 device_create+0x7b/0xb0
 bdi_register_va.part.13+0x58/0x2d0
 bdi_register+0x9b/0xb0
 init_mtd+0x62/0x171 [mtd]
 do_one_initcall+0x6c/0x3c0
 do_init_module+0x58/0x222
 load_module+0x268e/0x27d0
 __do_sys_finit_module+0xd5/0x140
 do_syscall_64+0x37/0x90
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>
kobject_add_internal failed for mtd-0 with -EEXIST, don't try to register
	things with the same name in the same directory.
Error registering mtd class or bdi: -17

If init_mtdchar() fails in init_mtd(), mtd_bdi will not be unregistered,
as a result, we can't load the mtd module again, to fix this by calling
bdi_unregister(mtd_bdi) after out_procfs label.

Fixes: 445caaa20c4d ("mtd: Allocate bdi objects dynamically")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221024065109.2050705-1-cuigaosheng1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index a16627455c1d..675305139a54 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -2485,6 +2485,7 @@ static int __init init_mtd(void)
 out_procfs:
 	if (proc_mtd)
 		remove_proc_entry("mtd", NULL);
+	bdi_unregister(mtd_bdi);
 	bdi_put(mtd_bdi);
 err_bdi:
 	class_unregister(&mtd_class);
-- 
2.35.1



