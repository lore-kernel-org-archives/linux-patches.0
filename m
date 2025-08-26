Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7778218A6C4;
	Tue, 26 Aug 2025 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214662; cv=none; b=Iqn4z1hEoTm8PAkq6Zmv0uEutFRRteep+BfUAbd26E4TNsQdyhTLzNMsOOqCZqE2iXJ/LrrSL+XxHD79oHqC8AUzsr2XhMEweJrXQFWaTESktTbMEWRHbYB3PNqb7y/UnOyl78BLO/xrbbG8jQwXn9lIgaIUQy6LS2KIDEEIX4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214662; c=relaxed/simple;
	bh=mQp1iEPyZwpGx/zyM3Bs8sgRIiWvfSKg0M6+3Xm09oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u96TOK87mAdN3sxefOPazuxh0cPyNJPjScoDCVftcUDq3RZYh24Kh2j9TOS3TkoLnXighCGdygovsJwIPJnxCboVXUnfeBYsisYCt43kd00qZkcnroOD2Tweibg+IEppi5uPNcVBuqbrB8jjMheU2ix4b6PsR0Ns6mYj4lNLqyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilir8f/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilir8f/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7CAC4CEF1;
	Tue, 26 Aug 2025 13:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214662;
	bh=mQp1iEPyZwpGx/zyM3Bs8sgRIiWvfSKg0M6+3Xm09oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilir8f/+AGvi0h+tRYEkY83QCX8tjqRXHj+8CV+WblQbeoUwAr2tIDqFH2XMi4Ekc
	 HOs76XI9re6+1xVyXV+M/GdQEuhmNa7RsVFZYH3RdC7U+UmB7G+Rn/eBiuIaXm+ver
	 l84PFVvSPP4ydjqbpcECTPsWLeD1zOZ7iaaKYAZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/482] dm-table: fix checking for rq stackable devices
Date: Tue, 26 Aug 2025 13:07:48 +0200
Message-ID: <20250826110936.088223703@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 8ca719b81987be690f197e82fdb030580c0a07f3 ]

Due to the semantics of iterate_devices(), the current code allows a
request-based dm table as long as it includes one request-stackable
device. It is supposed to only allow tables where there are no
non-request-stackable devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8b23b8bc5a03..f18e47a24454 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -863,17 +863,17 @@ static bool dm_table_supports_dax(struct dm_table *t,
 	return true;
 }
 
-static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
-				  sector_t start, sector_t len, void *data)
+static int device_is_not_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
 {
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
 
 	/* request-based cannot stack on partitions! */
 	if (bdev_is_partition(bdev))
-		return false;
+		return true;
 
-	return queue_is_mq(q);
+	return !queue_is_mq(q);
 }
 
 static int dm_table_determine_type(struct dm_table *t)
@@ -969,7 +969,7 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!ti->type->iterate_devices ||
-	    !ti->type->iterate_devices(ti, device_is_rq_stackable, NULL)) {
+	    ti->type->iterate_devices(ti, device_is_not_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-- 
2.39.5



