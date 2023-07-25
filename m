Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69881ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28203C433C9;
	Tue, 25 Jul 2023 11:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283486;
	bh=X3zg38bxyYUF7tBJf4wAJKJS9Ojz2ZpALTflpiyS3/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBysItUtSkQlkFayKVbuKjaU+UT5MFf/e87SHHTPsxvu0i+G9oIvgpzvWZjZM2xQ6
	 XEg4dtVHnO2NWjBn0pdDy7vpQnMDTXkiaZztJRiZ7hFIWKS/7ZNvVPxTRyjUsekg9U
	 tYjQvMNCo/7f6ULk0Zk1br9DsGyp6b6AD0s1yIRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/509] md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
Date: Tue, 25 Jul 2023 12:39:14 +0200
Message-ID: <20230725104554.339712242@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Nan <linan122@huawei.com>

[ Upstream commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5 ]

If we write a large number to md/bitmap_set_bits, md_bitmap_checkpage()
will return -EINVAL because 'page >= bitmap->pages', but the return value
was not checked immediately in md_bitmap_get_counter() in order to set
*blocks value and slab-out-of-bounds occurs.

Move check of 'page >= bitmap->pages' to md_bitmap_get_counter() and
return directly if true.

Fixes: ef4256733506 ("md/bitmap: optimise scanning of empty bitmaps.")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20230515134808.3936750-2-linan666@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 20afc0aec1778..f843ade442dec 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -54,14 +54,7 @@ __acquires(bitmap->lock)
 {
 	unsigned char *mappage;
 
-	if (page >= bitmap->pages) {
-		/* This can happen if bitmap_start_sync goes beyond
-		 * End-of-device while looking for a whole page.
-		 * It is harmless.
-		 */
-		return -EINVAL;
-	}
-
+	WARN_ON_ONCE(page >= bitmap->pages);
 	if (bitmap->bp[page].hijacked) /* it's hijacked, don't try to alloc */
 		return 0;
 
@@ -1365,6 +1358,14 @@ __acquires(bitmap->lock)
 	sector_t csize;
 	int err;
 
+	if (page >= bitmap->pages) {
+		/*
+		 * This can happen if bitmap_start_sync goes beyond
+		 * End-of-device while looking for a whole page or
+		 * user set a huge number to sysfs bitmap_set_bits.
+		 */
+		return NULL;
+	}
 	err = md_bitmap_checkpage(bitmap, page, create, 0);
 
 	if (bitmap->bp[page].hijacked ||
-- 
2.39.2



