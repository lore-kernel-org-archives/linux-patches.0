Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B62D235895;
	Thu, 12 Dec 2024 16:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022497; cv=none; b=AbebMiCGBu9YRNGEoxfX0Hm21KwXwvj2EhIR+0FW+slR028kIjZw2Tf4wY5+fsKa/IXMhU4Hvg7m1sc51DXIeGvYdMNIwvxRR7PQ8OuQZJwkIIQzrlB63n5k7RhYaOJUvxOlW6GOdF8/Ye9tb6WN7xfNWZpsEFE6u5XjPcm+O4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022497; c=relaxed/simple;
	bh=HJaqEnF1b2Upb6EsmXWGCfA5sFi78GknmNRFTojTPuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoKzrcUBn6Eu52UFY2QwGOB4BbjwH/8B8eCMHlk9WKluFJzKDYskdwMV7HQ3UP186D6Nb7RKVj8TH0ANxdHN6KjtahWQ5R6+Mv3f5IMga+IwFzSa/WR6ZdR40PITzPPLG+lFwYGpA4ZpIG6kisSk1DEQAqGVyeKxk6d1IpQ1EWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rx/n3dat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rx/n3dat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D739C4CECE;
	Thu, 12 Dec 2024 16:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022497;
	bh=HJaqEnF1b2Upb6EsmXWGCfA5sFi78GknmNRFTojTPuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rx/n3datXTCwsXJEWkSCSh8wc1gCBLoWaOGWKRmJ4X/zkyMdAB4zDa3Q6vEreddv/
	 yNnkLY6DTNUSJ23kVJ+sumeqsymvlGPPFtssTef0KWBzS8hS+GmqGtcHMsnqSRyRXP
	 kZJdwj2vkvKg6ZCB6tUH/8IkkzvIwnP15OqtTsdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 226/565] scsi: bfa: Fix use-after-free in bfad_im_module_exit()
Date: Thu, 12 Dec 2024 15:57:01 +0100
Message-ID: <20241212144320.421457405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



