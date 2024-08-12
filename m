Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99051EA8D;
	Mon, 12 Aug 2024 16:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478722; cv=none; b=a5o2ZumLJhfNBZnpQ24DpXEYZe8Vmyy2nB2QJ6OPRZVz3uR4FvhaL+ca8mQQyPfChx77tbRs6vzLWmlK0bxy93iWm5Pea5rUrOwNmiaMM540/xFe5iTYigLMJIdMPNm/B8cS/eRWl4DsvYrngN04FgPzAlht+y+03kTTJewoLAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478722; c=relaxed/simple;
	bh=XRgRjMzvZh+1EGaI41QESnuJjWMtKKj4kEAMOT828Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSfUINT17PqLOze+YMg4yHE6JlVDKjg/Povl7QT1EZs/aU2pu+CkOl3XNCMBodXMFLYgLi4xPHeKUPjWF1sJ9557efhzNLaLMOr+YivIFGvraokviqEM4Qk9OQR5NgPcyB/CKTNe9g1WDxH9kaAiW6amHoaASXYI9aIaFs62Ygg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgdRZ6qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgdRZ6qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315EBC32782;
	Mon, 12 Aug 2024 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478722;
	bh=XRgRjMzvZh+1EGaI41QESnuJjWMtKKj4kEAMOT828Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgdRZ6qj1zlnLkt29Eljyso4BgcxhATWJ2CHTZIj8TPYpLfNR2eY9a9hjkY1CE5oc
	 ThXCQSyI/YYD1PGl9V5LCAySNs+dsCk/9WLGtceZSc/NHpZZS7IP3eo9FmF+3zUNVQ
	 kgaIgR2Ic2tfQ71H8leqt91WtT/0vxjBv4a9mpSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/150] md/raid5: avoid BUG_ON() while continue reshape after reassembling
Date: Mon, 12 Aug 2024 18:01:39 +0200
Message-ID: <20240812160125.864710806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 305a5170dc5cf3d395bb4c4e9239bca6d0b54b49 ]

Currently, mdadm support --revert-reshape to abort the reshape while
reassembling, as the test 07revert-grow. However, following BUG_ON()
can be triggerred by the test:

kernel BUG at drivers/md/raid5.c:6278!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
irq event stamp: 158985
CPU: 6 PID: 891 Comm: md0_reshape Not tainted 6.9.0-03335-g7592a0b0049a #94
RIP: 0010:reshape_request+0x3f1/0xe60
Call Trace:
 <TASK>
 raid5_sync_request+0x43d/0x550
 md_do_sync+0xb7a/0x2110
 md_thread+0x294/0x2b0
 kthread+0x147/0x1c0
 ret_from_fork+0x59/0x70
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Root cause is that --revert-reshape update the raid_disks from 5 to 4,
while reshape position is still set, and after reassembling the array,
reshape position will be read from super block, then during reshape the
checking of 'writepos' that is caculated by old reshape position will
fail.

Fix this panic the easy way first, by converting the BUG_ON() to
WARN_ON(), and stop the reshape if checkings fail.

Noted that mdadm must fix --revert-shape as well, and probably md/raid
should enhance metadata validation as well, however this means
reassemble will fail and there must be user tools to fix the wrong
metadata.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240611132251.1967786-13-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ed99b449d8fd4..4315dabd32023 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6316,7 +6316,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
 	if (mddev->reshape_backwards) {
-		BUG_ON(writepos < reshape_sectors);
+		if (WARN_ON(writepos < reshape_sectors))
+			return MaxSector;
+
 		writepos -= reshape_sectors;
 		readpos += reshape_sectors;
 		safepos += reshape_sectors;
@@ -6334,14 +6336,18 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	 * to set 'stripe_addr' which is where we will write to.
 	 */
 	if (mddev->reshape_backwards) {
-		BUG_ON(conf->reshape_progress == 0);
+		if (WARN_ON(conf->reshape_progress == 0))
+			return MaxSector;
+
 		stripe_addr = writepos;
-		BUG_ON((mddev->dev_sectors &
-			~((sector_t)reshape_sectors - 1))
-		       - reshape_sectors - stripe_addr
-		       != sector_nr);
+		if (WARN_ON((mddev->dev_sectors &
+		    ~((sector_t)reshape_sectors - 1)) -
+		    reshape_sectors - stripe_addr != sector_nr))
+			return MaxSector;
 	} else {
-		BUG_ON(writepos != sector_nr + reshape_sectors);
+		if (WARN_ON(writepos != sector_nr + reshape_sectors))
+			return MaxSector;
+
 		stripe_addr = sector_nr;
 	}
 
-- 
2.43.0



