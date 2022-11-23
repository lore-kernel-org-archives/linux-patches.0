Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BA01C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6EFC433D6;
	Wed, 23 Nov 2022 09:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197083;
	bh=I0de6tU/91Ld37FFxXMW7zLvf5T389gBNGApIx/dz5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0UG0vK6k2RmGc11urm/mRaYGUH0YqSWgu00t4FNnHXQytuMtCsmkH6W9wF3x+c3R
	 hkGENT1tHcpfQ/op1+7T1TyuU14x9eVhtqRzFeDRbleHjBW0hOUd/IKFkQ/q61F+4X
	 ziYefiDxmUL93FLlsPd3EhuzUXgLUoLFjMnSESII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Jiri Pirko <jiri@mellanox.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 193/314] netdevsim: Fix memory leak of nsim_dev->fa_cookie
Date: Wed, 23 Nov 2022 09:50:38 +0100
Message-Id: <20221123084634.300589176@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 064bc7312bd09a48798418663090be0c776183db ]

kmemleak reports this issue:

unreferenced object 0xffff8881bac872d0 (size 8):
  comm "sh", pid 58603, jiffies 4481524462 (age 68.065s)
  hex dump (first 8 bytes):
    04 00 00 00 de ad be ef                          ........
  backtrace:
    [<00000000c80b8577>] __kmalloc+0x49/0x150
    [<000000005292b8c6>] nsim_dev_trap_fa_cookie_write+0xc1/0x210 [netdevsim]
    [<0000000093d78e77>] full_proxy_write+0xf3/0x180
    [<000000005a662c16>] vfs_write+0x1c5/0xaf0
    [<000000007aabf84a>] ksys_write+0xed/0x1c0
    [<000000005f1d2e47>] do_syscall_64+0x3b/0x90
    [<000000006001c6ec>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

The issue occurs in the following scenarios:

nsim_dev_trap_fa_cookie_write()
  kmalloc() fa_cookie
  nsim_dev->fa_cookie = fa_cookie
..
nsim_drv_remove()

The fa_cookie allocked in nsim_dev_trap_fa_cookie_write() is not freed. To
fix, add kfree(nsim_dev->fa_cookie) to nsim_drv_remove().

Fixes: d3cbb907ae57 ("netdevsim: add ACL trap reporting cookie as a metadata")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Link: https://lore.kernel.org/r/1668504625-14698-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b17e4e94a060..38562ed833da 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1675,6 +1675,7 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 				  ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
+	kfree(nsim_dev->fa_cookie);
 	devl_unlock(devlink);
 	devlink_free(devlink);
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
-- 
2.35.1



