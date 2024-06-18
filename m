Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B3D1534E9;
	Tue, 18 Jun 2024 12:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715375; cv=none; b=XFgiD5fqFCLHPNtQoW5uq7omlGQhDc9ED/iocEf4Su2ZzuabHeN7N+an0sHUYagMy+2uer4j9UFupDrd6Rjuozb6WMORcvEIBae/h0giOZiVokqQlMYYgAe4MJmlELH7l0KF3ESWKGM1ceUgmSlEZF1p1CPXl6TRG6GrBC2GjFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715375; c=relaxed/simple;
	bh=jU0PB9nM0nM+bSbwwiJPmff9QREuJMaKVySZMJwmXck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpMm9lrGlQ8eWP1PirbT/q/eglmQeJWOKhaQlyLPudB1CnTBXuSbVbYHoRmi9lJqmPFzPIOaJruy5JbF1fbPhdaUxwl3j0mrICjDqY+ZscJa3OYGNyeblVNKvUnWa1hpY0ZJwxprz6AxThcIt475Ua6OA2gwHCH0Vmxk6UBtgQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9gyBa3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9gyBa3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3410C3277B;
	Tue, 18 Jun 2024 12:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715375;
	bh=jU0PB9nM0nM+bSbwwiJPmff9QREuJMaKVySZMJwmXck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9gyBa3UnASN7Cbyb9XUR6Q+EOZPP9OZlDrQ65UGWTQ0ZfNke/7OgnRvF/TVfMy/t
	 QJ+hbfzikAVo+HigWmEX/7gXT/Er74M9TUnu8W8AYa3DSpNQMVK+t8NZ57Ut+tanHN
	 zXuiwxyfq/otSiGjNl8TSK9F5UZ16Hnsi+7+5Cl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/770] NFSD: Remove the nfsd_cb_work and nfsd_cb_done tracepoints
Date: Tue, 18 Jun 2024 14:32:21 +0200
Message-ID: <20240618123418.379283322@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1d2bf65983a137121c165a7e69b2885572954915 ]

Clean up: These are noise in properly working systems. If you really
need to observe the operation of the callback mechanism, use the
sunrpc:rpc\* tracepoints along with the workqueue tracepoints.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c |  5 -----
 fs/nfsd/trace.h        | 48 ------------------------------------------
 2 files changed, 53 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 453f60b127ebb..59dc80ecd3764 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -972,7 +972,6 @@ static void nfsd4_cb_probe_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_client *clp = container_of(calldata, struct nfs4_client, cl_cb_null);
 
-	trace_nfsd_cb_done(clp, task->tk_status);
 	if (task->tk_status)
 		nfsd4_mark_cb_down(clp, task->tk_status);
 	else
@@ -1174,8 +1173,6 @@ static void nfsd4_cb_done(struct rpc_task *task, void *calldata)
 	struct nfsd4_callback *cb = calldata;
 	struct nfs4_client *clp = cb->cb_clp;
 
-	trace_nfsd_cb_done(clp, task->tk_status);
-
 	if (!nfsd4_cb_sequence_done(task, cb))
 		return;
 
@@ -1328,8 +1325,6 @@ nfsd4_run_cb_work(struct work_struct *work)
 	struct rpc_clnt *clnt;
 	int flags;
 
-	trace_nfsd_cb_work(clp, cb->cb_msg.rpc_proc->p_name);
-
 	if (cb->cb_need_restart) {
 		cb->cb_need_restart = false;
 	} else {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 4361a0807f070..87ac1f19bfd0b 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -979,54 +979,6 @@ TRACE_EVENT(nfsd_cb_setup_err,
 		__entry->addr, __entry->cl_boot, __entry->cl_id, __entry->error)
 );
 
-TRACE_EVENT(nfsd_cb_work,
-	TP_PROTO(
-		const struct nfs4_client *clp,
-		const char *procedure
-	),
-	TP_ARGS(clp, procedure),
-	TP_STRUCT__entry(
-		__field(u32, cl_boot)
-		__field(u32, cl_id)
-		__string(procedure, procedure)
-		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
-	),
-	TP_fast_assign(
-		__entry->cl_boot = clp->cl_clientid.cl_boot;
-		__entry->cl_id = clp->cl_clientid.cl_id;
-		__assign_str(procedure, procedure)
-		memcpy(__entry->addr, &clp->cl_cb_conn.cb_addr,
-			sizeof(struct sockaddr_in6));
-	),
-	TP_printk("addr=%pISpc client %08x:%08x procedure=%s",
-		__entry->addr, __entry->cl_boot, __entry->cl_id,
-		__get_str(procedure))
-);
-
-TRACE_EVENT(nfsd_cb_done,
-	TP_PROTO(
-		const struct nfs4_client *clp,
-		int status
-	),
-	TP_ARGS(clp, status),
-	TP_STRUCT__entry(
-		__field(u32, cl_boot)
-		__field(u32, cl_id)
-		__field(int, status)
-		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
-	),
-	TP_fast_assign(
-		__entry->cl_boot = clp->cl_clientid.cl_boot;
-		__entry->cl_id = clp->cl_clientid.cl_id;
-		__entry->status = status;
-		memcpy(__entry->addr, &clp->cl_cb_conn.cb_addr,
-			sizeof(struct sockaddr_in6));
-	),
-	TP_printk("addr=%pISpc client %08x:%08x status=%d",
-		__entry->addr, __entry->cl_boot, __entry->cl_id,
-		__entry->status)
-);
-
 TRACE_EVENT(nfsd_cb_recall,
 	TP_PROTO(
 		const struct nfs4_stid *stid
-- 
2.43.0



