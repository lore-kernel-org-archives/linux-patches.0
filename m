Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C913B1DA3D;
	Tue,  3 Dec 2024 15:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238911; cv=none; b=Ta5cRqGqcFNIZ5XHBxQsbZFSLnNxYXPtamgeBrgGx47gBCJ+cZj6SNVRkj9MesclU0Q7R2cLky7lnI4K8DIAOJd9Dgv9XCX/mP76u0OmAgfjdchy23bIoh0MR1tq+I/6aKZAYBlT/fIyh6nXQwcEqo8YTp2smeWysUlJwdyUYAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238911; c=relaxed/simple;
	bh=mr8zoU5Y3VIsCfnyFLUiI3vfnUpXDOCpLuvzssCmdzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtpKxozLYdE6KgJHp/pvUczBkHObw7IKqwAfdPWIlRDv+TT+ljj96MLxvK3JlPOXc0j5Zod57u5K7LamQKMlhy4WyKXa9CZJTG6+QKQ9rP2nBzFDUz/ls6KRDkvi8k3Usyp4w1y59h3wcQeS+MDDpew6Hg7AfsZ95uHaw+xh+60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6Ugq2Ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6Ugq2Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFE1C4CECF;
	Tue,  3 Dec 2024 15:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238911;
	bh=mr8zoU5Y3VIsCfnyFLUiI3vfnUpXDOCpLuvzssCmdzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6Ugq2RyjVGiOOhndkLqTEXXqoMyJzWrnlq5/bJx6NnY/vHGJ0mmhqINQjaBoOb8O
	 ThRD/7VsJ+qYmLfwrcI1JBmZ4DXUi4ty2pCT/MCaYsq8QDkFQtHShwNC8W64mr0Rs9
	 3sy1fi+zksBEgnb0eUWx4zjnJMs/wFVw0erEHOJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 438/817] scsi: bfa: Fix use-after-free in bfad_im_module_exit()
Date: Tue,  3 Dec 2024 15:40:10 +0100
Message-ID: <20241203144012.977985124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 178b8f38932d635e90f5f0e9af1986c6f4a89271 ]

BUG: KASAN: slab-use-after-free in __lock_acquire+0x2aca/0x3a20
Read of size 8 at addr ffff8881082d80c8 by task modprobe/25303

Call Trace:
 <TASK>
 dump_stack_lvl+0x95/0xe0
 print_report+0xcb/0x620
 kasan_report+0xbd/0xf0
 __lock_acquire+0x2aca/0x3a20
 lock_acquire+0x19b/0x520
 _raw_spin_lock+0x2b/0x40
 attribute_container_unregister+0x30/0x160
 fc_release_transport+0x19/0x90 [scsi_transport_fc]
 bfad_im_module_exit+0x23/0x60 [bfa]
 bfad_init+0xdb/0xff0 [bfa]
 do_one_initcall+0xdc/0x550
 do_init_module+0x22d/0x6b0
 load_module+0x4e96/0x5ff0
 init_module_from_file+0xcd/0x130
 idempotent_init_module+0x330/0x620
 __x64_sys_finit_module+0xb3/0x110
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Allocated by task 25303:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0x7f/0x90
 fc_attach_transport+0x4f/0x4740 [scsi_transport_fc]
 bfad_im_module_init+0x17/0x80 [bfa]
 bfad_init+0x23/0xff0 [bfa]
 do_one_initcall+0xdc/0x550
 do_init_module+0x22d/0x6b0
 load_module+0x4e96/0x5ff0
 init_module_from_file+0xcd/0x130
 idempotent_init_module+0x330/0x620
 __x64_sys_finit_module+0xb3/0x110
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 25303:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x38/0x50
 kfree+0x212/0x480
 bfad_im_module_init+0x7e/0x80 [bfa]
 bfad_init+0x23/0xff0 [bfa]
 do_one_initcall+0xdc/0x550
 do_init_module+0x22d/0x6b0
 load_module+0x4e96/0x5ff0
 init_module_from_file+0xcd/0x130
 idempotent_init_module+0x330/0x620
 __x64_sys_finit_module+0xb3/0x110
 do_syscall_64+0xc1/0x1d0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Above issue happens as follows:

bfad_init
  error = bfad_im_module_init()
    fc_release_transport(bfad_im_scsi_transport_template);
  if (error)
    goto ext;

ext:
  bfad_im_module_exit();
    fc_release_transport(bfad_im_scsi_transport_template);
    --> Trigger double release

Don't call bfad_im_module_exit() if bfad_im_module_init() failed.

Fixes: 7725ccfda597 ("[SCSI] bfa: Brocade BFA FC SCSI driver")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20241023011809.63466-1-yebin@huaweicloud.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 62cb7a864fd53..70c7515a822f5 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1693,9 +1693,8 @@ bfad_init(void)
 
 	error = bfad_im_module_init();
 	if (error) {
-		error = -ENOMEM;
 		printk(KERN_WARNING "bfad_im_module_init failure\n");
-		goto ext;
+		return -ENOMEM;
 	}
 
 	if (strcmp(FCPI_NAME, " fcpim") == 0)
-- 
2.43.0



