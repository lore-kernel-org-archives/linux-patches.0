Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C67D168C3F;
	Thu, 12 Dec 2024 17:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025506; cv=none; b=XNzjkx2B8BIfPlejXeB8RpSO2zdkm9Xu0LrYVTxT2tdwYcS+vuasOwzH3SAWB5Y9RP4yGq+ByFw9NDeeXF6DwxtgeCqOnteE577j3CN4jG5UCcgGxr9OekSRpzH7rpMLzEs+oGjrIQq72+OGbN3ir5AnOATLJJQLaeweOzntoJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025506; c=relaxed/simple;
	bh=FWpu0a2KpvG4/z6ipzsavYle9JlpQBR+/8emFzwD83U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ps9enxXlR6gtYcHzRWsv+7+bBchUxgLO1vDheEebSNGvQr30DpeWc1+bnM17vU6ZELkpA6JBAwY5v9Y6uFNT0RhQJgXfCgfZpqRT5GE5IyP8o1HlEfq5axqN13FxtwVC+Ddopdjw0ej5S88B5yn/LYAuDfUw003W80/IfVA2uJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQXOsgPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQXOsgPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5333C4CED0;
	Thu, 12 Dec 2024 17:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025506;
	bh=FWpu0a2KpvG4/z6ipzsavYle9JlpQBR+/8emFzwD83U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQXOsgPId0XqsR3O6l8d3sv7wF1qOKSlHFofwVUaJORcNPnsHwUSJ6E6B6CApfLBw
	 cXpqTF7xoaLfNwU87Y/zAie3+Jzok+/Db4nNA2Lwvo1MmznG7paJcWxqcPdtgTytPP
	 CHovOWWElw9G6xv7qmJd0FidKw1rfp/sTyuJTcMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 175/321] NFSD: Prevent a potential integer overflow
Date: Thu, 12 Dec 2024 16:01:33 +0100
Message-ID: <20241212144236.896635325@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -285,17 +285,17 @@ static int decode_cb_compound4res(struct
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


