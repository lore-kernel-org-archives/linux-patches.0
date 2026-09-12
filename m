Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3B2418A5B;
	Sat, 12 Sep 2026 13:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220318; cv=none; b=ua8li9xmHkK4a5JPVw5WgDc44FU1yzOXkQui0IzP7pUGRjNqUQkCSl1DdAR38vUD7iYcq55bDjbQaj0b7fPqYDv+V3ylhaf+RAW1h9WsDakmFfjcZZauAC/IX6qi2Cly1uTMzGMqYwNU10aN5A7OZZOMaBFXFhu0Y+E7ol7ix/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220318; c=relaxed/simple;
	bh=WHFcCYDkUzh/W9fb7lH30JYZRwjrhmxnAVC/WE5V9aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UptuePLPdAJBWR6v05NbaYRiL/JfrhWPpYnPNzoNOPmPISFMClqVMr4L5sqQHiSyEpftd13xSfkXEkQwNsg1sx70NBFfsK3PgvULDwgEs3PlAq+cH9DCrCjUhunWaTVtnEhv5jNJFoIEJlgkI156Hazf4/xgpfG/Xq40oJHyZGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMcaGNqT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMcaGNqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AFA1F000FF;
	Sat, 12 Sep 2026 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220317;
	bh=GDhlMpQGjzvqsUkk3ngQZpMsm+9QNkJ5JISCH0Lorc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMcaGNqTTpp1dfjo58KA7TR0AlojJ37fGZrWuAMfiK9xr4Kjcys6irKGZaqvW4Y+G
	 bTqn3G5aLkd4KmVW3rXYV6CY/0zjHUXd5snLic/VpllV7omO4F8EvyRvLR86PkN6wy
	 wSQMUXhCilQUiIRWQBrexPYdnrVYGCK4mE9mO1Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0151/1424] SUNRPC: svcauth_gss: enforce krb5 token minimum length
Date: Sat, 12 Sep 2026 08:43:03 +0200
Message-ID: <20260912065610.678088680@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@meta.com>

commit a919c5c88769cf8fb3ec071e6078d830bf512489 upstream.

svcauth_gss_unwrap_priv() validates only an upper bound on the
wire-supplied opaque length before handing the buffer to
gss_unwrap():

    if (len > xdr_stream_remaining(xdr))
            goto unwrap_failed;
    offset = xdr_stream_pos(xdr);
    ...
    maj_stat = gss_unwrap(ctx, offset, offset + len, buf);

The wire value `len` flows unchanged as the upper bound into the
krb5 unwrap path, so a len in [0, 16] passes this check and is
handed to gss_unwrap(). For a krb5 v2 context that lands in
gss_krb5_unwrap_v2(), which reads the 16-byte RFC 4121 token
header fields at ptr+4 and ptr+6 and then calls rotate_left()
before any integrity check. With a sub-header length the header
reads run past the token, and _rotate_left()'s `shift %= buf->len`
path can divide by zero when buf->len has been driven to zero by
the truncated token. A header-only token (len == 16) is equally
invalid: with a non-zero RRC field and the opaque blob ending at
the XDR buffer boundary, rotate_left() builds a zero-length
subbuffer, reaching the same division.

Reject the token at the server entry point before it reaches the
krb5 unwrap core. A valid sealed RFC 4121 token must contain
the 16-byte header plus at least some encrypted payload.

Fix by adding a minimum-length check immediately after the
existing upper-bound check:

    if (len <= GSS_KRB5_TOK_HDR_LEN)
            goto unwrap_failed;

Fixes: 7c9fdcfb1b64 ("[PATCH] knfsd: svcrpc: gss: server-side implementation of rpcsec_gss privacy")
Cc: stable@vger.kernel.org
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260524010213.557424-2-cel@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -959,6 +959,8 @@ svcauth_gss_unwrap_priv(struct svc_rqst
 	}
 	if (len > xdr_stream_remaining(xdr))
 		goto unwrap_failed;
+	if (len <= GSS_KRB5_TOK_HDR_LEN)
+		goto unwrap_failed;
 	offset = xdr_stream_pos(xdr);
 
 	saved_len = buf->len;


