Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9272451B16B;
	Wed, 30 Sep 2026 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793694; cv=none; b=CcpEeshJuRNn7/faoJH9M04l9o7DpwaJ4ASg9XemYzp3K5NxzNtYOA5ebYXlDOlSf/VzsTj98mhcPHP0CsagZ4Zed+iR67WR6jyAX0YRGF615XqfKeMkv0cBqHmomHF5mpWF5f1GuaHTO0tim5f7cxLW+JWWgzx23AZYXDbvMKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793694; c=relaxed/simple;
	bh=NmFmfLYmHck3zeO14pC5FDbN9k7fXuvCEq+d7ehcyBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEhgZx03++w896Y2N7Vxch64IjOEk+wE2qbI1OT2zX0h0KzBnMypYjmCU1M29OFSiyuPTOrYaRQk0DDhmogjzb4so4HncuvquCeMgHyF3biswCtDDUfnkIrdjXz+DGiT8ET3G3edGFUIx0/Ter9rkmL/905S2004BoPi22F8igg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJUBmzeL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJUBmzeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9AA1F000FF;
	Wed, 30 Sep 2026 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793693;
	bh=l3/Je8xFRoV2+/VVpNMq3vSiwImvz+9hxCYqvHANVjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJUBmzeLGupBszAFLHlYH8fsbk/pI1x5tPoOXdxzGSD8+hiRhrriOE14aSGNBJ/sN
	 2hmlUy7tDiCe0n5XJ7LIG96P4ZDtCquah1qU9vZucdGB9iaEnNcZUkKaZtX2beMC/s
	 HUbloB2MF5nDj+/eG+34klwBHfHXZRMjdlD74zQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 344/395] xfs: dont let hidden_space go negative in xfs_metafile_resv_init
Date: Wed, 30 Sep 2026 17:30:06 +0200
Message-ID: <20260930152348.134911150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -292,14 +292,14 @@ xfs_metafile_resv_init(
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


