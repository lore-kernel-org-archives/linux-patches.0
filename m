Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828957;
	b=s6qSbPjRcB4xXTg2t042w69SJSaWVQVPSGsL2unkYE6T4SmY0JS7lejakoW6MiqfHmf1
	 wu9LqAqpU0PC9pKhFG+FQ1/YyoSRdfQyWNjDiWkFZV9vde0IAJUNzqSoR7M+58g1hkhvO
	 hoh8yWxo/x9LnCJyj4jT0fp8iIRrww3f1gfoiOyYpWAUiIxFr3RVt/2KclV/NYf+sD00y
	 93rhzssN0wRs+j7aDPpAxqpdgjUL8sakZg0IMuAT2RWoDktuP/XEcmfYSx34gZB5pC4mR
	 hn+VMVig1bUoq+05nnhAKx0KjbiBwXysJHsBk38LHVr1tCPFfqkSVURjkKEsOCEQS3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BhqC9kKFuNSyUytSEDgl1WjKxYFBs/CZ6M6wKG/g0lw=;
	b=ppXcubNMv9uaybKetgWMqJKUsdLF0ceuMNJDP6C4fFoKFvCHR2d7QM6bXyh4jyGpPo2X
	 fZsaO3JDXEdtPdUpGDAYOskovVURHOYfZJV6vNeNQFNYk8zhSXfEqnEFt69jPlzkYY/n3
	 q017CBj9ZF1izSEoSvjefzwcxfwfLImpNt+ArIa320rE5S5M/8DxBd6x7PZssRx5OvtH1
	 lMsnN+eZxwjFmKhZjpTCBel9NOMMaPphm+Ni/RRqwJ2coa8dUPGxHIwoXjnLpcZ/ZCFzp
	 suIb0qEMAuK+26uWz4l4n6pTsVAcrk4kpkGMVVrzrTAs4J4Z+RfXzaIybrPxy2sXNHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+kgNjPp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041E607E4B6;
	Wed,  4 Nov 2026 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d+kgNjPp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914511F00A02;
	Wed,  4 Nov 2026 21:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828956;
	bh=BhqC9kKFuNSyUytSEDgl1WjKxYFBs/CZ6M6wKG/g0lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+kgNjPpW04o/PQSzOQrStAPkuJ6+lcUC2hbtmKg34JGpBtfCkyb88b+bvfGPWlkt
	 PcwWonlAgEgbHxO2pe1dqP0Uax09t6Uvb3r6/Yo4NR14yNtVSw9boyYWLJ9lJjO7TY
	 fMUjHObDDPITTnx8nu7spW9LezwrESd3xucI2aPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 312/547] xfs: always reset incore attr fork buffer when resetting fork
Date: Wed,  4 Nov 2026 16:08:16 -0500
Message-ID: <20261104211047.077309712@linuxfoundation.org>
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

commit 71cb13685e72a3c5d118732559c727a0c9090b7f upstream.

LOLLM noticed that the local format attr fork verifier depends on
if_bytes being set correctly.  However, the fork reset function doesn't
reset that correctly, which can cause post-repair verifier failures.
Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -840,11 +840,11 @@ xrep_xattr_full_reset(
 
 		ASSERT(ifp->if_bytes == 0);
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-		xfs_idata_realloc(sc->tempip, sizeof(*hdr), XFS_ATTR_FORK);
 	}
 
 	/* Reinitialize the attr fork to an empty shortform structure. */
-	hdr = ifp->if_data;
+	hdr = xfs_idata_realloc(sc->tempip,
+			(int64_t)sizeof(*hdr) - ifp->if_bytes, XFS_ATTR_FORK);
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->totsize = cpu_to_be16(sizeof(*hdr));
 	xfs_trans_log_inode(sc->tp, sc->tempip, XFS_ILOG_CORE | XFS_ILOG_ADATA);


