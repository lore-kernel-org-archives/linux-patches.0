Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0CE3C0628;
	Tue, 16 Jun 2026 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625766; cv=none; b=qHycQhuhDiw9NAGYJrHR4bR68/waQLUtmS8EEretluKbzpDfrsuwvZmlexyt9hAOstH9lZ2EIJWGNtQb1Nz1NygxGqD9DYAZQB6Fg7Y49lYNwCJCrT9Z+t9Mfjze4Rr4BVNqUk/hPMvJcIFBRN1D3OFv4AUOczy2z9HIb3BLz9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625766; c=relaxed/simple;
	bh=/hsWOz/EtFP2I9O7EwZY/PBNuIpV5q/OS4/Yg5uvuTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObVTcAEqQ/xVsOicYk6R19NaN0JUvzFIGJpn3geCSv6CQ7qQOFqZ9BYQgdYrSaSSgUKa5d0hBVRXCyUovOL1myKhar+fNBZ9WE+iCcZKsqPTQhfh+XnXE6PEtZvZD6cOIY8zofcKztag+1t45V+PguGDft8Mfhvc4LmqHkCRUvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4ZZyv6P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4ZZyv6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7611F000E9;
	Tue, 16 Jun 2026 16:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625765;
	bh=i9NsskHsoggPLLdn6JjpTg0DQKlV+wVaPdjD4AG1BbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4ZZyv6PCfEL1+Bka1hRB5V74MO61sqCq1Uw8qwkMpnLfzmlWiUwECGhsP2ogbMqS
	 IWHX6I4Oc/9Es/YpEONf5KMzY6247PfFNO7S6tp4wnwM6yZijmm4L2AQ4A+Es5Krfu
	 m0djb5whAwIQza2lSNTiY2sQD2kuXMSBNqDCyhys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 203/325] xfs: fix error returns in CoW fork repair
Date: Tue, 16 Jun 2026 20:29:59 +0530
Message-ID: <20260616145108.136245445@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Yingjie Gao <gaoyingjie@uniontech.com>

commit fcf4faba9f986b3bb528da11913c9ec5d6e8f689 upstream.

xrep_cow_find_bad() returns success after the cleanup labels even if
AG setup, btree queries, or bitmap updates failed. This can make
repair continue with an incomplete bad-file-offset bitmap instead of
stopping at the original error.

The force-rebuild path has a related cleanup problem. If
xrep_cow_mark_file_range() fails, the function returns directly and
skips the scrub AG context and perag cleanup.

Let the force-rebuild path fall through to the existing cleanup code
and return the saved error after cleanup.

Fixes: dbbdbd008632 ("xfs: repair problems in CoW forks")
Cc: <stable@vger.kernel.org> # v6.8
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/cow_repair.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -300,18 +300,15 @@ xrep_cow_find_bad(
 	 * on the debugging knob, replace everything in the CoW fork.
 	 */
 	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
-	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
+	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
-		if (error)
-			return error;
-	}
 
 out_sa:
 	xchk_ag_free(sc, &sc->sa);
 out_pag:
 	xfs_perag_put(pag);
-	return 0;
+	return error;
 }
 
 /*


