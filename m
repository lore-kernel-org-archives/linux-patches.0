Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A6F7C6E9;
	Mon,  8 Apr 2024 13:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584638; cv=none; b=jTL6IXpPGM+a74Xf9BDq7YuwxmaNsoqgc4Q6BWkELKjGA174TsqRZCR6VVT7FMwA2/QkYZ7fw0+blbkGSvVFbcyC0pSZnNeHw0Xs9A8+fwAvCZ4uTg+bASbUIQdEj5pHz+vORaVHEjZhA6KNIuEfZTiDkm2se5geovUH98qBJ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584638; c=relaxed/simple;
	bh=5dQzNBCsGfepDH+wff7mc+xqldI9aH0Q9/I15NXPfNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nit2AMzk+YNxKQpeHCxJ4XuTTIhoWk+AZnAVPRFVwW9gS54AJ7hRYKzPQRNa8bwsJQ7WQ/YQuK9JUGHUJP6AOZACWjKF8Xizy6ENvH8R3hHXu02sxnI+ktQ2BJVnmg1266w0FAS9lBZ2t6bn2yDclifqS59/OLsNRGc7L7Ge19k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIBFZFqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIBFZFqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF62EC433F1;
	Mon,  8 Apr 2024 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584638;
	bh=5dQzNBCsGfepDH+wff7mc+xqldI9aH0Q9/I15NXPfNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIBFZFqDaDDoa/3RMaBpmCV1tmVo/58vS6UYR7t1dgnaOIKp9Sfart+GVPipwIRND
	 9ZEKs5GOgW1M+kcN5I9xh+yjSixWNvQJGCpLg6JoHKrzxjLQz0Q5+/AlCryFD7ALFI
	 vahA2srcAnrOx0tDLy0q7ziu0FF8tqM1gPRHpshA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 506/690] NFSD: add CB_RECALL_ANY tracepoints
Date: Mon,  8 Apr 2024 14:56:12 +0200
Message-ID: <20240408125417.978144421@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 638593be55c0b37a1930038460a9918215d5c24b ]

Add tracepoints to trace start and end of CB_RECALL_ANY operation.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
[ cel: added show_rca_mask() macro ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c      |  2 ++
 fs/nfsd/trace.h          | 50 ++++++++++++++++++++++++++++++++++++++++
 include/trace/misc/nfs.h | 12 ++++++++++
 3 files changed, 64 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1705aeb2a1b8e..8bb75adbd4e6a 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2876,6 +2876,7 @@ static int
 nfsd4_cb_recall_any_done(struct nfsd4_callback *cb,
 				struct rpc_task *task)
 {
+	trace_nfsd_cb_recall_any_done(cb, task);
 	switch (task->tk_status) {
 	case -NFS4ERR_DELAY:
 		rpc_delay(task, 2 * HZ);
@@ -6234,6 +6235,7 @@ deleg_reaper(struct nfsd_net *nn)
 		list_del_init(&clp->cl_ra_cblist);
 		clp->cl_ra->ra_keep = 0;
 		clp->cl_ra->ra_bmval[0] = BIT(RCA4_TYPE_MASK_RDATA_DLG);
+		trace_nfsd_cb_recall_any(clp->cl_ra);
 		nfsd4_run_cb(&clp->cl_ra->ra_cb);
 	}
 }
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index eb155e98a9dc2..f8eaef5b319eb 100644
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
@@ -1563,6 +1566,32 @@ TRACE_EVENT(nfsd_cb_offload,
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
@@ -1602,6 +1631,27 @@ DEFINE_NFSD_CB_DONE_EVENT(nfsd_cb_notify_lock_done);
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
diff --git a/include/trace/misc/nfs.h b/include/trace/misc/nfs.h
index 09ffdbb04134d..0d9d48dca38a8 100644
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
-- 
2.43.0



