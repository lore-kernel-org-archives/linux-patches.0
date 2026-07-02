Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF03A1E92;
	Thu,  2 Jul 2026 16:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009456; cv=none; b=jVtY+ldkigSyl2vxT4Zg51AT/qwBQqQC0m+z4+wMhzqrJ/lhLt2ILELXuivPu4QKYeu+ESCSYb2MrFHSuCqmQ9l3bMLAfwprJhjR4gUdcy6KWtO1ST/6ACiTx53tUM0jxGy4q7j/VRBERZ4qrkQoVvgarNax3F1oA13+dW4E4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009456; c=relaxed/simple;
	bh=5faJhOdJuqURD51iMaJyu9PtKqFS3/xuDPkrUl7ayLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=payAiJurgDkJATOtixNrAJta+eQnQxokrz323S+o+N2CufGRR+/fs0HgsxNZzmX2FdO905vcaynaJdHhfR8ZOB/tVTkCtB96xL2JxWEL6ArZQVJpq6sk2D1zpgzUZrlZklyRkLrxX+c4DxvLQaZbc5hNeM9mg/JSbSTu6UScs1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EabR3Yc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EabR3Yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271271F00A3A;
	Thu,  2 Jul 2026 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009452;
	bh=+2I8EpL8zNIvHgMGHq+ZvCxrCyKrQwbXvz0IerOFMv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EabR3Yc8FFBQKCbyjHzJbSmTu+PmOnKHGF3pfOTaa+LepYSwjBSHJwswQwCwv0zA
	 H6t+QjLHNg93/rGnrmpobtCIywrfUG1eJCKyjVzpYivyjSv7unj8HhovyS0HSXa7O7
	 Zb/aexIbeQ29hMJF37XNtNv8CJ+EWvb6yr1AQCPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 58/96] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Thu,  2 Jul 2026 18:19:50 +0200
Message-ID: <20260702155110.202230130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuto Ohnuki <ytohnuki@amazon.com>

[ Upstream commit 356227096eb66e41b23caf7045e6304877322edf ]

ext4_read_inline_page() does not validate that the inline data length
fits within a page before copying data. If the inline size exceeds
PAGE_SIZE due to filesystem corruption, this could lead to a kernel
memory write beyond the page boundary.

Add a bounds check after computing len, returning -EFSCORRUPTED if the
value exceeds PAGE_SIZE.

The upstream commit replaced a BUG_ON(len > PAGE_SIZE) in
ext4_read_inline_folio(). In 6.1 and earlier, the function is still named
ext4_read_inline_page() and the BUG_ON was never present, so this patch
adds the bounds check directly.

Fixes: 46c7f254543d ("ext4: add read support for inline data")
Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 129f7ff56b43bd..edaa8820226070 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -513,6 +513,14 @@ static int ext4_read_inline_page(struct inode *inode, struct page *page)
 		goto out;
 
 	len = min_t(size_t, ext4_get_inline_size(inode), i_size_read(inode));
+	if (len > PAGE_SIZE) {
+		ext4_error_inode(inode, __func__, __LINE__, 0,
+				 "inline size %zu exceeds PAGE_SIZE", len);
+		ret = -EFSCORRUPTED;
+		brelse(iloc.bh);
+		goto out;
+	}
+
 	kaddr = kmap_atomic(page);
 	ret = ext4_read_inline_data(inode, kaddr, len, &iloc);
 	flush_dcache_page(page);
-- 
2.53.0



