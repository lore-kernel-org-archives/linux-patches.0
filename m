Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52390354AE5;
	Tue, 16 Dec 2025 11:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885801; cv=none; b=mSg0UY6hpXmTv8zQsNggmNAyOPGf/YCuE2eGomjpkxXQA57grZFr//BIcpDWTfbrNUkknkmVmbpOj0sWvXK7/wrygCUBqMpA8whVK8wm8KTIY893CXCLBFcNXFi9VTIeCh11kWZyUi0hTkpNVxbmPyL8HLJR66RrucOyKJ9x8tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885801; c=relaxed/simple;
	bh=VAilaR8j69FOwIWcCulwM8ZF1tQMzxAgtczS+tGwtuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYoU1zstZO+cVUCtjgyP6+4tLyFbNn09X/HPhLKg4kmEHerZ+CJxBLpI0zNeoFhqXa7W8A0/ZS9Ljgj5ZpS5D8FR8sgqHD8qaLwVbtCoANtLw/R8K/QaXIL0rXmOG0hRLePrwGf02fEmM3RCLR/LoLUeBSp/IAzTNgkgGXfiZGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyhvaSmI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyhvaSmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFFAC4CEF1;
	Tue, 16 Dec 2025 11:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885801;
	bh=VAilaR8j69FOwIWcCulwM8ZF1tQMzxAgtczS+tGwtuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyhvaSmIFQA2PU3OR/m+2uq/ECBQm9R8qNrpPrCXRcLJ8E3CKzkEvgbvgeErTEZqo
	 XKKv2BvycyiBvnquG8mMEnJ9KLF6c7ZcyVQqVVVpT7xx/G49WAzf6UDbN6sR+F/99b
	 eTkMI31xv1REsLlfRJWFLAPIxTm4+dOM1Qljvo4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 205/507] md: delete md_redundancy_group when array is becoming inactive
Date: Tue, 16 Dec 2025 12:10:46 +0100
Message-ID: <20251216111352.938547974@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 0ce112d9171ad766d4c6716951e73f91a0bfc184 ]

'md_redundancy_group' are created in md_run() and deleted in del_gendisk(),
but these are not paired. Writing inactive/active to sysfs array_state can
trigger md_run() multiple times without del_gendisk(), leading to
duplicate creation as below:

 sysfs: cannot create duplicate filename '/devices/virtual/block/md0/md/sync_action'
 Call Trace:
  dump_stack_lvl+0x9f/0x120
  dump_stack+0x14/0x20
  sysfs_warn_dup+0x96/0xc0
  sysfs_add_file_mode_ns+0x19c/0x1b0
  internal_create_group+0x213/0x830
  sysfs_create_group+0x17/0x20
  md_run+0x856/0xe60
  ? __x64_sys_openat+0x23/0x30
  do_md_run+0x26/0x1d0
  array_state_store+0x559/0x760
  md_attr_store+0xc9/0x1e0
  sysfs_kf_write+0x6f/0xa0
  kernfs_fop_write_iter+0x141/0x2a0
  vfs_write+0x1fc/0x5a0
  ksys_write+0x79/0x180
  __x64_sys_write+0x1d/0x30
  x64_sys_call+0x2818/0x2880
  do_syscall_64+0xa9/0x580
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 md: cannot register extra attributes for md0

Creation of it depends on 'pers', its lifecycle cannot be aligned with
gendisk. So fix this issue by triggering 'md_redundancy_group' deletion
when the array is becoming inactive.

Link: https://lore.kernel.org/linux-raid/20251103125757.1405796-2-linan666@huaweicloud.com
Fixes: 790abe4d77af ("md: remove/add redundancy group only in level change")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 209ca3eade260..48345082d2eb3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6696,6 +6696,10 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		if (!md_is_rdwr(mddev))
 			set_disk_ro(disk, 0);
 
+		if (mode == 2 && mddev->pers->sync_request &&
+		    mddev->to_remove == NULL)
+			mddev->to_remove = &md_redundancy_group;
+
 		__md_stop_writes(mddev);
 		__md_stop(mddev);
 
-- 
2.51.0



