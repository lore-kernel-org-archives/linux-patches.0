Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034CC54723;
	Fri, 13 Feb 2026 13:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990695; cv=none; b=WKvh24gmB/DAjg0z1GHZBIEExMv+btZY09FJbZUO2s6l2ezzguwOv1vsL7wcAhYnZ+s2gPZgxSLJ1Pl5LzDIg+itrliPKIJf6AOIfk4x3hPN1JsQpAWDaWjJprLJWa1t6lMKxnRQH+4Cu+C4aLjokDSJT4TcSBRGwGbYkCq1w1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990695; c=relaxed/simple;
	bh=Tb8Qvl//ImJDlu+7KVeHrBi2GWZFRv7QiSpH5X0TQqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNuihFtpi8NrvC6aJ7rDyHPQpt7jqu7xAjzyJoD/4HHlpWBB+hwFpou8qpt4Zw7cHJ9wcRQa2UQvP0H9AOaadDPwX5uSQ2kKMVrqiZsGsA2b9j1uPRKGIipjyJZxF97tHHF3p+YW61xUliFhPTsB4J6eKHv5KPyumbaNWmvjXOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSzxk6t8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSzxk6t8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F91C116C6;
	Fri, 13 Feb 2026 13:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990694;
	bh=Tb8Qvl//ImJDlu+7KVeHrBi2GWZFRv7QiSpH5X0TQqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSzxk6t8AijVDOhZNH4o0nzslKgSKw7QdlI31dfaRrHZMr5hTVwRagI6qzyLzB00/
	 Qct718QG1BD0uocv7Y4gyV0RWaU1yn5kL1eBumfBvyQW89SLnvY9q+kHpqKfVSUd1g
	 pypalke+5MZWp8EH4IYgbn1H15JXfz4kMsAJ0Gxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	r772577952@gmail.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.19 46/49] xfs: fix UAF in xchk_btree_check_block_owner
Date: Fri, 13 Feb 2026 14:48:05 +0100
Message-ID: <20260213134710.397968879@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 1c253e11225bc5167217897885b85093e17c2217 upstream.

We cannot dereference bs->cur when trying to determine if bs->cur
aliases bs->sc->sa.{bno,rmap}_cur after the latter has been freed.
Fix this by sampling before type before any freeing could happen.
The correct temporal ordering was broken when we removed xfs_btnum_t.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.9
Fixes: ec793e690f801d ("xfs: remove xfs_btnum_t")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/btree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -370,12 +370,15 @@ xchk_btree_check_block_owner(
 {
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
+	bool			is_bnobt, is_rmapbt;
 	bool			init_sa;
 	int			error = 0;
 
 	if (!bs->cur)
 		return 0;
 
+	is_bnobt = xfs_btree_is_bno(bs->cur->bc_ops);
+	is_rmapbt = xfs_btree_is_rmap(bs->cur->bc_ops);
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
@@ -398,11 +401,11 @@ xchk_btree_check_block_owner(
 	 * have to nullify it (to shut down further block owner checks) if
 	 * self-xref encounters problems.
 	 */
-	if (!bs->sc->sa.bno_cur && xfs_btree_is_bno(bs->cur->bc_ops))
+	if (!bs->sc->sa.bno_cur && is_bnobt)
 		bs->cur = NULL;
 
 	xchk_xref_is_only_owned_by(bs->sc, agbno, 1, bs->oinfo);
-	if (!bs->sc->sa.rmap_cur && xfs_btree_is_rmap(bs->cur->bc_ops))
+	if (!bs->sc->sa.rmap_cur && is_rmapbt)
 		bs->cur = NULL;
 
 out_free:


