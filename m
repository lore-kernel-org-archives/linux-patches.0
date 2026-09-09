Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2862A582BBC;
	Wed,  9 Sep 2026 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964650; cv=none; b=RG/XngyQeDB0dUJQLcWS1b9+ELXAZ2SaPRSrWAwrXepdRzrntw3pZdDu49Y/4Q2JK8JDsdmmMtlR+jgg3yBtOs4nWgcrEA5pIOVykLEE7frP8d4XOTWbTMI1I32oWISLGlx0Hl85qUCpo+yUZ6d9ESQnymcggzZ2lZ2+V8k/QAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964650; c=relaxed/simple;
	bh=MPNnSer6CrHgvlTpVL+feQ4bgo++DeIkkuyA18WhICI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6BfE3j/eSnfAYTb00erduTtxvHJCpOfiJluLdGuwik0ApKZNi1sBsr+6LdHjOG5CARA0yvPAbb53npqdE5JoWNDa8FeZs7XbDrgKG1+XHS4Xh/dPTf9C+ClNoDjq6oQuFvXiV666C8vZPiqG41SWlCn0yZg8K2k/YgQBfhbnqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAn/MZTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAn/MZTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E1E1F00A3A;
	Wed,  9 Sep 2026 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964649;
	bh=ZKbQJ5Q4WEgC+ERNMJg5VHrFPKhnkQupZ5nQS/SUsSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAn/MZTGprjXkLDzrbXLnQYP7Sr/uEVckKNRTBg6MWt0sQq2NcvYCGQNnEn50H7hT
	 B2L2RTOJdkc36ymvU7XWKJfep42+jdOcc7n0itkteS5BVSRaw1LaRHB+yooegSwv9G
	 OBP8rNlsDruxAut1K982L0WjBSPp0fz+a4OHRS/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 496/583] svcrdma: Reject Read lists that exceed the page budget
Date: Wed,  9 Sep 2026 15:43:01 +0200
Message-ID: <20260909134254.964761560@linuxfoundation.org>
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

[ Upstream commit 0ca487abb3bdf581851664b5db21f364caf57682 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -430,11 +430,14 @@ static void svc_rdma_build_arg_xdr(struc
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
@@ -448,7 +451,10 @@ static bool xdr_count_read_segments(stru
 
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


