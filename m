Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6D739B95E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302516; cv=none; b=pvwDb0nRWbQIQVsOG2exc6ZufQ7Vn3RlJ8n1OjvkSEN4i2XB5S7hH05nrTsbSqd8UaaL1HTsTsTxoNgzdgiMnOtBz7dz3Mi5kSA+FnWjwGXFBj4ExdipWkQBU4nLk+GecIbqbD8cECPVxKnLUTNgtn6lUIhiIyynuZcqnN7HBwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302516; c=relaxed/simple;
	bh=BJhQuQ4cEv3l08Qt+kA3W6bw/rt/yBiDZqao4tCQeyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOFU84NQQRVXs8SWDgxeUxf77vd2JHoD3za49iB3rPZg26/bat9aEcryVwIKTxlDKdEzzsJmYQ3rV3Jg/UpCqNEXZFQ8rz0pgARGOnGJUS8x/f7LrZtmhxdvJ5jDS4pwzaUiv2cnK4//Xn9v9mqkD45V7+/+rEaGrnAWjpwCRfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lZvazOHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lZvazOHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0C1C19424;
	Sat, 28 Feb 2026 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302516;
	bh=BJhQuQ4cEv3l08Qt+kA3W6bw/rt/yBiDZqao4tCQeyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZvazOHQ8FfTkCqtq5sTWk4OF5G9cGRIiyd52tDrgJZyMJMvZQcHeDOi6Px88hY4k
	 +5EEBIW2iiKi5Z1jObdwAR/qr49vtwr40lP/+z7qHRh4RabgyNdWMmq+K78sMreIvQ
	 yIfyyPER0eQb72NicUbQGejBKDIwYYO9sJwCMFykBRIgUa/L28riAEKjctFKA3idc3
	 v587GcZo0TakDcNMca4tq5UnFli34ssQiVUqac5+MB5gMvjIR7NAOdaPrA4MTWAtQg
	 LEtVHbFl/2iAtJdsCLdjHBGm0z/soogs+1mf/Z48bkxChIQiYDLA1VUvNvMs765G+E
	 j37gyf4k1IIww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/164] md/raid10: fix any_working flag handling in raid10_sync_request
Date: Sat, 28 Feb 2026 13:12:32 -0500
Message-ID: <20260228181505.1600663-13-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 99582edb3f62e8ee6c34512021368f53f9b091f2 ]

In raid10_sync_request(), 'any_working' indicates if any IO will
be submitted. When there's only one In_sync disk with badblocks,
'any_working' might be set to 1 but no IO is submitted. Fix it by
setting 'any_working' after badblock checks.

Link: https://lore.kernel.org/linux-raid/20260105110300.1442509-11-linan666@huaweicloud.com
Fixes: e875ecea266a ("md/raid10 record bad blocks as needed during recovery.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5b0f38e7c8f13..c6429ef37f9e2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3546,7 +3546,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
-				any_working = 1;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3561,6 +3560,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						continue;
 					}
 				}
+				any_working = 1;
 				bio = r10_bio->devs[0].bio;
 				bio->bi_next = biolist;
 				biolist = bio;
-- 
2.51.0

