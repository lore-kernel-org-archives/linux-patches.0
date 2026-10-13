Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7E94F5DFD;
	Tue, 13 Oct 2026 12:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893596; cv=none; b=OTC53B/e0FMcjtjn6LoHlqBfwJMR7u/5pjtXDzkju/ngYdCPBU2gpK7PS+4Sw690dP9XFUkLZ9YkiIom3WJIbvdtdFbnT/y0IZgsYGlNHs+4KMEs8SULqShf98NqNrw+KOdNjZWH4pZJaCIgtqp54CC+9wG7Ulzk5bjCwRRkrsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893596; c=relaxed/simple;
	bh=+JECHkX1IpaaR+4Zz5BCz8bA0uM3t+u4StrApDTYmJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjcSSEGCTfOGleoBkjGU3JlEHdiAEG9Fb/TN5MwslKPoUHSynd5ejqBSoL5Q06Bk+mehLsRzsOa3HJ8scRHwgHZ7m3jjPUzda92XBYb9kO9Jabsw6TT3akUwlg1pxfhNcQHk5Rge4vMVwvB4/LrQ3F1KkVm5haWFjtaMovuBwpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i35xYIuJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i35xYIuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E141F000FF;
	Tue, 13 Oct 2026 12:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893594;
	bh=Kg73AhzXi2iAcevZFY/l9qUATXilD/gdhNebfBy9LA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i35xYIuJZuiGXZTDjzVLG9xlnBcH36PUFmdugzVpNQhppqB/XjR3yxMZcC2ncs5bg
	 xrizdMDCpwbcLp5n/7l4ukyjM2LiMve+Lt4orn/4/dN2Danv5hB8O1R3PGMz8/Rbjg
	 E0YJL7DOIlelcW7gh6LHvSGY7k5wX2T3fKnTCP34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 251/621] netfs: Fix zeropoint update where i_size > remote_i_size
Date: Tue, 13 Oct 2026 13:34:06 +0200
Message-ID: <20261013112926.818120005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4543a4d737944134a1394afe797622546fbcc98a ]

Fix the update of the zero point[*] by netfs_release_folio() when there is
uncommitted data in the pagecache beyond the folio being released but the
on-server EOF is in this folio (ie. i_size > remote_i_size).  The update
needs to limit zero_point to remote_i_size, not i_size as i_size is a local
phenomenon reflecting updates made locally to the pagecache, not stuff
written to the server.  remote_i_size tracks the server's i_size.

[*] The zero point is the file position from which we can assume that the
    server will just return zeros, so we can avoid generating reads.

Note that netfs_invalidate_folio() probably doesn't need fixing as
zero_point should be updated by setattr after truncation or fallocate.

Found with:

    fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
        /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

    truncate 0x0 0x1bbae 0x82864
    write 0x3ef2e 0xf9c8 0x1bbae
    write 0x67e05 0xcb5a 0x4e8f6
    mapread 0x57781 0x85b6 0x7495f
    copy_range 0x5d3d 0x10329 0x54fac 0x7495f
    write 0x64710 0x1c2b 0x7495f
    mapread 0x64000 0x1000 0x7495f

on cifs with the default cache option.

It shows read-gaps on folio 0x64 failing with a short read (ie. it hits
EOF) if the FMODE_READ check is commented out in netfs_perform_write():

                if (//(file->f_mode & FMODE_READ) ||
                    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Fixes: cce6bfa6ca0e ("netfs: Fix trimming of streaming-write folios in netfs_inval_folio()")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-7-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 02654b5c53fe3..d8a67ea348f7f 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -303,7 +303,7 @@ bool netfs_release_folio(struct folio *folio, gfp_t gfp)
 	if (folio_test_dirty(folio))
 		return false;
 
-	end = umin(folio_pos(folio) + folio_size(folio), i_size_read(&ctx->inode));
+	end = umin(folio_pos(folio) + folio_size(folio), ctx->remote_i_size);
 	if (end > ctx->zero_point)
 		ctx->zero_point = end;
 
-- 
2.53.0



