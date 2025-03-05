Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402492512D9;
	Wed,  5 Mar 2025 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197086; cv=none; b=mY2Qfot+pxxk7FJVl4Jwk802gH+E0JIk7UqdRC645QCmOYAdaMrWyHy3XnP+joSfmPKTqoOAznGJ1HBVpJ5h7sN0qWKxxMRhm6DO5mpgEH8vVdmQVfoUpWFOw1A640Ohw+pULvsq2dOpdqxxpNBGT9ycw2IwmLwDKKfY7U+YGcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197086; c=relaxed/simple;
	bh=I165AAfB6tcFVxDSkwfjpONen6tb9QwB8l/7DwKZxU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB0EmRKKXhfQIdHitGjWswST+xt/wncEXAQnPbWFuo6fRJ0m2uvMNS2rPBeFa9XZKgreh3+LHpkOzHrRCUE53PbeBZZ3gLNyPsoBJ/skzhbXvgUTHQgMdUBwRTs6HTTBL7jD6vCaDn0a+Wh6221XLblI4f3xhh/+yffpbggvAuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OU97chL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OU97chL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEDBC4CED1;
	Wed,  5 Mar 2025 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197086;
	bh=I165AAfB6tcFVxDSkwfjpONen6tb9QwB8l/7DwKZxU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU97chL4Vap+Sf0STeAM5zJaPCCtA7D4VvlbLm7pOGEsaQGZdI7kqytG6eRTRGOaC
	 o+z5LZBz8aDdb1fnuFTe0OQrFgnd+uPrQWaF8ZBu7K3QVOOtHNmcbY9k6bIDa0LLVd
	 RQpPHjKrzv4jyMQWNxFGDstHpJrxVboJeVSmlCoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/176] md/md-cluster: fix spares warnings for __le64
Date: Wed,  5 Mar 2025 18:46:15 +0100
Message-ID: <20250305174505.709126432@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 82697ccf7e495c1ba81e315c2886d6220ff84c2c ]

drivers/md/md-cluster.c:1220:22: warning: incorrect type in assignment (different base types)
drivers/md/md-cluster.c:1220:22:    expected unsigned long my_sync_size
drivers/md/md-cluster.c:1220:22:    got restricted __le64 [usertype] sync_size
drivers/md/md-cluster.c:1252:35: warning: incorrect type in assignment (different base types)
drivers/md/md-cluster.c:1252:35:    expected unsigned long sync_size
drivers/md/md-cluster.c:1252:35:    got restricted __le64 [usertype] sync_size
drivers/md/md-cluster.c:1253:41: warning: restricted __le64 degrades to integer

Fix the warnings by using le64_to_cpu() to convet __le64 to integer.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240826074452.1490072-6-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Stable-dep-of: 8d28d0ddb986 ("md/md-bitmap: Synchronize bitmap_get_stats() with bitmap lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-cluster.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 10e0c5381d01b..a0d3f6c397707 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1195,7 +1195,7 @@ static int cluster_check_sync_size(struct mddev *mddev)
 	struct dlm_lock_resource *bm_lockres;
 
 	sb = kmap_atomic(bitmap->storage.sb_page);
-	my_sync_size = sb->sync_size;
+	my_sync_size = le64_to_cpu(sb->sync_size);
 	kunmap_atomic(sb);
 
 	for (i = 0; i < node_num; i++) {
@@ -1227,8 +1227,8 @@ static int cluster_check_sync_size(struct mddev *mddev)
 
 		sb = kmap_atomic(bitmap->storage.sb_page);
 		if (sync_size == 0)
-			sync_size = sb->sync_size;
-		else if (sync_size != sb->sync_size) {
+			sync_size = le64_to_cpu(sb->sync_size);
+		else if (sync_size != le64_to_cpu(sb->sync_size)) {
 			kunmap_atomic(sb);
 			md_bitmap_free(bitmap);
 			return -1;
-- 
2.39.5



