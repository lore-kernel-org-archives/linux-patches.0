Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8373B7771;
	Thu, 17 Sep 2026 17:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666596; cv=none; b=kppHR8PDyWiLx9NzCfPUvFDkc7KZU1O5PEc9AZh1a9otMYCWgDhcG7JBXPuUXkHjmUf0rD7TQHTmLTgYpkjPVhFMojxVNUPiq9TCYJfpehjG9LMg/J17BvdI57jOzKLL9tht3njTuFcm6ubYWOzn7MXFpg0EoMyy6uMTjWJkwFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666596; c=relaxed/simple;
	bh=tJBvL51GNC9ziCkMmOBLPXHyW++Gv+RA2GH7EEC96eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6hunJrASozex2DK0iyj6q7hamHfW8HjS6fhKb9tu5WeN5OnvoKCMVZnQzrLuf3hKZn6vJO0gkFXk6KrhSup+FChqMNjtE11s7/xxSoJfKYCQmFHlAGOc9xFl+lztkq4h0hIUqSqvjJ8tAQm0K31s2pH0KAN3AAcySXfcsCHRhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbJXBqCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbJXBqCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5C01F008BD;
	Thu, 17 Sep 2026 17:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666595;
	bh=FqxNb8boyi4Yv1vpN+fKLzoKJ4MGby5n9tzXKUGsbKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbJXBqCjYu8rcTv8LTvA1jv169OWJYc/T1Hne/vdOUKxVi2K2EvkqK7DCR/JHxsC3
	 SyRmxo2oCku0RE7Z99vC8iL6/4WfUZDV40p9sBUu4gyUAvejv6R3evSozWqf6Edy43
	 KElX3+wfyyl+KdF/ETjGd/37qNtyeVev2q8jS99s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1090/1250] xfs: strengthen the "is cow staging" helpers in scrub
Date: Thu, 17 Sep 2026 16:14:45 +0100
Message-ID: <20260917151621.705141639@linuxfoundation.org>
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

commit 0d43368844a75ad13561a1198a3b027940730756 upstream.

LOLLM pointed out a bug in both of the refcount scrub predicates that
determine if a range of blocks is marked as CoW staging in the btree.
While it compares blockcount < len, this isn't enough to determine that
the CoW staging record is at least as large as the range passed into the
helper.  Fix both of them.

Cc: stable@vger.kernel.org # v4.16
Fixes: f6d5fc21fdc713 ("xfs: cross-reference refcount btree during scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c   |    6 +++++-
 fs/xfs/scrub/rtrefcount.c |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -582,8 +582,12 @@ xchk_xref_is_cow_staging(
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 
+	/* Can't start after bno */
+	if (rc.rc_startblock > agbno)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
 	/* Must be at least as long as what was passed in */
-	if (rc.rc_blockcount < len)
+	if (rc.rc_startblock + rc.rc_blockcount < agbno + len)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
 
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -610,8 +610,12 @@ xchk_xref_is_rt_cow_staging(
 	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
 		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
 
+	/* Can't start after bno */
+	if (rc.rc_startblock > bno)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+
 	/* Must be at least as long as what was passed in */
-	if (rc.rc_blockcount < len)
+	if (rc.rc_startblock + rc.rc_blockcount < bno + len)
 		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
 }
 


