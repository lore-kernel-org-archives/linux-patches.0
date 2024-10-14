Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A091D0942;
	Mon, 14 Oct 2024 15:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919776; cv=none; b=VjAQhkKFWUeE2Xb7zDxSGt/w8vtD88Rr17eO27Gd+XALYmVOl2XFi4MiXfQaEsovV5wY2RXFFzrotT7E++LCyHMCx9wOVZGKQUM5Qrh7f1ZK52H3LVIMbZ+HP5EYmgsVDXXPkJwfUca8IJolE/R0xdo4UxWpCF/MSNcOIYuFOds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919776; c=relaxed/simple;
	bh=DzwcWCfw4yxYBDAFLJM1CcyiRHI9xBtOsfeFFx1y+N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCXRRvEY8fOB9AAlbfYdCLc8Ycq75/GQP9fv0GziEsm088uuGwtI6urfntGigxTSqOd8cLwlFm7aURafTMLdRn28aWDrEcBk4SbFT+OGT3maA2R7Rd1JSiwxv0vQXXN3yK9+FnCqN58k+VW7lUzBxkGvzQlsX5ntihjp8+gaR+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z568USCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z568USCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC36C4CED1;
	Mon, 14 Oct 2024 15:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919776;
	bh=DzwcWCfw4yxYBDAFLJM1CcyiRHI9xBtOsfeFFx1y+N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z568USCQ96ef4eVAcu/dZ31vw9jfhXmuznGB16UCX2x7LpUYb/HIYlwgKJ4CCEanS
	 vmLZSxwbRPke48B2/fwWv6cgibfqrH1A2aPHxWoXj87Fj/jgjqgqdQVzZFVNKTbYyy
	 mOjtLnUocKyqxEkfejE8eTUi1dH2GMsdkej49mLI=
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
Subject: [PATCH 6.1 663/798] fsdax: unshare: zero destination if srcmap is HOLE or UNWRITTEN
Date: Mon, 14 Oct 2024 16:20:17 +0200
Message-ID: <20241014141244.099503797@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -1234,15 +1234,20 @@ static s64 dax_unshare_iter(struct iomap
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


