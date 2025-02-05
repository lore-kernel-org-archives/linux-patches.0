Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4461E89C;
	Wed,  5 Feb 2025 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768590; cv=none; b=Me4l1nVzszRi5rA7ghDfop1xFD7BRGzlkwSNgW5pct5ZSi/E2l+5N8BkhXDZ2Jsxix1SdL5SUDGxlH8ON4Z5m7GAVVOuVYFbsaSwmIsfc03M21/cvlE4Fy0QvK+daeWYIqaQgwjFtHaPpJ/w2CDCtpSlFLv2bOeAiUAzh4NAboY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768590; c=relaxed/simple;
	bh=6iVNFOKMZQQ2ij9sXDzzIPKMnvGdpsKVXxcjuM2+aYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqrTV9cV0AipOKKSQIRyx8iU0NjhiHZJMZFNBBCFOkATwc31l5sVxIkeRq+dit+lE6DqAB4zsv72OFOGwmtbDUIXh3CIqcfpfa8r8Db4Kili3ShwsG+VTFd9pDS8hnVmvKnNkTO8KLwYyYX3iHXXTfSY6z5fsMAFd9dG8vtQGGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRS5ALtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRS5ALtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41DCC4CED1;
	Wed,  5 Feb 2025 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768590;
	bh=6iVNFOKMZQQ2ij9sXDzzIPKMnvGdpsKVXxcjuM2+aYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRS5ALtJAejUdJe47VcT1MbN6gNs71PnKRAc6zUnguG77/CQz2eJHbsbB2W4CXJWY
	 D3rDuNEDRQVuA6cb6GcaZNbgSj2LPoVF2+LRv9n2T2efmGhFS+KWMhH06J2cnnEvPp
	 /9TSffqy9mR+QpA18RnonNlBMdS1oKVw4Zi7+OSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.13 583/623] xfs: check for dead buffers in xfs_buf_find_insert
Date: Wed,  5 Feb 2025 14:45:25 +0100
Message-ID: <20250205134518.523613805@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 07eae0fa67ca4bbb199ad85645e0f9dfaef931cd upstream.

Commit 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting
new buffers") converted xfs_buf_find_insert to use
rhashtable_lookup_get_insert_fast and thus an operation that returns the
existing buffer when an insert would duplicate the hash key.  But this
code path misses the check for a buffer with a reference count of zero,
which could lead to reusing an about to be freed buffer.  Fix this by
using the same atomic_inc_not_zero pattern as xfs_buf_insert.

Fixes: 32dd4f9c506b ("xfs: remove a superflous hash lookup when inserting new buffers")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: stable@vger.kernel.org # v6.0
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -663,9 +663,8 @@ xfs_buf_find_insert(
 		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
-	if (bp) {
+	if (bp && atomic_inc_not_zero(&bp->b_hold)) {
 		/* found an existing buffer */
-		atomic_inc(&bp->b_hold);
 		spin_unlock(&bch->bc_lock);
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)


