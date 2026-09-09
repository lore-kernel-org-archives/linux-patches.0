Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC6583AAF;
	Wed,  9 Sep 2026 14:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964647; cv=none; b=SKouFpH+ekkDbzNmQ3n2yx26PeHCw0G7Y4/fvO5b4m8tK5kqIJycMSpHZYw3a0Z3i3A9z3RxSDuLT/MnKm36PRhElmzY7XP7USR10qXvtE74Fc3fhOZOWz73en9Oy5L+NaJisJfBKeRWzJ/eJFUC4JwOlXIS5kPmhCSklZ60GaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964647; c=relaxed/simple;
	bh=fdkzugWVTlBrdWwrCRHNJCevuU955i7eP3Iz5BtmWik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcCjQHIgNgjMBVa1tyiUvU3lCxHzfgv2jPtistltZqU3TFGS2HXyuDSmdaiTXcdubAmLG+TweKuAWGFgq/wmQR+utdXlOAid1D5IBcAJNmEuiF93j2Uf+TfVFZGpiF27OgF+ipw62LNj0WlqrrgbbgrOJs6wuzhOLOaKUVuI3hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEAdq50Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEAdq50Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D481F00A3A;
	Wed,  9 Sep 2026 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964646;
	bh=Lx80koGvUg9n/8KXMLVE/IO1KV3A6KxCENeK//QgtWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEAdq50Z86R4Dp9+4VGeP9nXfZBfitZgBgd3zz7tN3MiXudfv7rjK5/4vjcmqH2xX
	 H9HLg8Dioe9g8UUQSu3TbB57FspddO/wK1HjzaJb0mhg5n4fPI6m6Zuji4qUQNYUwJ
	 AEbzjcLwLGvRfTyw0BPrrrgaXnwYI0rRxpkw7WgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 495/583] svcrdma: Reject oversized Read segments at decode time
Date: Wed,  9 Sep 2026 15:43:00 +0200
Message-ID: <20260909134254.934779813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit af6f0e06bed818ee7fc8b869915964410020a1c5 ]

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
Stable-dep-of: 0ca487abb3bd ("svcrdma: Reject Read lists that exceed the page budget")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    2 ++
 net/sunrpc/xprtrdma/svc_rdma_rw.c       |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -448,6 +448,8 @@ static bool xdr_count_read_segments(stru
 
 		xdr_decode_read_segment(p, &position, &handle,
 					    &length, &offset);
+		if (length > rctxt->rc_maxpages << PAGE_SHIFT)
+			return false;
 		if (position) {
 			if (position & 3)
 				return false;
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -766,7 +766,7 @@ static int svc_rdma_build_read_segment(s
 		len -= seg_len;
 
 		if (len && ((head->rc_curpage + 1) > rqstp->rq_maxpages))
-			goto out_overrun;
+			goto out_put;
 	}
 
 	ret = svc_rdma_rw_ctx_init(rdma, ctxt, segment->rs_offset,
@@ -779,7 +779,8 @@ static int svc_rdma_build_read_segment(s
 	cc->cc_sqecount += ret;
 	return 0;
 
-out_overrun:
+out_put:
+	svc_rdma_put_rw_ctxt(rdma, ctxt);
 	trace_svcrdma_page_overrun_err(&cc->cc_cid, head->rc_curpage);
 	return -EINVAL;
 }


