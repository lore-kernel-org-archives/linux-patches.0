Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590874;
	b=zWn8/1WyMky7bKqx96GBSZo+rGKnFahmdABy481p+480jXm2TAOonNXv7WlROJad5X68
	 ZcRG1bEgfCdh1xgovhi3teCfr4swVBU6C+w4DqaHTg3SHrbBjNSrpWj9hJGT4vLdVBUT6
	 r3Ow4FfY3pKxYuhflX6qrDGW77kkrwI6Lf7DTvOLqisDdLze++nqggY6Qy7xk/+ZMH/Qq
	 gM9GXHjMPCi9IGeNT1CeySjr9DrTvKQUO37/y1kDUH09V7FItLa/DNw+ElaSN2nuyllQk
	 cgtEIF0TjMShPf585B0SYGK9W2IcYK/Y02WPtwQrjIZKqBOg0u3okEKzgDza1Apb62g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qQzr+pMs4GuoDFx+7EUtLqqsaogErzKKRMOdiIM3w6I=;
	b=eSMxP4Rs8LTxGoiCHSFoQkJm0kqn7LNkTgvv1vg14zH6+tiAaVlOCPsTB6+YKLO0ReYZ
	 CegiaJQgaAaLmaLV+erQrC5IoXkZQfKGpepivMnPVeejyLGFJmUdxd2dWgd5sb+7UhMR7
	 cbc1x9onHBbM2Q9AfY0Bo0jrILTad/OPd492wJ64vpvSn9rTRBvbX0gvyXsID2fmNctau
	 530RGZPvEHjCJm7ORcD4aYaUX6PygCKZ8OXN98pQYa1pCkYPqLGGRI9Kt/1Vzv8vaMLOo
	 2NoTaWr7vEPuU8+dWV162+VQBJn1wuWHLJFIfd97K7HG1YV9EOT1A37HVALhQz687ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIC9RjN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243DF606D4A9;
	Fri, 13 Nov 2026 17:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIC9RjN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45491F000C4;
	Fri, 13 Nov 2026 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590874;
	bh=qQzr+pMs4GuoDFx+7EUtLqqsaogErzKKRMOdiIM3w6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIC9RjN8sefcM5DBTyk3IHMRKV8nHSmlBG4zxd7uMefSfP7i97noWBtFz3vgg8dVd
	 qgE1DTQVq+W9WFWzWy8zwMgsw1T2nHp+8GkaWy2Yj3IXLsicmv/9cwTDxhuGQkXIw/
	 XahsYnoPaMml0rpg3Tq86nAnkVYM0RTBQPOGBVTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/670] xfs: rescan the AGs if incore delalloc counter is negative
Date: Fri, 13 Nov 2026 10:43:55 -0500
Message-ID: <20261113153813.949670965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Changed the realtime error return to goto out_unlock because the bitmap lock is still held. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/fscounters.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index ac7e6329e46e8..ad23343c52f71 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -296,7 +296,7 @@ xchk_fscount_aggregate_agcounts(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag;
-	uint64_t		delayed;
+	int64_t			delayed;
 	xfs_agnumber_t		agno;
 	int			tries = 8;
 	int			error = 0;
@@ -359,6 +359,11 @@ xchk_fscount_aggregate_agcounts(
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
@@ -416,6 +421,7 @@ xchk_fscount_count_frextents(
 	struct xchk_fscounters	*fsc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	int64_t			delayed;
 	int			error;
 
 	fsc->frextents = 0;
@@ -431,7 +437,14 @@ xchk_fscount_count_frextents(
 		goto out_unlock;
 	}
 
-	fsc->frextents_delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
+	delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
+	if (delayed < 0) {
+		ASSERT(delayed >= 0);
+		xchk_set_incomplete(sc);
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
+	fsc->frextents_delayed = delayed;
 
 out_unlock:
 	xfs_rtbitmap_unlock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
-- 
2.53.0



