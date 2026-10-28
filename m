Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216297;
	b=Y3TbYj+QgXhGWbUVnmntaCf7MY5wkAuurdF+VsxaWl4EJa/eolcOOQ7sDKDawDSnweXV
	 BIbtgOf8LzTa84YFq2u3qEKMW2uhP296tKzND7CP8+xxpGcGC7KNkvc4X9ZHW+M4h894R
	 GIWivRMeAHgWBT72itaYXjv0VqiwhUvNXpFwC3D7W91RkximOpw3NqYchuDcCn1YWNTDU
	 CoOvy0hTYSzmdMSEbMMkuJ8u4JabeJ4LUvURNKzkh9K09g8fWudyf6Oz762B9c6uvaER3
	 NbQD8JgqcVnGxqWNiUDIBuGlyOzZUYz2OQ/N/oBPQp/H6kutnQ6l4rCQNoTjsp1aeWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tu6OBLZOTVhnoKLoxqTQNMLMWhDTaWeDc/BRrSfO7F4=;
	b=3VW+cWpr5gnhwQaV5wdm6HIG/Je4LskzFbOcQtDs8jtmSBinMP5YAJdjBnSC9nMxjsS1
	 W3eFWL8Gt+tjeFXiK34a2LjUUFMfQ4XlUyqFVxiZzDRcwDUAUrE9jWbHJtQNIj6/5uK3N
	 9ilx1uTO/2tkJ+ogKuOLhzjVvCUqS7Bl4THGV15USzidH0OsExWqUoXgGSJg3eycE4+jO
	 hlozqzeHLPPrM8FULcOaDcS3dhUiQW0iGqM6G+BwWulrBJbb/PjtoI2VBk0vbztHT0Y/A
	 vy7qg5pN2XeZYzrKCVWb0Sd50+MtuQbtDfHLTb9jbNhMWpIQcAZA7bOmGnWCEQFfw7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4FHZYyd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE251606A31A;
	Wed, 28 Oct 2026 19:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4FHZYyd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FC51F01828;
	Wed, 28 Oct 2026 19:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216296;
	bh=Tu6OBLZOTVhnoKLoxqTQNMLMWhDTaWeDc/BRrSfO7F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4FHZYydP2kBngfF+ETQRYDbnRUg10uhS07zsPLOl5Q2ePGooNyovnqgJQquxOkTP
	 3ScyR04ZxhhDEYuVfdo1YnGunVKuGlbHWXD/cHfX8cPZFqCQBTe2bSLZK9cUTP8er9
	 BNpOV3W6BZtL8TgOcllwlD1WJFTKv0eHHMJpBoEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1465/1887] svcrdma: Validate Read chunk positions before reconstruction
Date: Wed, 28 Oct 2026 17:59:21 +0100
Message-ID: <20261028170532.793076179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 33 +++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index e455f16440334..15140246f03e8 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -786,7 +786,7 @@ static int svc_rdma_build_read_chunk(struct svc_rdma_read_info *info,
 /**
  * svc_rdma_copy_inline_range - Copy part of the inline content into pages
  * @info: context for RDMA Reads
- * @offset: offset into the Receive buffer of region to copy
+ * @offset: offset into the inline content of region to copy
  * @remaining: length of region to copy
  *
  * Take a page at a time from rqstp->rq_pages and copy the inline
@@ -803,10 +803,14 @@ static int svc_rdma_copy_inline_range(struct svc_rdma_read_info *info,
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
@@ -856,9 +860,10 @@ static noinline int svc_rdma_read_multiple_chunks(struct svc_rdma_read_info *inf
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
@@ -876,6 +881,8 @@ static noinline int svc_rdma_read_multiple_chunks(struct svc_rdma_read_info *inf
 			break;
 
 		start += length;
+		if (info->ri_totalbytes > next->ch_position)
+			return -EINVAL;
 		length = next->ch_position - info->ri_totalbytes;
 		ret = svc_rdma_copy_inline_range(info, start, length);
 		if (ret < 0)
@@ -883,7 +890,9 @@ static noinline int svc_rdma_read_multiple_chunks(struct svc_rdma_read_info *inf
 	}
 
 	start += length;
-	length = head->rc_byte_len - start;
+	if (start > inline_len)
+		return -EINVAL;
+	length = inline_len - start;
 	ret = svc_rdma_copy_inline_range(info, start, length);
 	if (ret < 0)
 		return ret;
@@ -924,6 +933,9 @@ static int svc_rdma_read_data_item(struct svc_rdma_read_info *info)
 	int ret;
 
 	chunk = pcl_first_chunk(&head->rc_read_pcl);
+	if (chunk->ch_position > buf->head[0].iov_len)
+		return -EINVAL;
+
 	ret = svc_rdma_build_read_chunk(info, chunk);
 	if (ret < 0)
 		goto out;
@@ -1024,14 +1036,17 @@ static int svc_rdma_read_call_chunk(struct svc_rdma_read_info *info)
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
@@ -1047,7 +1062,11 @@ static int svc_rdma_read_call_chunk(struct svc_rdma_read_info *info)
 			break;
 
 		start += length;
+		if (info->ri_totalbytes > next->ch_position)
+			return -EINVAL;
 		length = next->ch_position - info->ri_totalbytes;
+		if (length > call_len - start)
+			return -EINVAL;
 		ret = svc_rdma_read_chunk_range(info, call_chunk,
 						start, length);
 		if (ret < 0)
@@ -1055,7 +1074,9 @@ static int svc_rdma_read_call_chunk(struct svc_rdma_read_info *info)
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



