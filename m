Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A611DFD8B;
	Wed, 19 Feb 2025 09:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956044; cv=none; b=PxUGWOmPs8fF0KguVFIV/Yu1mbYlUhiwBbzQNeyUF3En6cxZXZW/NjL26b5cw5ndAlhRl5bB5ZAmzM/+O0RwNqFw3UYtDSrPVlUqP+Xb6b3lfE7kEbRdx29GIz+5IbW6LmciUdW2CBRzEEVVjpPt9aWvvYFojq+kF1qmmiEGlqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956044; c=relaxed/simple;
	bh=6e0i495z23p5taCVdYsDjjwLusXGbXsdPhtLGOUjcl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHgqkaZv/Ae5g2aZJaYz9JTe7/p+YjGn7MP18KGX/5msUxbC7w7WCRhvRrA16mSbpsUMRwW2ptbQMzVKTomiUkZiVltnTM/1NaE7U7bL/iJ0TXhYeTQ4RF33AzkN4esv3LGZKP0ZRoYQdiZ7kNT6MI20N+ymFWP09gIqnwHYEj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bblEoKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bblEoKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF4DC4CED1;
	Wed, 19 Feb 2025 09:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956043;
	bh=6e0i495z23p5taCVdYsDjjwLusXGbXsdPhtLGOUjcl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bblEoKlbBr5Nr2MPd4TgnT09A1LP2GzAF+forIIeMCvqM4gmsMeQ7tf4WtThYsy9
	 C+0tuq/QicevRB4THTyZ/A89HhoG8Td5tuWFdIFRXEe7E/MJatuTmtMLuqzNlm5ToF
	 axvw9nqY1JnIZ+EnEQxze9lCAKprjAXhCemN4M00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yang Erkun <yangerkun@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/578] block: retry call probe after request_module in blk_request_module
Date: Wed, 19 Feb 2025 09:20:09 +0100
Message-ID: <20250219082653.111191153@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index 8256e11f85b7d..1cb517969607c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -738,7 +738,7 @@ static ssize_t disk_badblocks_store(struct device *dev,
 }
 
 #ifdef CONFIG_BLOCK_LEGACY_AUTOLOAD
-void blk_request_module(dev_t devt)
+static bool blk_probe_dev(dev_t devt)
 {
 	unsigned int major = MAJOR(devt);
 	struct blk_major_name **n;
@@ -748,14 +748,26 @@ void blk_request_module(dev_t devt)
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



