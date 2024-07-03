Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D063186280;
	Wed,  3 Jul 2024 11:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004965; cv=none; b=S3aR4yuS/qpIb02Y95xSSeW3IDjxZAwMfbPBcN8ogbru5BmtcX4JQWA0mSlP0RJG0tSgB4u/IMsgi1leAWQyHqMf+V1DElusb0E2X+94s0XDzWGvrHS2rvx4n390hH1F1X1aoi/GshPYdMYShiPXs10MyxNB2eeRmk/mLaDdObo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004965; c=relaxed/simple;
	bh=1Qh9g3zC+bKEGaSkgkNo7K9fHN2cqwfAVNUsJUHWoXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StqfLphgWXpqrZr882k1qf5z9NVhwSSuGp/ewR5sNCAkOvm1gd9o7H/UQx8bSJ5ph0KmXN2t3k7qRZgTKCYm0RsaNttfNUxys+N7D10Cx+XxGZMrhu4ZTfCFn1qIjssqBvMuKeYm9EcEj0seKu/k5KTiUDuKOYg3U5oT5K/uIqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPEATTdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPEATTdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B826BC2BD10;
	Wed,  3 Jul 2024 11:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004965;
	bh=1Qh9g3zC+bKEGaSkgkNo7K9fHN2cqwfAVNUsJUHWoXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPEATTdPV+WxGSAJd0iF4gpkX6zolPVQDv6yolpMSujCKURVejx84OUu+cyDDADGs
	 krSTq1gsG+57hIHa8IkD5IQLohveUouaC3oxGLrxbqZ0wiNJJe+UoFtynuAjErl9I7
	 LPFQYptyUWfQAGcRuCzdPjMeXljyBt6NqG4FK/ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/290] SUNRPC: Fix svcxdr_init_decodes end-of-buffer calculation
Date: Wed,  3 Jul 2024 12:39:56 +0200
Message-ID: <20240703102912.280022118@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 90bfc37b5ab91c1a6165e3e5cfc49bf04571b762 ]

Ensure that stream-based argument decoding can't go past the actual
end of the receive buffer. xdr_init_decode's calculation of the
value of xdr->end over-estimates the end of the buffer because the
Linux kernel RPC server code does not remove the size of the RPC
header from rqstp->rq_arg before calling the upper layer's
dispatcher.

The server-side still uses the svc_getnl() macros to decode the
RPC call header. These macros reduce the length of the head iov
but do not update the total length of the message in the buffer
(buf->len).

A proper fix for this would be to replace the use of svc_getnl() and
friends in the RPC header decoder, but that would be a large and
invasive change that would be difficult to backport.

Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 8583825c4aea2..f0e09427070cd 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -536,16 +536,27 @@ static inline void svc_reserve_auth(struct svc_rqst *rqstp, int space)
 }
 
 /**
- * svcxdr_init_decode - Prepare an xdr_stream for svc Call decoding
+ * svcxdr_init_decode - Prepare an xdr_stream for Call decoding
  * @rqstp: controlling server RPC transaction context
  *
+ * This function currently assumes the RPC header in rq_arg has
+ * already been decoded. Upon return, xdr->p points to the
+ * location of the upper layer header.
  */
 static inline void svcxdr_init_decode(struct svc_rqst *rqstp)
 {
 	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
-	struct kvec *argv = rqstp->rq_arg.head;
+	struct xdr_buf *buf = &rqstp->rq_arg;
+	struct kvec *argv = buf->head;
 
-	xdr_init_decode(xdr, &rqstp->rq_arg, argv->iov_base, NULL);
+	/*
+	 * svc_getnl() and friends do not keep the xdr_buf's ::len
+	 * field up to date. Refresh that field before initializing
+	 * the argument decoding stream.
+	 */
+	buf->len = buf->head->iov_len + buf->page_len + buf->tail->iov_len;
+
+	xdr_init_decode(xdr, buf, argv->iov_base, NULL);
 	xdr_set_scratch_page(xdr, rqstp->rq_scratch_page);
 }
 
-- 
2.43.0



