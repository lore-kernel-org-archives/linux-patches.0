Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6347A356773;
	Wed, 20 May 2026 17:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298266; cv=none; b=Q1fGtbFh9MvS66cMM4Rij7XBbkiRQzneB/IRFx7+tWl0uB/esO6QI1g0J7pmuTh9ztPq/cXqrjvDk4vTRS94DHpbHPfmTxKIxDx0Ug6Tfe34CFL7/8Vvf5+J/StnjshZ25QOU0YrDu/4luIfRd+l0Px4kvyW55a1z2xZUs2hdLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298266; c=relaxed/simple;
	bh=2HwqxJDCIfoMzqA+TmvTkZc6I5EheL/Ldc8U3xkkctE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJL9epjjR5IfQBqb1cU5J3M84UItx6jBCFiPqnpRZG3Fuu4YqFGvrWolIHaxGKweb53fHmwAd1rj3HWPCF/6li6wckXkGQ8Q5dXCLi6xyBhVgYzmvIJmhlYJo5eTeaaIGL24HSk3Z5M50wg+8WzgK/7A4qIVqJmxhOTDI9do0X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zK1pF/D1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zK1pF/D1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80491F000E9;
	Wed, 20 May 2026 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298265;
	bh=IRYafTCI5SfqBEbprQ8IpGqxM+GTuQHNqZ+T9NB70QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zK1pF/D1dWD/oRWc1Pm7oyL9vDHUWf9JDEU0Dn7H/qxhBBtEpAQLiXvbgqMXrBD8E
	 CHIkbCKiRbVyKA4URLp492QWQwWNP5A4LKpXWp67sS6KrlmUlWIR2j++HPrk+nco8j
	 nphrglgwUnSD0NHS3er2xr2n9lLML5vAqWZAiCuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horst Birthelmer <hbirthelmer@ddn.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 344/957] fuse: fix premature writetrhough request for large folio
Date: Wed, 20 May 2026 18:13:47 +0200
Message-ID: <20260520162141.991580263@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit 5223e0470e7bb7910038fe3d31171490e00fbbb9 ]

When large folio is enabled and the initial folio offset exceeds
PAGE_SIZE, e.g. the position resides in the second page of a large
folio, after the folio copying the offset (in the page) won't be updated
to 0 even though the expected range is successfully copied until the end
of the folio.  In this case fuse_fill_write_pages() exits prematurelly
before the request has reached the max_write/max_pages limit.

Fix this by eliminating page offset entirely and use folio offset
instead.

Fixes: d60a6015e1a2 ("fuse: support large folios for writethrough writes")
Reviewed-by: Horst Birthelmer <hbirthelmer@ddn.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6014d588845cd..00ff6374dc76b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1183,7 +1183,6 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 {
 	struct fuse_args_pages *ap = &ia->ap;
 	struct fuse_conn *fc = get_fuse_conn(mapping->host);
-	unsigned offset = pos & (PAGE_SIZE - 1);
 	size_t count = 0;
 	unsigned int num;
 	int err = 0;
@@ -1210,7 +1209,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_folio(folio);
 
-		folio_offset = ((index - folio->index) << PAGE_SHIFT) + offset;
+		folio_offset = offset_in_folio(folio, pos);
 		bytes = min(folio_size(folio) - folio_offset, num);
 
 		tmp = copy_folio_from_iter_atomic(folio, folio_offset, bytes, ii);
@@ -1240,9 +1239,6 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 		count += tmp;
 		pos += tmp;
 		num -= tmp;
-		offset += tmp;
-		if (offset == folio_size(folio))
-			offset = 0;
 
 		/* If we copied full folio, mark it uptodate */
 		if (tmp == folio_size(folio))
@@ -1254,7 +1250,9 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 			ia->write.folio_locked = true;
 			break;
 		}
-		if (!fc->big_writes || offset != 0)
+		if (!fc->big_writes)
+			break;
+		if (folio_offset + tmp != folio_size(folio))
 			break;
 	}
 
-- 
2.53.0



