Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA592417DE;
	Thu, 17 Sep 2026 18:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671205; cv=none; b=iAJIi4/q/G1FzxWsfH3fHCQoToR4Vf8VWggopNWbafXn0rqEuZj1V7VMYn2IVbdEDLkx5PCEFdm/GgX0XnIuUHKctTMWNcOxWmaWCqVjyXXfhvFmMkNKadlbgZKHrKXUYIlMcz6C/ClIZ+Mbe7OZL9NIXJbg7Ma8IwBMd5VmYM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671205; c=relaxed/simple;
	bh=6nKJ3F4IFGAAYn9kQEQcBtYMBEZcdciaFCJ8NGYiuvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEx4m1m1C9mq/2X8nIrZV/rjlGAWyPwxdx4bzPsOqlBzabMCkOz1iG9jrqmUbwqhWpXppz6cBTiHQv8wpioMWgbMmpu5gWuDWWbKNzk2itf1f7QkJQgTqza6+5tKOzZEKfHiAm/w3ELKzkL1U5fc+vKJ0ir2nAhwM1zTT7PP7KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5tb1zVy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5tb1zVy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52D81F000FF;
	Thu, 17 Sep 2026 18:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671204;
	bh=in4s/FJ9yXZg37EHYnHuy++rQaZBCGfPYXHuC7qDpzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5tb1zVy0MnQofMbLjKT26cGiAlZH9YNg4FEQSGryfyuAj/ReG3CFqbOe+LxxP9+7
	 C8532F9JsYkzlxLxH8VF+drFBP/FwDneArQgS92E4k1QEwO//doAAf8SMOfDcX1/Pv
	 8oRrGdPfgiQZwWl+2xAJF9knfEUhtGaKp2grtOT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0900/1102] xfs: signal inode btree xref error if get_rec returns an error
Date: Thu, 17 Sep 2026 16:14:03 +0100
Message-ID: <20260917151603.194451490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 8c71ad4d4f3e20c30b663bd292526fcbc4d3913f upstream.

LOLLM points out that xchk_finobt_xref_inobt and xchk_inobt_xref_finobt
both ignore errors being returned from the xfs_btree_get_rec function
and proceed with a (possibly stale) "true" value for has_record.  If the
*simple* btree record checks fail during cross-referencing, we can
immediately conclude that there's a cross-referncing error in the other
btree.  On those grounds, we can bubble up the returned error instead of
wasting time cross-referencing with garbage.

Cc: stable@vger.kernel.org # v6.4
Fixes: bc0f3b55467e1b ("xfs: directly cross-reference the inode btrees with each other")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/ialloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -85,6 +85,8 @@ xchk_inobt_xref_finobt(
 		goto no_record;
 
 	error = xfs_inobt_get_rec(cur, &frec, &has_record);
+	if (error)
+		return error;
 	if (!has_record)
 		return -EFSCORRUPTED;
 
@@ -188,6 +190,8 @@ xchk_finobt_xref_inobt(
 		goto no_record;
 
 	error = xfs_inobt_get_rec(cur, &irec, &has_record);
+	if (error)
+		return error;
 	if (!has_record)
 		return -EFSCORRUPTED;
 


