Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E537296FA2;
	Mon, 12 May 2025 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073050; cv=none; b=hVKmr544H3/h7fFNo+3pO5q31KUO+pMLUbHIsWCjeOr+qZaRIV9l8715AesXa6/idDT2eztEQ/fIBiu/8ZmyWeTGZ/s6sWa80Ni9u732vVinfVttyaIfVV+DvX00sT98zEVuKaTHtCrevc5jYfHXpuBkco/L9AV4/3VEIielbkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073050; c=relaxed/simple;
	bh=PiIqHbpu0AjccLkXGvGdCFDG1ZkSso+91QWm0jb+rU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlGxh4WUdqlp2O9HFfrSwpt8QzeiAJiz78op49tAdyncHRh3SBPQNWelqyS4AleymG3QjHxTaA830Wa/GnDWSY5GRbSrg3YeNkzatPg1V5Dnf090JJANZ4uhKlUgXfyOjRJJMj5zlDYfpxLb8rUZvmTflkY7Q/chxRdI5xRYtOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qade9Ef9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qade9Ef9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F71CC4CEF2;
	Mon, 12 May 2025 18:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073049;
	bh=PiIqHbpu0AjccLkXGvGdCFDG1ZkSso+91QWm0jb+rU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qade9Ef9EBEdF8RxUsyn7oLnmGSxA2W8UWIszZAEB64BxgzhPUO9ef7EDyJO/NfTl
	 od8BNd+HLrKONuBl5gMl2md1O9BoImVnWB01Gad6YWBSlCNyIV6muRcVfqMy0JJ/KB
	 tOAgJfcXXhjMNIA6/DYTT4SoI7rI6GFbCu4jVKSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/184] loop: Use bdev limit helpers for configuring discard
Date: Mon, 12 May 2025 19:45:40 +0200
Message-ID: <20250512172047.473190098@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 8d3fd059dd289e6c322e5741ad56794bcce699a2 ]

Instead of directly looking at the request_queue limits, use the bdev
limits helpers, which is preferable.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241030111900.3981223-1-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: f5c84eff634b ("loop: Add sanity check for read/write_iter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8827a768284ac..b3355a8d78965 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -710,11 +710,11 @@ static void loop_config_discard(struct loop_device *lo,
 	 * file-backed loop devices: discarded regions read back as zero.
 	 */
 	if (S_ISBLK(inode->i_mode)) {
-		struct request_queue *backingq = bdev_get_queue(I_BDEV(inode));
+		struct block_device *bdev = I_BDEV(inode);
 
-		max_discard_sectors = backingq->limits.max_write_zeroes_sectors;
-		granularity = bdev_discard_granularity(I_BDEV(inode)) ?:
-			queue_physical_block_size(backingq);
+		max_discard_sectors = bdev_write_zeroes_sectors(bdev);
+		granularity = bdev_discard_granularity(bdev) ?:
+			bdev_physical_block_size(bdev);
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
-- 
2.39.5



