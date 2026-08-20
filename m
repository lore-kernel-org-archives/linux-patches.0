Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA737CD28;
	Thu, 20 Aug 2026 15:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239001; cv=none; b=SX+cRSO5RAMhzsfsUKlngCzFO1z5AautjeQ9Qk+K85MRCL6maDNleFwK5ThktmHHp4TkCcDaGTpvd1Ex1md44XG57mrq5AzM35zsT13T+j49LlnZQG2hcMJyIeDv1fb8dx4freo2400lUYoNppe5WLARNTUUyH3eKVBykV5C8NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239001; c=relaxed/simple;
	bh=FG+lDx6dTZepa/Zqs7rideZFyPWp+Gp5HLpuIMxuoq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlmSYS6F2ik2ipIgxCQhQbQJ7Svk8kYZPPQxvd6TUFYR7h/JrW1F33LI3wdEIDbpn24fvgSwMCXPw4MxNoaEuQc5wwe4xkP+3WVRrMrjM669vzQDkfnZmeFnkrf2NrkIL0rX4TLqalGHDEPRfzCHpqj0Dk2PxLQsruwVe8XolmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4lCa9fL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4lCa9fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72D71F000E9;
	Thu, 20 Aug 2026 15:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239000;
	bh=FSG//pep2FC7HNbt9ZgK05OPDpnkmr3f62tTWKtLM8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4lCa9fLA1oDNVOBIuPUEf8gmV7iBIK/ZbT3jlcLL5lzxNT4Vw3Mgpe6PDvEGnk/E
	 KUJanOF9LLq1oA9LE7Xub4nUCMKdT2a83XSI4kS2upWQNZ1SxZ7n34VyjvXnWo8aGi
	 s0wxcxfoCxUBwFT9vFEpJSyJcYDpDhXL9J1KCz6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 114/217] xfs: pass runtime errors from xrep_iunlink_mark_ondisk_rec up to callers
Date: Thu, 20 Aug 2026 16:54:42 +0200
Message-ID: <20260820145241.171501427@linuxfoundation.org>
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

commit 5644fab990fc72406dddc91cbb8304659d77f3f1 upstream.

LOLLM points out that the only error that xrep_iunlink_mark_ondisk_rec
returns is ENOMEM, but we ignore that, and can end up writing a garbage
AGI based on incomplete information.  We shouldn't do that, though here
we must be screen out EFSCORRUPTED/EFSBASDCRC because we haven't
checked the inobt yet.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1302,7 +1302,7 @@ xrep_iunlink_mark_ondisk_rec(
  * iunlink_bmp.   We haven't checked the inobt yet, so we don't error out if
  * the btree is corrupt.
  */
-STATIC void
+STATIC int
 xrep_iunlink_mark_ondisk(
 	struct xrep_agi		*ragi)
 {
@@ -1314,6 +1314,14 @@ xrep_iunlink_mark_ondisk(
 	cur = xfs_inobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
 	error = xfs_btree_query_all(cur, xrep_iunlink_mark_ondisk_rec, ragi);
 	xfs_btree_del_cursor(cur, error);
+
+	/*
+	 * Don't proceed if we couldn't set a bit in the bitmap.  All other
+	 * errors we ignore because we haven't actually checked the inobt yet.
+	 */
+	if (error == -ENOMEM)
+		return -ENOMEM;
+	return 0;
 }
 
 /*
@@ -1505,7 +1513,9 @@ xrep_iunlink_rebuild_buckets(
 	 * If there are ondisk inodes that are unlinked and are not been loaded
 	 * into cache, record them in iunlink_bmp.
 	 */
-	xrep_iunlink_mark_ondisk(ragi);
+	error = xrep_iunlink_mark_ondisk(ragi);
+	if (error)
+		return error;
 
 	/*
 	 * Walk each iunlink bucket to (re)construct as much of the incore list


