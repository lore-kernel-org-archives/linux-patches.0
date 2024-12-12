Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B19153365;
	Thu, 12 Dec 2024 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022590; cv=none; b=rOluFge8oVIB2bloLhBefGBuUvF2K296AW2fhVIsWZkF1IDu7ziHLoKMZZqTsNf/+dwr3qpEhYSj+AWXqvWfJz8hdaW0eG3jdWwOJ4qqCR5CorSR280NzLuxF/Ep+oBnCJInbUpyS2/gJBdnaeRnUGxovw1dUuveUe14JmHUdPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022590; c=relaxed/simple;
	bh=ZaKUh52b2Ph1riNa7uE82ZKAY4Zfu7/UahxvyDkllKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYjS6b2NXU7otJko69g7UX9O1nMJSpsvx2NeLktQ2T7QRJiQ0CzuutIoBd+sNItY/Jn5umjfE1Vumo8Fi26wH9bi2WJpXbIFcDFz5IiMW+f6TJSOGc//DvAZYBuoyUaK2ERhXsiBndQxlq8xqn8o1ZZD18curBlFptxT8PI7WAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7bw7hbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7bw7hbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2E6C4CECE;
	Thu, 12 Dec 2024 16:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022590;
	bh=ZaKUh52b2Ph1riNa7uE82ZKAY4Zfu7/UahxvyDkllKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7bw7hbdA7eZRCOmAKpseajfjxsRM68cbuW1pCiGjjumtScZp3ABsCZjohDIpHUaH
	 n3zfGvJf1HGWVKdSTmmyhMDDweVDmua97o4sbg5EVvnAU4JdGIkSAM2NktgAVe6LEu
	 1xWv5CS+L74gE6wyMjf0+x/hYTFXm32wMOgqk/q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/565] svcrdma: Address an integer overflow
Date: Thu, 12 Dec 2024 15:57:30 +0100
Message-ID: <20241212144321.553747661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9a80d3be1f635..adfe05f19060a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -477,7 +477,13 @@ static bool xdr_check_write_chunk(struct svc_rdma_recv_ctxt *rctxt)
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



