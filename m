Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FAF381AF1;
	Sat, 12 Sep 2026 19:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241309; cv=none; b=Zp2lkLSOT27Ywz01D1FfFp/WQppgh/B6jUpdaFeMri+vL1zjYqfQpSGVsEyNDj1pJsTu0gMI2DRf43jzJyMfnMJ083hOwxbnPwam1qeHfY0FVomuxrnJpCM+8AfYC9Fi27WTmaDBK4IOyWhUhgJnUfshp/ZDp6/h7IeB5/zXaJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241309; c=relaxed/simple;
	bh=vi6WeGOwQ7AKsK7uJfTFL51cN4QrjkneAslvq0y9W44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJZlG5gAqnRQE0YRFJ5cObeKX7BKFuE8Eyreo6ZCi/xHX2GSnh9D3vs5p61s6tWzhxNRke25+ws84dIbHm23LEe5HjNR6TBX5YxMMfcQkZAigHBwCUjnLMVt/AAoVMHy9Ux8ncKX8uZ5GopqT1aD8iN8fnhJ3yZxeTSOBuJW53w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LV7PXJRB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LV7PXJRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF8C1F00898;
	Sat, 12 Sep 2026 19:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241307;
	bh=E0QeU85SYgprVVwa3GIZZ9JwWkjVQnLj5BrFJFYOlHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LV7PXJRBpH9NpeibGjsDnsPk2Glfm7WHpgLnNk5rFKQUV3Ugrl8lWKxC2PHOHVt4w
	 tgxHJox8C3DYhL9xfMct3toc0y6yt2PYF056uWqAR54yYGDaQBoXBz8eGGAcCAhc7s
	 0C3KfRI4BsI943G7r9vyEEUGNVjWEgrXln/3eWEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 102/798] SUNRPC: Reject krb5 v2 wrap tokens with oversized ec field
Date: Sat, 12 Sep 2026 08:55:30 +0200
Message-ID: <20260912065519.294116168@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -557,6 +557,8 @@ gss_unwrap_kerberos_v2(struct krb5_ctx *
 	buf->len = len - (GSS_KRB5_TOK_HDR_LEN + headskip);
 
 	/* Trim off the trailing "extra count" and checksum blob */
+	if (ec + GSS_KRB5_TOK_HDR_LEN + tailskip > buf->len - offset)
+		return GSS_S_DEFECTIVE_TOKEN;
 	xdr_buf_trim(buf, ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
 
 	*align = XDR_QUADLEN(GSS_KRB5_TOK_HDR_LEN + headskip);


