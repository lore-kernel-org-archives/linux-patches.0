Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049486;
	b=jGgOjcEfKBAXahsyruatFJ6pWR9Q18dgFzky6+6S69fRW73+UmB7JEgbS8M76wYhip0H
	 KYdaQIQiNFfStO6PGvswq2BIuSJd9t3B73/i4wU5mgx9jvB8T7+yIVM0tmw1uhuvOLHA8
	 aw+NMDiCy4AUk3+0SMjy6oYyu5b6VwA46Z4vQXXo83ZQGuC+yQCB8hNlPWzIzOZRthVd9
	 2/mhnRsam7eVWoxR321JF7qWJ0ocdjrOmFbExG4F9lvwhfT0LgT1/Gwm+OO+IQnxWNyv+
	 gVeJ2HD4W+vGIxLyEo8MDwXnliO8kghD99QwxWVmK2syI+YLhTQCIBWASU01F/EoRJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TODsgQZ71Y0bypI4kgQxpNrM/dXTmdB82Ccl6PfLwNY=;
	b=zoVrtYWVEd/noQVjD3zxOmFlvaJOaevP42wC1xuqmOJF9XzD2IOxt0rskVOqhBQiLkJa
	 Z8wHavMZzrwtULpcC546uAfF5peaUHjs3LjV5PHgNbZEsvKrleIYre6KlRZgjuWkrOdAJ
	 je6K2yw+zyQl40WU7pOo1MUyAN/wHObR+766jh/FR59cslUjq41KGYmW9mJBr/KrFkUqD
	 17Y5aEyFuQCM0MmdCwBKy5Twj2iUV2wtwERVEjXCxJ3erdz6hMqctotY35y4UWs3YgpeO
	 lXP75qF7xrNs3jHjjU0XpfANkR9U3smzKzSLWZWJ6WlVX1E3ZjcyQ5vQN9CUhxWp5lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhHRs+Uw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159CD606A336;
	Thu, 19 Nov 2026 00:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NhHRs+Uw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635541F000C4;
	Thu, 19 Nov 2026 00:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049485;
	bh=TODsgQZ71Y0bypI4kgQxpNrM/dXTmdB82Ccl6PfLwNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhHRs+Uw/wonM0F45bpeve/lnfHg0Ytty7ybHV4b8dQDktOdovpSbl1XVOFc/Lh9V
	 F/24quRFjjjpaYCsQLnHjgRvMiqgfpvzKMck9cAOo8veqB0XPwJ5NB0wrfKBLQrwok
	 uTJBF2yAktKBRyvWyJwU5t9RP/AKe4AzBZ07DYpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Yichong Chen <chenyichong@uniontech.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2369/2857] btrfs: retry verity reads for not-uptodate Merkle folios
Date: Wed, 18 Nov 2026 15:56:43 +0100
Message-ID: <20261118150326.816770821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 8cc569696dac51fc62bb39b3b8f530582b916d29 ]

btrfs_read_merkle_tree_page() can find a folio in the mapping that is not
uptodate.  After taking the folio lock, the current code treats that state
as a read error and returns -EIO.

That can make a previous transient read failure sticky.  If the failed read
left a not-uptodate folio in the mapping, later callers find that folio and
fail instead of retrying the read.

Keep the existing page-cache insertion and locking order, but retry the
Merkle item read when a not-uptodate folio is found in the mapping.  Also
unlock the folio when read_key_bytes() fails so that a later caller can
lock it and retry the read.

Fixes: 06ed09351b67 ("btrfs: convert btrfs_read_merkle_tree_page() to use a folio")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: fdf56b9d03d4 ("btrfs: refactor read_key_bytes() to remove the dest_folio parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index e2507dbaabbfe..99a11b59ec83c 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -726,14 +726,18 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 			goto out;
 
 		folio_lock(folio);
-		/* If it's not uptodate after we have the lock, we got a read error. */
-		if (!folio_test_uptodate(folio)) {
+		/* Folio was truncated from mapping. */
+		if (!folio->mapping) {
 			folio_unlock(folio);
 			folio_put(folio);
-			return ERR_PTR(-EIO);
+			goto again;
 		}
-		folio_unlock(folio);
-		goto out;
+		/* Another reader may have filled the folio while we waited. */
+		if (folio_test_uptodate(folio)) {
+			folio_unlock(folio);
+			goto out;
+		}
+		goto read_folio;
 	}
 
 	folio = filemap_alloc_folio(mapping_gfp_constraint(inode->i_mapping, ~__GFP_FS),
@@ -750,6 +754,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 		return ERR_PTR(ret);
 	}
 
+read_folio:
 	/*
 	 * Merkle item keys are indexed from byte 0 in the merkle tree.
 	 * They have the form:
@@ -759,6 +764,7 @@ static struct page *btrfs_read_merkle_tree_page(struct inode *inode,
 	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_MERKLE_ITEM_KEY, off,
 			     folio_address(folio), PAGE_SIZE, folio);
 	if (ret < 0) {
+		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(ret);
 	}
-- 
2.53.0



