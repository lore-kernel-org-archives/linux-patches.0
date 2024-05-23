Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DF113A897;
	Thu, 23 May 2024 13:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470417; cv=none; b=BU5F+J6FI1FWeRwZOta8Xj1CPeitlmE+2dJgCTqeiM7TfQ4Lkfcn+fvXytIoTmfqugBzF4ePTVcNyJ25ajVkHY/6v4px89R59/h+XBC8u/+1V8HtB/maQRuc2LpcOSl9Bt4WWUU7KqzwNxCAyqj+GIkg7pJDyXfrtGX2Js07ttc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470417; c=relaxed/simple;
	bh=9lcSinglYTzq53su3TxoQOlN+SZoOeREb+OsguBMm24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrOFa3nu/h/3BoGOglK7n80nHqHFR9DWHbamgo0gTUyKjeycvIopACUNZGbwrbloUlA9HbFoZr70irYI6muBekAvbilL1LQDJpQW/i9PuH2yVi6TAa4poLQZa6Uv7SBdQW5dYQ2g/KbIO8EQO6JowWr/4a0jj5gu8M8l5JmRn+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfIUwuC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfIUwuC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FFEC32781;
	Thu, 23 May 2024 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470417;
	bh=9lcSinglYTzq53su3TxoQOlN+SZoOeREb+OsguBMm24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfIUwuC0bDYg7a34QyESMiCue3Jk1uq79saCFyMDHHICyZ8caZff1N5fopmcAlWnz
	 nuDUeWW1KJCiCQrLB3IcVzdaXvI4F2yPvO/44Ai2WipudrabIl76uCvkk2SZMOWx19
	 6XJkmfvmiS+5M9spp09+OP/4f/jXfsaWrHt7oir8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 29/45] xfs: invalidate xfs_bufs when allocating cow extents
Date: Thu, 23 May 2024 15:13:20 +0200
Message-ID: <20240523130333.595567861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit ddfdd530e43fcb3f7a0a69966e5f6c33497b4ae3 ]

While investigating test failures in xfs/17[1-3] in alwayscow mode, I
noticed through code inspection that xfs_bmap_alloc_userdata isn't
setting XFS_ALLOC_USERDATA when allocating extents for a file's CoW
fork.  COW staging extents should be flagged as USERDATA, since user
data are persisted to these blocks before being remapped into a file.

This mis-classification has a few impacts on the behavior of the system.
First, the filestreams allocator is supposed to keep allocating from a
chosen AG until it runs out of space in that AG.  However, it only does
that for USERDATA allocations, which means that COW allocations aren't
tied to the filestreams AG.  Fortunately, few people use filestreams, so
nobody's noticed.

A more serious problem is that xfs_alloc_ag_vextent_small looks for a
buffer to invalidate *if* the USERDATA flag is set and the AG is so full
that the allocation had to come from the AGFL because the cntbt is
empty.  The consequences of not invalidating the buffer are severe --
if the AIL incorrectly checkpoints a buffer that is now being used to
store user data, that action will clobber the user's written data.

Fix filestreams and yet another data corruption vector by flagging COW
allocations as USERDATA.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4058,7 +4058,7 @@ xfs_bmap_alloc_userdata(
 	 * the busy list.
 	 */
 	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (whichfork == XFS_DATA_FORK) {
+	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
 		bma->datatype |= XFS_ALLOC_USERDATA;
 		if (bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;


