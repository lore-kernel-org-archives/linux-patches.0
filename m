Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461E23ED3B8;
	Wed, 20 May 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300059; cv=none; b=k1Uj99EE6dBoOJyfHS2usQkmPi1aD6iTmiT637108QCLda4u6eizPIQ3Wa/9AlUM8q1MIYQkP92dYwNKmKZpdJQ6hkT/O9t+8Zu4IzDtwrLWz+6LRa5Df4+XB1bsJhkDeYdz3xZIacKXxrqG+2+xYdA5/c7S6E9Dd2s74jF/yxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300059; c=relaxed/simple;
	bh=4n9ATU97h79/4N4qS+CrWJDigEBMI2bkoCRms3AX1rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMsH4XnHrR+ZNL8rp2KPvBxHqXmn9t0aNq3LJ6M1V8AUjabiBXAhW+f/vP0pdcrCorniPVFe2C268xTEZobznGUb+aZe3sxgxG9m7omxZuQxvrjlutPIRR0lk0x0igRzhgvV0E7kk4RxMVGsPgdUyG6IYhvAQCFa4da3mfOKcyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CG+GLaZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CG+GLaZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB241F000E9;
	Wed, 20 May 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300058;
	bh=s4iGKR0+n223SsluzaL2aCSjC9r18boxoB0UhC+LzBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CG+GLaZ4VNAsqpeI+v4Q9f8x/sK14ICx4tc2QwTEzd7JVz+8HzNkMrMRTfvhwOHwp
	 C7WI+maW0QmwEEtac5Awxh4bRjJ8Lgs4mdRvfkWDRvs/QHb2Z7XoqomQGjLMS2AmDQ
	 47HYS9dWCd6IC59O9tqRRDKEgxdyLSOabbYFBR2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/666] md/raid1: fix the comparing region of interval tree
Date: Wed, 20 May 2026 18:13:36 +0200
Message-ID: <20260520162111.348203440@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

[ Upstream commit de3544d2e5ea99064498de3c21ba490155864657 ]

Interval tree uses [start, end] as a region which stores in the tree.
In raid1, it uses the wrong end value. For example:
bio(A,B) is too big and needs to be split to bio1(A,C-1), bio2(C,B).
The region of bio1 is [A,C] and the region of bio2 is [C,B]. So bio1 and
bio2 overlap which is not right.

Fix this problem by using right end value of the region.

Fixes: d0d2d8ba0494 ("md/raid1: introduce wait_for_serialization")
Signed-off-by: Xiao Ni <xni@redhat.com>
Link: https://lore.kernel.org/linux-raid/20260305011839.5118-2-xni@redhat.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 093b04e6be675..eb583df45ecbc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -61,7 +61,7 @@ static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
 	unsigned long flags;
 	int ret = 0;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = lo + r1_bio->sectors;
+	sector_t hi = lo + r1_bio->sectors - 1;
 	struct serial_in_rdev *serial = &rdev->serial[idx];
 
 	spin_lock_irqsave(&serial->serial_lock, flags);
@@ -453,7 +453,7 @@ static void raid1_end_write_request(struct bio *bio)
 	int mirror = find_bio_disk(r1_bio, bio);
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = r1_bio->sector + r1_bio->sectors;
+	sector_t hi = r1_bio->sector + r1_bio->sectors - 1;
 	bool ignore_error = !raid1_should_handle_error(bio) ||
 		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
-- 
2.53.0



