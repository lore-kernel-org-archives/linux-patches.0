Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4B814A4E6;
	Tue, 20 Feb 2024 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464104; cv=none; b=ph/gkltKZQCCnVyA3HJeqbdvFVUjQydky4yCIJTr1/8lp7d+We7/q/q7n4/3PyS2B/OnnTXNnhiXCwlHgIlEEmsPCdLCBknKl1bAu/0fmdGPTIuZ+v1IULSpSkYu4ica7uLzkqRtKFqvJFlk6NP3M6S9ZwC/B9u0/KZrJ8oK0DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464104; c=relaxed/simple;
	bh=br985oqLz6IM4zzsP2BI5KTguAjdC/20MSA57hCoWns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgQHcYa8kPQq2rGbDrkJm9fV8wYdY8CCdG+WWDvr/GErlIGvNHLI2JTf05cLw0j4PuoG0GLrLoUxyuBmAUzxAd4c6AEvfun96fqtLj0/7hdZ4ekLJ8BRb6kQwRg2fE6lhbFp9pFO2cUjb3T/RDK9TifvGg8Ec3u4euzG2ksoQlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEtUk/df; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEtUk/df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1138C433F1;
	Tue, 20 Feb 2024 21:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464104;
	bh=br985oqLz6IM4zzsP2BI5KTguAjdC/20MSA57hCoWns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEtUk/dfcp1hxtKbtp1zd8xv1Hj6MIeA75IcosqH+JW0PP+rynXHPrAPXEGyDpE5j
	 aGymwvWvEcplc8Ff3m26uQayFmWFfLbvoAn1QVswNjjuTTlMpNW09ncyIWtc+pM2Fq
	 HxzEunCQymDDOXWkR/4I+of/CV9FNM9JqAgtRw/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/331] md: bypass block throttle for superblock update
Date: Tue, 20 Feb 2024 21:56:09 +0100
Message-ID: <20240220205645.794368913@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dccf270aa1b4..108590041db6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -940,9 +940,10 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
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



