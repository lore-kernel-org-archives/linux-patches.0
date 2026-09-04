Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E3C41C30F;
	Fri,  4 Sep 2026 05:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499384; cv=none; b=MypXghPYGrvyklXH/BkPrdYZ1r+yR+EFd1Pfc2amOgTjEIKJshCQa7KU1Mfk5gjOENmq00vwWKfHgAgF13P2LFPdorEl51Ovsu6MjnLTawEFe9oIZhMtbiWEYmf3cwuUsVoA1wMJTvmPPqvSzTD+UP6zceeCP1gqW7+5pKduTiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499384; c=relaxed/simple;
	bh=CMoYjwkubjb6MFshUyQ7yqaV/gmTMS5mhp6JE7JTXsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ap8H/nTn3YpJJUiYD7XjDcedl0RUEbytBkGkCkw+X6yr7M99KVfoJRoGGcbMDzFscE6UcSeti7ruVBHvdDPteqcm/meDdJsZu8js/yGzL/KsSmmxD74ieJBwY06yfsI7ZzTJL+fB6lWLeIvOWOniDHjI+UEaP7YjLqNpy0i+GbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3sBwsMl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3sBwsMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E21F1F00A3D;
	Fri,  4 Sep 2026 05:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499383;
	bh=v+aTEnzEMRIL6SiKOyiS0y14qrmokdoLm/cbZZotltg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3sBwsMlo8b1XTKBVI7d8LtKdxjMoqCH8P+b1H/mGglaV/JL8fXPOOgfhBZQDkpic
	 orqwhEpguO4pI9YYKT0XYTWBSeQ7zLoa2r6AJBlwBDqMkWLRD+O8wyQUue/2XOhwG2
	 Hy7DhKFnbyc2+bvjbmImrEZBd/q4EDudN8qbW41k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 396/713] svcrdma: Reject oversized Read segments at decode time
Date: Fri,  4 Sep 2026 06:56:04 +0200
Message-ID: <20260904045812.701058771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit af6f0e06bed818ee7fc8b869915964410020a1c5 upstream.

The RPC/RDMA Read list decoder stores wire-supplied segment
lengths without validation. xdr_count_read_segments() checks
4-byte alignment for non-zero position values but does not
cap the segment length.

An oversized rs_length reaches svc_rdma_build_read_segment(),
which derives nr_bvec from it and can drive a large dynamic
bvec allocation before verifying that enough rq_pages remain.
If the post-allocation page-overrun guard fires, the freshly
acquired rw context is not returned, leaking the resource.

Reject any segment whose length exceeds the receive context's
page budget during Read list decoding, consistent with how
xdr_check_write_chunk() bounds Write segment counts against
rc_maxpages. Also return the rw context on the existing
post-allocation overrun path in svc_rdma_build_read_segment(),
keeping that defensive guard balanced.

Fixes: 5ee62b4a9113 ("svcrdma: use bvec-based RDMA read/write API")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-rpc-kernel-bugs-v1-3-e251306ccca9@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 2 ++
 net/sunrpc/xprtrdma/svc_rdma_rw.c       | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index fe9bf0371b6e..15c1d8ae5301 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -458,6 +458,8 @@ static bool xdr_count_read_segments(struct svc_rdma_recv_ctxt *rctxt, __be32 *p)
 
 		xdr_decode_read_segment(p, &position, &handle,
 					    &length, &offset);
+		if (length > rctxt->rc_maxpages << PAGE_SHIFT)
+			return false;
 		if (position) {
 			if (position & 3)
 				return false;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index b4cb4f991235..9aaaade99e6e 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -795,7 +795,7 @@ static int svc_rdma_build_read_segment(struct svc_rqst *rqstp,
 		len -= seg_len;
 
 		if (len && ((head->rc_curpage + 1) > rqstp->rq_maxpages))
-			goto out_overrun;
+			goto out_put;
 	}
 
 	ret = svc_rdma_rw_ctx_init(rdma, ctxt, segment->rs_offset,
@@ -809,7 +809,8 @@ static int svc_rdma_build_read_segment(struct svc_rqst *rqstp,
 	cc->cc_sqecount += ret;
 	return 0;
 
-out_overrun:
+out_put:
+	svc_rdma_put_rw_ctxt(rdma, ctxt);
 	trace_svcrdma_page_overrun_err(&cc->cc_cid, head->rc_curpage);
 	return -EINVAL;
 }
-- 
2.55.0



