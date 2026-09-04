Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6994156F0;
	Fri,  4 Sep 2026 05:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499353; cv=none; b=YRA9EI4+0apVxuausESSNgQRyl/EYzLRJ5rSGQB/5Rm1zxJQI6oW2fOc7gpiT54UUEMMXJyTSJehD6PsBBdCKyQEFIBiUaReydEXoEz3FVQoB8XmtoruCNk5cqQxjd8yoFl8RJOd+Ht+ceRzUpvaRhZfYGw8F2pTrslclAfg6cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499353; c=relaxed/simple;
	bh=Zkel/7Zfdqa04IsDYzKHnG540e36ic9a/mba6EwLQJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEI/vNCC3hhWlyUYJNWd4k1FqSQ0GtpPukCicsZIz4rBMtsZyE8NdtGTiQjQpJg33kJR7qteevOIFRboXVH42JRWki73+zUZTC1a4LAZqxVuq5SzaxXWqNsGYa/YNLc80UTCPnb7aIl4gJ4ytPzNiUDrkRpLr96P46mMUub8n/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCbavjaP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCbavjaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26481F00A3D;
	Fri,  4 Sep 2026 05:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499352;
	bh=ayCTKDVP28wmMNAD4U0L5F7ivNxZXl1p6eA1Fkwvrj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCbavjaP8fLF96AvAInp5vwUCp9PeJY0WfWXk+P85lzp/uz914cuV3YXlSV6G6lPY
	 T9vgwkC+hJPhDYS6PezziOXgbKGhC/knyCvs0vY6x6rrPry76D24S6AVy+8dfj6y32
	 lIjes//NprPRL/Pu/FJOvdKmvT6wHFanrLzLcIJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 386/713] SUNRPC: Reject krb5 v2 wrap tokens with oversized ec field
Date: Fri,  4 Sep 2026 06:55:54 +0200
Message-ID: <20260904045812.476770647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit ad484748eec0a66eac0f13ab53b3fbedb7333c91 upstream.

gss_krb5_unwrap_v2() sets buf->len to a logical
length, which can be much smaller than head[0].iov_len
(the allocated receive-page capacity).  It then calls
xdr_buf_trim() with a trim length derived from the 16-bit
"extra count" (ec) field in the Kerberos v2 token header.

The ec field is authenticated by the post-decrypt memcmp()
against the encrypted header copy, so a randomly-mutated
value is rejected.  However, any peer holding a valid GSS
context can legitimately encrypt a token whose ec exceeds
the plaintext length.  Per RFC 4121, such a token is
structurally malformed.

Although xdr_buf_trim() now clamps the buf->len subtraction
to avoid unsigned underflow, the buffer is still left in a
semantically invalid state (zero length, inconsistent iov
lengths) when ec is oversized.

Reject these tokens before calling xdr_buf_trim(), giving
callers a well-defined GSS_S_DEFECTIVE_TOKEN error and
keeping the xdr_buf internally consistent.  The wrapped blob
begins at a nonzero offset -- both callers pass len as
offset + opaque_len -- so buf->len still counts the offset
bytes that precede the blob.  Compare the trim length
against the remaining wrapped segment, buf->len - offset,
rather than the whole buffer; comparing against buf->len
alone leaves an offset-wide window in which an oversized ec
passes the test and xdr_buf_trim() cuts into the bytes ahead
of the blob.

Fixes: cf4c024b9083 ("sunrpc: trim off EC bytes in GSSAPI v2 unwrap")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-tier2-v1-1-d026a1415e0b@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/gss_krb5_wrap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -235,6 +235,8 @@ gss_krb5_unwrap_v2(struct krb5_ctx *kctx
 	buf->len = len - (GSS_KRB5_TOK_HDR_LEN + headskip);
 
 	/* Trim off the trailing "extra count" and checksum blob */
+	if (ec + GSS_KRB5_TOK_HDR_LEN + tailskip > buf->len - offset)
+		return GSS_S_DEFECTIVE_TOKEN;
 	xdr_buf_trim(buf, ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
 
 	*align = XDR_QUADLEN(GSS_KRB5_TOK_HDR_LEN + headskip);


