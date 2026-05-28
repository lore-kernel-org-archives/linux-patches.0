Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6120C304BB3;
	Thu, 28 May 2026 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998669; cv=none; b=D9RRpP2pIXq4dv1xLr7Zhk1F7jbnoc4AsTlDJF7i0Ti/bBQQ1nKpjVaXrUhickCMYf1QBHndbUMrVbgt6brUjDkEqosiy0iU/YljdTiO91Zyhy+b9mUlrs1bEbE25b8ex7eWuH6dYKlVw/N+SLDYagaRoKYNKAniE8YU22ZSXBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998669; c=relaxed/simple;
	bh=YbYQk6cgvoDgaBhkLqNnWTqNI2LVrGnhnYwWnYY+9xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QItcjWJUgJvqbTnt+p0liDv6Z7YmHGPVIxQL0AOEDY7ff+Udf2u7PItrv/W1I9RS16iUQvCEOjlmBPIkCswVECBYGay2QIZS2ywXmMifFy7CL8L06q1KYRyskwrU0ORPbb0kdLHE60QUk6rTVur+ie3AJQUPiIdHN7tIAlb3yYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scTZwLWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scTZwLWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DEF1F00A3A;
	Thu, 28 May 2026 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998668;
	bh=vrg15zAevW1TNutE2LGYGvYapyn8ut1z+cSvBQM3lUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scTZwLWc8HRkPkS2QBbSXjUyPITXL5GXQDRmp+4McRRgcLpndqF1Wn43Vx0SvhTVJ
	 nSqzUQ4TuWd73X8LeKUpmxNUamw83uIfWEMUplyAaIP/lEwimBE1nLkO0dUzNV+oy9
	 ppXXKWUwDn9SFIxjJsDJ0vwGyNPOsMZiGwcPMbqA=
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
Subject: [PATCH 7.0 255/461] netfs: Fix zeropoint update where i_size > remote_i_size
Date: Thu, 28 May 2026 21:46:24 +0200
Message-ID: <20260528194654.533605498@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 fs/netfs/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index bad661ff2bec8..723571ca1b885 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -307,10 +307,10 @@ bool netfs_release_folio(struct folio *folio, gfp_t gfp)
 		return false;
 
 	netfs_read_sizes(inode, &i_size, &remote_i_size, &zero_point);
-	end = umin(folio_next_pos(folio), i_size);
+	end = folio_next_pos(folio);
 	if (end > zero_point) {
 		spin_lock(&inode->i_lock);
-		end = umin(folio_next_pos(folio), inode->i_size);
+		end = umin(end, ctx->_remote_i_size);
 		if (end > ctx->_zero_point)
 			netfs_write_zero_point(inode, end);
 		spin_unlock(&inode->i_lock);
-- 
2.53.0



