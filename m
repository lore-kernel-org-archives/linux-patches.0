Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C360630B53F;
	Thu,  2 Jul 2026 16:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010249; cv=none; b=RHfoeLFBYLrm8LVeEfcmE8YfGOl6MOPI2MoI5Pvz+PZIEi0x44MEJrzdJX5J3zt27AIcLM8+FuYW6HqQQlb3HdbGMuD0A+xdCTXeJJMZFqgmUHNCil4qDFMCv0/Xdb6QsFMUvxfjggr3noNVgWcgPxvNdJWfL4jvIFQgcF3IHzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010249; c=relaxed/simple;
	bh=fDIJoi2+7uoDgmY6dw9njX0ldk5QDGfPldzHqqZpnJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCQFGvIzoWUNl5oX4gf3xWQ7jnIh9wbpHrXdwZ9JEJYXkG7yhS1k2avvluc+nnFcGsySLedDd87azhzj2B2i7ZgezyflrMZGOU7kkGs/18qWyjkVycBOwTTHrXXW0kLXUpuO5VvHuy8vsDvpSCLXFwJRooITpHfAuBAVqJZ2tFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsdZVv+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsdZVv+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DD1F00A3D;
	Thu,  2 Jul 2026 16:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010248;
	bh=0GgpWAwopPFuHs+ja5TRhpPY+8Z3QcsIv/mv8kO0EuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CsdZVv+WaYmgeMWLEiFbiK/Nv1S22MIinpJ9xLpAzkX0L3pN9yLbGj42n7V4zVmqc
	 njj8O3EgLprr3PDTkxKSlVflSdSsAsJ6iHWV62OZYHSG/VDQEtd+3uC34K2Gl88yHy
	 pLpZehytfRN5NY3q7gpBklJNcX2jMW1ejxflMdRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/204] xfs: fix error returns in CoW fork repair
Date: Thu,  2 Jul 2026 18:18:14 +0200
Message-ID: <20260702155119.433914657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Gao <gaoyingjie@uniontech.com>

[ Upstream commit fcf4faba9f986b3bb528da11913c9ec5d6e8f689 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/cow_repair.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -297,18 +297,15 @@ xrep_cow_find_bad(
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


