Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D5C2DF9F;
	Tue, 20 Feb 2024 21:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465312; cv=none; b=CQrDToy22STJuu3FhhJNa6c7kAU1JhOaNmml1HLjouaeny9ChY9x9wizRTBvgXgK2iLtK3/zXRvG3QDhHyQalGTncZ0eV+QzTpeoQzIn81+NVbNtkTDA3NaesYoAe8wh2AGdAWESB+XKCT+rk2Tj1LHuDbIxu2cl/5OZGUu9q34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465312; c=relaxed/simple;
	bh=Td6D84620GDCMGExg4bG0mJ88LOwZeEzKssGacoYv5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ+5OV3vjnFLH7xqY5L1wjE5cuhHOzNglMXUEPiEy0gl427gywWlWNEsbqwkES3hSrGmNeDKuziQL5mq5IZrhOYfMoiT0PVAY5O9b2K/vGY30jOG0Muw3X8RQ3+DRMyZFbSizBLX0w52e4bXJgvpf8bZ0cuUDU0fwxR6nNQb3iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S281f3ly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S281f3ly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37F1C433C7;
	Tue, 20 Feb 2024 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465312;
	bh=Td6D84620GDCMGExg4bG0mJ88LOwZeEzKssGacoYv5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S281f3ly+HJ4h8NZxl6uDDGHvV3p2j16qsuLxH5/Bj9g5NSkPflITjqVN1HNIFfpr
	 08yZClMThPpCNA0jWL98VeyDQKzMamj4cBT9SUZLV1oZ2xFhyKa3m0ht96XTJCssZa
	 JM/Wk94pHwt8ztU6SBKHODATpT69VmUeIOKNIbXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 304/309] md: bypass block throttle for superblock update
Date: Tue, 20 Feb 2024 21:57:43 +0100
Message-ID: <20240220205642.604784886@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxiao Bi <junxiao.bi@oracle.com>

[ Upstream commit d6e035aad6c09991da1c667fb83419329a3baed8 ]

commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
introduced a hung bug and will be reverted in next patch, since the issue
that commit is fixing is due to md superblock write is throttled by wbt,
to fix it, we can have superblock write bypass block layer throttle.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Cc: stable@vger.kernel.org # v5.19+
Suggested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231108182216.73611-1-junxiao.bi@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21b04607d53a..d243c196c598 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1037,9 +1037,10 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 		return;
 
 	bio = bio_alloc_bioset(rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev,
-			       1,
-			       REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA,
-			       GFP_NOIO, &mddev->sync_set);
+			      1,
+			      REQ_OP_WRITE | REQ_SYNC | REQ_IDLE | REQ_META
+				  | REQ_PREFLUSH | REQ_FUA,
+			      GFP_NOIO, &mddev->sync_set);
 
 	atomic_inc(&rdev->nr_pending);
 
-- 
2.43.0



