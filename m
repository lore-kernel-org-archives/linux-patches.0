Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6562F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C85C433EF;
	Wed, 12 Apr 2023 08:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289483;
	bh=6pPtoos7XlZm+tErdnJ8qc6Lsa3V7V9OXbeueIdLfVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3tMG60ZaUBhlfbRbj3t+cBLHEA9fKdZZ411HgRfHPQqrXyo7ty3Q6v+3x8ME27cr
	 55/Khg63R+MSueGLbMrqpNqlLCmvaGVBr6vEyN5Couvs30UV8MBKnPQy1zWv8g6h8a
	 AMDHrBdyZUeLsa8NgZncXZfNOi0HfoPVsn7B5GtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 089/173] fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
Date: Wed, 12 Apr 2023 10:33:35 +0200
Message-Id: <20230412082841.647109699@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

commit 13dd4e04625f600e5affb1b3f0b6c35268ab839b upstream.

unshare copies data from source to destination.  But if the source is
HOLE or UNWRITTEN extents, we should zero the destination, otherwise
the HOLE or UNWRITTEN part will be user-visible old data of the new
allocated extent.

Found by running generic/649 while mounting with -o dax=always on pmem.

Link: https://lkml.kernel.org/r/1679483469-2-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dax.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1258,15 +1258,20 @@ static s64 dax_unshare_iter(struct iomap
 	/* don't bother with blocks that are not shared to start with */
 	if (!(iomap->flags & IOMAP_F_SHARED))
 		return length;
-	/* don't bother with holes or unwritten extents */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
-		return length;
 
 	id = dax_read_lock();
 	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
+	/* zero the distance if srcmap is HOLE or UNWRITTEN */
+	if (srcmap->flags & IOMAP_F_SHARED || srcmap->type == IOMAP_UNWRITTEN) {
+		memset(daddr, 0, length);
+		dax_flush(iomap->dax_dev, daddr, length);
+		ret = length;
+		goto out_unlock;
+	}
+
 	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;


