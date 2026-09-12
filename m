Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246F94BEE5E;
	Sat, 12 Sep 2026 15:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227186; cv=none; b=r0+Bl7c3Nx6QPTS/7J0l2k/Hc9l8Yio05M6Wh+hes+d9ADbdmuzFEnD4W6SaNXWbQ5VX5jEaE6o1U35D7WGkbhoApuxUexa6x69qqPWo7iZiMYVA1LmspC8POi0Hfj2EmCZwkjY3n+ISsfy0uoKIn0HSg3GTGDZLqlissm/mDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227186; c=relaxed/simple;
	bh=pCGph0h3TUX9VrJSL9VDoD3/HiH1afNTp9Ib+BKn4f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzXx7NPHYcgy3DBT7TOq1WLQXrdIgmBY4qlMmj3FjChJHtz4sfO5nP+b6ukSeEmoAtJRpOU6KELtwuu9FxuHsnpGRJE7Cus/YCIVRcj63ox/40VIOmeDNfXMktn9buJBadAX8ftLCNVO/aedb75hBNF1FvrtxQAXnsVQ8LZf5qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0IeLm3D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0IeLm3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C0C1F000FF;
	Sat, 12 Sep 2026 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227185;
	bh=E0AgTIUHwwAjYf2aCOZUgRE/+rr/LT9rBduv4bGnQ5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0IeLm3D71SVfe2UlnihViPr1Vq5anrQwMRJL5ZeP8PUG30wChzp3rNOGp6ypwhBP
	 U/heYtofuenhRf5BWuYHksWByXGuSdpn1FKegXEYKJKatL+/dj2ZGUAnWbk+LDmLWM
	 6efZd8rtCsvOvTIwayw8YxkSDcaYXNTg1HzR0yG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 0129/1191] SUNRPC: Guard svcauth_gss_release() dispatch on rq_auth_stat
Date: Sat, 12 Sep 2026 08:47:37 +0200
Message-ID: <20260912065551.091817069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1837,6 +1837,8 @@ svcauth_gss_release(struct svc_rqst *rqs
 
 	if (!gsd)
 		goto out;
+	if (rqstp->rq_auth_stat != rpc_auth_ok)
+		goto out;
 	gc = &gsd->clcred;
 	if (gc->gc_proc != RPC_GSS_PROC_DATA)
 		goto out;


