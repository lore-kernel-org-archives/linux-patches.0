Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E59FC0B;
	Wed,  5 Feb 2025 13:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763711; cv=none; b=a0ae0vyBYPxL1JZWAl34gc4IDV5kyQ322cUIzmnrvxzYElS9uwD9nOdIi2XFrlG+fOy01oaWlrcwV6qqEne6O8bdOOsqugAWcIMMApTGMis7l1csxOnFy2b2Orcg66Opal5UrLbEjgBxvsWTuu6WMqvL5e2p8jUHEObv97ycbVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763711; c=relaxed/simple;
	bh=RDaeWqD/gfJiL4pvJSYhMnXfPysZ85Jv+fI9EE87nIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQmthqNeJnEkXoTWFPfpjBIPbs9UN0O0nrVFeGkmTjGazge+mfSLmXw5icZnXZIZtoq7qwkqv04OdSAMNRds4OD7YAIieGQfpRUWj/6d1WCXxyUi9ZOvFZWPq5udSCB5jKJ9FmU5WqeKQTBmdn+rSDajUuyG0Vr25JkmnZftYpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqLszvmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqLszvmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C0AC4CED1;
	Wed,  5 Feb 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763711;
	bh=RDaeWqD/gfJiL4pvJSYhMnXfPysZ85Jv+fI9EE87nIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqLszvmFoVbp3qji6FL7gn0+WjfNEUDpORnCjTxBG3M/osRAWokZyzykZcPGQgV51
	 fhSOR4QuFImRGT6Vh4iF9yc7JcVDn6ds0duKlVspLZKWRFfU51DMCyKU0COrHMqCTy
	 kU1fXJaRvFncSrFDJUOO2qs6V/ETYOKU7mh3VCk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yang Erkun <yangerkun@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 011/623] block: retry call probe after request_module in blk_request_module
Date: Wed,  5 Feb 2025 14:35:53 +0100
Message-ID: <20250205134456.661714143@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 457ef47c08d2979f3e59ce66267485c3faed70c8 ]

Set kernel config:

 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_LOOP_MIN_COUNT=0

Do latter:

 mknod loop0 b 7 0
 exec 4<> loop0

Before commit e418de3abcda ("block: switch gendisk lookup to a simple
xarray"), lookup_gendisk will first use base_probe to load module loop,
and then the retry will call loop_probe to prepare the loop disk. Finally
open for this disk will success. However, after this commit, we lose the
retry logic, and open will fail with ENXIO. Block device autoloading is
deprecated and will be removed soon, but maybe we should keep open success
until we really remove it. So, give a retry to fix it.

Fixes: e418de3abcda ("block: switch gendisk lookup to a simple xarray")
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241209110435.3670985-1-yangerkun@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 79230c109fca0..8a63be374220c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -798,7 +798,7 @@ static ssize_t disk_badblocks_store(struct device *dev,
 }
 
 #ifdef CONFIG_BLOCK_LEGACY_AUTOLOAD
-void blk_request_module(dev_t devt)
+static bool blk_probe_dev(dev_t devt)
 {
 	unsigned int major = MAJOR(devt);
 	struct blk_major_name **n;
@@ -808,14 +808,26 @@ void blk_request_module(dev_t devt)
 		if ((*n)->major == major && (*n)->probe) {
 			(*n)->probe(devt);
 			mutex_unlock(&major_names_lock);
-			return;
+			return true;
 		}
 	}
 	mutex_unlock(&major_names_lock);
+	return false;
+}
+
+void blk_request_module(dev_t devt)
+{
+	int error;
+
+	if (blk_probe_dev(devt))
+		return;
 
-	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
-		/* Make old-style 2.4 aliases work */
-		request_module("block-major-%d", MAJOR(devt));
+	error = request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt));
+	/* Make old-style 2.4 aliases work */
+	if (error > 0)
+		error = request_module("block-major-%d", MAJOR(devt));
+	if (!error)
+		blk_probe_dev(devt);
 }
 #endif /* CONFIG_BLOCK_LEGACY_AUTOLOAD */
 
-- 
2.39.5



