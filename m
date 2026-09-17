Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0F14B7A29;
	Thu, 17 Sep 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666628; cv=none; b=kEfV9+8XDbE49oQY8fsRD0v6S2kDHBABo6l41G4Cx9+SPLAIH7E1AYl6ykz8arEnAO9LbflNhhrs5WMSM/TO+qtFlLx5uUClFtj3WrQ+foxKpLxDYA4E1Wg/ej/svH3EdffiikKRO+HRiqIkDe2eBzflqWyAcxvvCTtgOdYi/1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666628; c=relaxed/simple;
	bh=DaE2kfjS++taM139r1csZ3gj5bUYj1nTW7FEgKGt9Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPX14vU9afP1Scc5kxhcSkArmJCHWAEJne3qM6lBzzbAZCBEKIsvFjwcvfZRZJ1r4GH8KbyjOp1OCNXCgHBc5h58oiSlwRv0jBlLWGCLqS16ZnMY6fX4En7zwA4rTLQX90cT/j6S/Nt8tLJMurmjwljXOEaaVC+07w8j3oDACPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znba4xtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znba4xtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AD81F000FF;
	Thu, 17 Sep 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666626;
	bh=w3M+f5zNJQIrxXeIeEIYMlOPDn5hotglj86XYM3bJ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znba4xttGScgAR1ZDRxttww5npk2YSHl5hYmRr1yg1e/IAH490S7qBAaXpMbAfI4U
	 z+ZVMITngYwleYLLKdLdsAxRFOeVX5kc41o5rxlZ8qsRfLySkNzy1UM8yIf9vgzePz
	 NJX/OLebWwIU0uDmol3p+yIuFPPVdvevrYekwJ+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1099/1250] xfs: make the rtsummary repair fix the file size too
Date: Thu, 17 Sep 2026 16:14:54 +0100
Message-ID: <20260917151621.967470047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

commit 6b760b3232b3efc8bcc7c165e76300bc1c9140c5 upstream.

LOLLM noticed that the rtsummary repair code will create a new rtsummary
with the correct file size, but it won't force the new file size to be
set on the existing rtsummary file, leaving the rtsummary corrupt.  Fix
this by setting up the tempfile mapping-exchange to run to the end of
both files, which is the magic offset needed to reset the file size.

Cc: stable@vger.kernel.org # v6.10
Fixes: abf039e2e4afde ("xfs: online repair of realtime summaries")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtsummary_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -164,9 +164,10 @@ xrep_rtsummary(
 	/*
 	 * Now exchange the contents.  Nothing in repair uses the temporary
 	 * buffer, so we can reuse it for the tempfile exchrange information.
+	 * Use XFS_MAX_FILEOFF here so that we correct the rtsummary file size.
 	 */
 	error = xrep_tempexch_trans_reserve(sc, XFS_DATA_FORK, 0,
-			rts->rsumblocks, &rts->tempexch);
+			XFS_MAX_FILEOFF, &rts->tempexch);
 	if (error)
 		return error;
 


