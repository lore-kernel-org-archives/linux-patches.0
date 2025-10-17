Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76390330B0C;
	Fri, 17 Oct 2025 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715672; cv=none; b=u8msVgyWQWXBSuldEPM6MOHo3p1O87IzI6dYp7mpbsRY2TRTDQeA1sSG9BOrri1DLyfFmon3heU0ud5IviH2AQH0eVK1IeR2nCyhNt2jfBX0+trFd/VcJmd2AP5tGN7l10ago1e7L6X1fJIyhxLgejznfZRy7rsyxenxzH7U1q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715672; c=relaxed/simple;
	bh=nfgApfVrZIZtXGZuBZXScDN2+q9eT5KWTBnqpEYMVAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjL3Opw6ZDo8WK9G3WLVMJav2lm6WDHromBEQFqyUZ3zAFOk51fmUTJWd1hmOY2eZRnsf7e3wf1R8YRJIhTxoCAGs1/pB7vZVQzsdtAu5dRePneG3Jg7rt2XpwNHSf0d9wbg8oVGhLpJtgTuHIiwOOgXruVYK261Myr77ymjomw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xkql3PP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xkql3PP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F21C4CEE7;
	Fri, 17 Oct 2025 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715672;
	bh=nfgApfVrZIZtXGZuBZXScDN2+q9eT5KWTBnqpEYMVAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xkql3PP2Ib+vLkndxNwI4sc6imz8ZXybiXZOk70Gm60HyRkeZFbbtMXll9tKbUTpV
	 /YzZJ7GpqzOQWnIHRk5R5lesyAtv99I7Wj4beG45Q6fCHBHUMyMrCPtjCVmV0DSwWu
	 68RhHmYJ1S4XvnO5/uZgz3N68ngOv/g/6E952+ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.17 297/371] xfs: use deferred intent items for reaping crosslinked blocks
Date: Fri, 17 Oct 2025 16:54:32 +0200
Message-ID: <20251017145212.818685612@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit cd32a0c0dcdf634f2e0e71f41c272e19dece6264 upstream.

When we're removing rmap records for crosslinked blocks, use deferred
intent items so that we can try to free/unmap as many of the old data
structure's blocks as we can in the same transaction as the commit.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/reap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -416,8 +416,6 @@ xreap_agextent_iter(
 		trace_xreap_dispose_unmap_extent(pag_group(sc->sa.pag), agbno,
 				*aglenp);
 
-		rs->force_roll = true;
-
 		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
 			/*
 			 * If we're unmapping CoW staging extents, remove the
@@ -426,11 +424,14 @@ xreap_agextent_iter(
 			 */
 			xfs_refcount_free_cow_extent(sc->tp, false, fsbno,
 					*aglenp);
+			rs->force_roll = true;
 			return 0;
 		}
 
-		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
-				*aglenp, rs->oinfo);
+		xfs_rmap_free_extent(sc->tp, false, fsbno, *aglenp,
+				rs->oinfo->oi_owner);
+		rs->deferred++;
+		return 0;
 	}
 
 	trace_xreap_dispose_free_extent(pag_group(sc->sa.pag), agbno, *aglenp);


