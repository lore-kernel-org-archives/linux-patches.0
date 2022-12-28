Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D4D1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D71C433D2;
	Wed, 28 Dec 2022 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244555;
	bh=kTAUy8Qzi8QrrkKuCj6OjCd6nTzlyaATe0MpzQjGmzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF9j8h9epZmBKc0xoJgp71RR1m7uUjC/SOrI1fLjYfUgfOymeizX5+sgy+8Q705sG
	 k6zK4F/fBM1U8v66uH/wBEJEqFCcV1H3gXUxGJScPO+/3u8vCrLi8UZ+oM//5U6pDA
	 cC5UoQVBzlKg38todLSZVTkUg/WF3KksO33wSsRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avihai Horon <avihaih@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0693/1146] vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
Date: Wed, 28 Dec 2022 15:37:12 +0100
Message-Id: <20221228144348.965734810@linuxfoundation.org>
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

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit f38044e5ef58ad0346fdabd7027ea5c1e1a3b624 ]

iova_bitmap_set() doesn't consider the end of the page boundary when the
first bitmap page offset isn't zero, and wrongly changes the consecutive
page right after. Consequently this leads to missing dirty pages from
reported by the device as seen from the VMM.

The current logic iterates over a given number of base pages and clamps it
to the remaining indexes to iterate in the last page.  Instead of having to
consider extra pages to pin (e.g. first and extra pages), just handle the
first page as its own range and let the rest of the bitmap be handled as if
it was base page aligned.

This is done by changing iova_bitmap_mapped_remaining() to return PAGE_SIZE
- pgoff (on the first bitmap page), and leads to pgoff being set to 0 on
following iterations.

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Reported-by: Avihai Horon <avihaih@nvidia.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20221025193114.58695-3-joao.m.martins@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/iova_bitmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 6631e8befe1b..2dd65f040127 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -295,11 +295,15 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
  */
 static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
 {
-	unsigned long remaining;
+	unsigned long remaining, bytes;
+
+	/* Cap to one page in the first iteration, if PAGE_SIZE unaligned. */
+	bytes = !bitmap->mapped.pgoff ? bitmap->mapped.npages << PAGE_SHIFT :
+					PAGE_SIZE - bitmap->mapped.pgoff;
 
 	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
 	remaining = min_t(unsigned long, remaining,
-	      (bitmap->mapped.npages << PAGE_SHIFT) / sizeof(*bitmap->bitmap));
+			  bytes / sizeof(*bitmap->bitmap));
 
 	return remaining;
 }
-- 
2.35.1



