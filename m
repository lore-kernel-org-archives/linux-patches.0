Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7006254845;
	Mon, 24 Feb 2025 14:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407848; cv=none; b=jEvuLxOjyFciKSzjsPziZ8oeA39E/Htl+yvtYe3CtCFal49oLSRDENQlJkZYU1KA1Ho+tvrQUsXuyB0fzcRVz53Lf4mZmwou749hsdcmuhL7kfQRjpEMJuVb+VGi453y+8CmPGeAvJ0EFN9jgaymkWk/kY3l3S6oFjL6rD/Ev2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407848; c=relaxed/simple;
	bh=OBOQb61L6wukRNIEOPrWjynlpCic7u56UNJMgZahssE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9Z7hlcbX2SF4TryyZWnQ1blcK0zX/e85lEdvrMzOd93muuzHCe+MBeolJAO5mG5BMjM7htKTz153z/daXPab4xDPBo2Gue03N+6D57DaBKBoKpHTtCL4wzYul/IPKZvjrdNxKTOEm6rXVaR/Gr1Kr8reB5TzqiDmyGXYdSy4HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfKayxat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfKayxat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E878DC4CED6;
	Mon, 24 Feb 2025 14:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407847;
	bh=OBOQb61L6wukRNIEOPrWjynlpCic7u56UNJMgZahssE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfKayxate1iW9MZc0D17l1o0HMsWZS13gbbSlNzQF2/Tt+phOYqSWsuUN6cZXulH1
	 lsEKJQ6EgRf6FORNhON1UDoDBWpueQsap8gjTOGvakoBvsaaRGZTH3cqv2NX+b1X5o
	 6kzeQvJRpGLMAzJDCQ/4xxeAA5mnG8DsZkpCUIjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xfs-stable@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 003/140] xfs: validate inumber in xfs_iget
Date: Mon, 24 Feb 2025 15:33:22 +0100
Message-ID: <20250224142603.139668518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 05aba1953f4a6e2b48e13c610e8a4545ba4ef509 upstream.

Actually use the inumber validator to check the argument passed in here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -748,7 +748,7 @@ xfs_iget(
 	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
 
 	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
 	XFS_STATS_INC(mp, xs_ig_attempts);


