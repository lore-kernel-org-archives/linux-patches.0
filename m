Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACDB3812E9;
	Thu, 20 Aug 2026 15:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239151; cv=none; b=FnSdcT56B3mDWjR55tfdzlYX7MF5RLukJkcoxVWYAFpvuiOTKOjKTvLXKuTf2yic3qkZl73px+BoX5Ctud31q/CZlXmpU5H6FltXO0SexkilF5S08mxUWYNo9Xwn0AwED5gBYAMVNc9gSqkP+ERz7eV+5dUOULCgWDJFt7kBSyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239151; c=relaxed/simple;
	bh=s96voO+q+sn9oDi1ycAFxzy8fcKQ9Z8jdqaAvaDO/y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMV8F8rPnOYIzOCk6p/7X2C8rRjLp36QGLmoNBsCr+HtUrem8FelRiijzEIvmF2mhsGUiaQzujS1gh0tMjQaZKA873iqpWUdS9bho7rguNIODSLVX54jzTBjEW8n/JZzHpj0mtB+MzvwO4xH+V76aLtUdPEonGaURJ3sH9gD5go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jII6kAyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jII6kAyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED2C1F000E9;
	Thu, 20 Aug 2026 15:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239149;
	bh=Q/IJdK/icHT/9wsn+hcTbyYjeYCSMU6HehZ7lGeVsgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jII6kAyw7uy2UHefL4ZLw03wpUooeXfFQLA5+lmJZh1hCjXFC8Y2jq4TNk05PhgJv
	 0K3knh7wgYNUWSKltsuUhhQCfvJBMXaiaLOjDSHC/VV/mVce1hyv7Cmj7zMc6/Uw8t
	 3XOEf/YWTkGKXDORFIfCfY5SKukBN9W8FbjGlitA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 118/217] xfs: dont zap the attr fork on repair when there are queued pptr updates
Date: Thu, 20 Aug 2026 16:54:46 +0200
Message-ID: <20260820145241.288823864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

commit 5ee37132ea81abd36213b31a72140660c2aac54b upstream.

LOLLM noticed that xrep_xattr_rebuild_tree doesn't check for queued
parent pointer updates when it decides that it's going to zap the attr
fork.  This is obviously incorrect, so fix that.  We hold the IOLOCK and
the ILOCK of sc->ip at that point in time, so we can't race with any
/new/ operations.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1427,7 +1427,8 @@ xrep_xattr_rebuild_tree(
 	 * If we didn't find any attributes to salvage, repair the file by
 	 * zapping its attr fork.
 	 */
-	if (rx->attrs_found == 0) {
+	if (rx->attrs_found == 0 &&
+	    (!xfs_has_parent(sc->mp) || xfarray_length(rx->pptr_recs) == 0)) {
 		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		error = xrep_xattr_reset_fork(sc);
 		if (error)


