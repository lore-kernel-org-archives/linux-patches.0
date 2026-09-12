Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A8B455626;
	Sat, 12 Sep 2026 13:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220313; cv=none; b=s/LwHP8TH3PtPpdtXUdAvKtN97ScRbiLcGLlRbYPG3jEYYe4l7vBc0OUQFSwmIv/Ft+R/Q9+59CGloSYOt+tnc55HKNty2k1juDP+j8RQG/QTWw1gkGqZnFidj1lWepIWW2zlHUtLlx/s46pT62x57uclgZIYzyJHJBE1LqlY08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220313; c=relaxed/simple;
	bh=CkaBs4BWtucAFUBcEY+5yiH/5oZQhjNB6L7TgRZ593E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8V8075+Rzb1VE6PT3ctpsjuExUHZCPPXWHeM9BGhLMjqO8Ml6iEdDetLIQ1oDP5kVQgUh+dqaaVCsXkdXrngo2QA0vpm6ayILqObE4lZoECUfnCapv/w+GU6UOWj0Vo6F5QSqTeZfdXMkippeOeiVdmcHZRheLsqUc5CaEePNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5wNVrQU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5wNVrQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2AB1F000FF;
	Sat, 12 Sep 2026 13:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220312;
	bh=BCXPxpfQ+WX+hr+cP0ucjG/N1iODltTyBxYRWqylgiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5wNVrQUOzI1yIesEtZOeN8Z/UUi3JpCHKWp87DV0bp6+hpT3G1TAJYkqPJ/4j+w3
	 2nyF0dsWzCQDqa7G3Q7wvhjsg5gBvyOt+0E+KE7ALy7ZGdY+fmQzBA37f7FJA07GNh
	 HEOehoRS+QhTlXVUSCX99ubqewbrO7YN47aTH5B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0150/1424] SUNRPC: Zero rpc_gss_wire_cred at svcauth_gss_decode_credbody() entry
Date: Sat, 12 Sep 2026 08:43:02 +0200
Message-ID: <20260912065610.655668267@linuxfoundation.org>
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
@@ -1583,6 +1583,9 @@ svcauth_gss_decode_credbody(struct xdr_s
 	u32 body_len;
 	__be32 *p;
 
+	/* Early-return paths leave deterministic state, not stale residue. */
+	memset(gc, 0, sizeof(*gc));
+
 	p = xdr_inline_decode(xdr, XDR_UNIT);
 	if (!p)
 		return false;


