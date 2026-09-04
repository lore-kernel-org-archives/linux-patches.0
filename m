Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936BB30C366;
	Fri,  4 Sep 2026 05:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501094; cv=none; b=sv9433UJsL5cejBVmuvtRDrt4B+7Xwd2K1t+F7EwNxsfr0t8YdF9NRX9TcUEv4WbrVsDBrc5KzKVCV0SCaMXd/YbLs7UhJo7x9PnQ5aherLe1xDtixhfQj6RK5dAyp3pumwXe6XluL4bH82HzMHlm0fqo5M4pYVKdfoJpFbCf2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501094; c=relaxed/simple;
	bh=F+0+dCxMUB7jzcYWXZUufBVTqKCuUWzirTQw7vG5lqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfk4hp5PYgRNFLAuO888TYsrh9YqBlISDksj/VNkdAdFdwk2sIU8ZHl8TVmTcyAhVOZouTr8q52gnJD1L7NnZkkGQhm0ZZDl5hhMziJEyXKGeGW62DEe0VQ167qXDZg86yflZIj0LbCVnYK3SP4L2upBAcHgs3YgzQyOmgHFKt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teNnoZ/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teNnoZ/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEA11F00A3D;
	Fri,  4 Sep 2026 05:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501093;
	bh=euGUTaNwOJJbgjZ5aRToFHJ1UXyuks5CaB7tyhcNSbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teNnoZ/BpIvZAq60kgout0O/GZ6K6vyiYUbiW0cu9pgtpzdD9ruLfv40u0jjmnrnu
	 9qtQjcWpgIvfkUpIHRrBONpgC6yhLySgR1ppZE+LQ+7ZwjUc0CiMZoqUD0MSUhVIFM
	 HDP3U8p6AOYRvpoe0dF37M86u+4gT6yfwuab64Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 287/552] SUNRPC: harden gss_unwrap_resp_priv length checks
Date: Fri,  4 Sep 2026 06:57:24 +0200
Message-ID: <20260904045756.463032333@linuxfoundation.org>
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
@@ -2074,7 +2074,11 @@ gss_unwrap_resp_priv(struct rpc_task *ta
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


