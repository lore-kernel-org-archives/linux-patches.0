Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB3A3B42F7;
	Fri,  4 Sep 2026 06:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502423; cv=none; b=ZxymccyXDwh0pOMP0LEVmhGQoqAthpfGatq/ucjU/DuBJu9hXE55kZOdUoiwS2EEjECCYqLqiZDMY+JiJ8h3i4HkIBybT6f456xtMD98BXq2eLNRvQyLQzHyo+LvLEjs5XhHp2xdp/4rXkNZ50Y0INoGOhdY8vogWSdtFJhY/eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502423; c=relaxed/simple;
	bh=wz3ys0AUY0TFDSaYvpY+c6Wd7dr4iH/VYDT+HPHPGMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATMsyjS0ukGyjTwzz1Tem/L4sHwgfJy4WRu39ouZsoLT2menlgoY+zeG7faS6SHeVF2HarbdqlLCIwwyKiO4W+OlpZrH6+1EucqvT2fGrY+mjiKEY/kRpXKDi2TwODnRXMunExVZ7cytJ4WSY2FWpEs2I21VqtP1E7+IhvzQLkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA3wOIpD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA3wOIpD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E591F00A3D;
	Fri,  4 Sep 2026 06:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502422;
	bh=C38+aIaC9nVkIk9k6hKWkwpjbPT8fy4Td2lojidhNl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA3wOIpDskoDHi/GO4CXMeIiYNrcbpTnsHomhEIfTu+kPCUvGjs74kvyWQirhOyNo
	 CFWZQinNdG1DPXJKqlkwqQvAf+n/WnLs8IM0xM32SctpfhOFY7yS6Nmf8hMbc5X4Il
	 9LBECGEtEEniNDD8gJ29DITmgpx7vpZwFy6FjBPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 202/403] SUNRPC: Zero rpc_gss_wire_cred at svcauth_gss_decode_credbody() entry
Date: Fri,  4 Sep 2026 07:00:05 +0200
Message-ID: <20260904045739.447318699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


