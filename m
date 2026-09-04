Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDABD41DEDF;
	Fri,  4 Sep 2026 05:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499387; cv=none; b=KhLKsesfAE8dhoUuHDMANrRHLGBsZsr4D+Mk2D1XD57XUvSb4NeYIHBO2xfaoueGv5QnAQ2f0sjz6N4FDbe+IlitJ9GWHe4YZVRUoA6NWsBYm8L2vmurHnv2UhasG8cAkflRGvhNOQWk65SFURvF9Ch0e4ltbJwlzd4YC+/BwTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499387; c=relaxed/simple;
	bh=YR8ru2XXB568DyHM73OlAtX276DlhGnxFuK9hXfGH0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjAt+Uy8o7/3lQf/5It0zVKAVIhmrcImmpc6Qrua0OR0z04paGAhx6SZLoIjOuAZWUCBxYjcL9et4r4XUlK6PLtSiJfpLJo54xrsIH1YiJHryQON6VuOQqgqqOyGXcKQQFr+eDT2SdBwQofxSwA+yqm2al7Nrsrs3ZUwcI0X2FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efmP/hPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efmP/hPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09251F00A3D;
	Fri,  4 Sep 2026 05:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499386;
	bh=vS4WM2iVjizHEIURoqRhuxbGowMpko7C4mCCaG7GDsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=efmP/hPs5wVXll4drUmhpS3RMoMTw9PpvFXQkl1t1PkiTJLg13HaBIhiyjh+P3ko2
	 8VMURVbKbWL8F+PlLv8RhqUx+ngvw4KmAsIBAKwTyqGc7uOt37hPCT+EOQHCH4JD3E
	 8qxqZSseEd+QMAR896KnBXPoxtRf7ZclYepaTq64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 397/713] svcrdma: Reject Read lists that exceed the page budget
Date: Fri,  4 Sep 2026 06:56:05 +0200
Message-ID: <20260904045812.723708188@linuxfoundation.org>
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

commit 0ca487abb3bdf581851664b5db21f364caf57682 upstream.

Individual Read segment lengths are validated at decode time, but
nothing prevents a requester from sending multiple segments whose
cumulative length exceeds the rq_pages array budget. When one
segment fills the page array exactly, the runtime guard in
svc_rdma_build_read_segment() is bypassed because len reaches zero.
A subsequent segment then accesses the NULL sentinel slot at
rq_pages[rq_maxpages], resulting in a NULL pointer dereference during
DMA mapping.

Accumulate pages across all Read segments and reject the message at
decode time when the total would overflow the page budget.

Fixes: 026d958b38c6 ("svcrdma: Add recvfrom helpers to svc_rdma_rw.c")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -440,11 +440,14 @@ static void svc_rdma_build_arg_xdr(struc
  *	    to the first byte past the Read list. rc_read_pcl and
  *	    rc_call_pcl cl_count fields are set to the number of
  *	    Read segments in the list.
- *  %false: Read list is corrupt. @rctxt's xdr_stream is left in an
- *	    unknown state.
+ *  %false: Read list is corrupt or exceeds the page budget. @rctxt's
+ *	    xdr_stream is left in an unknown state.
  */
 static bool xdr_count_read_segments(struct svc_rdma_recv_ctxt *rctxt, __be32 *p)
 {
+	unsigned int maxlen = rctxt->rc_maxpages << PAGE_SHIFT;
+	unsigned int total_len = 0;
+
 	rctxt->rc_call_pcl.cl_count = 0;
 	rctxt->rc_read_pcl.cl_count = 0;
 	while (xdr_item_is_present(p)) {
@@ -458,7 +461,10 @@ static bool xdr_count_read_segments(stru
 
 		xdr_decode_read_segment(p, &position, &handle,
 					    &length, &offset);
-		if (length > rctxt->rc_maxpages << PAGE_SHIFT)
+		if (length > maxlen)
+			return false;
+		total_len += length;
+		if (PAGE_ALIGN(total_len) > maxlen)
 			return false;
 		if (position) {
 			if (position & 3)


