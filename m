Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DAD51EDE8;
	Wed, 30 Sep 2026 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790353; cv=none; b=HS7utJOGkAjhXcvvalKdhuLTtRxPO3f4xQjHqIPzq5wgpbKLKxodHiKStzpdXq3oZZDyMXiBDnZ6c5xnACPVPlhD1ocjNSwdT02XOI6LUPGGEWTMvSreGG108EbOUhvLpXvw1YDoV5pm8X5bsnihELD9AeknQHHyiv7dgGzRKjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790353; c=relaxed/simple;
	bh=hchH15UaXSpz3n0uyW7nH5nJdjICUrcC5+/Y9nEmEag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuhfK4lfQeVrpYi7LajfzGDZD5JPU9gIxfuPiZLgGErEF1XEhChQG8J82NmE0+mIRmEEj/PcEiJhK2IKcPhvydSXr8/BeDWEOQLDxm4Gce8mP+aTCKiqeCmsMosVLadfB52WtpwWUSsqxOxKv5wpIea6oICBzFxiBdkZzB4T3zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtUSF5Yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtUSF5Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024E81F000FF;
	Wed, 30 Sep 2026 17:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790352;
	bh=NBKZXFY4qwCJVjSvisxy6eRli4yPeZJm6aGtOfTI4oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtUSF5Yr6mTxP8z3JSw4DTb0JGOhhuvRQcsI7ZU+nv0TA8aWYMB7pbGlik5siZoLE
	 FyF3FcKKLytqx49MicuQbXjNnMcEKBcxln//8tQXx4XBVg/zFPrUayq6ej5Az8/f1+
	 dgtDe/va75XHyJ7evs3zrKAnVNVt+WapUgIB/R5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 782/877] xfs: fix backwards mergeability logic in refcount scrubber
Date: Wed, 30 Sep 2026 17:28:13 +0200
Message-ID: <20260930152431.589995969@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit e8b01aaafffe6b852325debdf1ef4b13ccea1cd7 ]

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
[ omitted the rtrefcount.c hunk because the file does not exist in Linux 6.12. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -411,7 +411,7 @@ xchk_refcount_mergeable(
 	const struct xfs_refcount_irec	*r1 = &rrc->prev_rec;
 
 	/* Ignore if prev_rec is not yet initialized. */
-	if (r1->rc_blockcount > 0)
+	if (r1->rc_blockcount == 0)
 		return false;
 
 	if (r1->rc_domain != r2->rc_domain)


