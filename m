Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831649;
	b=vcMpD/mRJgnAHx3dsSa+uSaXCoy58K4I+nukPERBd9WYlTseHAjoRNjUE/azPzSoHJ94
	 CKOn9LFKXz7CsfrUsH/Tjr+U3rQjRrrV01S8wBaAGyMUwom3dCyRq47V5LpQBr0FK4s2r
	 cIntYwEeRry5b5sM/sBWY20e1FbFxl3pexp455fFPvSl664rR/TuSr7BRGbL67lHq0jeq
	 27CsFFoLqgjidXhoOBe0J7bV/zFSrAN0t8zxviBUSCWUvkWVqW/wXiSEwci0zA5HFfBvV
	 mM6CropMubf7TX0dH3Wbz17fAvgntDjUreoTYg9ff+H/FKa2TDMRd0IdoOGfAzvaPGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x+NSh1xjQzSxuwGcvfXL3QT5JPWbj3WQ0TsbdmjMGz0=;
	b=45T5iAgsAaom1rfvzkVdxotl5JlhzlZyHgGpo3jxLQ1WiVBwUkptNV2Oy/dGiZSUg+QN
	 tuAmRNzZn9MYlysn/YMnwUqhWyZDCYiYEiomeq0YzM6lz7doG1BbmRoqmT7HjdpzRDtIy
	 MaUxvKrTU4HjG/4nXwuXA8CnRXSMVUiK2rRKIAk87+tBW2EKTgR+Mvsef9l7zxoh8KeYH
	 nc+hM1U9U98n1GdXDUrb2M6kTeF/+jiNVqQNZyPqnc9A8t0c9oKNPF2BT2sqWCf5IQqMX
	 IgmhKYZ1gZdDpOT6desT9aoSZ1pZumiH/Ro8qoJQ6q6/UZ7gM5iGPmf96x3odd2djxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0MiHMhN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC7C606B2E7;
	Wed,  4 Nov 2026 22:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0MiHMhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48101F000C1;
	Wed,  4 Nov 2026 22:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831649;
	bh=x+NSh1xjQzSxuwGcvfXL3QT5JPWbj3WQ0TsbdmjMGz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0MiHMhNy0JtpziwANPwT8arEqQGlAmznApiJfzGHwrS04EGb/w7+fkUpiwtDzdyc
	 DJL+PGDCySccoMUbH/AChzU0BAP+ZyiteuaeuOMd18Oxr/tRoNfg1ii8tbosXbYMzJ
	 fkhqjRThBWyOqDjS4gGcyexHVynbd+4nr06AHkfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0832/1005] xfs: rescan the AGs if incore delalloc counter is negative
Date: Wed,  4 Nov 2026 16:09:25 -0500
Message-ID: <20261104211106.633463206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


