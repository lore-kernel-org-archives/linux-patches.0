Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140421C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8706EC433D2;
	Wed, 28 Dec 2022 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246227;
	bh=1C/btrXoj9FohJvdTnZDUNcU45dnEn6H8iX9b6YHpx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qENeESOXBSi462vXEmDtMGrRFC2mgQ/Vf6jitXPa8hu/4VK+T/OVTb4r5/tE63zgL
	 MB74EffdNWCaMnsrrUuhc+hw+rH1otzOWuVHzgSs6wLYcjkBrICy9lWwCUQCYqlYAm
	 4al1m7sU3bqHq3KpImNqs5N0jPdfJaaqdMn9T3XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhong <floridsleeves@gmail.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1006/1146] drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()
Date: Wed, 28 Dec 2022 15:42:25 +0100
Message-Id: <20221228144357.695918898@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zhong <floridsleeves@gmail.com>

[ Upstream commit 3bd548e5b819b8c0f2c9085de775c5c7bff9052f ]

Check the return value of md_bitmap_get_counter() in case it returns
NULL pointer, which will result in a null pointer dereference.

v2: update the check to include other dereference

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6dffadbe6f..63ece30114e5 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2195,20 +2195,23 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 
 		if (set) {
 			bmc_new = md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);
-			if (*bmc_new == 0) {
-				/* need to set on-disk bits too. */
-				sector_t end = block + new_blocks;
-				sector_t start = block >> chunkshift;
-				start <<= chunkshift;
-				while (start < end) {
-					md_bitmap_file_set_bit(bitmap, block);
-					start += 1 << chunkshift;
+			if (bmc_new) {
+				if (*bmc_new == 0) {
+					/* need to set on-disk bits too. */
+					sector_t end = block + new_blocks;
+					sector_t start = block >> chunkshift;
+
+					start <<= chunkshift;
+					while (start < end) {
+						md_bitmap_file_set_bit(bitmap, block);
+						start += 1 << chunkshift;
+					}
+					*bmc_new = 2;
+					md_bitmap_count_page(&bitmap->counts, block, 1);
+					md_bitmap_set_pending(&bitmap->counts, block);
 				}
-				*bmc_new = 2;
-				md_bitmap_count_page(&bitmap->counts, block, 1);
-				md_bitmap_set_pending(&bitmap->counts, block);
+				*bmc_new |= NEEDED_MASK;
 			}
-			*bmc_new |= NEEDED_MASK;
 			if (new_blocks < old_blocks)
 				old_blocks = new_blocks;
 		}
-- 
2.35.1



