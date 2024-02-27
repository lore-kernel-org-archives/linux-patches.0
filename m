Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CBE54FA5;
	Tue, 27 Feb 2024 13:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040700; cv=none; b=XfxQ+r3l/bnBgRjODjJvyxRww819+HjME8lkjZ33lrGc86Nu4JwscJBLLl9owd0RxVHDR9n3iwDoHOknRPloIWpmKJeBdwFLYSroPeEC/TyO+z2EVMgEAZ77nrC18m/gm+bDPLg3CN76xa6Mxnkpur1K+XoGTVPfM3Kxhccyrg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040700; c=relaxed/simple;
	bh=GhNKLcRHzbZQyCeriPKCJnaLWb8u1tAGIztMmMmfyik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNQc3uhSNUtAjZxXsS8M1bo46mvY89YQnUippxOYRtgcIhScbX/7BuVJHTFWQGzFiOhFGGrEfKsAuDxOSEJjkWLMktEpCZ/1hB0UKgDvW0PMld3tpYQWSabW/LGE91m7x0QDomhPZZTpxC/OTqMprb62sU05cSFiaT2UA2Yahi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnvj/giE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnvj/giE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C7FC433F1;
	Tue, 27 Feb 2024 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040699;
	bh=GhNKLcRHzbZQyCeriPKCJnaLWb8u1tAGIztMmMmfyik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnvj/giE9gA8NykCtQRkedMg0rm/1SdzbZSII5qA/x4RdYcMERUZ0+zBcj7wb+/42
	 /Wr0gCRj0Qz/HECZibLQ7C8ZbAuL36enYuWuLak0jpbPTtNLNbU7iLd0bzzC2s21PO
	 I3r/tuO15SPhzP00LWwXVXu03A7ZTiLmFhzKH9NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 078/334] fs/ntfs3: Improve ntfs_dir_count
Date: Tue, 27 Feb 2024 14:18:56 +0100
Message-ID: <20240227131633.050664476@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 6a799c928b78b14999b7705c4cca0f88e297fe96 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 22ede4da04502..726122ecd39b4 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -515,11 +515,9 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 	struct INDEX_HDR *hdr;
 	const struct ATTR_FILE_NAME *fname;
 	u32 e_size, off, end;
-	u64 vbo = 0;
 	size_t drs = 0, fles = 0, bit = 0;
-	loff_t i_size = ni->vfs_inode.i_size;
 	struct indx_node *node = NULL;
-	u8 index_bits = ni->dir.index_bits;
+	size_t max_indx = ni->vfs_inode.i_size >> ni->dir.index_bits;
 
 	if (is_empty)
 		*is_empty = true;
@@ -563,7 +561,7 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 				fles += 1;
 		}
 
-		if (vbo >= i_size)
+		if (bit >= max_indx)
 			goto out;
 
 		err = indx_used_bit(&ni->dir, ni, &bit);
@@ -573,8 +571,7 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 		if (bit == MINUS_ONE_T)
 			goto out;
 
-		vbo = (u64)bit << index_bits;
-		if (vbo >= i_size)
+		if (bit >= max_indx)
 			goto out;
 
 		err = indx_read(&ni->dir, ni, bit << ni->dir.idx2vbn_bits,
@@ -584,7 +581,6 @@ static int ntfs_dir_count(struct inode *dir, bool *is_empty, size_t *dirs,
 
 		hdr = &node->index->ihdr;
 		bit += 1;
-		vbo = (u64)bit << ni->dir.idx2vbn_bits;
 	}
 
 out:
-- 
2.43.0



