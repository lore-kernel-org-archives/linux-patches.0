Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6158350AC0D;
	Wed, 30 Sep 2026 17:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787968; cv=none; b=Mn+ZL0ZZYgE2v4+1jihBSm/n1ArSta8CocGU35qlJPh7157ss5//364k6bLK2CjUUvdDb2VaO3apJrGhrvNw8Xp7/Y2PJz8VwRR9bLuNoSuJSmo0uHEqOM4hRiDpIv84waaJwxP6RSV5gqkHtVxEZvsea2k/ZFsyyFDdp/7uZkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787968; c=relaxed/simple;
	bh=YVRwFhnvXVOJwmiRCFBZaLArq2FC4tJRYMjPMtx2Hq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfOop8skkEY7KCVPKxCRLeyA55GK1+FzcDB3Smiq3ZeRMBpMCYJbL2Ut9GgLwmDY9sruGbvm7io2vaHdXr1xpjlcDLDGZStDelPvfwB32tMWJBBQkRry7UJcSDljAHH3GZRcuGSBFXSDAp3bZV++H8O5Aba2AAGGk2YdY/Frj/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/Cm5UZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/Cm5UZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8A11F000FF;
	Wed, 30 Sep 2026 17:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787967;
	bh=ecV1yhl/7Mo1aaWd7JCMbbBz2eNXYC5LuQXS7fD6fJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/Cm5UZ32udkQsccrIn9pMqrxbgJXJHJLYTGR1usk+DFp4YYNmD+NWuumO7NCie0B
	 /MeQdO26UFxlc39qg5KqL6s+WfUmD+d0WDQ+X4WlbaPwT+bK3iBn3jzrLVFL4AF+qB
	 CGWNmZIO5AhiQ1O6c5KXMhhL1H6bCMMF54JUNHd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 417/457] xfs: fix attr fork block count checks in xrep_inode_blockcounts
Date: Wed, 30 Sep 2026 17:28:42 +0200
Message-ID: <20260930152354.985013167@linuxfoundation.org>
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

commit bb991b7f79dd34cc5f24db0f736bf75630c970e7 upstream.

LOLLM points out that a file has an attr fork, it will call
xchk_inode_count_blocks to set @ablocks to the number of fsblocks mapped
by the attr fork; but then it'll compare @blocks (aka the count of
fsblocks mapped by the data fork).  We already checked that and we never
do anything with @acount, so I think this is clearly a bug.  Fix the
comparison.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1702,7 +1702,7 @@ xrep_inode_blockcounts(
 				&acount);
 		if (error)
 			return error;
-		if (count >= sc->mp->m_sb.sb_dblocks)
+		if (acount >= sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 		error = xrep_ino_ensure_extent_count(sc, XFS_ATTR_FORK,
 				nextents);


