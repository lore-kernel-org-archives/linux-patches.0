Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B9288CAF;
	Wed, 23 Apr 2025 15:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420913; cv=none; b=GZ+3gFibzXXQhCmPtePpP29GFJIIQCYc4H+qHyD+XFZaJec2pnMoVWBLsXf0SAT5S1Lu7i2tTV3mZfxo+1Iyr/WAK+gdjdA0nwHuuEZRmZAoIyOmE8sdBIo2XxwaprHqGpk2CU4vNWDAGx/FHFLNTil30Z4UvURrxpqIXyT8cJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420913; c=relaxed/simple;
	bh=abeP2Q9HV7NiTBqhmWu8LPKMhVHi9NAh+DN69aByxkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=exRUWZUZeg+yDM7jmpew1GEAm9rl1LO7xpvWtx7JfPKpCJ15VC+eBvZNDRZanRR0jZWGyQMaEPdCRnhQUIh2+0J1e3kNH/bDlQJY5lSKoHEHmJdNBBNBMRCYTSb2o0U8Mdd7n+bzhudoZfhSX2mWCWtnOAVD57xbVl3dzEO//x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zJs9DY76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zJs9DY76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE60DC4CEE2;
	Wed, 23 Apr 2025 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420913;
	bh=abeP2Q9HV7NiTBqhmWu8LPKMhVHi9NAh+DN69aByxkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zJs9DY76Q1EocVLsmobU2Ke0vYBdiPBLVgDVqAinaX3l3mQkkwATIyMUmcjqH+aFf
	 sttI9T+PLGQ3NZbFnDeOFF5IOn8k7bfFQp+z6e6Bvi1hoMqXjWn5yCpGb3z8c292LR
	 8jnxw3TNpPJUEpW6Rw+gnLAepb/H8dcmhspuAZ/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheng Yong <shengyong1@xiaomi.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.14 135/241] lib/iov_iter: fix to increase non slab folio refcount
Date: Wed, 23 Apr 2025 16:43:19 +0200
Message-ID: <20250423142626.079986918@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng Yong <shengyong1@xiaomi.com>

commit 770c8d55c42868239c748a3ebc57c9e37755f842 upstream.

When testing EROFS file-backed mount over v9fs on qemu, I encountered a
folio UAF issue.  The page sanity check reports the following call trace.
The root cause is that pages in bvec are coalesced across a folio bounary.
The refcount of all non-slab folios should be increased to ensure
p9_releas_pages can put them correctly.

BUG: Bad page state in process md5sum  pfn:18300
page: refcount:0 mapcount:0 mapping:00000000d5ad8e4e index:0x60 pfn:0x18300
head: order:0 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
aops:z_erofs_aops ino:30b0f dentry name(?):"GoogleExtServicesCn.apk"
flags: 0x100000000000041(locked|head|node=0|zone=1)
raw: 0100000000000041 dead000000000100 dead000000000122 ffff888014b13bd0
raw: 0000000000000060 0000000000000020 00000000ffffffff 0000000000000000
head: 0100000000000041 dead000000000100 dead000000000122 ffff888014b13bd0
head: 0000000000000060 0000000000000020 00000000ffffffff 0000000000000000
head: 0100000000000000 0000000000000000 ffffffffffffffff 0000000000000000
head: 0000000000000010 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
Call Trace:
 dump_stack_lvl+0x53/0x70
 bad_page+0xd4/0x220
 __free_pages_ok+0x76d/0xf30
 __folio_put+0x230/0x320
 p9_release_pages+0x179/0x1f0
 p9_virtio_zc_request+0xa2a/0x1230
 p9_client_zc_rpc.constprop.0+0x247/0x700
 p9_client_read_once+0x34d/0x810
 p9_client_read+0xf3/0x150
 v9fs_issue_read+0x111/0x360
 netfs_unbuffered_read_iter_locked+0x927/0x1390
 netfs_unbuffered_read_iter+0xa2/0xe0
 vfs_iocb_iter_read+0x2c7/0x460
 erofs_fileio_rq_submit+0x46b/0x5b0
 z_erofs_runqueue+0x1203/0x21e0
 z_erofs_readahead+0x579/0x8b0
 read_pages+0x19f/0xa70
 page_cache_ra_order+0x4ad/0xb80
 filemap_readahead.isra.0+0xe7/0x150
 filemap_get_pages+0x7aa/0x1890
 filemap_read+0x320/0xc80
 vfs_read+0x6c6/0xa30
 ksys_read+0xf9/0x1c0
 do_syscall_64+0x9e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x71/0x79

Link: https://lkml.kernel.org/r/20250401144712.1377719-1-shengyong1@xiaomi.com
Fixes: b9c0e49abfca ("mm: decline to manipulate the refcount on a slab page")
Signed-off-by: Sheng Yong <shengyong1@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/iov_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 8c7fdb7d8c8f..bc9391e55d57 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1191,7 +1191,7 @@ static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 			return -ENOMEM;
 		p = *pages;
 		for (int k = 0; k < n; k++) {
-			struct folio *folio = page_folio(page);
+			struct folio *folio = page_folio(page + k);
 			p[k] = page + k;
 			if (!folio_test_slab(folio))
 				folio_get(folio);
-- 
2.49.0



