Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51ECEEC9;
	Tue, 10 Sep 2024 09:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962339; cv=none; b=qiSIkhsi4YWSUQAjz0of19DGiCeuVbyknnTHWlL1ErHiibocBTIzsDVsx6aK6UPy0rPNAU1SeFF+SUPgh/1NaZGTfVGtGtCXtk2tyCqTLX+fdJrCjcQ818HqYEHd6WZu8xRp470jgFRAkezk7LVJvvsEyGdVXzSvTo1F/HiCvqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962339; c=relaxed/simple;
	bh=7Odgf81H/fPmEJ5oW500Y533kklo12xiLW7U8/EPqag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8qYqhFiJRiH8w3xwwE6eNqa88+WRI2RKG6Apl1+Tz9vkG9CK9YeQqVaUsEY7Rw+sB7a4ZgQePNaHx6BupbWxxiVkryQVD+nK9hPAgh4yndLQX3zBK/4wLc4c/BcMJ8QXkEAfWB7TDWVN8F9+OIYvzASd+lJ7IcgCeOLBMIeDgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UuIIKkPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UuIIKkPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A90C4CEC3;
	Tue, 10 Sep 2024 09:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962339;
	bh=7Odgf81H/fPmEJ5oW500Y533kklo12xiLW7U8/EPqag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuIIKkPzDoPMkU8EEU6Dn+mOTKnjgsF83KDqC4JEv8yPXPmP8JEeDufJUh9TqC7Y4
	 Iy61UVrxaoTJjCEH043HTblzqMp5WpkLwOB6/4nF7XjBfnqFDtkbXfa/huiVY/VpqU
	 68AFB/PpD6dtqDLAFenz1qY7scRAOwHLpwbwZmt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Li Nan <linan122@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	Changhui Zhong <czhong@redhat.com>
Subject: [PATCH 6.10 369/375] ublk_drv: fix NULL pointer dereference in ublk_ctrl_start_recovery()
Date: Tue, 10 Sep 2024 11:32:46 +0200
Message-ID: <20240910092635.023314626@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit e58f5142f88320a5b1449f96a146f2f24615c5c7 ]

When two UBLK_CMD_START_USER_RECOVERY commands are submitted, the
first one sets 'ubq->ubq_daemon' to NULL, and the second one triggers
WARN in ublk_queue_reinit() and subsequently a NULL pointer dereference
issue.

Fix it by adding the check in ublk_ctrl_start_recovery() and return
immediately in case of zero 'ub->nr_queues_ready'.

  BUG: kernel NULL pointer dereference, address: 0000000000000028
  RIP: 0010:ublk_ctrl_start_recovery.constprop.0+0x82/0x180
  Call Trace:
   <TASK>
   ? __die+0x20/0x70
   ? page_fault_oops+0x75/0x170
   ? exc_page_fault+0x64/0x140
   ? asm_exc_page_fault+0x22/0x30
   ? ublk_ctrl_start_recovery.constprop.0+0x82/0x180
   ublk_ctrl_uring_cmd+0x4f7/0x6c0
   ? pick_next_task_idle+0x26/0x40
   io_uring_cmd+0x9a/0x1b0
   io_issue_sqe+0x193/0x3f0
   io_wq_submit_work+0x9b/0x390
   io_worker_handle_work+0x165/0x360
   io_wq_worker+0xcb/0x2f0
   ? finish_task_switch.isra.0+0x203/0x290
   ? finish_task_switch.isra.0+0x203/0x290
   ? __pfx_io_wq_worker+0x10/0x10
   ret_from_fork+0x2d/0x50
   ? __pfx_io_wq_worker+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Fixes: c732a852b419 ("ublk_drv: add START_USER_RECOVERY and END_USER_RECOVERY support")
Reported-and-tested-by: Changhui Zhong <czhong@redhat.com>
Closes: https://lore.kernel.org/all/CAGVVp+UvLiS+bhNXV-h2icwX1dyybbYHeQUuH7RYqUvMQf6N3w@mail.gmail.com
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Li Nan <linan122@huawei.com>
Link: https://lore.kernel.org/r/20240904031348.4139545-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 3b5883932133..fc001e9f95f6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2664,6 +2664,8 @@ static int ublk_ctrl_start_recovery(struct ublk_device *ub,
 	mutex_lock(&ub->mutex);
 	if (!ublk_can_use_recovery(ub))
 		goto out_unlock;
+	if (!ub->nr_queues_ready)
+		goto out_unlock;
 	/*
 	 * START_RECOVERY is only allowd after:
 	 *
-- 
2.43.0



