Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0DB377575;
	Mon,  4 May 2026 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903951; cv=none; b=J/9fkubZB3CWpcAzv2ZHexm0rMWHSEh22tQZEYCwtO0HdupjNjX3IZLcO08p0d+ABTPPdQRzVHmfRSixGD/JP9KbUFPwERBgGYiTPHaOAMTUoptw65sKOKPdakciswTKqJhc6WwVWcMdi7VI5qWG/tWSdb8v4FOMO+9n8t2qCAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903951; c=relaxed/simple;
	bh=XYqT5lOCQBrjnqIJHLqPhhg+fA2MjIAuTP+RttybFug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayGevrd9WDGzW1J/t5WFnFvaVSfK5XJJvzVoqVadiSCoRktw+6UoZG3AqcwQwCkfj8icR5WAZgGUWs8YOX6ViXzpBAaA4fhR2nzDB7aYzRLvmG5BwP+d8f8NbH4GT7DCFRCHXyj2XRmaGA9y5zpJwZd/kSHFCQHE1RTYj7Wanek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAY3WFWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAY3WFWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA87C2BCB8;
	Mon,  4 May 2026 14:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903951;
	bh=XYqT5lOCQBrjnqIJHLqPhhg+fA2MjIAuTP+RttybFug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAY3WFWYkZGuH+TKKWU8I0mLMl3q7ngcZK0aC5DSXJJhaBYOl53HzFCbHlfOu8Qls
	 fMQ7Xu6e50QdZLg9dmtk2XaHGD42k+nhXln81LEp6ANun7hx6JgM9WRSsFpBcO+O4Q
	 SyqHvP2e6Vp5aCompBuLXuZRdEjlUJUQzKlU/9zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 093/275] block: fix zone write plugs refcount handling in disk_zone_wplug_schedule_bio_work()
Date: Mon,  4 May 2026 15:50:33 +0200
Message-ID: <20260504135146.372964884@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 0a8b8af896e0ef83e188e1fe20f98f2bbb1c2459 upstream.

The function disk_zone_wplug_schedule_bio_work() always takes a
reference on the zone write plug of the BIO work being scheduled. This
ensures that the zone write plug cannot be freed while the BIO work is
being scheduled but has not run yet. However, this unconditional
reference taking is fragile since the reference taken is released by the
BIO work blk_zone_wplug_bio_work() function, which implies that there
always must be a 1:1 relation between the work being scheduled and the
work running.

Make sure to drop the reference taken when scheduling the BIO work if
the work is already scheduled, that is, when queue_work() returns false.

Fixes: 9e78c38ab30b ("block: Hold a reference on zone write plugs to schedule submission")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -801,13 +801,17 @@ static void disk_zone_wplug_schedule_bio
 					      struct blk_zone_wplug *zwplug)
 {
 	/*
-	 * Take a reference on the zone write plug and schedule the submission
-	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
-	 * reference we take here.
+	 * Schedule the submission of the next plugged BIO. Taking a reference
+	 * to the zone write plug is required as the bio_work belongs to the
+	 * plug, and thus we must ensure that the write plug does not go away
+	 * while the work is being scheduled but has not run yet.
+	 * blk_zone_wplug_bio_work() will release the reference we take here,
+	 * and we also drop this reference if the work is already scheduled.
 	 */
 	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
 	refcount_inc(&zwplug->ref);
-	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+	if (!queue_work(disk->zone_wplugs_wq, &zwplug->bio_work))
+		disk_put_zone_wplug(zwplug);
 }
 
 static inline void disk_zone_wplug_add_bio(struct gendisk *disk,


