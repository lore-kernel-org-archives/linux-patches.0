Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC77115B0FE;
	Tue,  2 Jul 2024 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940401; cv=none; b=DPMokuvhk+HXiodiXFOYsSkdsx5GzWffryGd0qowGWkeLDwWRadKDBOBrm9cNoM8xrYqhRNabQcA6YKN0abTanQiiv0AtnOJAIYzYKsMqRcntqcOFsgLj8T89AK6l+5Dh71Byj4EKB8qS1K65BG3hDMhWDcPM1Pld/1AWve8PV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940401; c=relaxed/simple;
	bh=bFyc4GyOrO+bWMYsirSeVIBNVfGZGRa/V96K7sYIKZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihi8y+7YIr4cTGhB/7qrP1kc0pcwGKY+5WRdx2T0/3eJK9XLDKsNoQN6OLPLE6Ywx3f22BGNvyB3rnTSRnYssam/AwvhaaRzdpYJHL+sv0MPwNHcA/MVEVUXDyELRtwJew/k8l5af7S4ypAnJPySGX0n6jxvtTd78fwK2pgR9Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPy9ozGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPy9ozGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1894BC116B1;
	Tue,  2 Jul 2024 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940400;
	bh=bFyc4GyOrO+bWMYsirSeVIBNVfGZGRa/V96K7sYIKZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPy9ozGvrm39Xn7Xq8XzL8l2QoYUUBsNtQnzCLxk8vhl88hCsngDuPBo4zSjAutmQ
	 38pmZ09cSDq29fVehwxO9dN0NMsJoipc1/OyKmp6LCDSE6PyxGyomj9fYAcgOXTUv1
	 aECkKUMwFiN4TOp+QSlP3/TFWD4j40gbCB8WtNjI=
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
Subject: [PATCH 6.9 116/222] nfs: drop the incorrect assertion in nfs_swap_rw()
Date: Tue,  2 Jul 2024 19:02:34 +0200
Message-ID: <20240702170248.403279200@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -141,8 +141,6 @@ int nfs_swap_rw(struct kiocb *iocb, stru
 {
 	ssize_t ret;
 
-	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
-
 	if (iov_iter_rw(iter) == READ)
 		ret = nfs_file_direct_read(iocb, iter, true);
 	else


