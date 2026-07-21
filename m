Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9F0433BAC;
	Tue, 21 Jul 2026 19:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663662; cv=none; b=kSb7ttaEF8JNaPsT8OE+lj0JmKlcU3T4OMcsdY97oKjarxTzA5A+U1h+jTtl1ZyIYpa4k7zk8+p3G43sSC9JfoL055QUNcAqXBd0Odevc31/6Ca+qI0SUdF+idZU7nDwX3/2VGLhLUpHF1zTbYmfZi7HnNcDcC+MjFtTXrGKG/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663662; c=relaxed/simple;
	bh=qkY3an/+KDhn4/izenrGj+cFSV3lkpyJHlePp36pFVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2zRnrAG2IkQZ2V6PSDA3y9MMXiGaheWLrVDxDva05ARzcESCRioSlUOutQg8FMwo4/mecrfem4D/TIB3tnTxcRR32yiHEiYGo1u5xicHL8Lx/PWBQrwr/zwORrFSFboKZQnn6jEqu2vFUtETr/Oq4KQtsopCSBLGRPH7dqPusA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MN08I9Qa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MN08I9Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706A01F000E9;
	Tue, 21 Jul 2026 19:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663660;
	bh=O9WuF7z3SRT6KB6jJhM/+6WOkHnBuqpN5lhiJkfUTe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MN08I9Qa+vp66Ezo7UBvd2GDBk7Xtg74u7GJjHuSSj2vFNOhYUKU5yXKBToMYeqjx
	 CD3KeXGDKTurUonrQcYNUoyGPdaxwYCN8HTF1j/V+Rp5kUI6TzOFHR6CXlAEKXdQkt
	 Gwzo4HlebrB1V+FPlbnrnSi2L4A1M6EnezJDCRxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 0906/1276] SUNRPC: Bound-check xdr_buf_to_bvec() stores before writing
Date: Tue, 21 Jul 2026 17:22:29 +0200
Message-ID: <20260721152506.310666438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 42f5b80dda6b86e424054baf1475df686c403d5c upstream.

xdr_buf_to_bvec() writes a bio_vec into the caller's array before
testing whether that slot is in range, and the head branch performs
the store with no check at all. When the caller's budget is exactly
used up, the next store lands one element past the end of the array.
The overflow label returns count - 1, which masks the surplus store
but cannot undo it.

rq_bvec, the array passed by nfsd_vfs_write(), is allocated to
exactly rq_maxpages entries with no slack. The OOB store can land in
adjacent slab memory; the bv_len and bv_offset fields written there
are derived from client-supplied RPC payload sizes.

Move the in-range check ahead of the store in the head, page-loop,
and tail branches. With the check at the top of each sequence, count
is incremented only after a successful store, so the overflow label
can return count directly.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 2eb2b9358181 ("SUNRPC: Convert svc_tcp_sendmsg to use bio_vecs directly")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xdr.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -180,6 +180,8 @@ unsigned int xdr_buf_to_bvec(struct bio_
 	unsigned int count = 0;
 
 	if (head->iov_len) {
+		if (unlikely(count >= bvec_size))
+			goto bvec_overflow;
 		bvec_set_virt(bvec++, head->iov_base, head->iov_len);
 		++count;
 	}
@@ -193,25 +195,27 @@ unsigned int xdr_buf_to_bvec(struct bio_
 		while (remaining > 0) {
 			len = min_t(unsigned int, remaining,
 				    PAGE_SIZE - offset);
+			if (unlikely(count >= bvec_size))
+				goto bvec_overflow;
 			bvec_set_page(bvec++, *pages++, len, offset);
 			remaining -= len;
 			offset = 0;
-			if (unlikely(++count > bvec_size))
-				goto bvec_overflow;
+			++count;
 		}
 	}
 
 	if (tail->iov_len) {
-		bvec_set_virt(bvec, tail->iov_base, tail->iov_len);
-		if (unlikely(++count > bvec_size))
+		if (unlikely(count >= bvec_size))
 			goto bvec_overflow;
+		bvec_set_virt(bvec, tail->iov_base, tail->iov_len);
+		++count;
 	}
 
 	return count;
 
 bvec_overflow:
 	pr_warn_once("%s: bio_vec array overflow\n", __func__);
-	return count - 1;
+	return count;
 }
 
 /**


