Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146F4335BC9;
	Mon, 18 Aug 2025 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524305; cv=none; b=Ksae9wR0RTQrQMkWQfTj/RfLupRFdJLAPpyH4wf45/VIrna4NTRAdZNSeZpu6Rjt8vA9QfQxMogaJnsS6RaibK5m+eluPIHtbAyiINIoudNDOc/LfnzmDKKXvPeLiKw15xapUv+Wg7OJoqboC2g5ZdFQM/pZWZvhSdgn3HKy9U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524305; c=relaxed/simple;
	bh=oDXC4fooYvilrNxrgvTDSzFKCofvrNCRnEbTURrl/lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRdGPFr79Uoozy4H7t7MwG0/9beNw8HnFWtN17+lslx9srU4T60E6g0qZ/Wm909BCXYr6lRvGoAOeeGhrR5pKM3eBvZyDbypnACw6/cVpW2jH38bN/6B53cVrjsnLdlQxfWqNYcfYwcOZpm+oCX0HBYAXBorPC2CjngrxFJrw7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aU2riUvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aU2riUvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79482C116C6;
	Mon, 18 Aug 2025 13:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524305;
	bh=oDXC4fooYvilrNxrgvTDSzFKCofvrNCRnEbTURrl/lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aU2riUvOVg8ZCY0o419AYiFQzq8t6hDHDv/OskDcDcHVT/bUe0hbnE/OPhhVCiqHL
	 +Tqvu3FmMS6ZYRCFg4xMpuatJZz8U4aCt6o8km0thed5ejY0Vn+a0RJ2DJAV7hK4sb
	 W70xiOETa+x6jlFeQKV63hYrq/trI2UuWn89aEEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 398/515] dm-table: fix checking for rq stackable devices
Date: Mon, 18 Aug 2025 14:46:24 +0200
Message-ID: <20250818124513.732421368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd074c8ecbba..587a9833c1f6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -900,17 +900,17 @@ static bool dm_table_supports_dax(struct dm_table *t,
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
@@ -1006,7 +1006,7 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!ti->type->iterate_devices ||
-	    !ti->type->iterate_devices(ti, device_is_rq_stackable, NULL)) {
+	    ti->type->iterate_devices(ti, device_is_not_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-- 
2.39.5



