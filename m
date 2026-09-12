Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBA639150B;
	Sat, 12 Sep 2026 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232926; cv=none; b=o3neoveLAA2b2wVlGv65vR7Ak3MlmQUrrjaIBaWoi/JURls7k98BKcw1ez36jdC9POsKzH3do2tIoGpDnCZZSsH34xmCjLG/6WYO+NzVYkBNrLE8RI12GYpaOo32DuZHx7Q8bzbJMleHk5Ss0B6i+dc2wFE9n6VD45yfmw9HiSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232926; c=relaxed/simple;
	bh=ibURjGsXCIKkfB7ZvjW/3IRWH0hy5RoaiqsmmeDEaXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CV015py8rhqdssq+5SnxSqkZMJSWEHtw+v+GWgdOSxElhZuQ/R0/NWSKi7lw8MzC4r1TCbdUSdM/i3mMHxSvgHrtw7Ly5Dl4p0CcKUOKqilieH6TzspVfOjPpyxpBSZWBerGqxe2kGT1W6bSffCDJDdTa6J2hTWtxn++Na+qkWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSqc3Djs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSqc3Djs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16581F000FF;
	Sat, 12 Sep 2026 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232924;
	bh=uWLcSSsXY3pdajMZQNAkM5WpfF0JNqaM0TvdgnmXoC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSqc3DjsBlR9AmqvMsZ0a+Up5luOCqCDm+skIDYl4XMAkxVmwp7l+n6Knuu5MjF09
	 OwD+qzgys3R9BTMUYQp7O+OqckQg4i+00nhfjMCmgbdMjrk6/cW1MGgz0DhZqC8UtR
	 vABHZAjFhKP6RsjJXde7sFIx9yU0IWyn0D0XepsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 109/935] SUNRPC: Guard svcauth_gss_release() dispatch on rq_auth_stat
Date: Sat, 12 Sep 2026 08:52:19 +0200
Message-ID: <20260912065529.317843312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


