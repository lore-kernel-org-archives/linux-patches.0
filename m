Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCEB1BD00C;
	Tue,  2 Jul 2024 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941552; cv=none; b=PF9Td7B/pF72i9ODY5v78WW/rqQdk1FzERfa/rvjP6j8nq+A6UmQvC5yHdpotNu1zb9iF3gwnxLwbITGpewk32e06v6P5ZgINaAI+ZjSZ+AOYGlJMMPkGv0hpsJ/a08u5AzEFwBGnQ5BpRuUZi/O9oSZsr0JQl9kTM0hOr2UvhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941552; c=relaxed/simple;
	bh=/cCikUa5jiU8B1EG43VLO8dZfduhI22O8eHMkORZwE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHArSK3d5c/iIe+GQhGi0+MlhPvPPw3qhtBJ95GNhQ3tyyHxgGV9HXkitKl34P9MAr6euIdhZxmXXYg/NwVg8+W8aVVS18Q7klINozOmVBoS8W+hckUjdkQyVFYs08M7xk8z7YuE+iVoinyKiKGBmRtkgVU+YdajXabMFDLfqrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqhXJKzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqhXJKzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351A5C116B1;
	Tue,  2 Jul 2024 17:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941551;
	bh=/cCikUa5jiU8B1EG43VLO8dZfduhI22O8eHMkORZwE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqhXJKzQOXP/Pnxz4tk5Lry4dMLxwqx9wovghuFItmzgfKy+oev8hdfjQjFn7AC20
	 oKR/Yo2D7t7/o8H6bzoiU7uH4mdk/zoSirjaLCwyaHj4vFUmUe5uaNZu/M25PHPhvo
	 VWAk+co3a5E2iVfPHIyf+LySPREHOHmRNuHM7/D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Barry Song <v-songbaohua@oppo.com>,
	Martin Wege <martin.l.wege@gmail.com>,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <anna@kernel.org>,
	Steve French <sfrench@samba.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Chuanhua Han <hanchuanhua@oppo.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Chris Li <chrisl@kernel.org>,
	"Huang, Ying" <ying.huang@intel.com>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 067/128] nfs: drop the incorrect assertion in nfs_swap_rw()
Date: Tue,  2 Jul 2024 19:04:28 +0200
Message-ID: <20240702170228.769694258@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 54e7d59841dab977f6cb1183d658b1b82c9f4e94 upstream.

Since commit 2282679fb20b ("mm: submit multipage write for SWP_FS_OPS
swap-space"), we can plug multiple pages then unplug them all together.
That means iov_iter_count(iter) could be way bigger than PAGE_SIZE, it
actually equals the size of iov_iter_npages(iter, INT_MAX).

Note this issue has nothing to do with large folios as we don't support
THP_SWPOUT to non-block devices.

[v-songbaohua@oppo.com: figure out the cause and correct the commit message]
Link: https://lkml.kernel.org/r/20240618065647.21791-1-21cnbao@gmail.com
Fixes: 2282679fb20b ("mm: submit multipage write for SWP_FS_OPS swap-space")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Closes: https://lore.kernel.org/linux-mm/20240617053201.GA16852@lst.de/
Reviewed-by: Martin Wege <martin.l.wege@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Steve French <sfrench@samba.org>
Cc: Trond Myklebust <trondmy@kernel.org>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/direct.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -131,8 +131,6 @@ int nfs_swap_rw(struct kiocb *iocb, stru
 {
 	ssize_t ret;
 
-	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
-
 	if (iov_iter_rw(iter) == READ)
 		ret = nfs_file_direct_read(iocb, iter, true);
 	else


