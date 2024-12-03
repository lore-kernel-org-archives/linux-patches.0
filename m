Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34BD17BB16;
	Tue,  3 Dec 2024 14:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236813; cv=none; b=KW/JmSRCzOmRI2rzmY1DnyXB5m60n5HwVH8J9nKyIqwuNmtxu+JnFbK4kyAMXlkzDKtIeeMgSkiz4Le03Ww4FD+1MrrCGzzFyG8FiHk+DyQA5g1ADiwt1mTWE84RI92cnBcDOMV4l+0RqrgW/OC+Gg9WulZ7XSh+NolA96VP+LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236813; c=relaxed/simple;
	bh=PfUB9fWs5la2RLWAPeZeCiRv0Z/eRDZtER/7qSvThHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRHgQwd7yIFXJuVYbRIqLeGxMDkgYP/qsXghs6PO1Wgx1wdGFlMjLHA0GQw1KmhUNUm1abBFiY/DcvsZbrit0bR+J91KQXMes2DRKaw7Eokh9ult4dgSwAB76pDaQle+QZuQVn6j8GzxikvbdKBmqKFFeQvv663sTYp30JiOW+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKmuWG9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKmuWG9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DD1C4CED6;
	Tue,  3 Dec 2024 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236813;
	bh=PfUB9fWs5la2RLWAPeZeCiRv0Z/eRDZtER/7qSvThHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKmuWG9eo9X4WsXGTbzBGFVJhhErU3n7fX+Y33/+BIbG9GlkKL6ho6hjNBzpbCKdi
	 VICJi1Z0ZCvS2gjEZ1OwYq5nwulVduDCcvDN3iUJTqLavGRzZrmb9CMnFhNoosXKm9
	 sn8SsHK41VexZ29fCpsU7BzHfnNXsc8jOLH+H/p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.19 125/138] NFSD: Prevent a potential integer overflow
Date: Tue,  3 Dec 2024 15:32:34 +0100
Message-ID: <20241203141928.349671840@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 7f33b92e5b18e904a481e6e208486da43e4dc841 upstream.

If the tag length is >= U32_MAX - 3 then the "length + 4" addition
can result in an integer overflow. Address this by splitting the
decoding into several steps so that decode_cb_compound4res() does
not have to perform arithmetic on the unsafe length value.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -283,17 +283,17 @@ static int decode_cb_compound4res(struct
 	u32 length;
 	__be32 *p;
 
-	p = xdr_inline_decode(xdr, 4 + 4);
+	p = xdr_inline_decode(xdr, XDR_UNIT);
 	if (unlikely(p == NULL))
 		goto out_overflow;
-	hdr->status = be32_to_cpup(p++);
+	hdr->status = be32_to_cpup(p);
 	/* Ignore the tag */
-	length = be32_to_cpup(p++);
-	p = xdr_inline_decode(xdr, length + 4);
-	if (unlikely(p == NULL))
+	if (xdr_stream_decode_u32(xdr, &length) < 0)
+		goto out_overflow;
+	if (xdr_inline_decode(xdr, length) == NULL)
+		goto out_overflow;
+	if (xdr_stream_decode_u32(xdr, &hdr->nops) < 0)
 		goto out_overflow;
-	p += XDR_QUADLEN(length);
-	hdr->nops = be32_to_cpup(p);
 	return 0;
 out_overflow:
 	return -EIO;


