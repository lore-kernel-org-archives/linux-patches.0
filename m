Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3789E5172CF;
	Wed, 30 Sep 2026 17:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787971; cv=none; b=k5vefYKNkOi/5516KGy4nrYzWsraJgTKRhC1FJ1UtO85/84lqN/KgU9eaRCNaZbgVRF/6r33Fd7Q+lMlha8ORhxtBjbhYpNuPt8KvqraFgwukmY8h91EXHUm0dvjWxTTdLkzebeapJvf5rSmRQeU8gPXqVBOaOcTUeQ9DdnK+/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787971; c=relaxed/simple;
	bh=TU75L2+nKl5TngsBxTk6Xjzys3uUa171SKkxbMX/ulk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABfCL0gvbadt97x87ia3EZhsTCJu/zLy8MUX6i4lKKugianSB7A60MDRjmxNdgkP0rfWfAfCyBeo4N1xEk/QDj8WuOaKEi0bSjYzhGwO7LIPkz5N5ERnTleosXG+nFGGGgm9rhtRFkwI4cdrvH9TI/tFqDt8bycxvaT6uaYh01M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThP5jAqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThP5jAqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913A61F000FF;
	Wed, 30 Sep 2026 17:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787970;
	bh=Ig7Wc0ZY7OkDYCNpz98LVm+dbEjxrl+5yKto2izpda0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThP5jAqXmxr7r5w0Rh+JeDCTp+nqxbBd1Pgx3cy3fv/RynBdPsAGd7M01mCGNl0y6
	 pxHtp4W+haaITtOWUQi9UNoX41Egmm6FoNIHBOQgcDWjSqUYVrpV1xTyo4jYmpARyo
	 Y++Hl+puoxNbrAO64GNB3TmjC2vjUEBpwZuhe4Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 418/457] xfs: release orphanage dir inode if chown fails
Date: Wed, 30 Sep 2026 17:28:43 +0200
Message-ID: <20260930152355.007152067@linuxfoundation.org>
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

commit 1c32cdc986467eaffeedb6c5334852809555b82d upstream.

LOLLM points out that we leak the igrab'd reference to the orphanage
directory inode if chowning it fails.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: 1e58a8ccf2597c ("xfs: move orphan files to the orphanage")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/orphanage.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -192,12 +192,16 @@ xrep_orphanage_create(
 	/* Make sure the orphanage is owned by root. */
 	error = xrep_chown_orphanage(sc, XFS_I(orphanage_inode));
 	if (error)
-		goto out_dput_orphanage;
+		goto out_rele_orphanage;
 
 	/* Stash the reference for later and bail out. */
 	sc->orphanage = XFS_I(orphanage_inode);
 	sc->orphanage_ilock_flags = 0;
+	orphanage_inode = NULL;
 
+out_rele_orphanage:
+	if (orphanage_inode)
+		xchk_irele(sc, XFS_I(orphanage_inode));
 out_dput_orphanage:
 	end_creating(orphanage_dentry);
 out_dput_root:


