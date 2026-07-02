Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A477349CE8;
	Thu,  2 Jul 2026 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010007; cv=none; b=Lq0L3DjODP/RxMGbyV115FVOso395SyHIhxtS3DQ87qbfxXbxyfmbaWKwhf29YqByUjcihXL3gZ3JTiKQ1MrgUjGwkXOZsl0fnx+uuGcPVoKIgX69WQM5y0+gEyiL8Nls5s75a/GMOmlTsDZWmlZUsPR/aRUs3xL9me9NHBhBLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010007; c=relaxed/simple;
	bh=UVJ3i6vNnAfVtNZxxdxJ25bBR93tKNK2noXpzikIQNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YasV39E3ytRV9r3DCYU38M7Y4KXYyJ7IB5azUwapVBpgyfEiJG3CebAWDErJpsmzgcgBfYN5iz73R7N8uqx0mAlgsrfHld9bLjxUfplrR70IeOml61Fn+Ej0X+2PogtMNg2h+KqdXrEZSo6S0CeQO7c7Yg/8dz7SUkyj1czQHQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOQUdqiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOQUdqiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15201F000E9;
	Thu,  2 Jul 2026 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010006;
	bh=alPHjo8j4cvASzJaU0kLgaw4CEQ8q/R81ul0pHYFujs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOQUdqiu5YI2IiUzRzpjD9cpgaUXzDkSBjZCZIfFFEWNOYUomgMNPlX4zgaJIfm9Y
	 GIY9j1tYI/dsZ4UidjSlvLrduCL2hlYK+/1XU7zQDnWFc51jRVmaqFZmb3OB8QNWPj
	 zKRTwCwri6oMkBbf2RbZ+dKMLlYoGCdurkYLDRNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuto Ohnuki <ytohnuki@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/129] ext4: add bounds check for inline data length in ext4_read_inline_page
Date: Thu,  2 Jul 2026 18:19:55 +0200
Message-ID: <20260702155113.714041170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1fb99d2b472bf..c0c1e865270785 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -518,6 +518,14 @@ static int ext4_read_inline_page(struct inode *inode, struct page *page)
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



