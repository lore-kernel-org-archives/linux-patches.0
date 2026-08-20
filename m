Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AE92874E6;
	Thu, 20 Aug 2026 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238551; cv=none; b=FWjxCwuNhKuXML7Oc0uumYnIfjMZ0dMRi5ayhWVG/b08/KuhakO6zUhWvo3IORUEfsCSPU9HBIlsKxQkC0e+6+fsOpmyorgGTULNGbBRAU5fHIpi8P1U05Y5ZwMqJzAcXEEiSzfMD0Lp5kPlWPtkBOt1wBgDDUPs2KZ+E3NKq94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238551; c=relaxed/simple;
	bh=nvfxnQcq79vTQgMErG7g8XRQ7dZ4zEKhgRkXZ8dc9LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eN4nyl1AsGeAN3iVwmGCIsD/lge3/PdzHmMIWtn4Erz3F5Zjd0Q0TFeemTVEXWdv2VlUkb4Mycy+IF+lrBLy+ruGVgV/1IYFEjT7uhdU0Irh5BNs9Ku1ylzv4964f2KdbMIaxPgiEmT95XmRTWWENYIJ73VAk57mKWVBOLWNjGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXAaCaoN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXAaCaoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EADA1F000E9;
	Thu, 20 Aug 2026 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238550;
	bh=vk3pg+DPjop1zn4ODOWB58/+Jo1DW4aEi5WO270gG5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXAaCaoNzcyC1PgznaPR9bs2udTKWkqSNaufG88OTVWeJRsNQA7mvsamtJjirH8LF
	 lLYd1QoG1GihQCwHTmYdtGCfv8FojshwGQYEJg41heGKAU72URl1qG6WsnJyIQ5J66
	 Di1ZVhs7iNrZXSNS2X0moeU71JBPj8MxUG1dUV0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 148/228] xfs: dont ignore runtime errors in xrep_iunlink_reload_next
Date: Thu, 20 Aug 2026 16:54:50 +0200
Message-ID: <20260820145249.119862505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


