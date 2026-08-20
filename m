Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F70381AE2;
	Thu, 20 Aug 2026 15:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239145; cv=none; b=Wfa1zeS2rkd2xHo7gljhGErS3NahhnAaOcrnNliCO/ze92VLuew54FCIPyfV4RwNLUdRmeawzzr9oUlLJLFqjk4oYPrOV3MRsvXN3BnTlDpBvmNKjlglXE65VEqLFanYZIHsw7qNfFNsnOKtxyqjHwFD0k3Q3xM2NBuoAqPkoiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239145; c=relaxed/simple;
	bh=0x4/xf0P/YPmEI3oMibQDLLRpz9uQWFPWP6gyKrC3aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0a6Od938o4bBCLwCEPU/qNfYnBCRDM8gg5PXmcNabAdVBOTdj00bT8x1brVL9gni64eaIB8Ru/8+QCmxNo6UxFroEuP2U12V6AWEgbHzX8meAdcAgIGF9Gdx1l9j0QdV3kEi/iJebeJWDVF9kwa7DN0vjyHWGzkKEXQhR4+LSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQ4s96eL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQ4s96eL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7DA1F000E9;
	Thu, 20 Aug 2026 15:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239144;
	bh=Rj2jUHg8k4eILsXrzQUWPKeuZhlWXR1WXvtH79ZIM3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQ4s96eL6ho3pLQ/QQwz97l8AhVufMoSgmup/eY5suxFiHooRXu6fBQIgBWqsbVnS
	 OutV1uedCiPCfjrE7YjwfkhPqc9fvjhC+yfB/3Tncw6HvfZ1wIDIPevZncS4Wi4PHo
	 sbTzL3E03ilWd0fBGrqcD722q5zBBui1ARrrK7jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 126/217] xfs: dont ignore runtime errors in xrep_iunlink_reload_next
Date: Thu, 20 Aug 2026 16:54:54 +0200
Message-ID: <20260820145241.525286448@linuxfoundation.org>
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

commit 0052633527158b49762ab427e73924e4f8d25e6c upstream.

LOLLM complained that this function ignores runtime errors being
returned by xrep_iunlink_store_*.  Rework the function signature so that
we can return runtime errors to abort the repair.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1041,31 +1041,40 @@ xrep_iunlink_next(
  * the chain or if we should stop walking the chain due to corruption; or a
  * per-AG inode number.
  */
-STATIC xfs_agino_t
+STATIC int
 xrep_iunlink_reload_next(
 	struct xrep_agi		*ragi,
 	xfs_agino_t		prev_agino,
-	xfs_agino_t		agino)
+	xfs_agino_t		agino,
+	xfs_agino_t		*next_agino)
 {
 	struct xfs_scrub	*sc = ragi->sc;
 	struct xfs_inode	*ip;
-	xfs_agino_t		ret = NULLAGINO;
 	int			error;
 
+	*next_agino = NULLAGINO;
+
 	error = xchk_iget(ragi->sc, xfs_agino_to_ino(sc->sa.pag, agino), &ip);
 	if (error)
-		return ret;
+		return 0;
 
 	trace_xrep_iunlink_reload_next(ip, prev_agino);
 
 	/* If this is a linked inode, stop processing the chain. */
 	if (VFS_I(ip)->i_nlink != 0) {
-		xrep_iunlink_store_next(ragi, agino, NULLAGINO);
+		error = xrep_iunlink_store_next(ragi, agino, NULLAGINO);
+		if (error)
+			return error;
+
+		error = xrep_iunlink_store_prev(ragi, agino, LINKED_AGINO);
+		if (error)
+			return error;
+
 		goto rele;
 	}
 
 	ip->i_prev_unlinked = prev_agino;
-	ret = ip->i_next_unlinked;
+	*next_agino = ip->i_next_unlinked;
 
 	/*
 	 * Drop the inode reference that we just took.  We hold the AGI, so
@@ -1074,7 +1083,7 @@ xrep_iunlink_reload_next(
 	 */
 rele:
 	xchk_irele(sc, ip);
-	return ret;
+	return 0;
 }
 
 /*
@@ -1107,9 +1116,12 @@ xrep_iunlink_walk_ondisk_bucket(
 			break;
 
 		next_agino = xrep_iunlink_next(sc, agino);
-		if (!next_agino)
-			next_agino = xrep_iunlink_reload_next(ragi, prev_agino,
-					agino);
+		if (!next_agino) {
+			error = xrep_iunlink_reload_next(ragi, prev_agino,
+					agino, &next_agino);
+			if (error)
+				break;
+		}
 
 		prev_agino = agino;
 	}


