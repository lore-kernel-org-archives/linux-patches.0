Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046094;
	b=nU5irf6SXhrS6pffHrmx3osFUZAVW/sMW/vKTjp37Orxom+usI24vbls1LOyQc0EeXgm
	 OVZVQc5LkcgLwsOHvbMwAjyuhqlc8aNTITpj3Po5OgMBWJoMhkL0c0FyXd0YCLL3EiwZx
	 Z9TbAZH+/qZS/zzJpln/fC/4i0hP0ttAVERySQL8hAsasNimsM56QAwMg/jU6tyNMBF1M
	 VhS/BxQf334fu4spwsC9E0APhxZSh4kqIMRHjIvFraDN5UnrPmgO276za/ME6Z5WHIFK6
	 Po/tbacT5Ny1XhvOfrRibVLM6PemM+O76YqxP81Xsd6lS6tIdpbRpdJ0Jg0zVSpTg3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bjKmKzU2Vo4YfBmr5Y70heP2RPJ4H+UhWtLt0sy7whU=;
	b=P3GZdkx45hape9l+21UpMZtAiqzG6vF0KVMmPvD4C9bZHD8TSPW31tFA3Dj9VB2ZxMlK
	 RAbSaELbj3x1wUHDFHk59Q94o5lYBepA7JKXUODHyKeRYxYQawzSWTEVM8p6fQ3Ehbrdy
	 giFq+8R0DUnszbHgBefFRHMT8P8DgokbHpQbvBsA8sFZMu57t+PYfDuSEzh9EtuAGs3e7
	 ALR2/iLBN7DlMQEaqZFQIZ6X30iSnQPs5ItQ7ULOr+0kkvZ1Y/Wk89jBbcj2ohqTT+PMP
	 t730C1FnupuHuEqxHRvkPEZwnvTZLpvgYG+Xe6Ehcq3QJsIpq3J/Iv1BJDcnDFBvuvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvDRQq3f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89439606A31C;
	Wed, 18 Nov 2026 23:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvDRQq3f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D678C1F000C5;
	Wed, 18 Nov 2026 23:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046094;
	bh=bjKmKzU2Vo4YfBmr5Y70heP2RPJ4H+UhWtLt0sy7whU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvDRQq3fSk+mDGiK+PxJ2PIpPWkiBMUzg6SL+rUpR9lDdiNnyzsAuu0O0JS8qFb8C
	 6BXO/oDoZXzsF3zKE73Lle3N/egLwR5OOMXE8a13d+dL+lreuhdqkcTBmlWwOI/olf
	 j2lddWd7Xt12juwjW/pmrsJyGzGLqAbpoqg9Ed4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1156/2857] xfs: rescan the AGs if incore delalloc counter is negative
Date: Wed, 18 Nov 2026 15:36:30 +0100
Message-ID: <20261118150243.209625729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted the changes to xchk_fscount_count_frextents() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/fscounters.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 88d6961e38866..1f4170bab6908 100644
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



