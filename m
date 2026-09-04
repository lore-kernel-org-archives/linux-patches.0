Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D8E41D106;
	Fri,  4 Sep 2026 05:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499305; cv=none; b=Zu3evootck0VIVqA9vpFlRQn0qsmwT9sWKE1ZI6DfAaGHjvZcNgUohfax29fyQkejLewzGufsl919Ld/w9xfHeEefiq9argqkHyJIvkSthlZsywbe0wHl45xiJLmimKftGvuXOhAauUqpwQtPLMWYAupBXiE+O2o8J3EuWTSGBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499305; c=relaxed/simple;
	bh=8QpCv7X6jvtfeMhtQF3MjIoJtY6viGFHaUmlIsRUZig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZndRk0kZYQQjV31/4bvubTIzZSNwBSC6CkxP11kLCeqKdoJpW0uhRT2WEBZTf4Kx1/7gVfl+pLb7LOSrxz3DQR6NHgvI0PEFWcNtBarF1nnBX7iiM7e6bJAX3nfHfm7e5/WpgSFvJoAgOqQ3b90gt/39YsrG8H8HO3s6xeLJeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQn0Y6gk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQn0Y6gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D006A1F00A3D;
	Fri,  4 Sep 2026 05:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499304;
	bh=ZxfL2aDdE0zzL01mWe96Tvacxamh9Xrd8rIpNvqiwxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQn0Y6gkutnJzvL/PNKfjK/k5aIxVj894dSd0sE78gETNMmdjCvfrwTxYfc+1tR1X
	 UXHbea5AXKXOPMl2q7VjrzZfy+08S7389NLq0uumrHXOu4ZyWGvdlcaxhbZzqE3Jdp
	 RL/tTu9ZFy/mhIN+fUdY0R0uwR9TW3kEE/WTxZ8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 371/713] SUNRPC: Zero rpc_gss_wire_cred at svcauth_gss_decode_credbody() entry
Date: Fri,  4 Sep 2026 06:55:39 +0200
Message-ID: <20260904045812.143382283@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 11539e8fcce0b0af062ae5fecf7b3676c2f7aeed upstream.

svcauth_gss_decode_credbody() writes the caller's
rpc_gss_wire_cred field by field and assigns gc_ctx.len only on
the success tail.  The caller storage is svcdata->clcred, which
lives in the per-svc_rqst gss_svc_data and is reused across
requests.  Early decode failures leave partially decoded state
mixed with residue from the prior request.

The trailing body_len tightness check is the sharpest case:
xdr_stream_decode_opaque_inline() has already written gc_ctx.data
with a borrowed inline pointer into the current request's XDR
pages, but gc_ctx.len retains its prior value.  Once the request
pages are released the pooled clcred carries a dangling pointer
paired with a stale length.

Zero the caller's rpc_gss_wire_cred at function entry so that
every early-return path leaves a deterministic all-zero cred.
On the trailing tightness-check path, gc_ctx.len is now zero
instead of stale, which neuters length-driven consumers such as
gss_svc_searchbyctx() that would otherwise walk the dangling
data pointer.

Fixes: b0bc53470d1a ("SUNRPC: Convert the svcauth_gss_accept() pre-amble to use xdr_stream")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-tier2-v1-5-d026a1415e0b@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1573,6 +1573,9 @@ svcauth_gss_decode_credbody(struct xdr_s
 	u32 body_len;
 	__be32 *p;
 
+	/* Early-return paths leave deterministic state, not stale residue. */
+	memset(gc, 0, sizeof(*gc));
+
 	p = xdr_inline_decode(xdr, XDR_UNIT);
 	if (!p)
 		return false;


