Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84AF15DBA3;
	Wed,  5 Feb 2025 15:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768074; cv=none; b=qUcdPnoNdpygltU+Ac3TwWSCBkEQt4PgiJg4CvcRNzkVPYZBGirzywd3rOn79SSj4ZsLC5ZwtPNsFr+Cqp578y9feNvP0veBwmPTmuNO/1sGqDwDIoYALItWmCzif6JkoHry9W9kW69LCp6veAlE8LTxkH5zYNv/ZCOtxV7EtMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768074; c=relaxed/simple;
	bh=e/pTB1PB67wunYTpeQkrAlpzFb7v+c2VZNOaNS9O1WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEoT1fl29xV2i8Y9XuCoE6gy74hrW9AbybkF1wE03BB6dk28XtvZVriYMSn6Yld6ZOIAGmUoThl+XbbJVS9+ZTPXPLnDMjinqZHshiepV+A5sPnMuYHHYvnW5pkM1M6Vg4oEPZAVd5MRR9rVzOxbh8SEu0NYIjBUg4yDdXty+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKLuXpuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKLuXpuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3222C4CED6;
	Wed,  5 Feb 2025 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768074;
	bh=e/pTB1PB67wunYTpeQkrAlpzFb7v+c2VZNOaNS9O1WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKLuXpuvopvbA2iLOFzVAhZaRgPbbxF5fZRN7kQcdwBrMLYXlvUvJBlKlfRW3y4wF
	 fTuyKXClwn9vZdbxVX8x3kCAr44Zuxe/cqko1Sego8unhl5qoAKI/ZLK9Vv1pn8U/H
	 +TMaL9JZYl4PbzODl9bdBxRXo9Io/dHwHzafieMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 549/590] xfs: check for dead buffers in xfs_buf_find_insert
Date: Wed,  5 Feb 2025 14:45:04 +0100
Message-ID: <20250205134516.273315841@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


