Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B442F2907;
	Mon, 22 Sep 2025 19:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570305; cv=none; b=HJDunqw3WrXnwWu4DpMHGhuAHn0tauc6SybUs5II2HixBg6dX5Mlrwo/CJ7pMiNAKTxtWPdw152AXd1X83zF2FXucplDPK+bg5yTfdUTXa7h6QAsT5JRThJL3ww8rCpOQUKd5rnxdBBam8kkUcXF9e1GcWv9sIVeX4MGzprTMHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570305; c=relaxed/simple;
	bh=f+BCxr+NSjYly+iu/dDeF1pirzRGc/vNuMLR+GfCZ+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kyzpx7nfDeGhkPPEVBdj5mv2+ear62y4XY7fvvtwR01cOdXm5OoRGqVdfXFWp4EIunXT2Zt26jAadnxAuq3nTowbcsF2RJHBZxWxHtxJg6gJzRMvOzffurW67PhEsTxPnxM4jn1rpiYV7638L2wv2CRzWPD5MBILlRDWGYVoCOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/GPYuuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/GPYuuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F92BC4CEF0;
	Mon, 22 Sep 2025 19:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570305;
	bh=f+BCxr+NSjYly+iu/dDeF1pirzRGc/vNuMLR+GfCZ+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/GPYuuS7GFJek83nd3t6L0vCthscUfFpMqhpSHE6v5RcOIJBwtFzETpvFEt+vNmA
	 wbhRbp4NNwyCTaTiCBN6UHKp5tJnbxl9+2nYkuD6+QMZPgv8gxhNwhlEfZw6TULk1x
	 LMNkemGhklO8F/XrofkYtxGWPWUzAQwvXSnhtpyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.16 083/149] btrfs: tree-checker: fix the incorrect inode ref size check
Date: Mon, 22 Sep 2025 21:29:43 +0200
Message-ID: <20250922192414.977363537@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 96fa515e70f3e4b98685ef8cac9d737fc62f10e1 upstream.

[BUG]
Inside check_inode_ref(), we need to make sure every structure,
including the btrfs_inode_extref header, is covered by the item.  But
our code is incorrectly using "sizeof(iref)", where @iref is just a
pointer.

This means "sizeof(iref)" will always be "sizeof(void *)", which is much
smaller than "sizeof(struct btrfs_inode_extref)".

This will allow some bad inode extrefs to sneak in, defeating tree-checker.

[FIX]
Fix the typo by calling "sizeof(*iref)", which is the same as
"sizeof(struct btrfs_inode_extref)", and will be the correct behavior we
want.

Fixes: 71bf92a9b877 ("btrfs: tree-checker: Add check for INODE_REF")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1756,10 +1756,10 @@ static int check_inode_ref(struct extent
 	while (ptr < end) {
 		u16 namelen;
 
-		if (unlikely(ptr + sizeof(iref) > end)) {
+		if (unlikely(ptr + sizeof(*iref) > end)) {
 			inode_ref_err(leaf, slot,
 			"inode ref overflow, ptr %lu end %lu inode_ref_size %zu",
-				ptr, end, sizeof(iref));
+				ptr, end, sizeof(*iref));
 			return -EUCLEAN;
 		}
 


