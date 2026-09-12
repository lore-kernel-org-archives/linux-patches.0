Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C424288B2;
	Sat, 12 Sep 2026 10:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208645; cv=none; b=t2F/EC9vu81wC79FhM10TMnveKpvonxwjd0vjcgiiA7sxh1yepkr1oQDddgwWmwyXzJH22XgV3oH/7NayAv36DoLY3dRO0lst8au7CJFUFXsPcqT0vNrLoDVTXctiFKhsjIoBKH7fZIfEdNvuxo6FmPQL5Lj82HFjQNFTvzDYHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208645; c=relaxed/simple;
	bh=JDdYUNlhM889XalNuJ3TgPzg6wm6Z03Ku0BIfV4BRwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUoOYSUJZesYFg/4OyyNtkFNQ557LpTu/o+YXU5kGui86N7Gvr6yIhHKV9VUkx64qXIGHD3d0/xIaRUEhO4LeBf4O+E/yDXOwMzCWhgT/fqNQ0v05mIkG77vOKB6y5DBmhxZG3gk6+pjBXQYnk3fhGQhAAeGjpxlth7P4DSqiO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MxnCmpNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MxnCmpNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DC51F000FF;
	Sat, 12 Sep 2026 10:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208644;
	bh=puz6wJByV4I862D+Or78epQg0Mbmsc9/eIlke+/D5zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MxnCmpNSEPHjTAVQS7Ey75UVT9tKjxiePlOzPhOT6pWXXOXWGjHbVgrpMFJcoFmcP
	 zrrXCz4I9ddod9Man0b2Z/eowVnyQ72eeBk+IoOdHMpdCLW9V+Qbg5DfdMeMz+9R09
	 7o7AOgG5MGYRFTW2gXo+9Lr7BRh7bOcjTwtuuK0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	John Garry <john.g.garry@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0660/1518] md/raid10: consistently fail atomic writes that require splitting
Date: Sat, 12 Sep 2026 08:47:09 +0200
Message-ID: <20260912065638.364545353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit 3409bf2f9678d769a4c33bd232a3571c51fac481 ]

RAID10 currently handles one badblock path explicitly by failing atomic
writes with EIO. However, another badblock path can also reduce the
writable range and force the bio through bio_submit_split_bioset(),
which implicitly completes the bio with EINVAL.

Fix this by handling atomic writes in the common split check. If RAID10
determines that an atomic write would require splitting, complete the
bio with EIO.

Fixes: a1d9b4fd42d9 ("md/raid10: Atomic write support")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://patch.msgid.link/20260710101521.1714-4-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1ae9a587a9599..c4c01619bf7e1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1348,6 +1348,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	int i, k;
 	sector_t sectors;
 	int max_sectors;
+	bool atomic = bio->bi_opf & REQ_ATOMIC;
 
 	if ((mddev_is_clustered(mddev) &&
 	     mddev->cluster_ops->area_resyncing(mddev, WRITE,
@@ -1454,16 +1455,6 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			if (is_bad) {
 				int good_sectors;
 
-				/*
-				 * We cannot atomically write this, so just
-				 * error in that case. It could be possible to
-				 * atomically write other mirrors, but the
-				 * complexity of supporting that is not worth
-				 * the benefit.
-				 */
-				if (bio->bi_opf & REQ_ATOMIC)
-					goto err_handle;
-
 				good_sectors = first_bad - dev_sector;
 				if (good_sectors < max_sectors)
 					max_sectors = good_sectors;
@@ -1483,6 +1474,9 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		r10_bio->sectors = max_sectors;
 
 	if (r10_bio->sectors < bio_sectors(bio)) {
+		if (atomic)
+			goto err_handle;
+
 		allow_barrier(conf);
 		bio = bio_submit_split_bioset(bio, r10_bio->sectors,
 					      &conf->bio_split);
-- 
2.53.0



