Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242074DEC3F;
	Thu, 17 Sep 2026 17:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666670; cv=none; b=juQbl/GWY+2+BUzg8gpdqftZpjRnUC7LjMo6f1JYPU7t31iwi5WgoNEPpyoGKt+APg1bmgM1kLvxWNBDn5SOLZu4FI3xRWO0vUOKWiCJn/4u5PloOWDLlBjUr6CSyM+3zcStxen2F9JelY59uvCVrZ1W9jHHsN4wgTqCmkdcxQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666670; c=relaxed/simple;
	bh=JAqvK3QJSDm836oxpWKiFhhYhYJR0RzU9HnY+O7MGnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5tleQuaIhnEUclMf58UPOAxQXHi4avQm3yDgHdJcsRRac7Gvf6ExboG/aaCx/DJ4Cu7HTqbvh3v3FljBfWZq8vOv8NBbHGxu0suDYkJ6IDdEgNOpLmpPy0HXyfZ54EZdjtEL14akt//Efa2hxOAffSWX7tjs0pGbc7IUC1kzDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3aCP5MY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3aCP5MY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD671F000FF;
	Thu, 17 Sep 2026 17:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666669;
	bh=q1DknrHDCfc3ZG4000ajUX5/LYKwWnc/XYj4XEv5WrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3aCP5MYk2y6RrCjhjupcPaPwYdISE7H4ZIuAK7Ym5oaqHfWQa2AUKJTNkG9A+KLC
	 rY8RVpAW7ITzwB/RUplrqURVbunH7KFze6nv2JTdGhzKLE0vgv55L49MGVl467GhrO
	 nSdKQ+4hvQ5T703fMY56epz9VvC7y+2vH0vE0RVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1115/1250] xfs: fix backwards mergeability logic in refcount scrubber
Date: Thu, 17 Sep 2026 16:15:10 +0100
Message-ID: <20260917151622.447771642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

commit e8b01aaafffe6b852325debdf1ef4b13ccea1cd7 upstream.

When we start the refcount or rtrefcount btree scanners, prev_rec is
initialized to all zeroes.  This is done so that the record mergeability
checks skip the first record because you must have two records to
compare.  Unfortunately, I got the logic backwards, so scrub has never
complained about mergeable refcountbt records.  Fix this bug that LOLLM
noticed.

Cc: stable@vger.kernel.org # v6.4
Fixes: db0502b39c21d1 ("xfs: flag refcount btree records that could be merged")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c   |    2 +-
 fs/xfs/scrub/rtrefcount.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -411,7 +411,7 @@ xchk_refcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_domain != r2->rc_domain)
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -377,7 +377,7 @@ xchk_rtrefcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)


