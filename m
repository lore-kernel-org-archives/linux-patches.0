Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07C74E7819;
	Thu, 17 Sep 2026 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660775; cv=none; b=eNpGNEl9P56jT6Zrhx7Oa4QxNt8grEXsgLZEHD6O4AF/bXoaMMHu07TCJMxQ+Ciz1iOb0oKCl0ppQQPL3SX7WKC5PKR1Xa7+K7NTYHAfKJVZc0RKjZcd4jeflKAMS1CEQ5SFmDKyCNoOsZA7+4TJGZziM+kGAXivnlDZIH/7VZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660775; c=relaxed/simple;
	bh=qR8Sbh7uuRg8P1XEnbe1/opvAiUjP3fW2COFTdScOhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ravvprL4lvTAmemDbYkpDjyVFOx345zOa7scmJFUihpQltM+2jN7lxwt5dRhsMwVykBf3kfPoIt96MjAxEAmBJUV2dE1fxJSBuDdp6mI6c3sIQTrl6YyurtFqrGbQ3s0HE/tPiaNQDWVwPRd6uocRCDWuS10BZ9rZFOo6B1isvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLMLuUd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLMLuUd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9191F00898;
	Thu, 17 Sep 2026 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660774;
	bh=zDESvTnV8FdiwIYXbiRjSlUcpF4n/dhxIbNxt8V4NBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lLMLuUd5EyhVRfa3DeezQc2xF6mQudqxEXB9F5PaYM4GZcpN4i7L3I9nQOmgkmCti
	 FVfdn/rE1hDzBdv8gNF3TiC0bDQmljjno98ydXfFA7R06WbZA8SjPTSniFqO/cCiHY
	 zYrB7hnv/E5Y9JCeEcCO4BnkoC+gNBw3XPMRA4Uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 666/733] xfs: fix parent rec lookup initialization in xrep_metapath_unlink
Date: Thu, 17 Sep 2026 16:16:14 +0100
Message-ID: <20260917151409.292505998@linuxfoundation.org>
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

commit cdc4a083adf7bf15a0722c5bd292a35e00112006 upstream.

LOLLM notices that xrep_metapath_unlink looks for a parent pointer in
the child metafile that it's removing, but initializes the parent handle
using the child.  This is obviously incorrect, so fix that.

Cc: stable@vger.kernel.org # v6.13
Fixes: 0d2c636e489c11 ("xfs: repair metadata directory file path connectivity")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -397,7 +397,7 @@ xrep_metapath_unlink(
 
 	/* Figure out if we're removing a parent pointer too. */
 	if (xfs_has_parent(mp)) {
-		xfs_inode_to_parent_rec(&rec, ip);
+		xfs_inode_to_parent_rec(&rec, mpath->dp);
 		error = xfs_parent_lookup(sc->tp, ip, &mpath->xname, &rec,
 				&mpath->pptr_args);
 		switch (error) {


