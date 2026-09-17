Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188ED56E06B;
	Thu, 17 Sep 2026 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660601; cv=none; b=DEvelV1JXwIKWWc4UfmvFPcRqkFB9BPvkOHKZVlQas0Ti8D3E6b6O9icfY20DhO5GbdplmnMOlXKR+HhuCGcI+I9GYIr7T3c9nWX4p2tXWV3F1XYBj40y+UuAzQXM1E3iZcqKApW1AD3e9PpwlRltQiSmNxlUq2nXTZzW0+WyO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660601; c=relaxed/simple;
	bh=VyxNifvzDt8XxHxIBHOSkr84loVbQV/cEEwHY2TbrPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=busgfEsv9TW1x8qTG4Ojeb5I+BzKDKtr57CBZwdqyCDmSXX2nQah+8BcKQPDckESvlmZHfUPNSAp1/nA3nzZXzs8LoVMozKh4ysRd0G3gahW9cDxugi/fQaaLBllifPBwI4YtNKt5teNp14mf0yOLkijbHd6juPrBpgObaFdE8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSfOAtey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSfOAtey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F11D1F00898;
	Thu, 17 Sep 2026 15:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660599;
	bh=bKqm4oa30uQ63b+x+yss0Gd6BA4xC92u5lkamftkOJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSfOAteySsqWjFugOU7wO6WlARNA6zkHZaigdlbMbPijEyBjsbx7RVgShPr6Tp527
	 rthcZO7Sn+kJ48RUopgteobh/5/mcFcJ+XmBz0rUoV3qP7qojXelNJ/+GF7rtLKQ+j
	 B4m2M9CJyjeM6shZI0tPJLPl5dOWrlNK0BItLjQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 646/733] xfs: signal inode btree xref error if get_rec returns an error
Date: Thu, 17 Sep 2026 16:15:54 +0100
Message-ID: <20260917151408.706641395@linuxfoundation.org>
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
 


