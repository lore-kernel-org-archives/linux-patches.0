Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829039;
	b=y/R3cSaALaWltTcBVH+k30VxYK5VDvcu9f5E/0kMDhMdK8onymwYaQP0uqPqxw+xz0h8
	 6bUn/lbKOsh8jvrh1r5mmbSl3O2iQ164YyKVD2twmD2BXjZNei+ALEX1EZm/KdtlrpstG
	 VA/gAOdMlRBLV4wLsLtxNWhy/adhBPrBBFGlHOGwqx6sU450sO+6Xgw+Da1ocDPEhblr+
	 ycdD/L5XIWfkcNf02d9tsWxnl5gN/Zc+GIgkw4Mp6X3qvjpdNRLc8AHQXNWtMPhDsGt39
	 6IVlaUh1F5roPIxLokeTFKf433LweeQwRYympUQYhm/S0rnj4EcOOLHoj6Dz2iz1G2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HOr+A3W1vyEWgFT9Buq2m6S5GqjPsQdv5HMup8VxZ5Q=;
	b=IY2pa1svuNaW2FMDJ0/C/YyHiAvWesDojca9+tKYz5zwR3AaAKB9R4ogOyFt7hyVpPOX
	 LGcuWBJKwbnnRR8qoewNy9m3dwfqoPUNitGnfKuio/8QEdWrrHO9DigQVnfsTm7PShZcA
	 VgA/6S12QWgsk3hXramnj2298AOH/i3ZZcAiEbSZl/VRam0CawZZ4gVxdn/rYfsiGXTCL
	 wc6Bd8Tu7XkcT/rJ7x1hdufdz9EV9rmObbMobyI4ui0Cv05TkPjkn4aAMB5cUKs5re9fI
	 m0Maw6mBx3QbrCGaGaVydMytzM98BcQDYuhhZZXXOKcFEMYRK9dthOyoOZ6LsG1VYbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WGK5p1OU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC31D6070764;
	Wed,  4 Nov 2026 21:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WGK5p1OU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240E01F000C1;
	Wed,  4 Nov 2026 21:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829038;
	bh=HOr+A3W1vyEWgFT9Buq2m6S5GqjPsQdv5HMup8VxZ5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGK5p1OUzIXO9x6ragNevFaBfj1QqE9SHbgdYulX046bvCJ+RlyZq3nTVnFKtiwWK
	 pNdBDochGJelaOTw7tVrHA+hWVbnTEKc1ncKTl48MjBIe1rdxpMdRMdwkyKb4P74Ln
	 yJ8bWqMFNXr2UE25ECL3Ga7vnsnutlahko6k8A9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 405/547] NFSv4/flexfiles: Bound page coalescing on the absolute stripe offset
Date: Wed,  4 Nov 2026 16:09:49 -0500
Message-ID: <20261104211049.822344546@linuxfoundation.org>
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

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit a84c62c4f03706b2c2f01dcc5fe614a4233ee75d upstream.

ff_layout_pg_test() was copied from the files layout, which partitions
data servers relative to pattern_offset and bounds coalescing with a
segment-relative offset.  Flexfiles has no pattern_offset:
nfs4_ff_layout_calc_dss_id() partitions on the absolute file offset
(RFC 8435 Section 6).  So when a layout segment's offset is not
stripe-unit-aligned, the segment-relative coalescing window is shifted
off the absolute stripe grid and a coalesced I/O can straddle a stripe
boundary, sending the bytes past it to the wrong data server.

Bound coalescing on the absolute offset to match calc_dss_id().  Aligned
segments, including all whole-file layouts, are unchanged.

Fixes: 4934ccbeaed3 ("NFSv4/flexfiles: Read path updates for striped layouts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -996,7 +996,6 @@ ff_layout_pg_test(struct nfs_pageio_desc
 	unsigned int size;
 	u64 p_stripe, r_stripe;
 	u64 stripe_offset;
-	u64 segment_offset = pgio->pg_lseg->pls_range.offset;
 	u64 stripe_unit = FF_LAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
 
 	/* calls nfs_generic_pg_test */
@@ -1008,8 +1007,8 @@ ff_layout_pg_test(struct nfs_pageio_desc
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-		p_stripe = (u64)req_offset(prev) - segment_offset;
-		r_stripe = (u64)req_offset(req) - segment_offset;
+		p_stripe = (u64)req_offset(prev);
+		r_stripe = (u64)req_offset(req);
 		p_stripe = div64_u64(p_stripe, stripe_unit);
 		r_stripe = div64_u64(r_stripe, stripe_unit);
 
@@ -1018,7 +1017,7 @@ ff_layout_pg_test(struct nfs_pageio_desc
 	}
 
 	/* calculate remaining bytes in the current stripe */
-	div64_u64_rem((u64)req_offset(req) - segment_offset,
+	div64_u64_rem((u64)req_offset(req),
 			stripe_unit,
 			&stripe_offset);
 	WARN_ON_ONCE(stripe_offset > stripe_unit);


