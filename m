Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828972;
	b=kBzIAaqLDGEla/cA1uXlFcVErEobvkvj3ygzx/DW5hoDWaOx99x1SHi4+IPlCYlNXLW4
	 q1tJjbjAU+pvYgUAEqdu4UyMKtJRUZuIEI+Bk9efNyO6MPJp4gH56fHHQDydoPaFHCb05
	 MlOEanKKoqsLiC+dnLg00QI+qLYDXgVT1WjR8y1qVllHgyWQaq6qsCeRydh68Jq44JqWI
	 lhiWyNQplSYvbctKYZ+RPf1V3ExrxvJO1tHIM9Am/Rqc64nJNxFAETUJxencKymE6Od4K
	 PFwNyLqpQf/fA9/AMUDsLqAxuTuod3ZBkCfTj/8IfT0V1fyluyuh/5Y5oEzZObPUsuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aiY6D+ExFTivmUKwHkjKMtMj8icC4b3AWeHrpUruX8Y=;
	b=jsypl8I6W+g9DacBNktHDpXPzJ29vfLZxRuCqsJmd50szZlCffvilzQ4sYg4TkB3oH8t
	 aaM/f/wqHjxpTQjOl6GlT3Bj1UTWNhFApvSjqXxgdKM4PjpuLGjyVE4rxMdEtOs03U5U1
	 NcHAv5NtEWcdWCc3/qa4H3ltDSd9kXct67HlV7BDEszhq44Y9L079dZxsHDRgf7oBIYRh
	 6dbXniWqIaTg10mcvqMH3y2hHTbBq7iiqxuFErz2t/LHmppQSr+0mSPtpDPwUXqUoaf9C
	 HgVcug5jZNodt+I8kIqV1Nsi46HsnJSQXxCqZmRsVYFJwRL4D7bs9drUzPNJ22vzGmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WkbyvAa5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237B8607E926;
	Wed,  4 Nov 2026 21:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WkbyvAa5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4C21F000C1;
	Wed,  4 Nov 2026 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828971;
	bh=aiY6D+ExFTivmUKwHkjKMtMj8icC4b3AWeHrpUruX8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkbyvAa5G7E3zBK+xTmVJK9OTKEgKpCCIgi3ToCGPNiNSk8Wg0Fz7JP36LawxjuhH
	 igsjO5X5eYEfJSsloOyVkTIRRECnXJvjk2VgjNa+DIPZKkwPVHf8eom6MXGb+1MAEF
	 WE6bFpJ8HMXsgFrMuFPatJjDG4x+oPXzYeNgCrzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 362/547] xfs: dont subtract excess usage twice when computing agf_btreeblks
Date: Wed,  4 Nov 2026 16:09:06 -0500
Message-ID: <20261104211048.576129049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 4439b626fb5104204952aa2f169451688fb6be26 upstream.

LOLLM noticed that the free space btree repair code calculates
agf_btreeblks from the number of blocks we wrote to rebuild the free
space btrees (minus the roots).  That's correct.  However, it observes
that we subtract the "excess" reservation, which is not correct.  Fix
this accounting problem.

Cc: stable@vger.kernel.org # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc_repair.c |    6 +-----
 fs/xfs/scrub/newbt.c        |   13 -------------
 fs/xfs/scrub/newbt.h        |    1 -
 3 files changed, 1 insertion(+), 19 deletions(-)

--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -663,15 +663,11 @@ xrep_abt_reset_counters(
 
 	/*
 	 * Compute the contribution to agf_btreeblks for the new free space
-	 * btrees.  This is the computed btree size minus anything we didn't
-	 * use.
+	 * btrees.  This is the computed btree size minus the root block.
 	 */
 	freesp_btreeblks += ra->new_bnobt.bload.nr_blocks - 1;
 	freesp_btreeblks += ra->new_cntbt.bload.nr_blocks - 1;
 
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_bnobt);
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_cntbt);
-
 	/*
 	 * The AGF header contains extra information related to the free space
 	 * btrees, so we must update those fields here.
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -598,16 +598,3 @@ xrep_newbt_claim_block(
 	/* Relog all the EFIs. */
 	return xrep_defer_finish(xnr->sc);
 }
-
-/* How many reserved blocks are unused? */
-unsigned int
-xrep_newbt_unused_blocks(
-	struct xrep_newbt	*xnr)
-{
-	struct xrep_newbt_resv	*resv;
-	unsigned int		unused = 0;
-
-	list_for_each_entry(resv, &xnr->resv_list, list)
-		unused += resv->len - resv->used;
-	return unused;
-}
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -71,6 +71,5 @@ void xrep_newbt_cancel(struct xrep_newbt
 int xrep_newbt_commit(struct xrep_newbt *xnr);
 int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xnr,
 		union xfs_btree_ptr *ptr);
-unsigned int xrep_newbt_unused_blocks(struct xrep_newbt *xnr);
 
 #endif /* __XFS_SCRUB_NEWBT_H__ */


