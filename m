Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7481B569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007FFC433D2;
	Sun, 28 May 2023 19:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302265;
	bh=i6FBoeECACKt1pvh281YTXRR4k/KDad4V/Zf/tzrb6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1tnXajGElTqbU5p0sB254zyoyhONj3pB7dTiRb5uI4cgnzLtoir4ee+vp91U0aw5
	 44LYeBSyW28ZN2H7C3Mvo7CoBYRZZzteq/7mxJCKnZCQVdArypVLsvOj00RbSfBdFS
	 mWoOyfj2u7W0/ysPm+j9ze7Ync5UqIrEihCbAD54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>
Subject: [PATCH 6.3 037/127] xfs: fix livelock in delayed allocation at ENOSPC
Date: Sun, 28 May 2023 20:10:13 +0100
Message-Id: <20230528190837.533619394@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

commit 9419092fb2630c30e4ffeb9ef61007ef0c61827a upstream.

On a filesystem with a non-zero stripe unit and a large sequential
write, delayed allocation will set a minimum allocation length of
the stripe unit. If allocation fails because there are no extents
long enough for an aligned minlen allocation, it is supposed to
fall back to unaligned allocation which allows single block extents
to be allocated.

When the allocator code was rewritting in the 6.3 cycle, this
fallback was broken - the old code used args->fsbno as the both the
allocation target and the allocation result, the new code passes the
target as a separate parameter. The conversion didn't handle the
aligned->unaligned fallback path correctly - it reset args->fsbno to
the target fsbno on failure which broke allocation failure detection
in the high level code and so it never fell back to unaligned
allocations.

This resulted in a loop in writeback trying to allocate an aligned
block, getting a false positive success, trying to insert the result
in the BMBT. This did nothing because the extent already was in the
BMBT (merge results in an unchanged extent) and so it returned the
prior extent to the conversion code as the current iomap.

Because the iomap returned didn't cover the offset we tried to map,
xfs_convert_blocks() then retries the allocation, which fails in the
same way and now we have a livelock.

Reported-and-tested-by: Brian Foster <bfoster@redhat.com>
Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3505,7 +3505,6 @@ xfs_bmap_btalloc_at_eof(
 	 * original non-aligned state so the caller can proceed on allocation
 	 * failure as if this function was never called.
 	 */
-	args->fsbno = ap->blkno;
 	args->alignment = 1;
 	return 0;
 }


