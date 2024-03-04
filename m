Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBD81EB5A;
	Mon,  4 Mar 2024 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589130; cv=none; b=HU5aUnxWaJYaTvOmL7akk7TGl9EyxCc5gKbq+yr8tELqQdSwMw35rP39YoDCKJe4URfmAtOPQnJrsyohY0GTIj1tc/XsEkhGgiNt4fTX1IvzGgXqzfDIOb++9XDpr/mLuLhEZYu+8K845JYmGe7P8jVeR6094rwqA5oN7UuA+0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589130; c=relaxed/simple;
	bh=ayZQnL6EvrPfImgG4OiUK4wNRmVSYu0ai2MQLvCLJ9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjZV60QcskCcN66UY2J6I+lbOPuG8wqNGF61QfRMabWaxtGOHh7Sqr4U8gKtGsR3PSYW1kTN0eYqH6lLMZAJ216NaxXztERbnLBUjk0podW217glnQXwhymbf+pWVuHQaaYkFppDBJwKVfFtOkoZkorq44ONi8ipSPIM0BZ9sro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRr339sQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRr339sQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A7FC433C7;
	Mon,  4 Mar 2024 21:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589129;
	bh=ayZQnL6EvrPfImgG4OiUK4wNRmVSYu0ai2MQLvCLJ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRr339sQrZf3d5QWFrFHn/uyYsiio//6EFgdSrbzj1rUakxwastHLZcwJkkbo+Hh1
	 7MrV+8eLnZ8VZt9HlZz0QyZupQGLlBYLoDN5Uimoe6hnn+2v6DziY72yv+5vTfpGQI
	 TeZrR/aGZuhZIvj726vrRctS4ZWg+M3pZibxfs+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 173/215] NFSD: add CB_RECALL_ANY tracepoints
Date: Mon,  4 Mar 2024 21:23:56 +0000
Message-ID: <20240304211602.434774424@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 638593be55c0b37a1930038460a9918215d5c24b ]

Add tracepoints to trace start and end of CB_RECALL_ANY operation.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
[ cel: added show_rca_mask() macro ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c      |    2 +
 fs/nfsd/trace.h          |   50 +++++++++++++++++++++++++++++++++++++++++++++++
 include/trace/misc/nfs.h |   12 +++++++++++
 3 files changed, 64 insertions(+)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2877,6 +2877,7 @@ static int
 nfsd4_cb_recall_any_done(struct nfsd4_callback *cb,
 				struct rpc_task *task)
 {
+	trace_nfsd_cb_recall_any_done(cb, task);
 	switch (task->tk_status) {
 	case -NFS4ERR_DELAY:
 		rpc_delay(task, 2 * HZ);
@@ -6254,6 +6255,7 @@ deleg_reaper(struct nfsd_net *nn)
 		list_del_init(&clp->cl_ra_cblist);
 		clp->cl_ra->ra_keep = 0;
 		clp->cl_ra->ra_bmval[0] = BIT(RCA4_TYPE_MASK_RDATA_DLG);
+		trace_nfsd_cb_recall_any(clp->cl_ra);
 		nfsd4_run_cb(&clp->cl_ra->ra_cb);
 	}
 }
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -9,9 +9,12 @@
 #define _NFSD_TRACE_H
 
 #include <linux/tracepoint.h>
+#include <linux/sunrpc/xprt.h>
+#include <trace/misc/nfs.h>
 
 #include "export.h"
 #include "nfsfh.h"
+#include "xdr4.h"
 
 #define NFSD_TRACE_PROC_RES_FIELDS \
 		__field(unsigned int, netns_ino) \
@@ -1492,6 +1495,32 @@ TRACE_EVENT(nfsd_cb_offload,
 		__entry->fh_hash, __entry->count, __entry->status)
 );
 
+TRACE_EVENT(nfsd_cb_recall_any,
+	TP_PROTO(
+		const struct nfsd4_cb_recall_any *ra
+	),
+	TP_ARGS(ra),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(u32, keep)
+		__field(unsigned long, bmval0)
+		__sockaddr(addr, ra->ra_cb.cb_clp->cl_cb_conn.cb_addrlen)
+	),
+	TP_fast_assign(
+		__entry->cl_boot = ra->ra_cb.cb_clp->cl_clientid.cl_boot;
+		__entry->cl_id = ra->ra_cb.cb_clp->cl_clientid.cl_id;
+		__entry->keep = ra->ra_keep;
+		__entry->bmval0 = ra->ra_bmval[0];
+		__assign_sockaddr(addr, &ra->ra_cb.cb_clp->cl_addr,
+				  ra->ra_cb.cb_clp->cl_cb_conn.cb_addrlen);
+	),
+	TP_printk("addr=%pISpc client %08x:%08x keep=%u bmval0=%s",
+		__get_sockaddr(addr), __entry->cl_boot, __entry->cl_id,
+		__entry->keep, show_rca_mask(__entry->bmval0)
+	)
+);
+
 DECLARE_EVENT_CLASS(nfsd_cb_done_class,
 	TP_PROTO(
 		const stateid_t *stp,
@@ -1531,6 +1560,27 @@ DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_notify
 DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_layout_done);
 DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_offload_done);
 
+TRACE_EVENT(nfsd_cb_recall_any_done,
+	TP_PROTO(
+		const struct nfsd4_callback *cb,
+		const struct rpc_task *task
+	),
+	TP_ARGS(cb, task),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__field(int, status)
+	),
+	TP_fast_assign(
+		__entry->status = task->tk_status;
+		__entry->cl_boot = cb->cb_clp->cl_clientid.cl_boot;
+		__entry->cl_id = cb->cb_clp->cl_clientid.cl_id;
+	),
+	TP_printk("client %08x:%08x status=%d",
+		__entry->cl_boot, __entry->cl_id, __entry->status
+	)
+);
+
 #endif /* _NFSD_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
--- a/include/trace/misc/nfs.h
+++ b/include/trace/misc/nfs.h
@@ -360,6 +360,18 @@ TRACE_DEFINE_ENUM(IOMODE_ANY);
 		{ IOMODE_RW,			"RW" }, \
 		{ IOMODE_ANY,			"ANY" })
 
+#define show_rca_mask(x) \
+	__print_flags(x, "|", \
+		{ BIT(RCA4_TYPE_MASK_RDATA_DLG),	"RDATA_DLG" }, \
+		{ BIT(RCA4_TYPE_MASK_WDATA_DLG),	"WDATA_DLG" }, \
+		{ BIT(RCA4_TYPE_MASK_DIR_DLG),		"DIR_DLG" }, \
+		{ BIT(RCA4_TYPE_MASK_FILE_LAYOUT),	"FILE_LAYOUT" }, \
+		{ BIT(RCA4_TYPE_MASK_BLK_LAYOUT),	"BLK_LAYOUT" }, \
+		{ BIT(RCA4_TYPE_MASK_OBJ_LAYOUT_MIN),	"OBJ_LAYOUT_MIN" }, \
+		{ BIT(RCA4_TYPE_MASK_OBJ_LAYOUT_MAX),	"OBJ_LAYOUT_MAX" }, \
+		{ BIT(RCA4_TYPE_MASK_OTHER_LAYOUT_MIN),	"OTHER_LAYOUT_MIN" }, \
+		{ BIT(RCA4_TYPE_MASK_OTHER_LAYOUT_MAX),	"OTHER_LAYOUT_MAX" })
+
 #define show_nfs4_seq4_status(x) \
 	__print_flags(x, "|", \
 		{ SEQ4_STATUS_CB_PATH_DOWN,		"CB_PATH_DOWN" }, \


