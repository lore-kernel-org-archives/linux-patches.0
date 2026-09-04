Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335241A4F8;
	Fri,  4 Sep 2026 05:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499390; cv=none; b=HQxt53bb3eMBztT/31l2dT9rbvmhqzS1c9uoPs8BAW7SVXQcCCgZW0GHcIahjeSIAi2Y6KiswNW3x/EAfyMLURvPp+NGc18N17UyUrCBFSGDJ9Dwv1h5aTovoOQE61MaOPhaaquVxj2y13QwcF5a39pJb1GdwdOERzBhV5bqQlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499390; c=relaxed/simple;
	bh=Sl1VzMDTN4LVPNftD+pXErnkvNsrBNIbbEx1n4MK4E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQ+hNlyGl1XLtNjAUjsfS+RF1G5vzFefLeeqmTmrZpi28fPaX65bn5Sh+JPPPAn7lAHMibekq2e5Tc7QxDLLK09rBPaHirl5fwjJXDJE1rws3XH/zm8yIK3Lb+i7DunojXXlReqJIUBNuhF/v4oUoCYZxAV9afgAymCki7ZpLr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLI+fO23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLI+fO23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B7C1F00ACA;
	Fri,  4 Sep 2026 05:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499389;
	bh=2/y0Gy07sFES3WUu5vGGevoQNnueL6vHs6NN4mujsKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLI+fO23pYK4MQ7pjea1XwyNtQzAPcYGmQODqMnEh0zVH1/n7DXuaVZhxU46Ngn/j
	 /AmOdnoNCVjfrVysYmtTQx1RoM/D+cmJfVJSz0O1JC6oVe4xOBzWqr8cXYTpxpqDM6
	 Cj13sNCYLcxvqFxc1r2tqps//sUunMbFe+X3DaoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 398/713] svcrdma: Reject Write/Reply chunks with segcount 0
Date: Fri,  4 Sep 2026 06:56:06 +0200
Message-ID: <20260904045812.745777183@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 9808eb7656666acc7291bae9ab6b987bd16e47e0 upstream.

A peer can send a Write or Reply chunk whose segcount field is zero.
xdr_check_write_chunk() only rejects segcount > rc_maxpages, so zero
passes the range check, and xdr_inline_decode(stream, 0) returns the
current (non-NULL) cursor without advancing. The function returns
true and pcl_alloc_write() then links a struct svc_rdma_chunk with
ch_segcount == 0 onto rc_write_pcl or rc_reply_pcl.

An earlier patch in this series made pcl_for_each_segment() safe for
ch_segcount == 0, so this no longer drives the memory walk it used
to. Rejecting the malformed frame at the decode boundary is still
worthwhile as defense in depth: it keeps degenerate zero-segment
chunks off the parsed chunk lists entirely, so any future consumer
that walks ch_segments directly cannot observe one, and it makes the
zero-floor easy to backport to trees where the macro change is more
intrusive. RFC 8166 has no meaning for a Write/Reply chunk that
describes no remote buffer, so no legitimate client is affected.

xdr_check_reply_chunk() funnels Reply chunks through
xdr_check_write_chunk() and inherits the same rejection.

pcl_alloc_write() also links each chunk onto the parsed chunk list
before filling its segment array. If a future change weakens the
segcount-0 rejection, an incomplete chunk is visible to consumers
during the fill loop. Reorder so that list_add_tail() follows the
segment fill loop, ensuring only fully-populated chunks appear on
the list.

Fixes: 78147ca8b4a9 ("svcrdma: Add a "parsed chunk list" data structure")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-rpc-kernel-bugs-v1-5-e251306ccca9@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_pcl.c      |    2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_pcl.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_pcl.c
@@ -213,7 +213,6 @@ bool pcl_alloc_write(struct svc_rdma_rec
 		chunk = pcl_alloc_chunk(segcount, 0);
 		if (!chunk)
 			return false;
-		list_add_tail(&chunk->ch_list, &pcl->cl_chunks);
 
 		for (j = 0; j < segcount; j++) {
 			segment = &chunk->ch_segments[j];
@@ -225,6 +224,7 @@ bool pcl_alloc_write(struct svc_rdma_rec
 			chunk->ch_length += segment->rs_length;
 			chunk->ch_segcount++;
 		}
+		list_add_tail(&chunk->ch_list, &pcl->cl_chunks);
 	}
 	return true;
 }
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -516,10 +516,13 @@ static bool xdr_check_write_chunk(struct
 		return false;
 
 	/* Before trusting the segcount value enough to use it in
-	 * a computation, perform a simple range check. This is an
-	 * arbitrary but sensible limit (ie, not architectural).
+	 * a computation, perform a simple range check. A zero
+	 * segcount describes no remote buffer and is rejected so
+	 * downstream consumers never see a degenerate ch_segcount==0
+	 * chunk. The upper bound is an arbitrary but sensible limit
+	 * (ie, not architectural).
 	 */
-	if (unlikely(segcount > rctxt->rc_maxpages))
+	if (segcount == 0 || unlikely(segcount > rctxt->rc_maxpages))
 		return false;
 
 	p = xdr_inline_decode(&rctxt->rc_stream,


