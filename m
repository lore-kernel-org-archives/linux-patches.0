Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF44D402BAB;
	Tue, 21 Jul 2026 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654451; cv=none; b=khfCm5T+jF/6sW1/Bcr0RzorItUW8wvd6wzMAU2pk077G6L+ArwSsNYJvrcO3HEsJ3FTeLZ7FDjyadngt2qbIQOUBzSwBFysqpN6ExKKp1/Z/WVbI1u7UlNHPdleqo95llVKaxDIJJ/hDXInK3Bvu9lTma2bJsSga4R0yCdjKTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654451; c=relaxed/simple;
	bh=Fn+/ykaycwop0bFPXn7/jXtLyCznoUnoeKdf92CUKYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRe8RAsyypuyFYuR+urECBYx0unROJkX4H57uAtjxmvF4E/MpdiWg4i58MYORrn66mLL2t0nayukx0VjDkkJWuefA9fkICGNnD8zrnN8YbwmsTSJR6M7jsGvqwLDlAWMFnQMr0+BjtKyt8yQu0jjMzIkDQauvtJr1kSkIK3WjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeJiR9XT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeJiR9XT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4368F1F000E9;
	Tue, 21 Jul 2026 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654449;
	bh=bXUa+1RzUZRCwnn7yGoCeFs/LllYz3b1BQJUYK6E6nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeJiR9XTS9vdTmFAlgkjJp+MhdTrwdL3z7/7cPFbjjtzoXHuYtBxdWl96c9R/XRmj
	 qWboV5C9xV8NI7XKE8edXWHKaMreuQ3R1Xg0t1+QnHBiUSlWi8Rly7zgFn7xbSHt8O
	 ZIgBJEJnrLLzRTfMXI66g5cazUBEwjI2RmS6IJVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.1 1666/2077] SUNRPC: Bound-check xdr_buf_to_bvec() stores before writing
Date: Tue, 21 Jul 2026 17:22:19 +0200
Message-ID: <20260721152632.039200471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -152,6 +152,8 @@ unsigned int xdr_buf_to_bvec(struct bio_
 	unsigned int count = 0;
 
 	if (head->iov_len) {
+		if (unlikely(count >= bvec_size))
+			goto bvec_overflow;
 		bvec_set_virt(bvec++, head->iov_base, head->iov_len);
 		++count;
 	}
@@ -165,25 +167,27 @@ unsigned int xdr_buf_to_bvec(struct bio_
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
 EXPORT_SYMBOL_GPL(xdr_buf_to_bvec);
 


