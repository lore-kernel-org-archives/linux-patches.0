Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829032;
	b=wVhZe1BpOq4vXwp2tqC+U9SntwkJCVbAwOaBzwfMS00pHewiJ/BWsM5s+uzmyUlOSxv0
	 lCGHPZ2Mgwg1fr/uj/YYf0vbh98p9nZPkW+C++ptcU9zToE5F2dbMBGFgUCAiGDQKsieI
	 gkVrL2lqMc6nlbeCsUJSv1/QbKYfJFYi18r+wr5Mzl6m4bldfQjA/u+ZKOgJWuZ/Iid2x
	 +WXXus01gf89jApEf9dNfwzg1VCPuT/PClih1KyzzwotL8oa8I03iy8Pgm0kRnl0zKwku
	 qMsU5RDWMFJXVkdCnWdQiv4+AJualGd+JNk0AsPJ+r4YYzglZmFtUVNaXQC54AFQMJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8k2lMyRPYq+NRA8L3NUrD2G24GPi7YUsAj8VzODsAo=;
	b=D3ySw+c+96N8v0oZhQfI+gXR2qKGZ4KtE5Z9fqAb/Pk4T8Grac+PJCxJjOMfXWabyY4I
	 GR4kR/Fz1YJquXHrAhIgRxTS1cCrQO7rYkIre5ORmtNH0GCySOjcZZ3dik3X2LhcKERnq
	 7FAVExZudX80sk8Dt6h11XKp+CQZvNjuFdPD8aJvWn7ix1aGgiXlpx078ivtU7QAjYH7i
	 tKc38SEfY4zHGNhQSxJpvQ1nY/SAO9bW3gOQ+JqUL5doLEFAQv0aX6jiu/d3n0RNagR8J
	 rSXaRhOXIO0c/mHzAxYH+edA9AbyRwe420eU0fKHcTd5uXZWCTJuzDnaQ4f4BuHGRMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xdSOyt52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9908D6070764;
	Wed,  4 Nov 2026 21:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xdSOyt52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A1E1F000C1;
	Wed,  4 Nov 2026 21:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829032;
	bh=Q8k2lMyRPYq+NRA8L3NUrD2G24GPi7YUsAj8VzODsAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xdSOyt52oZcV/TZJyQJ5xdse5hn9mycZ/znh3nByyS9rx6X1MK2b40nt5pafXXs7T
	 JzZ63//coVRC/7I7duqIXqMh2Dhw6CoH4kV1a6jG6Dqb9H1liNssg/BfYEiXAVtWtV
	 lVxTB3XAvhln13Mz23D5NPTnYWwMkNiOxD75Wabk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 401/547] NFSv4/filelayout: Anchor page coalescing on pattern_offset
Date: Wed,  4 Nov 2026 16:09:45 -0500
Message-ID: <20261104211049.707067195@linuxfoundation.org>
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

commit 7f2d221b01f356b6bb3bb6efef998f8b28339824 upstream.

filelayout_pg_test() bounds page coalescing to a single stripe unit
using an offset relative to pls_range.offset, but the data server is
selected by nfs4_fl_calc_j_index() using an offset relative to
pattern_offset.  When a segment's pattern_offset and range offset are
not congruent modulo the stripe unit, the coalescing window is shifted
off the DS-selection grid, so a coalesced I/O can straddle a stripe
boundary and send the bytes past it to the wrong data server.

Anchor coalescing on pattern_offset to match nfs4_fl_calc_j_index().
Stripe-congruent segments, including the common whole-file pattern_offset
0 case, are unchanged.

Fixes: c6194271f94b ("pnfs: filelayout: support non page aligned layouts")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/filelayout/filelayout.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -796,7 +796,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	unsigned int size;
 	u64 p_stripe, r_stripe;
 	u32 stripe_offset;
-	u64 segment_offset = pgio->pg_lseg->pls_range.offset;
+	u64 pattern_offset = FILELAYOUT_LSEG(pgio->pg_lseg)->pattern_offset;
 	u32 stripe_unit = FILELAYOUT_LSEG(pgio->pg_lseg)->stripe_unit;
 
 	/* calls nfs_generic_pg_test */
@@ -808,8 +808,8 @@ filelayout_pg_test(struct nfs_pageio_des
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-		p_stripe = (u64)req_offset(prev) - segment_offset;
-		r_stripe = (u64)req_offset(req) - segment_offset;
+		p_stripe = (u64)req_offset(prev) - pattern_offset;
+		r_stripe = (u64)req_offset(req) - pattern_offset;
 		do_div(p_stripe, stripe_unit);
 		do_div(r_stripe, stripe_unit);
 
@@ -818,7 +818,7 @@ filelayout_pg_test(struct nfs_pageio_des
 	}
 
 	/* calculate remaining bytes in the current stripe */
-	div_u64_rem((u64)req_offset(req) - segment_offset,
+	div_u64_rem((u64)req_offset(req) - pattern_offset,
 			stripe_unit,
 			&stripe_offset);
 	WARN_ON_ONCE(stripe_offset > stripe_unit);


