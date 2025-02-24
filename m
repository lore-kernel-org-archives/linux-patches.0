Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3042E2837B;
	Mon, 24 Feb 2025 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409102; cv=none; b=tum0KOK/p6LAepH60F8wPvSI11x9LzpHSOEOET4k2a67f0E0/22YMkpbb1/qCVfKe6lRq+408E259ErfkzRKC1d/DwaWUc6NmmaIXf+TjzUWtYsWkJtIr2d87SkonIcD3gz+6YKf4r5xzA6+rsuJO6Ch6Nq2BB0aZAXi2Gcv0+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409102; c=relaxed/simple;
	bh=5M6jdALafyFkmYoIx0ZxwxB4fq2gJzven1R8MnKmKp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/iZwyB3a5jUx2Ez/Vx9AmYo8I0wu1CRY9SoLihztY4vVL+LFYCSlRZs3l9RwFqs4iLS1cpoQqBAt3DRtGRD83hKfQev1eb90415kuvlm4LMSOnYTNxQ/inqP9y26/fJ3nw2fvXz9CLeIcmkYkOxBEiM1S/VUYuJ2lyFqbaNE5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T02wqxD8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T02wqxD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C121C4CEE6;
	Mon, 24 Feb 2025 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409102;
	bh=5M6jdALafyFkmYoIx0ZxwxB4fq2gJzven1R8MnKmKp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T02wqxD8x5Tq6xsOyRGcrRiVfKa746Uwd2Mp5KNGB7ZU+51yG4Q/BJPmD5Z1KJCi9
	 h4GYbxymwUoGlxvzo9V5kQUlKzpNKTy2IJl9zgacHPCE/CJesq7lWdD/cUwA2Dt5Ui
	 nmsDhL2Z0xJmkt3Eh+oBpLnwYz/H21qQMezu2Ric=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Yu Kuai <yukuai@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 065/138] md/raid*: Fix the set_queue_limits implementations
Date: Mon, 24 Feb 2025 15:34:55 +0100
Message-ID: <20250224142607.033252652@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fbe8f2fa971c537571994a0df532c511c4fb5537 ]

queue_limits_cancel_update() must only be called if
queue_limits_start_update() is called first. Remove the
queue_limits_cancel_update() calls from the raid*_set_limits() functions
because there is no corresponding queue_limits_start_update() call.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/linux-raid/20250212171108.3483150-1-bvanassche@acm.org/
Signed-off-by: Yu Kuai <yukuai@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c  | 4 +---
 drivers/md/raid1.c  | 4 +---
 drivers/md/raid10.c | 4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 7049ec7fb8eb4..e8802309ed600 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -386,10 +386,8 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.io_opt = lim.io_min * mddev->raid_disks;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a5cd6522fc2d4..3c75a69376f47 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3219,10 +3219,8 @@ static int raid1_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = 0;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e1e6cd7fb125e..8b736f30ef926 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4020,10 +4020,8 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
-	if (err) {
-		queue_limits_cancel_update(mddev->gendisk->queue);
+	if (err)
 		return err;
-	}
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-- 
2.39.5



