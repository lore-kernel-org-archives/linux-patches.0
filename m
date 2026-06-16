Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0CF44103D;
	Tue, 16 Jun 2026 15:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623914; cv=none; b=UgSnZjQ/RNp0fbsyDjUgHfNQcSO83E0LiEcfIMlEtQGAz021oZJsM+1R+fSqcKJkGr5J3LwfjUXHxGBPHdzGsHB6Jz+zBuiHWdQKP7siFM6fRus7tG0jm52amA3/d22QK6Drz2xWRADZRJPWpH9ntCHoR4TPo2pmB185goH8msY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623914; c=relaxed/simple;
	bh=ZzjKRm90K0GJtbgcXM1Djoq1i6NpH0ZMDVAY+/fmecI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKpolJH7T0L/itVl7BIXZdBlVP7BNIcFT2bfZdxvUgD7WhCG9QpxxMrkXTak4xf529JOVpAOTGPt+36v+lpG4AM52Z4lIski16tHYWie4S04WzbwGxz4O4LuGXZSTTXpxkoBF71IymNFguG+qXuqyP6f3e0RmjjGHgqpu1LKeUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKrknRvu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKrknRvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6C21F000E9;
	Tue, 16 Jun 2026 15:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623913;
	bh=GuCQQf6fun15hKBAAiEK/ME9J0MAzLrrO+MY5EbWY9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKrknRvu01DU8MAB2BRy0/Vkt1n4391r4Bn1bubcaF6FV68ygL9FlfFFFNkYpDe7s
	 VjooBb7+zBPxb4/z68Q3RmWpBNEkkMb7pgvCJXSTnCO2JeF/7lJfyM5Abp6DsblucI
	 iuRxRp8UuYMjAE91HnXUYZtKD6c0KRSCuokMb958=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.0 240/378] xfs: fix error returns in CoW fork repair
Date: Tue, 16 Jun 2026 20:27:51 +0530
Message-ID: <20260616145122.853628169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


