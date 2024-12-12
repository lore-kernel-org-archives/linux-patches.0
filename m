Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5DE13CA93;
	Thu, 12 Dec 2024 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024072; cv=none; b=BrOCrbl94uUmCAVcHVyC/raUGZiopwUlTM/0hbS7UPMZqfUXiKAQ39LvlQz7qK7KGCl/5+9dgunHhMiM4NMZMgkas9PZGiIFOWNbMElW4qy7WcQBK56Uvm+1+KtkIL4rTXKy6Op2tNCVEEYICdBCujiAu64yMKP5apCf5I6sT4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024072; c=relaxed/simple;
	bh=qwvHZfHejgQ2Z+HonXeJZTSOpvTdlJEl2/nnTEHaOAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EO2eCbVY6+RHEm1sN7ECYfZ835f0UVieNeXBDD27q9ffTGtMpSRoDATdH0HBptPWgqwpwvm921CBozeqDLpC+E8/YZQEnzrqcEv0YeGZjmI0xkWqFcytFOpj4Fh6dcSAS7MOH9hTsurkgRIPyL/Dzxc2FLwRQDdkkja6mQ9Shy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWhvDN3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWhvDN3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5258AC4CECE;
	Thu, 12 Dec 2024 17:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024072;
	bh=qwvHZfHejgQ2Z+HonXeJZTSOpvTdlJEl2/nnTEHaOAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWhvDN3mYdkPZhARdu9el3sxnlNbLtb6hfZX9nYjMvRtIn9dKa35WtNrKsxcsYxNU
	 KOGsycj6QHzc3O0Y3Rylp+wp79MIr4bUxGFTSpEqcqjP0iEsBh1zmBMfDp8YhPCVFj
	 JoJbrRopBpvVobJjgnH5E4i6zKGYnpblsHrxxPp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/459] scsi: bfa: Fix use-after-free in bfad_im_module_exit()
Date: Thu, 12 Dec 2024 15:58:34 +0100
Message-ID: <20241212144300.476599649@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 440ef32be048f..45b5f83ad6da1 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1705,9 +1705,8 @@ bfad_init(void)
 
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



