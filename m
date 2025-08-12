Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A386BB5B;
	Tue, 12 Aug 2025 18:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023228; cv=none; b=JMgmZS/ix0pWjgLvoq9euGkviL9CICty24Uach9wl2SeTbpksQBUd9CvdGz7uuHUfIqJhCPHh133Y+yZqyHKuS7dojyD5uH9P0tGDV8qbN0O8dU+ZY5TQJaYwjxm5y9klNKY1tDc6g7+oFnO+COEaHD5MrNPH2Pp8bzHxPN01YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023228; c=relaxed/simple;
	bh=9k0i24K2HM8mkulCgeBurjpVmZkBQLsmW7XpFcOP0Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcPlKK2oEz9oSdrekFpU6+oBvRn7wRAV6Zw/YzEhHhAmPodVPVueemIl4KQCZ/tIYMODqY2gB0N89Z69O2BxO+uP+uq6b0C2bncIHLSlFDSWZLoP1y4JX6owIB8tPMipzXjM5ICWlcVi+ArmmHqmmj56rc1O/3w2jYAitxaICw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQGAEC4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQGAEC4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFECBC4CEF0;
	Tue, 12 Aug 2025 18:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023228;
	bh=9k0i24K2HM8mkulCgeBurjpVmZkBQLsmW7XpFcOP0Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQGAEC4OYRYWVwAS0Xo2APbBp6VwqCo/89KzdqhrmXnCApdbUkPy2l8VCJnxFFBmj
	 F76Va78GTZwKheb4ozTRACLFC37RWvkNTj4AaxAlr9S2OAOP6SxKp9iG6OQlgy8Zs+
	 S/VLsiDPPdIxnJ3WIRAzaavZqcoMLoudGbt3XpxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 019/627] ublk: validate ublk server pid
Date: Tue, 12 Aug 2025 19:25:14 +0200
Message-ID: <20250812173420.051129007@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c2c8089f325ed703fd5123b39e2dece1dd605904 ]

ublk server pid(the `tgid` of the process opening the ublk device) is stored
in `ublk_device->ublksrv_tgid`. This `tgid` is then checked against the
`ublksrv_pid` in `ublk_ctrl_start_dev` and `ublk_ctrl_end_recovery`.

This ensures that correct ublk server pid is stored in device info.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250713143415.2857561-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 2492c11defcc..3e60558bf525 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -218,6 +218,7 @@ struct ublk_device {
 	unsigned int		nr_privileged_daemon;
 	struct mutex cancel_mutex;
 	bool canceling;
+	pid_t 	ublksrv_tgid;
 };
 
 /* header of ublk_params */
@@ -1517,6 +1518,7 @@ static int ublk_ch_open(struct inode *inode, struct file *filp)
 	if (test_and_set_bit(UB_STATE_OPEN, &ub->state))
 		return -EBUSY;
 	filp->private_data = ub;
+	ub->ublksrv_tgid = current->tgid;
 	return 0;
 }
 
@@ -1531,6 +1533,7 @@ static void ublk_reset_ch_dev(struct ublk_device *ub)
 	ub->mm = NULL;
 	ub->nr_queues_ready = 0;
 	ub->nr_privileged_daemon = 0;
+	ub->ublksrv_tgid = -1;
 }
 
 static struct gendisk *ublk_get_disk(struct ublk_device *ub)
@@ -2732,6 +2735,9 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub,
 	if (wait_for_completion_interruptible(&ub->completion) != 0)
 		return -EINTR;
 
+	if (ub->ublksrv_tgid != ublksrv_pid)
+		return -EINVAL;
+
 	mutex_lock(&ub->mutex);
 	if (ub->dev_info.state == UBLK_S_DEV_LIVE ||
 	    test_bit(UB_STATE_USED, &ub->state)) {
@@ -3232,6 +3238,9 @@ static int ublk_ctrl_end_recovery(struct ublk_device *ub,
 	pr_devel("%s: All FETCH_REQs received, dev id %d\n", __func__,
 		 header->dev_id);
 
+	if (ub->ublksrv_tgid != ublksrv_pid)
+		return -EINVAL;
+
 	mutex_lock(&ub->mutex);
 	if (ublk_nosrv_should_stop_dev(ub))
 		goto out_unlock;
-- 
2.39.5



