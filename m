Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398734EDCB2;
	Thu, 17 Sep 2026 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666865; cv=none; b=iwjFaKI+IpVnQGqUO1GDNUcN0bKckk6o9bCZg0W0ULEkbuMWkJ5+9ycQaI1+ituQaS/SfjqXZBfA/hd42Mu+9C0+bK4iWl/5cRacCXftUFxi6xO+R+T09sDgtHmBrXYoMc4U0b2byOI1kZz/xAk/b9TEuboQHYEaMtBaeCIxH9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666865; c=relaxed/simple;
	bh=ES51ed3/JNfuuCDlnOU0w1Q7eCGDMzQr70e9H1QP0/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jakUAYIr8JRo9fzeAo1Sai3l6DdLMmMvBre6pX3RW1fkFjlX5vFd2NDOG9KGpqtW+N3XoB1RbGiuZjy/AXNhpm/AsB5u1UVH527yvtsc+b3m17BBi1ujl4SKnUa2z9HT+EZoAEh9J9cX+7GwqNHXuplUAc5KMgWXFoPNyk3K9gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6q9TAmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6q9TAmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A1B1F000FF;
	Thu, 17 Sep 2026 17:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666864;
	bh=3E++cEodCnTXYertu8gz0MynNP7UvpAkalAnzvEjIlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6q9TAmb85UJc32VNfkdnKctT9pwH3MsitHx1CP2ZaiOwBrlfb77Zc8yvTphlQIpr
	 5tPsm6nDJMg2Fi5VaO4ZymFkblHgUzyCEaThHxwjbEynYF0FTPhSURzs7tDPZJPuoR
	 kuNxn1aK6JThWhQWdYnoEiHDaE71fbLEsoy/1tto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin Jiapeng (TencentOS Red Team)" <jiapenglin@tencent.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1112/1250] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN
Date: Thu, 17 Sep 2026 16:15:07 +0100
Message-ID: <20260917151622.363355667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Lin Jiapeng <ljp1205831794@gmail.com>

commit a23eca88448e52eb1a81549862df7adce794fafb upstream.

When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
can move the reflink inode flag from the file that currently has it to
the other file, as long as exactly one side is marked.  This assumes
that the file contents, and therefore all shared extents, are exchanged.

That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
from file1, so an exchange can complete without moving every mapping
that the earlier flag-swap decision accounted for.  In that case the
post-operation cleanup can clear the reflink flag from an inode that
still owns shared written extents.  Later writes then take the
non-reflink write path and may update blocks that should still have
been protected by CoW, which shows up as data corruption between
reflink-related files.

Fix this by disabling the reflink flag exchange whenever
XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
proceed; the conservative outcome is that both inodes keep the reflink
flag.  The regular reflink flag cleanup path can drop the extra flag
later once the inode no longer has shared extents.

Reported-by: Lin Jiapeng (TencentOS Red Team) <jiapenglin@tencent.com>
Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
Cc: stable@vger.kernel.org # v6.10
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Lin Jiapeng <jiapenglin@tencent.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_exchmaps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -969,6 +969,16 @@ xmi_can_exchange_reflink_flags(
 	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
 		return false;
 
+	/*
+	 * The INO1_WRITTEN optimization can skip exchanging hole and
+	 * unwritten mappings, which means we cannot guarantee that all
+	 * shared extents actually moved to the other file.  Clearing the
+	 * reflink flag of an inode that still holds shared extents breaks
+	 * the CoW write path, so refuse to exchange the flags in that case.
+	 */
+	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
+		return false;
+
 	if (hweight32(reflink_state) != 1)
 		return false;
 	if (req->startoff1 != 0 || req->startoff2 != 0)


