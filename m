Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EF63195EF;
	Thu, 16 Jul 2026 14:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211060; cv=none; b=GzL+KEvGlQJF1uViXFaYovOW9fnRzCWDJA/54OjlaLS9vBOxSb9KtRPaFOsM+jAXVLNHiHV39u+zGgGsWVFL9ME8ipAynJZVzIWutuaE1b3I2mcDHtVRlF0ri0g5M1Ik9YMY0GEZwu7VocJtgc3y143sn5LeG1SXJ6vmQ0Z2KuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211060; c=relaxed/simple;
	bh=+hnA91H8HrXDE59InjayVIzcdWVN9+MT3MNuOl9I5+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYv/hBcuNiK26d8dNN0p59hjeOhbBNRcesMXA1bn2qljHtWlRfH0HCr99GzFHRuenIva0BXU250wJb7p1JyrzgFF9d2LKqoj/QC/4NkeEayD0FqzhKlPQ/W147YfzYl3CE0aRGRVo3I/0tn+EpkS1veUSgZ5vEOTcnfiUZeSVvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btigQQSA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btigQQSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027461F000E9;
	Thu, 16 Jul 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211059;
	bh=rR+c5c+hFTSe92JW3uLc40piHlyI7rCC0iF8StYEeho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btigQQSAPyONIfzp0i+bkMZUB9KeGTXna6fSu+RdXnxFfjK7V9NtclPO6MgIaqBtY
	 8rvm7QKNSXF9ZfQCaJ9l9zu1AW/9Hnr8VyLKXaTQ8aP0Onou+Kw5rRYAQKv6q0AhUY
	 fileSnE+AgX3BOlY0moFa6XvsAZXTDOVPXBm/vjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 277/480] xfs: fix pointer arithmetic error on 32-bit systems
Date: Thu, 16 Jul 2026 15:30:24 +0200
Message-ID: <20260716133050.817373450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 84eec3f7fc73144d1a230c9e8ad92721e37dcaab upstream.

The translation of the old XFS_BMBT_KEY_ADDR macro into a static
function is not correct on 32-bit systems because the sizeof() argument
went from being a xfs_bmbt_key_t (i.e. a struct) to a (struct
xfs_bmbt_key *) (i.e. a pointer to the same struct).  On 64-bit systems
this turns out ok because they are the same size, but on 32-bit systems
this is catastrophic because they are not the same size.  So far there
have been no complaints, most likely because the xfs developers urge
against running it on 32-bit systems.  But this needs fixing asap.

Cc: stable@vger.kernel.org # v6.12
Fixes: 79124b37400635 ("xfs: replace shouty XFS_BM{BT,DR} macros")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -89,7 +89,7 @@ xfs_bmbt_key_addr(
 {
 	return (struct xfs_bmbt_key *)
 		((char *)block + xfs_bmbt_block_len(mp) +
-		 (index - 1) * sizeof(struct xfs_bmbt_key *));
+		 (index - 1) * sizeof(struct xfs_bmbt_key));
 }
 
 static inline xfs_bmbt_ptr_t *


