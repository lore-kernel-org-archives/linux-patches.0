Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13280417BCA;
	Fri,  4 Sep 2026 05:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499543; cv=none; b=Jl45Ew2P0gGgU1t2dRB8N+ACUyjVCJngywkdHVQRk4egdg6Y5h8eEZlmbDbIrZDQ0qG4Wd91BmE1TVae/Xj5jgQfP/db8YwfwCLuAuJXjz1Rbz73P2rlpoe9aMGVomnF76MkuEZ/KeVFyFFdaOZ/CFr+9eMTR8bE6ie0e8VPf4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499543; c=relaxed/simple;
	bh=cSSNIo2wrxLo8OGSLdjb0lCFy2xsMqMcN0r6omLr2i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiOSnEU6I1onLVNy5FR/js62jco1oVS8+EEqJlBV+BPsZW7/r+hdqxsROlBmnxSQQGGQHOWJ2R1k9zuaZUKaQatbJshj3PTUNzrUBWIXdSeFoqb6PpYDxMBNyAL7m/1h073MqyLWxoIB0zPU2bQszwxra3uyP5KLHkJsj0P60Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z+nf8JE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z+nf8JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD781F00A3D;
	Fri,  4 Sep 2026 05:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499542;
	bh=w4KMa05/ph86i9CspD0nZxRE2G2UDKKx91bwAC5MZ3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Z+nf8JEj+pyPzp9vzyjCMpENwvNfFbo7KoYFSsB44O1YIazbO9nZ6OytOkMKZZkQ
	 PSlF95R0HUFZ/x3XVWhq/A/9L60fd3VE0ez82iqjLz0i5VNOB0DoHgX2QGSkAp5KD1
	 yhyIYspORtQATboDTs3spokTeZDR/wS1i2EhtDJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 400/713] svcrdma: Validate Read chunk positions before reconstruction
Date: Fri,  4 Sep 2026 06:56:08 +0200
Message-ID: <20260904045812.791666653@linuxfoundation.org>
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

commit 3779b7b9e7d1c8ba4738f9d327de3b0288cefe9b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -848,7 +848,7 @@ static int svc_rdma_build_read_chunk(str
  * svc_rdma_copy_inline_range - Copy part of the inline content into pages
  * @rqstp: RPC transaction context
  * @head: context for ongoing I/O
- * @offset: offset into the Receive buffer of region to copy
+ * @offset: offset into the inline content of region to copy
  * @remaining: length of region to copy
  *
  * Take a page at a time from rqstp->rq_pages and copy the inline
@@ -865,9 +865,13 @@ static int svc_rdma_copy_inline_range(st
 				      unsigned int offset,
 				      unsigned int remaining)
 {
-	unsigned char *dst, *src = head->rc_recv_buf;
+	unsigned char *dst, *src = head->rc_saved_arg.head[0].iov_base;
+	unsigned int inline_len = head->rc_saved_arg.head[0].iov_len;
 	unsigned int page_no, numpages;
 
+	if (offset > inline_len || remaining > inline_len - offset)
+		return -EINVAL;
+
 	numpages = PAGE_ALIGN(head->rc_pageoff + remaining) >> PAGE_SHIFT;
 	for (page_no = 0; page_no < numpages; page_no++) {
 		unsigned int page_len;
@@ -918,9 +922,10 @@ svc_rdma_read_multiple_chunks(struct svc
 {
 	const struct svc_rdma_pcl *pcl = &head->rc_read_pcl;
 	struct svc_rdma_chunk *chunk, *next;
-	unsigned int start, length;
+	unsigned int inline_len, start, length;
 	int ret;
 
+	inline_len = head->rc_saved_arg.head[0].iov_len;
 	start = 0;
 	chunk = pcl_first_chunk(pcl);
 	length = chunk->ch_position;
@@ -938,6 +943,8 @@ svc_rdma_read_multiple_chunks(struct svc
 			break;
 
 		start += length;
+		if (head->rc_readbytes > next->ch_position)
+			return -EINVAL;
 		length = next->ch_position - head->rc_readbytes;
 		ret = svc_rdma_copy_inline_range(rqstp, head, start, length);
 		if (ret < 0)
@@ -945,7 +952,9 @@ svc_rdma_read_multiple_chunks(struct svc
 	}
 
 	start += length;
-	length = head->rc_byte_len - start;
+	if (start > inline_len)
+		return -EINVAL;
+	length = inline_len - start;
 	return svc_rdma_copy_inline_range(rqstp, head, start, length);
 }
 
@@ -970,8 +979,12 @@ svc_rdma_read_multiple_chunks(struct svc
 static int svc_rdma_read_data_item(struct svc_rqst *rqstp,
 				   struct svc_rdma_recv_ctxt *head)
 {
-	return svc_rdma_build_read_chunk(rqstp, head,
-					 pcl_first_chunk(&head->rc_read_pcl));
+	struct svc_rdma_chunk *chunk = pcl_first_chunk(&head->rc_read_pcl);
+
+	if (chunk->ch_position > head->rc_saved_arg.head[0].iov_len)
+		return -EINVAL;
+
+	return svc_rdma_build_read_chunk(rqstp, head, chunk);
 }
 
 /**
@@ -1045,14 +1058,17 @@ static int svc_rdma_read_call_chunk(stru
 			pcl_first_chunk(&head->rc_call_pcl);
 	const struct svc_rdma_pcl *pcl = &head->rc_read_pcl;
 	struct svc_rdma_chunk *chunk, *next;
-	unsigned int start, length;
+	unsigned int call_len, start, length;
 	int ret;
 
 	if (pcl_is_empty(pcl))
 		return svc_rdma_build_read_chunk(rqstp, head, call_chunk);
 
+	call_len = call_chunk->ch_length;
 	start = 0;
 	chunk = pcl_first_chunk(pcl);
+	if (chunk->ch_position > call_len)
+		return -EINVAL;
 	length = chunk->ch_position;
 	ret = svc_rdma_read_chunk_range(rqstp, head, call_chunk,
 					start, length);
@@ -1069,6 +1085,10 @@ static int svc_rdma_read_call_chunk(stru
 			break;
 
 		start += length;
+		if (next->ch_position > call_len)
+			return -EINVAL;
+		if (head->rc_readbytes > next->ch_position)
+			return -EINVAL;
 		length = next->ch_position - head->rc_readbytes;
 		ret = svc_rdma_read_chunk_range(rqstp, head, call_chunk,
 						start, length);
@@ -1077,7 +1097,9 @@ static int svc_rdma_read_call_chunk(stru
 	}
 
 	start += length;
-	length = call_chunk->ch_length - start;
+	if (start > call_len)
+		return -EINVAL;
+	length = call_len - start;
 	return svc_rdma_read_chunk_range(rqstp, head, call_chunk,
 					 start, length);
 }


