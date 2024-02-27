Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016E7140391;
	Tue, 27 Feb 2024 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043523; cv=none; b=V3u/z06k7LLZvxoV//ki2qmhP7L4YKiFeWOJ6ykpacTuJ+4lQ82PdB2jcFOIPHN+bqhfiI8qc2+mZ5MKnSOFAwVEiuHfPNXjkKXLpb2xDumyMplJPhDC5RuXBBjy1cfOeF3PheNbNs1FnA4CmIOnYtdUidjs1qzALxV9i2mZiJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043523; c=relaxed/simple;
	bh=KEEkcKuHJCXTgOmRU7D0WtYytpPrtDR8HfUUcRfHqgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYJVBh200yTqclVXM6WKh+33/sPrwYOe8aj/QlIfNbUf3Ed30YrI9nkQMvcTKYwifpN7/osiSEhfrzD2IeHBXdXw8AA1lx4iAf57Sr6ySjUeAwmPzh3bp/fzzonyHtw/UWOYLg9HzH/9ZLsDtJQqOxrefuDnlrrOaZcBgIaEQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FgMv6f0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FgMv6f0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A992C433C7;
	Tue, 27 Feb 2024 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043522;
	bh=KEEkcKuHJCXTgOmRU7D0WtYytpPrtDR8HfUUcRfHqgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FgMv6f0JWLBX9DL+3jHSP9As6q6nQmj69t1nU6IZKE1FxZXowZJzAsu7e3VKhIUP+
	 u42e8GdIiL6X7QLYkTXG3DF6pCuZZteRIref0pnZWWxdr5n+AfPdHn2qB0dOP1jDTI
	 BSsVsJge0DGU+Gq9I/8ei6XKanMnNshghAPXxhiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Avihai Horon <avihaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/195] iommufd/iova_bitmap: Consider page offset for the pages to be pinned
Date: Tue, 27 Feb 2024 14:26:40 +0100
Message-ID: <20240227131615.022071542@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit 4bbcbc6ea2fa379632a24c14cfb47aa603816ac6 ]

For small bitmaps that aren't PAGE_SIZE aligned *and* that are less than
512 pages in bitmap length, use an extra page to be able to cover the
entire range e.g. [1M..3G] which would be iterated more efficiently in a
single iteration, rather than two.

Fixes: b058ea3ab5af ("vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries")
Link: https://lore.kernel.org/r/20240202133415.23819-10-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/iova_bitmap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index c748a1e3ba53a..dfab5b742191a 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -174,18 +174,19 @@ static int iova_bitmap_get(struct iova_bitmap *bitmap)
 			       bitmap->mapped_base_index) *
 			       sizeof(*bitmap->bitmap), PAGE_SIZE);
 
-	/*
-	 * We always cap at max number of 'struct page' a base page can fit.
-	 * This is, for example, on x86 means 2M of bitmap data max.
-	 */
-	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
-
 	/*
 	 * Bitmap address to be pinned is calculated via pointer arithmetic
 	 * with bitmap u64 word index.
 	 */
 	addr = bitmap->bitmap + bitmap->mapped_base_index;
 
+	/*
+	 * We always cap at max number of 'struct page' a base page can fit.
+	 * This is, for example, on x86 means 2M of bitmap data max.
+	 */
+	npages = min(npages + !!offset_in_page(addr),
+		     PAGE_SIZE / sizeof(struct page *));
+
 	ret = pin_user_pages_fast((unsigned long)addr, npages,
 				  FOLL_WRITE, mapped->pages);
 	if (ret <= 0)
-- 
2.43.0



