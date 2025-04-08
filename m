Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FA2268C79;
	Tue,  8 Apr 2025 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110517; cv=none; b=AWFgoUQvwpNPjnLi6Q7c0PZQK/lO53WGR5WHzkIiQVegFHEln256v1XqsI7vFT8c8Y8DKvjo4c38awy/IbgHW4+jQ8oIoYnRa6dnxlraZS+hVKk4ArK0urZJRrigAKFPh9KvgGf6hvsge+vP42BmPAx9D8RUEdFWbATxYHqKbDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110517; c=relaxed/simple;
	bh=FaoL7+ixDUQW4POUl8LJrDdpaE4OZJhlyKX0CK8lV50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1fd/nG9vNjpDHWaFYg28Vb4Ex9YQPPyRDYuYWPV6dZ3JMcxOjC81n4akNaGQ+lmdMQ9ttoS6OCstf1+ZYRog04wwHIXQk8lCifXj0y5D+OqgvIM13Kh+zDjdQXHBnB2SkwrEjXB/r4hIxF5s4e4MS8ECpuuh5CoPvQK+caP2QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPlxCgGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPlxCgGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE4BC4CEE5;
	Tue,  8 Apr 2025 11:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110516;
	bh=FaoL7+ixDUQW4POUl8LJrDdpaE4OZJhlyKX0CK8lV50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPlxCgGZy2m+p0RXFGkHnXJaMMEskaBRCYPlKuBtOJ7ANAdqOo3F+kYl4kGmJzH0W
	 fpEV+LOjyiUkG74Cv9VDcTq0Erx6Bj+mC/D3y6QraY2fEPbmhBI4ycfJmcNjsSPX78
	 +g1C0fkVG2v/R7W/YU9fbC+p3z8I5phwxVh2j3Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 6.14 094/731] md/raid1: fix memory leak in raid1_run() if no active rdev
Date: Tue,  8 Apr 2025 12:39:51 +0200
Message-ID: <20250408104916.454877640@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 5fbcf76e0dfe68578ffa2a8a691cc44cf586ae35 ]

When `raid1_set_limits()` fails or when the array has no active
`rdev`, the allocated memory for `conf` is not properly freed.

Add raid1_free() call to properly free the conf in error path.

Fixes: 799af947ed13 ("md/raid1: don't free conf on raid0_run failure")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250215020137.3703757-1-zhengqixing@huaweicloud.com
Singed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 10ea3af40991d..cb108b3e28c4d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -45,6 +45,7 @@
 
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
+static void raid1_free(struct mddev *mddev, void *priv);
 
 #define RAID_1_10_NAME "raid1"
 #include "raid1-10.c"
@@ -3256,8 +3257,11 @@ static int raid1_run(struct mddev *mddev)
 
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
-		if (ret)
+		if (ret) {
+			if (!mddev->private)
+				raid1_free(mddev, conf);
 			return ret;
+		}
 	}
 
 	mddev->degraded = 0;
@@ -3271,6 +3275,8 @@ static int raid1_run(struct mddev *mddev)
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
 		md_unregister_thread(mddev, &conf->thread);
+		if (!mddev->private)
+			raid1_free(mddev, conf);
 		return -EINVAL;
 	}
 
-- 
2.39.5



