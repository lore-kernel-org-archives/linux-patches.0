Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E7D3C0628;
	Tue, 16 Jun 2026 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625772; cv=none; b=arAlSD7EAItFVLQR6CRdAe3RtQoFr0QCyFbV1d5TpgMo7m39ZGN3rI9Y9LW9dtHzCWv+fgARAgR/7V/rYLuaxJxtvY4Wnl37tTxImilwWCkGWPUhgK75npWSn6boQ1E+c6nxhbvFWF/kQyA3/HcqLAkjMaSjmdHItPnRZ8HEww8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625772; c=relaxed/simple;
	bh=E/v0iZXqO5GHrjQXdjVpG+HwwnPdyfZ8ubIPWdQ1pC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRC/K0rM6AiBx3f4qWGr4nZSaLlZmc+K8c9zfNUPiMHJdKDUzRHP6xlGJIP6WPAJ5v+j5kVfLcxzc46M5Qf7fGmOykTtJYGcqYB9rX9DvQl7O60JhH6HRfpmhpw9iO2IPj1/OdrKMlJE5p4OM1AvAWmsvqpCWkw6luOY7yoizu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTQIrska; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTQIrska"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448C61F000E9;
	Tue, 16 Jun 2026 16:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625771;
	bh=4PM1OT3VUcYiPAXDrEXeKzEFet49MgxOZOlAcZ0kLCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTQIrska0zDA+iv+IRI3Ri+64v1eSeq9Tp9rZc3SL7bGnLodYfE2cXzzo1JTQ1DKQ
	 TS4A5gP1isOru7TUUb9v2FZL2xQZ3b5jjbuDCFyWf/RC25ydcBXDIStf7xVxgx1e/V
	 6Uh65b6LaiSTU4gZvlPN4zd6ArwOkqsnwnhdpsGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Gao <gaoyingjie@uniontech.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 204/325] xfs: fix rtgroup cleanup in CoW fork repair
Date: Tue, 16 Jun 2026 20:30:00 +0530
Message-ID: <20260616145108.198055186@linuxfoundation.org>
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

commit c3e073894379532c00cca7ba5762e18fafe29da8 upstream.

xrep_cow_find_bad_rt() initializes scrub rtgroup state before the
force-rebuild path calls xrep_cow_mark_file_range(). If that call
fails, the code jumps directly to out_rtg, which skips the scrub
rtgroup cleanup and only drops the local rtgroup reference.

Remove the unnecessary jump so the function falls through to out_sr,
ensuring the realtime cursors, lock state, and sr->rtg reference are
released before returning.

Fixes: fd97fe111208 ("xfs: fix CoW forks for realtime files")
Cc: <stable@vger.kernel.org> # v6.14
Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/cow_repair.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -382,12 +382,9 @@ xrep_cow_find_bad_rt(
 	 * CoW fork and then scan for staging extents in the refcountbt.
 	 */
 	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
-	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
+	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
 		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
 				xc->irec.br_blockcount);
-		if (error)
-			goto out_rtg;
-	}
 
 out_sr:
 	xchk_rtgroup_btcur_free(&sc->sr);


