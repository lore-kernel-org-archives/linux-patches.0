Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828943;
	b=HYTELSpyJno7ad1pHVOTuKFUTEwrwP/nF1TA5oYXPN/7wRhNNhLNfTgr0OUbEoJdBFov
	 4dvNbgRCTxiT08WM5GWkWrncYx2i2nC4SHFjQds5WscjXvWs4pzqS1Zl5WhE01qDEwHyQ
	 6B6IiAVdUBr4PWKIGHhWWjMpWXZd5IL7CmOIhcPYK/JnlkHn99bzMW1+2Ln+stGTG9eC9
	 FJgnWWx1SfD1s3wPfQ3BvqVz0W+gfeHA5VyrH1o9L5GoiYyRfvPVd9t2S3Yq5jaAlxEAt
	 X0PAFuaPSqp99vYs/L0Mj+F/BsahlwHi4i5ffynTez/C5Un/Q0hKflCuFw5y14HxrSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QmZkgHrl6NNccs15kJ47LOdRLNOEefT04lh3Vk0vWwc=;
	b=WzzRry9iDmXbJ3PG5bNAd5dbwRT49ErxIdU4rFn/R9iZ8lfLvcyMCzdTO2cvo6Fbec82
	 KL4IbeBIhttVsKitfAV7QKlRflBD6SBz+MTEAFrKVL/izC3tnQys9At/2VY8yWiukR3vd
	 ia0LkQuG0VKmvZ0JbeIk678bx4RwqtY3Z8tFRCde+D0AtwPtp+mBbfzC4bJLUf6yjC6wL
	 FEI+5vXoPZNJtNr8LkfUfwFOkU204UFgpMxmXxNaXefUiGQQohJ253tddp+8lhOnQsr7r
	 22DKkGQe4ag+bwZtgdygF7hSMfZQRAWk0C26Ps8tctENmLYsaqBoiMAQYmMyUjhf57w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k+Ga9HLs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB60607E490;
	Wed,  4 Nov 2026 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k+Ga9HLs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7811F00919;
	Wed,  4 Nov 2026 21:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828943;
	bh=QmZkgHrl6NNccs15kJ47LOdRLNOEefT04lh3Vk0vWwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k+Ga9HLsnHBHSTLEgUdTTA8iUaBciXZ/1xp5ycRj14f1/R9/bE0BsE8f53+E35wSv
	 F1drEW9qLcq7FIoP54oF9TOg1l2SQFHjnJezZlFqioVZkBc2oTxQPFOJmT+2unMm4X
	 YsZHKLgWUBBDYpDjItWLToF9+Q0rMxE4UQ933dk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 341/547] xfs: rescan the AGs if incore delalloc counter is negative
Date: Wed,  4 Nov 2026 16:08:45 -0500
Message-ID: <20261104211047.918038515@linuxfoundation.org>
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

commit 47b1e941bb55f735d82ba2649412260da78b98f8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/fscounters.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -297,7 +297,7 @@ xchk_fscount_aggregate_agcounts(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag = NULL;
-	uint64_t		delayed;
+	int64_t			delayed;
 	int			tries = 8;
 	int			error = 0;
 
@@ -359,6 +359,11 @@ retry:
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
@@ -412,6 +417,7 @@ xchk_fscount_count_frextents(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_rtgroup	*rtg = NULL;
+	int64_t			delayed;
 	int			error;
 
 	fsc->frextents = 0;
@@ -437,7 +443,14 @@ xchk_fscount_count_frextents(
 		}
 	}
 
-	fsc->frextents_delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
+	delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
+	if (delayed < 0) {
+		ASSERT(delayed >= 0);
+		xchk_set_incomplete(sc);
+		return -EFSCORRUPTED;
+	}
+	fsc->frextents_delayed = delayed;
+
 	return 0;
 }
 #else


