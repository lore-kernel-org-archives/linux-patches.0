Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8641823CE;
	Tue,  3 Dec 2024 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241888; cv=none; b=qHkq8LlkoNNlyd9Cx1oE/YfhtEm71hZt6L8VHZmPOrnoBpOaeplgHkz9T1f51bkK/FaYrpOUxFDnvFJ1jrrHET9xZ2FTY0+knPUAT7D01nDKZrV2oGHErvKYqANkiBuo3KHa7MFy25Tk0AFR+7JVR5yu2M8X8WPYpIl4lHHlbTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241888; c=relaxed/simple;
	bh=PfWCZpqWlwY33BPic0cW9bdU0kAcfBG63b3ErhJ0bqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2yK8jJJ2F/42o16tkmCGzH19fGKE5Ty7Z/HJuiA0YRgVeHc5QOCBvmKQfTC1TjmiGQH4mnhsdlsEDvHjLp3k06PCDb08Jdby9bl9yKKGnAymtyOJ7vz+W5RZB05r1+Ralv/R6Ky8LGTTyovtvL5tslsxtvsFmEPlLSO2x3wpP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHALDG0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHALDG0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3116C4CECF;
	Tue,  3 Dec 2024 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241888;
	bh=PfWCZpqWlwY33BPic0cW9bdU0kAcfBG63b3ErhJ0bqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHALDG0ODvRWwqvLZRryGj+8hz3+pQWGoLcyOVfyygBzAz7C6WbzgWwcoB3Msu4+q
	 9LN7kdKMb0M9E09h1RayN5lS9rt3zNXk1GdXn5ECUL7YogTzkgG7ywz5pAOJXkXAN7
	 IWPLpHCt2YetaXGX1dEGdJ7ZHST0oq128j1o27Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 513/826] svcrdma: Address an integer overflow
Date: Tue,  3 Dec 2024 15:44:00 +0100
Message-ID: <20241203144803.768272966@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3c63d8946e578663b868cb9912dac616ea68bfd0 ]

Dan Carpenter reports:
> Commit 78147ca8b4a9 ("svcrdma: Add a "parsed chunk list" data
> structure") from Jun 22, 2020 (linux-next), leads to the following
> Smatch static checker warning:
>
>	net/sunrpc/xprtrdma/svc_rdma_recvfrom.c:498 xdr_check_write_chunk()
>	warn: potential user controlled sizeof overflow 'segcount * 4 * 4'
>
> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
>     488 static bool xdr_check_write_chunk(struct svc_rdma_recv_ctxt *rctxt)
>     489 {
>     490         u32 segcount;
>     491         __be32 *p;
>     492
>     493         if (xdr_stream_decode_u32(&rctxt->rc_stream, &segcount))
>                                                               ^^^^^^^^
>
>     494                 return false;
>     495
>     496         /* A bogus segcount causes this buffer overflow check to fail. */
>     497         p = xdr_inline_decode(&rctxt->rc_stream,
> --> 498                               segcount * rpcrdma_segment_maxsz * sizeof(*p));
>
>
> segcount is an untrusted u32.  On 32bit systems anything >= SIZE_MAX / 16 will
> have an integer overflow and some those values will be accepted by
> xdr_inline_decode().

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 78147ca8b4a9 ("svcrdma: Add a "parsed chunk list" data structure")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index ae3fb9bc8a216..292022f0976e1 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -493,7 +493,13 @@ static bool xdr_check_write_chunk(struct svc_rdma_recv_ctxt *rctxt)
 	if (xdr_stream_decode_u32(&rctxt->rc_stream, &segcount))
 		return false;
 
-	/* A bogus segcount causes this buffer overflow check to fail. */
+	/* Before trusting the segcount value enough to use it in
+	 * a computation, perform a simple range check. This is an
+	 * arbitrary but sensible limit (ie, not architectural).
+	 */
+	if (unlikely(segcount > RPCSVC_MAXPAGES))
+		return false;
+
 	p = xdr_inline_decode(&rctxt->rc_stream,
 			      segcount * rpcrdma_segment_maxsz * sizeof(*p));
 	return p != NULL;
-- 
2.43.0



