Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4392F260C;
	Sat, 12 Sep 2026 19:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241265; cv=none; b=BtPqt3O66LwirUxjfvRoK+8C/HR91LTRvPOw6Mg5KMK+kfVpPnI63eUY1G5wg7wUHlgJ1ThiIQTtSEiiUUijyk2DsPHau8J/y7zttwXbIn027e28mdfQnm3AYg3+nvit3QK3Hm4UVL+2acRwFcz/RzUENhYzvJW+76dfm/lWu8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241265; c=relaxed/simple;
	bh=SbgRChH2EOo0ptC85KcISSV3hORtKnYrfedBhUdmUTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0T2+/QJMhR85Q+OKdS2aXcxuoSoE6qnb1MkBGtLXTFB8n58tg/AwxFr20B5uNCZMYtqm+qeBRFy4iwfCOQGeZMlJpKkf3B6M+ct5cdCWil/wYNpaxMyOeNxP0IAtJbwGpNz0AGd/d38P6R78f1KH16EOgX+aAoam8lK6QDkMWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6q5uLjI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6q5uLjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0941F000FF;
	Sat, 12 Sep 2026 19:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241264;
	bh=2vhzwHmzKiUfMj/J/WtOxek+vLLT2v0Ep2R3sMA0asI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6q5uLjIgM/LMpJuF4vR0fLddAJs99e3b6oFII7qgHM6dwNMdSkHlwMeGinw9STkB
	 HRnbkvO2vbFscqAjAzCeGGNj/MYbS5LqmTvb3MUfLPQ0n1wUOA/uRoH4i/c8cy70g4
	 ByKdq5U+L+d4lGqYyYa8ZD25Aywctre69M21cmeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 098/798] SUNRPC: Guard svcauth_gss_release() dispatch on rq_auth_stat
Date: Sat, 12 Sep 2026 08:55:26 +0200
Message-ID: <20260912065519.204167166@linuxfoundation.org>
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

commit f8870b9b75afb77986bc65940a231d54068ff2b1 upstream.

svcauth_gss_release() reads gc_proc and switches on gc_svc before
consulting rq_auth_stat.  On the SVC_DENIED path after a failed
svcauth_gss_accept(), those fields may hold stale values from a
prior request or uninitialized slab residue: svcauth_gss_accept()
allocates gss_svc_data with non-zeroing kmalloc and clears only
gsd_databody_offset and rsci per request, not clcred.

Because RPC_GSS_PROC_DATA is zero, a zeroed or stale-zero gc_proc
passes the existing guard and falls through into the gc_svc switch,
which can dispatch to svcauth_gss_wrap_integ() or
svcauth_gss_wrap_priv().  Both wrap helpers call
svcauth_gss_prepare_to_wrap() before any rsci->mechctx dereference,
and that helper already returns early when rq_auth_stat is not
rpc_auth_ok, so the downstream NULL dereference is blocked.  The
dispatch itself remains structurally wrong: it reads scalars that
the caller has no contract to have initialized after a failed
authentication.

Mirror the existing rq_auth_stat gate in
svcauth_gss_prepare_to_wrap() one frame up, so
svcauth_gss_release() skips the clcred dispatch entirely when
authentication has not succeeded.  The cleanup tail that releases
rq_client, rq_gssclient, cr_group_info, and rsci still runs.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <clm@meta.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-tier2-v1-4-d026a1415e0b@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1835,6 +1835,8 @@ svcauth_gss_release(struct svc_rqst *rqs
 
 	if (!gsd)
 		goto out;
+	if (rqstp->rq_auth_stat != rpc_auth_ok)
+		goto out;
 	gc = &gsd->clcred;
 	if (gc->gc_proc != RPC_GSS_PROC_DATA)
 		goto out;


