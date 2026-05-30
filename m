Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E51267B05;
	Sat, 30 May 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162965; cv=none; b=nxwSNn6yrBDuONWh4+5W9ASXwUaJjLrSP0roM99d91fBXnWlPZYCFzFmLLWi0/4sbf74Kh0mg4kyJjryjtKBS3ESiy1V+A95C0kHv1VWluBYXIBmuNLbd4q5sr4ZzWlZq3JCZ2ki5Kt08umj5xPCSijEElLMGvF9t7UuQcQrZ9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162965; c=relaxed/simple;
	bh=pENjsD1zHE2IJHmiGduQNZgunfw0Vy2gcvGleLTjUes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jl10xiTW6Qds4VxN2joi+2tPRbzzTKmU9LIrfhHvrf5J413mNkqU32+W5gVigPSiHO3+Ko0tMOwQPRnN0fZWliwxA22RzeOMTBrCvwhebFVMPHXTVNRw2bYW0eN+cEJCJKVLdGwjgKM8pXjjhwNF5/Vggdcip5dZlZb0KgEBa/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwmXH9QV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwmXH9QV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6E31F00893;
	Sat, 30 May 2026 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162964;
	bh=MiuOeLc144If47qBQO66tzTeuWb74jwtHUkgA3ZiQng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwmXH9QVguEO433hdxrneusybsWVxYeUgWjZR8rCDnvZ47wq7KIW/jw2oRfmQgvTm
	 MAy1UY0v+9rYd9//VG3tIhsaHDbpsCwcFuKdtWIbZC1Tw8Xn6MxvMVVoKliV23p0WB
	 Z0bDeJNtwYjcogkz+YXbZi6ihsU0FEH3SYzgnoOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yufen <wangyufen@huawei.com>,
	Jiri Pirko <jiri@mellanox.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johnny Hao <johnny_haocn@sina.com>
Subject: [PATCH 5.15 117/776] netdevsim: Fix memory leak of nsim_dev->fa_cookie
Date: Sat, 30 May 2026 17:57:11 +0200
Message-ID: <20260530160243.392274376@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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
[ The context change is due to the commit 5e388f3dc38c
("netdevsim: move vfconfig to nsim_dev") in v5.16
which is irrelevant to the logic of this patch. ]
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netdevsim/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -1582,6 +1582,7 @@ void nsim_dev_remove(struct nsim_bus_dev
 				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
+	kfree(nsim_dev->fa_cookie);
 	devlink_free(devlink);
 }
 


