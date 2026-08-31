Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FAC4A8FEB;
	Mon, 31 Aug 2026 13:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183956; cv=none; b=AsBPc2xpYa02AcA9vfDPtxmt/g9gFTWC3V4uJZ3hs0Ch2E9xIso8jq1sgUpIolgYJ2FaI9Y/rSPvALMEzSalxZNIpvvX60WVd78pb1IUePMjhzHq2coQLuhfHfyhPbeZiO2MOjLxSb+lDozzAGsr4ypvoKEAxoCWC2xBk1zOMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183956; c=relaxed/simple;
	bh=zkYofZZQEwCxF/i1lVYQytgE13GVlA7jDYqA/+ByxsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpM3ktvaABWhkUqdcxratnCUJmS1BP6dxE3idP/MZ89fIRjfYoiva/P6LsIvYhYm/eVZ+g5Z2jYPfxh7f1WD71bQKYytG9RnsUZKhTLt+X/vleeEemAK9u6Y7P+xGJWyd30vocGM8ElX/F7/peqACaU0U69ZEeBIOKeFIN2klLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hEj3CSAq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hEj3CSAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674081F00ACA;
	Mon, 31 Aug 2026 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183953;
	bh=qY5EmaKrMSLMF7iAAluBbO2kKjmPNjfCNhHPGjk4TBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hEj3CSAqjwoYm3pK/VGSUSXT3tZFDkl6kjJbjLRdS0FD3f05U53jtMYl3DURLDROA
	 Pmdhdg+UpXa9i2I9Qr4t7que5/sjppnf6zhOwEEli7vaGtE8f4OmhXXhzBjreCQP2B
	 Y50aKhk1Vlcsedo6IQA+rq43PV61vNWq4JyWKh4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 22/83] io_uring/rsrc: improve regbuf iov validation
Date: Mon, 31 Aug 2026 15:33:58 +0200
Message-ID: <20260831133400.381169281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 2e02f9efdbc6c73544e315b7eb85e55a59776b6f ]

Deduplicate io_buffer_validate() calls by moving the checks into
io_sqe_buffer_register(). Now we also don't need special handling in
io_buffer_validate() passing through buffer removal requests. I also
was using it as a cleanup before some other changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: cd305ee3633a ("io_uring: defer eventfd signaling when queued from a wakeup handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -94,20 +94,6 @@ int io_validate_user_buf_range(u64 uaddr
 	return 0;
 }
 
-static int io_buffer_validate(struct iovec *iov)
-{
-	/*
-	 * Don't impose further limits on the size and buffer
-	 * constraints here, we'll -EINVAL later when IO is
-	 * submitted if they are wrong.
-	 */
-	if (!iov->iov_base)
-		return iov->iov_len ? -EFAULT : 0;
-
-	return io_validate_user_buf_range((unsigned long)iov->iov_base,
-					  iov->iov_len);
-}
-
 static void io_release_ubuf(void *priv)
 {
 	struct io_mapped_ubuf *imu = priv;
@@ -317,9 +303,6 @@ static int __io_sqe_buffers_update(struc
 			err = -EFAULT;
 			break;
 		}
-		err = io_buffer_validate(iov);
-		if (err)
-			break;
 		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
@@ -788,8 +771,17 @@ static struct io_rsrc_node *io_sqe_buffe
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!iov->iov_base)
+	if (!iov->iov_base) {
+		if (iov->iov_len)
+			return ERR_PTR(-EFAULT);
+		/* remove the buffer without installing a new one */
 		return NULL;
+	}
+
+	ret = io_validate_user_buf_range((unsigned long)iov->iov_base,
+					 iov->iov_len);
+	if (ret)
+		return ERR_PTR(ret);
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
@@ -895,9 +887,6 @@ int io_sqe_buffers_register(struct io_ri
 				ret = PTR_ERR(iov);
 				break;
 			}
-			ret = io_buffer_validate(iov);
-			if (ret)
-				break;
 			if (ctx->compat)
 				arg += sizeof(struct compat_iovec);
 			else


