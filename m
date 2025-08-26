Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C698D1F4CA9;
	Tue, 26 Aug 2025 13:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213227; cv=none; b=q/XAk+m+Ak5X39x/4kJ5w/tIf4aDknc0DD0VXCTWyqnfB1WAYEvCRhzP5pVekNsIqw4zscXNEKJ80zLg3AtaHSzTmU2KJcB+8K91of0nN9vGNheEnUGpo2J0NG0VsZo+Zp6jT3jIz17YKyAdCx/FHH2v9POVZcWn5gRl52rUm/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213227; c=relaxed/simple;
	bh=ruyeTUtDFKxq6Z5AYLIvLhNdepF6ZnyNuYujYBTEuLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvPFn39nR3kAVIeRzd0PODsAIhvJouVHWvo0qRRkHtlDgwe5tH8KiKrFsishG4TIOEyO088XohgptJMJINrPHT06CZYrVh0nquqD/TyZ0f2CdJnOsE9jI2ilbZbc4pIP/6Otej5+HWcJmwZuM3JYlm4tgt+ptsC3CcM18++D7dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THOWcqAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THOWcqAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E370C4CEF1;
	Tue, 26 Aug 2025 13:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213227;
	bh=ruyeTUtDFKxq6Z5AYLIvLhNdepF6ZnyNuYujYBTEuLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THOWcqAZPh6aOzqHiF0BltLSXXPyvQh4Z7s2TXznlh7GnRHT/APmmEdPxfAc36wDd
	 G/uvoNvXjGtQ6g3Q07DMhsfZ9K5YwibzVcShmIn4rd74j46BttTd36wCAijpS8WWxf
	 JtjuNEVpCIkQD5zXbKEPHYb7sBG0cHVCRGerCTEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/587] dm-table: fix checking for rq stackable devices
Date: Tue, 26 Aug 2025 13:06:58 +0200
Message-ID: <20250826110959.771502160@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf2ade89c8c2..ed0a5e91968d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -862,17 +862,17 @@ static bool dm_table_supports_dax(struct dm_table *t,
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
@@ -968,7 +968,7 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!ti->type->iterate_devices ||
-	    !ti->type->iterate_devices(ti, device_is_rq_stackable, NULL)) {
+	    ti->type->iterate_devices(ti, device_is_not_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-- 
2.39.5



