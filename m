Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF1235C58;
	Thu, 12 Dec 2024 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019730; cv=none; b=gu13GqRovM913zSfcoU/9QNiR76BjlSBiU/ZFk6wJvsvD3D7yGKj1a3HcVlvf9EvxD9LTPj/T2JFeKjwCfGhqYnOFMwcoS+9b784N/cx7VPjUF3YSQc2YTsrxtBGe4BvKErCy6otahs2856lekbx8h/OLb6NpEdRHZq3k0SaPNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019730; c=relaxed/simple;
	bh=XD4sPBUy0hPnxs01hLQ8c44UZK/JSXqkluTh9ar5qZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HW0gfTUheEOL5+94x46p9bnpEwLYoJQiHFGSvCAtexIY0MBs/PSVXV35mBVSHlPkmcZHAmqy242SiNsB3QyUdMhQHtSOmXsbNj1n/cGZFY0ThKMkwqH77O6ROOItfk+6OCHE9wpTYDguecdIWi9qx7ykfBGYeRhFTFmVKIsMAQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/n4jvwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/n4jvwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68640C4CECE;
	Thu, 12 Dec 2024 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019730;
	bh=XD4sPBUy0hPnxs01hLQ8c44UZK/JSXqkluTh9ar5qZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/n4jvwipbJbdQHcym2Mr4JXUxFKUG4JlDMfKd1NpC/je2mkFg8Al85rAgh+sqedr
	 /c+n1ItEYhcb1j/rNBFi9wmSoxLbQtjF9mcv5HoZzq2wQWvLOZ7nuz/A9UU/6Adlel
	 qGF3YNh3v0AI40OlgsM8RVH94eUESM00iAsPcBZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 282/772] svcrdma: Address an integer overflow
Date: Thu, 12 Dec 2024 15:53:47 +0100
Message-ID: <20241212144401.555883880@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2dd01e5274e9..186c9c12432b1 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -482,7 +482,13 @@ static bool xdr_check_write_chunk(struct svc_rdma_recv_ctxt *rctxt)
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



