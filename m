Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17D43E120E;
	Wed, 20 May 2026 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294433; cv=none; b=Ig1L8wkvkdU6v1N5HlD5sBX+TjeedLIfynbQXGqIPvkFdBzH3usGy3m8DQF6oklvifEqpnI+I6eKYT9HDtutXCoERF348dCRGw9TRfdrOAOX43HeGN0ZmTLDMk2nRGt/jpzbfvEdynqdK1KInFoM9iGJJHSbtEEU6XXNc4ktnpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294433; c=relaxed/simple;
	bh=b3Ejh19jUAzqqLQ/Alhu5hb3UbHTQg3JneC+hYrWfbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTkipB6gr3iIv0eqDiBtmsI8sePcQVtuyXvefOaXn5aSQTeQC9x6LMqpJSWqCo+HGXaSksGtHbcre9FsAy3N6KJ24d62woQDFY6ypNC3x+pp5kA3RI9o+/XWgk7Arkhllkv5mXK2oLl80jSYPU/dbJq5wFNF80o+xjxS6tvzLEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMD5n9rf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMD5n9rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC9B1F00898;
	Wed, 20 May 2026 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294431;
	bh=EmiD+vczLu10SQuKF1DbsdnbKGO03++CN84ZsSUWYm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMD5n9rfsv7IhA6TAgXQMhF28Ew2THMQKAMmU1ChQgzjesLUZUlfWfe//LZmg7LRk
	 KlxmV/8REXBqAZT0g1sBgif+J1CpySK8KRtKXBhX6U+o6ZPHmAPD2M4CznGMKaYO2r
	 JP+vEb6oKhBJtPX+A7VivYcvBSfVr0WX/INrsKT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0005/1146] md/raid1: fix the comparing region of interval tree
Date: Wed, 20 May 2026 18:04:15 +0200
Message-ID: <20260520162148.516529317@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 181400e147c0d..be2565dee4202 100644
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
@@ -452,7 +452,7 @@ static void raid1_end_write_request(struct bio *bio)
 	int mirror = find_bio_disk(r1_bio, bio);
 	struct md_rdev *rdev = conf->mirrors[mirror].rdev;
 	sector_t lo = r1_bio->sector;
-	sector_t hi = r1_bio->sector + r1_bio->sectors;
+	sector_t hi = r1_bio->sector + r1_bio->sectors - 1;
 	bool ignore_error = !raid1_should_handle_error(bio) ||
 		(bio->bi_status && bio_op(bio) == REQ_OP_DISCARD);
 
-- 
2.53.0



