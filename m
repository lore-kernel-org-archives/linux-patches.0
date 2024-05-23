Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CAE14A605;
	Thu, 23 May 2024 13:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470386; cv=none; b=sTBGLdn9Nc6Hn0rdqjrfjx3xf5ehOe2nQPaJrSXBTyxCeUIyOl0q+Yqw/7zFev6+A5rplZCQK2mhv4mVUzPw+cujiqh4i6J3uPKxHpRw/nPqbfPF3MT+rPleryHAirkOF3lnjv278aWU16xgq1oqH6NTVUnQyOzBGgkRYcZzGME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470386; c=relaxed/simple;
	bh=pHvGTNU4EH9gMrUROsTYfztxnLvggJpWH1pguCmMBLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnvyeBPJ3JkeCb6tMxscy9NBoYf8GGWGRmm8Vml6jiBQ7W1ELG15Xcw/iuY5ymgW+Xj67lAGdxRfXReLIa9yuAVtaZ5hwISA9/WtxJcgveNKX3mGj9uCJJQjTBUDzbB9ndvvuAgTntVBS6kZLesI6d8HLX/TT525ek3i6ZK4/wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b12/LBbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b12/LBbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E35C2BD10;
	Thu, 23 May 2024 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470385;
	bh=pHvGTNU4EH9gMrUROsTYfztxnLvggJpWH1pguCmMBLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b12/LBbn5YZuuOJBshtze2irRqPma2Fu/RV/B34dZ1450bpK1LSRY+NIOOJYlJPKf
	 sXe0OHWgIozVYfAvHv0ReMzPdWu+m3VHSIyqW1GAl3CuZsDO+1SxmkCv0VTwEs77mR
	 V6I6Na/iTeYlRAormJ2ovtievK8b2SJ/RtN4qv8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6.1 19/45] xfs: fix off-by-one-block in xfs_discard_folio()
Date: Thu, 23 May 2024 15:13:10 +0200
Message-ID: <20240523130333.217647647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 8ac5b996bf5199f15b7687ceae989f8b2a410dda ]

The recent writeback corruption fixes changed the code in
xfs_discard_folio() to calculate a byte range to for punching
delalloc extents. A mistake was made in using round_up(pos) for the
end offset, because when pos points at the first byte of a block, it
does not get rounded up to point to the end byte of the block. hence
the punch range is short, and this leads to unexpected behaviour in
certain cases in xfs_bmap_punch_delalloc_range.

e.g. pos = 0 means we call xfs_bmap_punch_delalloc_range(0,0), so
there is no previous extent and it rounds up the punch to the end of
the delalloc extent it found at offset 0, not the end of the range
given to xfs_bmap_punch_delalloc_range().

Fix this by handling the zero block offset case correctly.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217030
Link: https://lore.kernel.org/linux-xfs/Y+vOfaxIWX1c%2Fyy9@bfoster/
Fixes: 7348b322332d ("xfs: xfs_bmap_punch_delalloc_range() should take a byte range")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Found-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -439,15 +439,17 @@ xfs_prepare_ioend(
 }
 
 /*
- * If the page has delalloc blocks on it, we need to punch them out before we
- * invalidate the page.  If we don't, we leave a stale delalloc mapping on the
- * inode that can trip up a later direct I/O read operation on the same region.
+ * If the folio has delalloc blocks on it, the caller is asking us to punch them
+ * out. If we don't, we can leave a stale delalloc mapping covered by a clean
+ * page that needs to be dirtied again before the delalloc mapping can be
+ * converted. This stale delalloc mapping can trip up a later direct I/O read
+ * operation on the same region.
  *
- * We prevent this by truncating away the delalloc regions on the page.  Because
+ * We prevent this by truncating away the delalloc regions on the folio. Because
  * they are delalloc, we can do this without needing a transaction. Indeed - if
  * we get ENOSPC errors, we have to be able to do this truncation without a
- * transaction as there is no space left for block reservation (typically why we
- * see a ENOSPC in writeback).
+ * transaction as there is no space left for block reservation (typically why
+ * we see a ENOSPC in writeback).
  */
 static void
 xfs_discard_folio(
@@ -465,8 +467,13 @@ xfs_discard_folio(
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
 			folio, ip->i_ino, pos);
 
+	/*
+	 * The end of the punch range is always the offset of the the first
+	 * byte of the next folio. Hence the end offset is only dependent on the
+	 * folio itself and not the start offset that is passed in.
+	 */
 	error = xfs_bmap_punch_delalloc_range(ip, pos,
-			round_up(pos, folio_size(folio)));
+				folio_pos(folio) + folio_size(folio));
 
 	if (error && !xfs_is_shutdown(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");


