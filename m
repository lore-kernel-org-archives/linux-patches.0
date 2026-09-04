Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7693242BD;
	Fri,  4 Sep 2026 05:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501066; cv=none; b=N6MDpZcVDj2RlqSgOBQQsd4CbaK26YSACnxDrBzp6SiRdkictHwckY4m0xceE21jaP+hFOIVLTUMBbfwML+98t/owQO7epxcynvwX+R91QYA3OlD85mgH7aFXlSdNNbAfjPwx1oPBXbKQE6ZdsWCfm8gP1Kj4kQV+SiKCyGLJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501066; c=relaxed/simple;
	bh=mz+ZdfSqSyif1+ss9ZNnD3dsaJImoQ5MuS7z1jcjr6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ti1wOboiKBlvVqRrJpPfMrB5cq4c9MwKM6lVYUcBBvL/MB/K8WcmYV7tgqqk/1ievLlBAP2G+byR2l81HzKEhOXIqaSTvOZ4X78xWR4++z7ozrllzXKcN5NH1ubpwULnyTPQ+vH+msiCQxrzDZ3wk1e1x3bLFmf13U85YxMwoIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+UlYzul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+UlYzul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D35E1F00A3D;
	Fri,  4 Sep 2026 05:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501065;
	bh=IOAHyRePeYaSR2F/WISD9h9AagcadyrtTu4hc4AgCf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+UlYzulHNtE5AS9nIJDZRlm9EEDYZu1XNpD8V4XoGTCCUAUEwuGpWbI4bXhiY+C1
	 6i87Udcruu5BBmzPvwkthbHPhpQNzcQlZRPNYmZ/90kuGgo7gg/r/TDYWYpvnnOcts
	 sbLfHDqp9HfzZxboqwqrQAhHtZDInOrgkwHiJVxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 278/552] SUNRPC: svcauth_gss: enforce krb5 token minimum length
Date: Fri,  4 Sep 2026 06:57:15 +0200
Message-ID: <20260904045756.271340000@linuxfoundation.org>
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
@@ -949,6 +949,8 @@ svcauth_gss_unwrap_priv(struct svc_rqst
 	}
 	if (len > xdr_stream_remaining(xdr))
 		goto unwrap_failed;
+	if (len <= GSS_KRB5_TOK_HDR_LEN)
+		goto unwrap_failed;
 	offset = xdr_stream_pos(xdr);
 
 	saved_len = buf->len;


