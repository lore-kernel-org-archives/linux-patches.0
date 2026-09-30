Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682834FECCF;
	Wed, 30 Sep 2026 17:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788002; cv=none; b=ie/d7VmlkI/wMeM/ZTG3n5+nGeR9CMLyvCF34a7THmiRj+zB2iPNm8eFACnjSLCQ9S6QyB+74s+ojZhBe6jZ445oliMCI7agIRPfT2th70inliIfhOto5CybDAToUEnh0VWo/mbubXjx6kA9++ZROny5me0+l8s+PtFwQBIKDT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788002; c=relaxed/simple;
	bh=AgK5Hz1c7ygZsgYNVZ9RIpFK0ADc564T931ZWRPxdG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mooXRyUjmpjZCk0hp4rSgMsBLQpZyvSUB40fOhidoONv0OzkDD/41zRKvliL3se9KuabJd1kXQfE6MEB8oJy9CKgrGyJVHIuefkgFSMV5Ej6FU/dFA8knL2DepbM66eC+G33Oya1TDlOLQBEm9f43miiGCKKNB9TAOt6Na91kyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXv/HbCa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXv/HbCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FF91F000FF;
	Wed, 30 Sep 2026 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788001;
	bh=c25rGtR11GPLGyrRnboON5VfYuipbTitUD0AKzJ1S+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXv/HbCaEWo5+NANlB2poYbg8wn0xpmZRCpWVvbdWlxo3SblsI6yK8GfU37p4L36y
	 00e8b0L75crhfyEDmLZAFuItJ/pG6seQ88nNj95eC3xJ0OF81XwNiRtduuaSZYZYBb
	 fVB/vZiHA/N8Ro7rgWi0WllkBCIk5pJgpbPawL58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 428/457] xfs: dont let hidden_space go negative in xfs_metafile_resv_init
Date: Wed, 30 Sep 2026 17:28:53 +0200
Message-ID: <20260930152355.226448451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

commit 476582d754cdc5110f806001417fea6c77824c13 upstream.

LOLLM points out that if the amount of fdblocks that we can reserve for
a metadata btree file goes below the space already used by that file,
then the hidden_space subtraction can underflow, causing
xfs_dec_fdblocks to subtract a huge amount of space.  We never want the
target to be less than the used sapce, so fix the logic that adjusts
dblocks_avail downwards.

Also fix an error in the adjacent comment.

Cc: stable@vger.kernel.org # v6.15
Fixes: 1df8d75030b787 ("xfs: make metabtree reservations global")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_metafile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -297,14 +297,14 @@ xfs_metafile_resv_init(
 		goto out_unlock;
 
 	/*
-	 * Space taken by the per-AG metadata btrees are accounted on-disk as
-	 * used space.  We therefore only hide the space that is reserved but
-	 * not used by the trees.
+	 * Space taken by metadata btrees are accounted on-disk as used space.
+	 * We therefore only hide the space that is reserved but not used by
+	 * the trees.
 	 */
 	if (used > target)
 		target = used;
 	else if (target > dblocks_avail)
-		target = dblocks_avail;
+		target = max(dblocks_avail, used);
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);


