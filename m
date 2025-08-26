Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F00343205;
	Tue, 26 Aug 2025 11:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208048; cv=none; b=AMqSOONnPnmGxGJV/IJ9WlulHTCE/LZaGVTkB+xmUGIKCs+5gkchVnopKIPnGwym66BasZMDRsGZK7OUtgaj8mBAhr0nfEkambiUn9UBNJBgvgaZIoCd+SRSLPR1N7JOnZS5WQhRwT8kcTkNuFlsoRxgfjgxfgFPHJrvFKoVulg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208048; c=relaxed/simple;
	bh=1FRMdDfpDOHY0/8N+h2som1WipNzyn4RMBv/d6g9NF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJwCg9da1DfL24rnV1Jx9M2MT/9Gmqzc0I7XnE/Pz3gzjo5tWDIYQJ4UJBan4TG7mBLkfZS6LyObM5QnJ8sfjbaRIeB6pCBTuLakUzwTaNxCReQmCtM+dC9bs3IOixlonqCEmmIJBV6jcnrSAYJZtTKslaFsSN0LLs+MUSh1j30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+qua+1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+qua+1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F32CC4CEF1;
	Tue, 26 Aug 2025 11:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208048;
	bh=1FRMdDfpDOHY0/8N+h2som1WipNzyn4RMBv/d6g9NF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+qua+1bJ8aM5EU6V+KvioEGPQag8Kf2+1opc1LOdHpwbkwti9m6KD5mtxi01vG9B
	 nLd6vDLZZ6kYZFYr2O2xfOlEAY3ksL9W/2p8uZyb98beheDqCSxfmDdGsBIei7OTDj
	 Pq8BBhbEuQjtLIpppzSTRspIeVjXNMBzLV+uBy+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 386/457] md: fix sync_action incorrect display during resync
Date: Tue, 26 Aug 2025 13:11:10 +0200
Message-ID: <20250826110946.839104859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit b7ee30f0efd12f42735ae233071015389407966c ]

During raid resync, if a disk becomes faulty, the operation is
briefly interrupted. The MD_RECOVERY_RECOVER flag triggered by
the disk failure causes sync_action to incorrectly show "recover"
instead of "resync". The same issue affects reshape operations.

Reproduction steps:
  mdadm -Cv /dev/md1 -l1 -n4 -e1.2 /dev/sd{a..d} // -> resync happened
  mdadm -f /dev/md1 /dev/sda                     // -> resync interrupted
  cat sync_action
  -> recover

Add progress checks in md_sync_action() for resync/recover/reshape
to ensure the interface correctly reports the actual operation type.

Fixes: 4b10a3bc67c1 ("md: ensure resync is prioritized over recovery")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250816002534.1754356-3-zhengqixing@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0348b5f3adc5..8746b22060a7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4831,9 +4831,33 @@ static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
 	       rdev->recovery_offset < sectors;
 }
 
+static enum sync_action md_get_active_sync_action(struct mddev *mddev)
+{
+	struct md_rdev *rdev;
+	bool is_recover = false;
+
+	if (mddev->resync_offset < MaxSector)
+		return ACTION_RESYNC;
+
+	if (mddev->reshape_position != MaxSector)
+		return ACTION_RESHAPE;
+
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev) {
+		if (rdev_needs_recovery(rdev, MaxSector)) {
+			is_recover = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
+}
+
 enum sync_action md_sync_action(struct mddev *mddev)
 {
 	unsigned long recovery = mddev->recovery;
+	enum sync_action active_action;
 
 	/*
 	 * frozen has the highest priority, means running sync_thread will be
@@ -4857,8 +4881,17 @@ enum sync_action md_sync_action(struct mddev *mddev)
 	    !test_bit(MD_RECOVERY_NEEDED, &recovery))
 		return ACTION_IDLE;
 
-	if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
-	    mddev->reshape_position != MaxSector)
+	/*
+	 * Check if any sync operation (resync/recover/reshape) is
+	 * currently active. This ensures that only one sync operation
+	 * can run at a time. Returns the type of active operation, or
+	 * ACTION_IDLE if none are active.
+	 */
+	active_action = md_get_active_sync_action(mddev);
+	if (active_action != ACTION_IDLE)
+		return active_action;
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
 		return ACTION_RESHAPE;
 
 	if (test_bit(MD_RECOVERY_RECOVER, &recovery))
-- 
2.50.1



