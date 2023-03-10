Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AE7881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EF6C4339C;
	Fri, 10 Mar 2023 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459247;
	bh=5at4ai9yLrDP04I+bN+t21bFY5RKB+tceFpFTfRme3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FR7u4BhEUA64FrVHLAHMKz+2H7zj/n2atTZj9PKzjPdKTnMC+cOmj3OypCcBpkEIP
	 3JGDJh0bNeZEK6ypB0H77klolAnKrzJjF5V5yGSCCtzK4zn7yb2SKvMoppor+Ol7K5
	 TKhkfEl6eDIW4OToocSP2K92FECnnGFERgGRY9uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zetao <lizetao1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 298/357] ubi: Fix use-after-free when volume resizing failed
Date: Fri, 10 Mar 2023 14:39:47 +0100
Message-Id: <20230310133747.902743255@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

[ Upstream commit 9af31d6ec1a4be4caab2550096c6bd2ba8fba472 ]

There is an use-after-free problem reported by KASAN:
  ==================================================================
  BUG: KASAN: use-after-free in ubi_eba_copy_table+0x11f/0x1c0 [ubi]
  Read of size 8 at addr ffff888101eec008 by task ubirsvol/4735

  CPU: 2 PID: 4735 Comm: ubirsvol
  Not tainted 6.1.0-rc1-00003-g84fa3304a7fc-dirty #14
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
  BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   print_report+0x171/0x472
   kasan_report+0xad/0x130
   ubi_eba_copy_table+0x11f/0x1c0 [ubi]
   ubi_resize_volume+0x4f9/0xbc0 [ubi]
   ubi_cdev_ioctl+0x701/0x1850 [ubi]
   __x64_sys_ioctl+0x11d/0x170
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
   </TASK>

When ubi_change_vtbl_record() returns an error in ubi_resize_volume(),
"new_eba_tbl" will be freed on error handing path, but it is holded
by "vol->eba_tbl" in ubi_eba_replace_table(). It means that the liftcycle
of "vol->eba_tbl" and "vol" are different, so when resizing volume in
next time, it causing an use-after-free fault.

Fix it by not freeing "new_eba_tbl" after it replaced in
ubi_eba_replace_table(), while will be freed in next volume resizing.

Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/vmt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 6ea95ade4ca6b..6c7822c1cc451 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -464,7 +464,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		for (i = 0; i < -pebs; i++) {
 			err = ubi_eba_unmap_leb(ubi, vol, reserved_pebs + i);
 			if (err)
-				goto out_acc;
+				goto out_free;
 		}
 		spin_lock(&ubi->volumes_lock);
 		ubi->rsvd_pebs += pebs;
@@ -512,6 +512,8 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		ubi->avail_pebs += pebs;
 		spin_unlock(&ubi->volumes_lock);
 	}
+	return err;
+
 out_free:
 	kfree(new_eba_tbl);
 	return err;
-- 
2.39.2



