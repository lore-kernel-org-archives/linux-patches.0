Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545FC4E0205;
	Thu, 17 Sep 2026 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660687; cv=none; b=WGDHK4y5lQ8KCzr93yeMP780rCI7Igb4AHE4kXQzxvddcDSIAY9VZsk4nilYU+XF/6j7yDoJIBevio8a769ONqf2lC+6QzPfSb5a4PNEpDpagK/07V4zqRbvULM8MQcitaGItaPsWWMT2+YLEJZYRjUXJa7dfJxRqigQe+cIU/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660687; c=relaxed/simple;
	bh=0gPCd1yZs+L5lZOenU5kxd+yknKN5UtmqvicYjNSqqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3z+aP5c4LjDwmVTnQtd76UfYSG2PbcXz8gNm5HPF+QxtbokdPICxAmTmmV1n6ySebo3CUEzJgRUoblVFJjHaqyv0F67hbGQwokE9Cs6p7v3hLy7JDDp9ck38RoYLOVd2uiibbnH5VqLckloZ/oK7y3xpKQqAwFl9vGab/kV29A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQfnWY0i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQfnWY0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC731F000FF;
	Thu, 17 Sep 2026 15:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660685;
	bh=+5JWVjoZUnJqSLNoFj+xUZxUDiwQ8cS5648j4oMqyDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQfnWY0ivpKT4KRfYeIAkN+ft9Xb6G9HWZMvQ7a0qVIu9PVvMglOr3M8+rvkYzqWe
	 HkOpTjkz5tmpw3WKGWSATmHuvbTHrqEp1cVSWo1rTIuqRqBaujAHX7bKyW15JJibj5
	 o8UsMunxnIJ3mUKf4sqwwj5+8+56gtr0IUTUUcfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 676/733] xfs: dont leak new_bp if xfs_btree_bload_drop_buf fails
Date: Thu, 17 Sep 2026 16:16:24 +0100
Message-ID: <20260917151409.594023679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f1930bc578095409c2dcfca6e4e898b24f0f0de6 upstream.

LOLLM observes that in xfs_btree_bload_prep_block,
xfs_btree_bload_drop_buf can hit an IO error if writing the delwri
buffer list to disk fails.  In this case, we fail to release new_bp,
which means we lose a locked buffer.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: e069d549705e49 ("xfs: constrain dirty buffers while formatting a staged btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_btree_staging.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -337,8 +337,10 @@ xfs_btree_bload_prep_block(
 		xfs_btree_set_sibling(cur, *blockp, &new_ptr, XFS_BB_RIGHTSIB);
 
 	ret = xfs_btree_bload_drop_buf(bbl, buffers_list, bpp);
-	if (ret)
+	if (ret) {
+		xfs_buf_relse(new_bp);
 		return ret;
+	}
 
 	/* Initialize the new btree block. */
 	xfs_btree_init_block_cur(cur, new_bp, level, nr_this_block);


