Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A6C37E2F3;
	Sat, 12 Sep 2026 19:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241274; cv=none; b=sOoO9/NMXW3D7jdtp+MmUQEqCzde/L49cjepvqf9nD5kByTVlPyvUIPcJ6xqNT7EZ2b9AI1STxdZrWE8m5XeteoLDfYb26fmAiaacg1mJ9PFueNFplSXTz3N06S4MgvYzRna67E5nHuVcQzgSy0MPN2MuiRZiNPf4xbXgH9wT2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241274; c=relaxed/simple;
	bh=T62fS0F6Nwg4yvao7JqTH3zM09jAIoGiaDPIAxtZCQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fg9UE2bgeKKlpuB5obsOx1+R/pNIl39g9yMuMUCQu0LlL7g+RVGFbqa7h96FAazWM2rhbdeC+MX1UfpAXbVRWUkzso5EUnWyOsY2+NEWYExX2St8ABfy3gXc9LsmsXnS0F00ACUw/Mkb3usBMqnoeaNgBNQm3Rnz1yLCahT2LN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQmlGpvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQmlGpvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59CD1F00893;
	Sat, 12 Sep 2026 19:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241273;
	bh=J3IGl8WYwSS344ctCG5hn98fxqdkRtVUG4/tuZSSyt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQmlGpvIxIHNls3nDBhTnmyKNkj6kSi8rVW5TQCRzQ+c7daU9mPBsg3dTVcqc145w
	 N1nNjbi5ybwTlc4SJo/T87yrq/vJdgJTkBbWHy2ThXxFU5bWHdF6j/ElP9qPQd2mvV
	 AM2EUs04eJsTOZG2P/DwHz0pmA5maefwwueXwZjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 100/798] SUNRPC: harden gss_unwrap_resp_priv length checks
Date: Sat, 12 Sep 2026 08:55:28 +0200
Message-ID: <20260912065519.247672578@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 87831b92112c81db251d46756d65daa4f91af6a2 upstream.

gss_unwrap_resp_priv() validates the RPCSEC_GSS opaque length with

    offset = (u8 *)(p) - (u8 *)head->iov_base;
    if (offset + opaque_len > rcv_buf->len)
            goto unwrap_failed;
    maj_stat = gss_unwrap(ctx->gc_gss_ctx, offset,
                          offset + opaque_len, rcv_buf);

Both operands are u32 and the sum is computed in u32. A reply with
opaque_len near 0xffffffff makes offset + opaque_len wrap to a small
value that is below rcv_buf->len, so the bound check passes and
gss_unwrap() is called with end < begin. The check also lacks a
lower bound, so any opaque_len in [0, GSS_KRB5_TOK_HDR_LEN) is
accepted and forwarded to gss_krb5_unwrap_v2(), whose pre-decrypt
header reads at ptr+4 and ptr+6 then run past the token.

A krb5p NFS server returning a crafted RPCSEC_GSS reply can drive
the client into out-of-bounds reads in gss_krb5_unwrap_v2() and the
rotate_left() loop that follows.

Fix by replacing the single combined check with three guards that
are safe in u32 arithmetic and that enforce the RFC 4121 minimum
outer token length:

    if (offset > rcv_buf->len)
            goto unwrap_failed;
    if (opaque_len > rcv_buf->len - offset)
            goto unwrap_failed;
    if (opaque_len < GSS_KRB5_TOK_HDR_LEN)
            goto unwrap_failed;

The first guard makes the subtraction in the second guard
unconditionally safe; offset is derived from a successful
xdr_inline_decode() in the head kvec, so in practice it already
satisfies the bound. The floor mirrors the server-side check added
in commit 5b757c2e57a5 ("SUNRPC: svcauth_gss: enforce krb5 token
minimum length").

Fixes: 2d2da60c63b6 ("RPCSEC_GSS: client-side privacy support")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260524010213.557424-3-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/auth_gss.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -2050,7 +2050,11 @@ gss_unwrap_resp_priv(struct rpc_task *ta
 		goto unwrap_failed;
 	opaque_len = be32_to_cpup(p++);
 	offset = (u8 *)(p) - (u8 *)head->iov_base;
-	if (offset + opaque_len > rcv_buf->len)
+	if (offset > rcv_buf->len)
+		goto unwrap_failed;
+	if (opaque_len > rcv_buf->len - offset)
+		goto unwrap_failed;
+	if (opaque_len <= GSS_KRB5_TOK_HDR_LEN)
 		goto unwrap_failed;
 
 	maj_stat = gss_unwrap(ctx->gc_gss_ctx, offset,


