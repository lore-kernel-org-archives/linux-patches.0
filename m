Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18563C13E0;
	Sat, 17 Oct 2026 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260540; cv=none; b=k44+ugiA/zy9Enc8bDRq2NsdaJBMM6+vJsr4lgDFrzgwULji8nyLKOCLF9cBMUH5oZXisIV/A4fhTRnOGbJ05AY1SjiaclWBs4lOSMg4TctAuMyqjgxKP2AxaTMmP/BdcHY9IPbzISdcRRJG9kqPC3+yAhUDQ6QS0yZyRHIgkzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260540; c=relaxed/simple;
	bh=baF/ACFluZYJqzZ3JIq9VI9P9Xz7tfffEx8Vpcz1rjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpR1TMKfTIphZwnAQN6HwnxvGuDhNCIakopDEiwBWC5tpUYSGiV7lshzT1FFf9rK57jHShuZYS9Ghut42o+TlRwBIFpqQRH05wrkPKEHm8BiST4F687btrXZckxo7grzlKZOuPF9pw5Ipn20EMfbU3jcH9uZa+0Nm4qwolgM9ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pta/v39M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pta/v39M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F111F000C4;
	Sat, 17 Oct 2026 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260538;
	bh=R4rEgcGgtOCpReJZpgHOjWJafTQojiK69QGo/o9xMSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pta/v39MRHHS7mQG74REAySH1y5vRE61aOV0B/e7G+kmguZmBula8ZzsRbmZvmgDl
	 eoynNERsLaaacD++Y/e2JFOuCjHBR/LNqdhyJkt/CY+yZpP+5JeU7exVb2DTkdOevH
	 XZiV1opoFZSV1Q6G7ysC6tvg+gBUr6QRqe67eA1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1577/1674] svcrdma: Validate Read chunk positions before reconstruction
Date: Sat, 17 Oct 2026 18:04:09 +0200
Message-ID: <20261017160511.573320218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3779b7b9e7d1c8ba4738f9d327de3b0288cefe9b ]

The RPC/RDMA Read chunk position field is supplied by the remote
client and stored verbatim in the parsed chunk list.
xdr_count_read_segments() checks only 4-byte alignment; it never
compares the position against the received inline body length.

In the single-chunk path, svc_rdma_read_complete_one() splits the
head and tail kvecs at ch_position. A position past the inline
body underflows the tail length, exposing adjacent slab memory to
the upper XDR decoder.

In the multi-chunk path, svc_rdma_read_multiple_chunks() computes
gap lengths between chunks as unsigned subtractions from
ch_position. Overlapping Read chunks cause these subtractions to
underflow. A final position past the inline body likewise
underflows the trailing gap length. svc_rdma_copy_inline_range()
then copies past the receive buffer into request pages that are
returned to the client through the Reply channel.

Bound inline-range copies in svc_rdma_copy_inline_range() against
the decoded inline RPC body saved in rc_saved_arg. Reject a
single Read chunk positioned beyond that body, and reject
multi-chunk lists where accumulated read bytes exceed the next
chunk's position. Apply the same position and overlap checks in
the call-chunk interleaving path.

Fixes: d96962e6d0e2 ("svcrdma: Use the new parsed chunk list when pulling Read chunks")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260526-rpc-kernel-bugs-v1-1-e251306ccca9@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 347db3b7e0bc8..e9edbcfec28cc 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -790,7 +790,7 @@ static int svc_rdma_build_read_chunk(struct svc_rdma_read_info *info,
 /**
  * svc_rdma_copy_inline_range - Copy part of the inline content into pages
  * @info: context for RDMA Reads
- * @offset: offset into the Receive buffer of region to copy
+ * @offset: offset into the inline content of region to copy
  * @remaining: length of region to copy
  *
  * Take a page at a time from rqstp->rq_pages and copy the inline
@@ -807,10 +807,14 @@ static int svc_rdma_copy_inline_range(struct svc_rdma_read_info *info,
 				      unsigned int remaining)
 {
 	struct svc_rdma_recv_ctxt *head = info->ri_readctxt;
-	unsigned char *dst, *src = head->rc_recv_buf;
 	struct svc_rqst *rqstp = info->ri_rqst;
+	unsigned char *dst, *src = rqstp->rq_arg.head[0].iov_base;
+	unsigned int inline_len = rqstp->rq_arg.head[0].iov_len;
 	unsigned int page_no, numpages;
 
+	if (offset > inline_len || remaining > inline_len - offset)
+		return -EINVAL;
+
 	numpages = PAGE_ALIGN(info->ri_pageoff + remaining) >> PAGE_SHIFT;
 	for (page_no = 0; page_no < numpages; page_no++) {
 		unsigned int page_len;
@@ -860,9 +864,10 @@ static noinline int svc_rdma_read_multiple_chunks(struct svc_rdma_read_info *inf
 	const struct svc_rdma_pcl *pcl = &head->rc_read_pcl;
 	struct xdr_buf *buf = &info->ri_rqst->rq_arg;
 	struct svc_rdma_chunk *chunk, *next;
-	unsigned int start, length;
+	unsigned int inline_len, start, length;
 	int ret;
 
+	inline_len = buf->head[0].iov_len;
 	start = 0;
 	chunk = pcl_first_chunk(pcl);
 	length = chunk->ch_position;
@@ -880,6 +885,8 @@ static noinline int svc_rdma_read_multiple_chunks(struct svc_rdma_read_info *inf
 			break;
 
 		start += length;
+		if (info->ri_totalbytes > next->ch_position)
+			return -EINVAL;
 		length = next->ch_position - info->ri_totalbytes;
 		ret = svc_rdma_copy_inline_range(info, start, length);
 		if (ret < 0)
@@ -887,7 +894,9 @@ static noinline int svc_rdma_read_multiple_chunks(struct svc_rdma_read_info *inf
 	}
 
 	start += length;
-	length = head->rc_byte_len - start;
+	if (start > inline_len)
+		return -EINVAL;
+	length = inline_len - start;
 	ret = svc_rdma_copy_inline_range(info, start, length);
 	if (ret < 0)
 		return ret;
@@ -928,6 +937,9 @@ static int svc_rdma_read_data_item(struct svc_rdma_read_info *info)
 	int ret;
 
 	chunk = pcl_first_chunk(&head->rc_read_pcl);
+	if (chunk->ch_position > buf->head[0].iov_len)
+		return -EINVAL;
+
 	ret = svc_rdma_build_read_chunk(info, chunk);
 	if (ret < 0)
 		goto out;
@@ -1028,14 +1040,17 @@ static int svc_rdma_read_call_chunk(struct svc_rdma_read_info *info)
 			pcl_first_chunk(&head->rc_call_pcl);
 	const struct svc_rdma_pcl *pcl = &head->rc_read_pcl;
 	struct svc_rdma_chunk *chunk, *next;
-	unsigned int start, length;
+	unsigned int call_len, start, length;
 	int ret;
 
 	if (pcl_is_empty(pcl))
 		return svc_rdma_build_read_chunk(info, call_chunk);
 
+	call_len = call_chunk->ch_length;
 	start = 0;
 	chunk = pcl_first_chunk(pcl);
+	if (chunk->ch_position > call_len)
+		return -EINVAL;
 	length = chunk->ch_position;
 	ret = svc_rdma_read_chunk_range(info, call_chunk, start, length);
 	if (ret < 0)
@@ -1051,6 +1066,8 @@ static int svc_rdma_read_call_chunk(struct svc_rdma_read_info *info)
 			break;
 
 		start += length;
+		if (info->ri_totalbytes > next->ch_position)
+			return -EINVAL;
 		length = next->ch_position - info->ri_totalbytes;
 		ret = svc_rdma_read_chunk_range(info, call_chunk,
 						start, length);
@@ -1059,7 +1076,9 @@ static int svc_rdma_read_call_chunk(struct svc_rdma_read_info *info)
 	}
 
 	start += length;
-	length = call_chunk->ch_length - start;
+	if (start > call_len)
+		return -EINVAL;
+	length = call_len - start;
 	return svc_rdma_read_chunk_range(info, call_chunk, start, length);
 }
 
-- 
2.53.0



