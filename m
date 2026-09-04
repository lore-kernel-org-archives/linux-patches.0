Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5999B3F7873;
	Fri,  4 Sep 2026 05:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501103; cv=none; b=ren4d5cbLVztqJu6QFR+3Dsediep9AmLEoN1Vt8zIp3v+tqmXd2Y7EeeZugqczVHFTsTAE8lUbPGduvQ87WvP1C2xmytAWgY7ht2U7mfnnj0pZJ8YF1/p8jCoELmB4rrMc8pHD4BgEXjqvlGjPSm8Ouf21y1hhfKRBJ2iZpFtiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501103; c=relaxed/simple;
	bh=HxYqKWFWSCWe9l8nyC17KB3vFUPaC7uo3eJSzsKPbN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjDgDNuHF768h7luE5Gy8qMbOHO3qQkmUoMK8T4pVRfte4pOo17ca7n5BBi8P+OvpDWvoM4dhVikugUlKI4s8ugtCeBpLDGPoop6vHyRLojAocHf+otmazfzyUU9yahR+g3QColaEUK7u/3Y3iqemOC25/mxVN+FxhT3KQZEXgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6nmdfnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6nmdfnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B84B1F00A3D;
	Fri,  4 Sep 2026 05:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501102;
	bh=uApguYY6rGP8xoepbDqQyUm42GjfNWPTF/pUCI1OXs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6nmdfnD7W465puRH2G6u1ptsYtN0iqwf+C0fH9IHW0eu+/oE15qcnl2aEUXJNlKE
	 cT+UsvxAReSgizDYydhouarazQ0rYEv+3yAyrti52mubBfJeqNJUBcYj2KXEEjIxWC
	 EYHsPI61Jh2xzBGoIBRiar17JGuVz4MpaV1/AZXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 290/552] SUNRPC: Reject krb5 v2 wrap tokens with oversized ec field
Date: Fri,  4 Sep 2026 06:57:27 +0200
Message-ID: <20260904045756.529787171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -236,6 +236,8 @@ gss_krb5_unwrap_v2(struct krb5_ctx *kctx
 	buf->len = len - (GSS_KRB5_TOK_HDR_LEN + headskip);
 
 	/* Trim off the trailing "extra count" and checksum blob */
+	if (ec + GSS_KRB5_TOK_HDR_LEN + tailskip > buf->len - offset)
+		return GSS_S_DEFECTIVE_TOKEN;
 	xdr_buf_trim(buf, ec + GSS_KRB5_TOK_HDR_LEN + tailskip);
 
 	*align = XDR_QUADLEN(GSS_KRB5_TOK_HDR_LEN + headskip);


