Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053107;
	b=tkJ/wsZVd4rJuj7pw8TdAOF3f7um9e/vTtBUaehdjYVO59ZOX3h5o/OhhTMuu9Zwx6hX
	 sXr/9i/Rs5yl53MG1ALXyHFoE4VY28nlpxdvL1E3x92jGc4HsAqAqN6dEVzR/MWJhoyYN
	 +KsigLUpOWYcPvwsDTd8B5csGgOL43LnBEsr72PsgtQDRAhnBh0ob+U+c821vTK3NUXXL
	 7by2iLi/kB+QOBjKmWoT9U1nKN5vAzkBJ/srujDy+kZcR6mQQ3xlLcmR5wIjTBHBRd+VO
	 OZWU+XarrjtAsFiuJvUga0+WUocbOM7E2Y5pnX7YnnmwoVv/rdz9FISgYRYt1KCzKsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fx/jdumlINcU4nM1HwDrgqA4NqM3F7736twtYDuGWgk=;
	b=R+hbtXmNUF6Aa6bfT6JFEEOTgGn1N2VqSg3kma+7oN8lrJ+eJ8G3eBl6fEAb68kqe1cU
	 frvYA0e87bTs7tHr6A2oyjltvtO4/jO9VmVUvcC9ZuqKPsmhLQooQxr85B13d25thEiTx
	 1Mwzrkxjy76uBAeLZsSpuB+6UfdHGfCyg70tHZ8seK9s8gD0qW23uCfHmpBfznwtXhF58
	 9oLaJPMv3UX+D4Be0dmEn/EtGrh4pRbQ05wT+cmQoOtH56CTNuXyG9uniMR5BQOwO175J
	 bFOalw27XMSlJ6HLWvpDkH++O9WUJHmSDlANEU+6MhnMu+2C6dvTyteBWmGDRkA0d8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4woAajl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534F2606A31C;
	Thu, 19 Nov 2026 01:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4woAajl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A061E1F000C4;
	Thu, 19 Nov 2026 01:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053107;
	bh=Fx/jdumlINcU4nM1HwDrgqA4NqM3F7736twtYDuGWgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4woAajlZZxfzkUNwN+jKVnrvMv/53RxTj0ImtaZoW7zXkhkrtCGJffv5UEqEEhYQ
	 hfl3HVQYS3czD7mwEE4nY4wy47o5nElr4NKP5C4OLBr67SBMYMQeFqbVd6uXFVoDn/
	 MklWJfoBsX6b2W34qWkgpaXXfESzFG1FFHGGj2rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0803/2214] xfs: rescan the AGs if incore delalloc counter is negative
Date: Wed, 18 Nov 2026 15:41:19 +0100
Message-ID: <20261118150043.628644730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 47b1e941bb55f735d82ba2649412260da78b98f8 ]

LOLLM complains that percpu_counter_sum can return a negative number but
we instead misinterpret that into a huge unsigned value and do bad
things to fdblocks.  It shouldn't do that, so let's add a retry loop and
an attempt to freeze the filesystem to (hopefully) zero out the incore
delalloc counter.  It probably won't work, but at least failing the
repair beats doing the wrong thing.

Cc: stable@vger.kernel.org # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: omitted the realtime extent counter validation changes in xchk_fscount_count_frextents() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/fscounters.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 037541339d80a..f17912a9cda8d 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -173,7 +173,7 @@ xchk_fscount_aggregate_agcounts(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag;
-	uint64_t		delayed;
+	int64_t			delayed;
 	xfs_agnumber_t		agno;
 	int			tries = 8;
 	int			error = 0;
@@ -233,6 +233,11 @@ xchk_fscount_aggregate_agcounts(
 	 * of the computation.
 	 */
 	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
+	if (delayed < 0) {
+		ASSERT(delayed >= 0);
+		xchk_set_incomplete(sc);
+		return -EFSCORRUPTED;
+	}
 	fsc->fdblocks -= delayed;
 
 	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,
-- 
2.53.0



