Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9343369999;
	Wed, 20 May 2026 17:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297455; cv=none; b=PzD8zTEqpDBIqBqlo3y23Kjmer6RlkXDlacDxhba18FsMvNH3wdYjDeLlitqqsjuBUgmUrdjHwiAMrkHyoHSsyKCkUrU0Z8DNTAC1FhIu/sfvgf6/eyu8MlNSV6SZzAr1UIKnoTEf1SzYifdEhDwFpyy1+qgUg99kbLYok0Bf9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297455; c=relaxed/simple;
	bh=7bxvKaDs1XsdK5ja+K5VUs2+G3H0jGu96jbmspcI+nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwKDRH3DyiJTzFd299Lfe3/5PvWIM3maN6Bhpi9hTXizmovlfgNohR/KLbYjZKeRHVuIhKuIusCzc3J5G54zJ6JZklzMUGY3bg/k+8IKDjE00NqGlZdC2iEGJlrVXAmz+eMgm2A0DbnXMxf+hYCkKSEHqIPeBY9ZdUtxpiVnEfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lltb1B29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lltb1B29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325DF1F000E9;
	Wed, 20 May 2026 17:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297454;
	bh=7jtOe8jI2jnBRR7oJuVt0OWMXelJQpihS3pMWGyiNJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lltb1B29b20h2pr0bEl52zQs7dnl1hDyIYO1O0+AAklVg5aBBGfFU9prS7vxLeKRY
	 G/tQTd1GfQ/pvsvwiYpTA7ybihHmJ+2HijRO6bIhpWimlj1jh+Jvb7e8glWZ/eFDkL
	 mfISiOyGWdfRCv6Dd1pMckATyGv+UuMjFvigy/2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/957] md/raid1: fix the comparing region of interval tree
Date: Wed, 20 May 2026 18:08:07 +0200
Message-ID: <20260520162134.654766711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ce7fd68869566..84dbf801e9b1b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -62,7 +62,7 @@ static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
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



