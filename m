Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA448615A;
	Tue, 17 Dec 2024 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455999; cv=none; b=O+G6Isak4+lzg8sKkVTS8kK1bH50oLjQKQ0f2YI8GLu0O1z4VAIYyi+CYWMjSts6qhgIxzyNvkWyvDWDWSspoLRpAN+5qK/OClivw6CWVwclfhiSAjjD46C3RRyTaPIx7f2Wz2KsjLrXqawLGP0UNS4TnxwW1BJpS2nSUVCdeEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455999; c=relaxed/simple;
	bh=+ALq327CR7rJEcM4tTBowA7i/q45WAtmeMQ+dbVn5Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIbqP5prChP7cMrD3NH5b3MPn8oy0ScwCQvyUGI6FfrqMhYtTVk/CWsVZSLxOKOkWzKoGJHDfba6CZlVPFJdln0Sdmbrty51+xrnIeK+Qn6qJRzu79PMOz7S80bJb2X3Bf3OHx7jIMQFSHhYOZe5tRd/bVHyNocVu6Qr4NcOmfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2XQ0aZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2XQ0aZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA01C4CED3;
	Tue, 17 Dec 2024 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455999;
	bh=+ALq327CR7rJEcM4tTBowA7i/q45WAtmeMQ+dbVn5Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2XQ0aZaDCoWrJJsgr+eqo6ltjUr31Mioqq1iDKCVVzEr3BXKm/RhWmX8vvJRTBzq
	 Qh1yMrzN0y2AKuc1y9Pmr0JkHjbtbAGO7O2yLrclfjBKb3csCrmYl8CGaxE40u0Gnb
	 2WV13zV6RtFoAyp411ZV7mHGlhSi/qjLag3xuxqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.6 026/109] xfs: return from xfs_symlink_verify early on V4 filesystems
Date: Tue, 17 Dec 2024 18:07:10 +0100
Message-ID: <20241217170534.471850202@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 7f8b718c58783f3ff0810b39e2f62f50ba2549f6 upstream.

V4 symlink blocks didn't have headers, so return early if this is a V4
filesystem.

Cc: <stable@vger.kernel.org> # v5.1
Fixes: 39708c20ab5133 ("xfs: miscellaneous verifier magic value fixups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_symlink_remote.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -89,8 +89,10 @@ xfs_symlink_verify(
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
 
+	/* no verification of non-crc buffers */
 	if (!xfs_has_crc(mp))
-		return __this_address;
+		return NULL;
+
 	if (!xfs_verify_magic(bp, dsl->sl_magic))
 		return __this_address;
 	if (!uuid_equal(&dsl->sl_uuid, &mp->m_sb.sb_meta_uuid))


