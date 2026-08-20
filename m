Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D353E37E5E5;
	Thu, 20 Aug 2026 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239032; cv=none; b=A8foq091QKR6smk3SUuWW8ySCvfbwMREmX3FgB+5wHlAhO0stCppzA2tzFS5ddyQYAsGiwTHSneOUq8v3kRnB9CWbRQvCd9pNcBAieZBGKxeH68IPhC2JHwcrAWBHAdhw2PzWV52pal3Rv9z4KtAklsbFJhcEMtB8BX5jecANpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239032; c=relaxed/simple;
	bh=adHL9/PJKDSO55DUbyKoMP7/ByF4m0AIVuBwRK+jk08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp2XK4KfsGaQWc3YWBqtFV8KkhPVlBV9wuqYBdBbELOAV/W9vJhtI5fJJss08VI6oxOzbpz22jHVCFyfCGIYwECS55PexUgSwFZarOEoGULqQYWkkJkGoEGW2ica2SgdY7ZaOzwcnMaaj4XRzkk8CLp+F2xxB+qgeUJi7GnEdR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsISpXJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsISpXJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E4F1F00A3A;
	Thu, 20 Aug 2026 15:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239031;
	bh=f7N5iT0MM173kWVlOgSUAyjX9WdQuOHijJEWBSfoFhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsISpXJbGk0d4yWO66VwcrXWQEy+cOpuWol3GWHnDC9tUv5eGe/ORzQ2pJzGC1JmL
	 IqdMHjKfPhyySaMgTXMVl2wwPHTFAkE9i902xDZnIB0GuanYXZPV0/a1rRhsSwW0am
	 gn3uwYQq5Djx+DyMTMkQ/1i8ZQXW91s0SkDcnp/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 119/217] xfs: dont walk off the end of a null sc->sa.agi_bp in AGI repair
Date: Thu, 20 Aug 2026 16:54:47 +0200
Message-ID: <20260820145241.318905071@linuxfoundation.org>
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

commit 1e96a00e0d3a00be6e4f368b2f18e2d345f813ce upstream.

LOLLM noticed a longstanding bug where xrep_iunlink_walk_ondisk_bucket
tries to walk ragi->sc->sa.agi_bp to rebuild the unlinked inode lists.
Unfortunately, it's possible for agi_bp to be null if the buffer
verifier fails, so we have to use ragi->agi_bp (which skips verifier
checks) instead.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1081,7 +1081,7 @@ xrep_iunlink_walk_ondisk_bucket(
 	unsigned int		bucket)
 {
 	struct xfs_scrub	*sc = ragi->sc;
-	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
+	struct xfs_agi		*agi = ragi->agi_bp->b_addr;
 	xfs_agino_t		prev_agino = NULLAGINO;
 	xfs_agino_t		next_agino;
 	int			error = 0;


