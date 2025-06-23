Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C6119D084;
	Mon, 23 Jun 2025 21:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714772; cv=none; b=h9df+TlTQLRrIPKB3bZRMCTytSad/AOKQeYcoAkmDMON5DMIfQST1QeanfWndnPJ270vupdWHP8T0e2SHNNGRwM3QNnnZjIULvTjjpv8SkXckbrC1HonU4x2+Jp8fnqY3dsaYRWxC/JnEIMY3P9Da4V+zQm36B4DV9saS+bkjRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714772; c=relaxed/simple;
	bh=J6kKIfbHq8GqxJzxoR6MxYjyrGFqD7bVn8k4MV0518M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO3QTe1DkNYutNqCVJo2jAaYdWffeLW+Fa3KUlKnykIiuYjc4vayRfC7XhcA/Su23UepuGY9/zrjDYxDbhyFymJHXDn7iWKpPr3+9k+/CthjjFycKGmhwhIcEKTxkQ0N22QYILGCXQ/7hey2GIrKnzU7b3BzN83izcmR+bQLhw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8fsGqzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8fsGqzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D55C4CEEA;
	Mon, 23 Jun 2025 21:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714772;
	bh=J6kKIfbHq8GqxJzxoR6MxYjyrGFqD7bVn8k4MV0518M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8fsGqzUGI0PiHcZK0KhJa86hMqOL94dgLgSwPXzUGUQRkophLDY4OKKKHu2ZtY27
	 8ZKwE3ZUsSEBQL50AaJpxYzi0udOvRCUS/Wgd85y/985zdV+syy0MnXMomMJrAKNma
	 YnHjnR30oPuy8GYZe40E04qcj4hgI1Na2MTd2AEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 129/414] dm: lock limits when reading them
Date: Mon, 23 Jun 2025 15:04:26 +0200
Message-ID: <20250623130645.283563731@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit abb4cf2f4c1c1b637cad04d726f2e13fd3051e03 upstream.

Lock queue limits when reading them, so that we don't read halfway
modified values.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -431,6 +431,7 @@ static int dm_set_device_limits(struct d
 		return 0;
 	}
 
+	mutex_lock(&q->limits_lock);
 	if (blk_stack_limits(limits, &q->limits,
 			get_start_sect(bdev) + start) < 0)
 		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "
@@ -448,6 +449,7 @@ static int dm_set_device_limits(struct d
 	 */
 	if (!dm_target_has_integrity(ti->type))
 		queue_limits_stack_integrity_bdev(limits, bdev);
+	mutex_unlock(&q->limits_lock);
 	return 0;
 }
 
@@ -1734,8 +1736,12 @@ static int device_not_write_zeroes_capab
 					   sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
+	int b;
 
-	return !q->limits.max_write_zeroes_sectors;
+	mutex_lock(&q->limits_lock);
+	b = !q->limits.max_write_zeroes_sectors;
+	mutex_unlock(&q->limits_lock);
+	return b;
 }
 
 static bool dm_table_supports_write_zeroes(struct dm_table *t)


