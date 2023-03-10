Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1126847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5917DC433EF;
	Fri, 10 Mar 2023 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456530;
	bh=+0gThIHyZBEUYHQ/4qVHTDMAbmenVVT/8tL5NhFFXkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9ZqYHUxT8zjJbYcWpRd8AhHEZGCrRq9/oxBxK5SnWD15GYVFR+3pfSELk6R4mIuw
	 jPi9aBRwUXUdUPZh5RrXtiX7Hk4t+TZcsqHoDFgKkcSaRd3dVmZOLUmKnmWIp0pXJP
	 5GKH/b2qlNApyy+KFEbt8Xu5N2Qxis4o2WcRyi9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 034/211] ubi: Fix unreferenced object reported by kmemleak in ubi_resize_volume()
Date: Fri, 10 Mar 2023 14:36:54 +0100
Message-Id: <20230310133719.773919547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 1e591ea072df7211f64542a09482b5f81cb3ad27 ]

There is a memory leaks problem reported by kmemleak:

unreferenced object 0xffff888102007a00 (size 128):
  comm "ubirsvol", pid 32090, jiffies 4298464136 (age 2361.231s)
  hex dump (first 32 bytes):
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
  backtrace:
[<ffffffff8176cecd>] __kmalloc+0x4d/0x150
[<ffffffffa02a9a36>] ubi_eba_create_table+0x76/0x170 [ubi]
[<ffffffffa029764e>] ubi_resize_volume+0x1be/0xbc0 [ubi]
[<ffffffffa02a3321>] ubi_cdev_ioctl+0x701/0x1850 [ubi]
[<ffffffff81975d2d>] __x64_sys_ioctl+0x11d/0x170
[<ffffffff83c142a5>] do_syscall_64+0x35/0x80
[<ffffffff83e0006a>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

This is due to a mismatch between create and destroy interfaces, and
in detail that "new_eba_tbl" created by ubi_eba_create_table() but
destroyed by kfree(), while will causing "new_eba_tbl->entries" not
freed.

Fix it by replacing kfree(new_eba_tbl) with
ubi_eba_destroy_table(new_eba_tbl)

Fixes: 799dca34ac54 ("UBI: hide EBA internals")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/vmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 74637575346e8..9fbc64b997cef 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -515,7 +515,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 	return err;
 
 out_free:
-	kfree(new_eba_tbl);
+	ubi_eba_destroy_table(new_eba_tbl);
 	return err;
 }
 
-- 
2.39.2



