Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D020F384CED;
	Sat, 17 Oct 2026 16:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254193; cv=none; b=J6Mpk+87YWK/bzN2clnV7/vX/Ge7sjUltU8PpDpgaA4frgE28tlHXoYwZm3HYPu+GRNyFD/ZzxijIRBmF7EWV9a6ieL2GIjXwfKFxhXmlRIDfUIetQLo3nF34vlXIpGUG7jaCsLHZ5Fyi/61Dv8N5Xi79zHrdlGC/A926mwaj1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254193; c=relaxed/simple;
	bh=L/BY99RdC2OrtnlkjQxpZJCD16VGHCo+61LJR5JTjVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTGIkT1bYN4Zx/Z/lk6I3HZKQEbJGAE4NVysgh97Y738j0Z34/7NmyMmfK7NbYtP+pXhGlH8oAM+FZqkGk6xel+KP7n5iV2XuN0aWWmi3BbATOWhoI3CtfJr3s/KrCau8UqS1xW1+2q1eOQm8tTIfvqayVhcq2BnCTtB8HKuuTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhwfYky6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhwfYky6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331461F000C4;
	Sat, 17 Oct 2026 16:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254192;
	bh=rZhJ2UZzwssNe3fRSTZrOMrvV1DEg+U8DB8YdcV1qeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhwfYky694Ya85MUTyGxEmAIwPr26s0wWzJW4nvW8XOMM6M+cs/VYs78X1lZbS8uJ
	 BuZFIsRD7Ckkt6R9BdOFa49M0vXWD9JC8R1E7nDP42e438SqrSyUQ1p4O709pSVf3v
	 dI7akenqD4NiOGN0gZ195Rw6a3fA7e37JyennWhI=
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
Subject: [PATCH 6.12 365/869] netfs: Fix zeropoint update where i_size > remote_i_size
Date: Sat, 17 Oct 2026 17:53:26 +0200
Message-ID: <20261017160046.466695204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f5f7c0de3a7ca..8bdacbf15226c 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -315,7 +315,7 @@ bool netfs_release_folio(struct folio *folio, gfp_t gfp)
 	if (folio_test_dirty(folio))
 		return false;
 
-	end = umin(folio_pos(folio) + folio_size(folio), i_size_read(&ctx->inode));
+	end = umin(folio_pos(folio) + folio_size(folio), ctx->remote_i_size);
 	if (end > ctx->zero_point)
 		ctx->zero_point = end;
 
-- 
2.53.0



