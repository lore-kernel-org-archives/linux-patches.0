Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4870C341077;
	Thu,  2 Jul 2026 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009701; cv=none; b=e76wtVtzXYzIpP5MZ3jZb2R/VDWygwO94qsXdJw30B6rF9zf/GQcKPCve4ZlnYFVt0skg/mUjR0jbXGaaH60NNl1ilk0D2Pr0peg5+mHK8OhymnOAGxFOuCzN1yCPDBdTLWVTTXZ9NQghbE3rfr+u7jKLkZd1hncN0MGoGut56Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009701; c=relaxed/simple;
	bh=nZZJlTNU6Js+AA+dDJT7GPmsRaGXyJC6YYh+SqayZHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrlhzfA4nkYyORSHd08n+/zZPFc8OgIXtAKKpVm7fxjcL4q9ZxArYE0BrVJ/1ZVCPzVO2mOt8McP0HVpEjtY5hL3ZXBUSikMPUUrFEJ18uE29dMWV7Wb+wpIoN/TslgY6IOGym9FQSn7p7v9E/NJrEtw80iK7WmNtCrg6HF8DkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vV0JT4rT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vV0JT4rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7CD1F000E9;
	Thu,  2 Jul 2026 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009699;
	bh=wLe+JtGZjnmRR0XMwUwUcWlISBdXm6dMUiTaNTkcfjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vV0JT4rTlyy5elPYRzStMAUmBczT7lImt9ItL4weuBAMg03xA7rgxXd6mDQ4UtIK9
	 3ocjcBm7bpA1+AkZ9J+tYnFUYMmfFqCPkfDff+m6XRNaSOnlqpjVdjj62l1gG4PhrE
	 XWh7a1V6uH8fV9uXe1mMywedpZcKgVo39PkoUkL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 55/95] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Thu,  2 Jul 2026 18:19:58 +0200
Message-ID: <20260702155110.365025501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c5b1f9af230952..5d5f99ed974687 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -517,6 +517,14 @@ static int ext4_read_inline_page(struct inode *inode, struct page *page)
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



