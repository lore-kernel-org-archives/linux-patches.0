Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404591C7B61;
	Tue, 27 Aug 2024 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772251; cv=none; b=muA9/qS8elCdxHTCtxwnTcBGxkbFMU/QmC/6cVk4bQ7vhbnXeqqmatWAGziLtGVfnGVlSl27sCLMjMawN4hdtTx1L64bLHDHwvP8NF8jtlXDgOU2HQjGp6JUbXEHYEYDIxxzGiVflQy3l69eNu/GoF3c9ixt0q+7mXH3BnXPb0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772251; c=relaxed/simple;
	bh=ZXEZFghgRImd3dTFUq79NYrHa9aROwF9hqS524swmxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtVnROP5Z42Vatyi6T/Ri++wNQ8XsoMZcs8DiCqJprjx5EXj2NuC6K9HSeq1gL6xtyyHXxrarBbLOnUplfbJhef94rfzXCt30x1X3PJnFPaRSKWAwmo6GFNFudNag29EMezKbbGaMZdwKyx2ZeHolWOTKPxUr66Crl1RPCym8Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWY1XzkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWY1XzkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FB9C61069;
	Tue, 27 Aug 2024 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772251;
	bh=ZXEZFghgRImd3dTFUq79NYrHa9aROwF9hqS524swmxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWY1XzkV4aqNhP7K0OEAoIAkVKgzcodKXpw9f9/IWdvkcU2WariZQ1eWddpD5mHLH
	 6WMaOv1BwRejvvbT5RlkjpPkFMhWp/LxmW6fnTeOL0/04lSCy5y4SdGZ24Duj7Ic11
	 xPi78KyCdq3V6eLPUpeUzPS/ECwqFBFEsrBltulE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/321] nvmet-trace: avoid dereferencing pointer too early
Date: Tue, 27 Aug 2024 16:37:46 +0200
Message-ID: <20240827143844.245876337@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 0e716cec6fb11a14c220ee17c404b67962e902f7 ]

The first command issued from the host to the target is the fabrics
connect command. At this point, neither the target queue nor the
controller have been allocated. But we already try to trace this command
in nvmet_req_init.

Reported by KASAN.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/trace.c |  6 +++---
 drivers/nvme/target/trace.h | 28 +++++++++++++++++-----------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/target/trace.c b/drivers/nvme/target/trace.c
index bff454d46255b..6ee1f3db81d04 100644
--- a/drivers/nvme/target/trace.c
+++ b/drivers/nvme/target/trace.c
@@ -211,7 +211,7 @@ const char *nvmet_trace_disk_name(struct trace_seq *p, char *name)
 	return ret;
 }
 
-const char *nvmet_trace_ctrl_name(struct trace_seq *p, struct nvmet_ctrl *ctrl)
+const char *nvmet_trace_ctrl_id(struct trace_seq *p, u16 ctrl_id)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
 
@@ -224,8 +224,8 @@ const char *nvmet_trace_ctrl_name(struct trace_seq *p, struct nvmet_ctrl *ctrl)
 	 * If we can know the extra data of the connect command in this stage,
 	 * we can update this print statement later.
 	 */
-	if (ctrl)
-		trace_seq_printf(p, "%d", ctrl->cntlid);
+	if (ctrl_id)
+		trace_seq_printf(p, "%d", ctrl_id);
 	else
 		trace_seq_printf(p, "_");
 	trace_seq_putc(p, 0);
diff --git a/drivers/nvme/target/trace.h b/drivers/nvme/target/trace.h
index 974d99d47f514..7f7ebf9558e50 100644
--- a/drivers/nvme/target/trace.h
+++ b/drivers/nvme/target/trace.h
@@ -32,18 +32,24 @@ const char *nvmet_trace_parse_fabrics_cmd(struct trace_seq *p, u8 fctype,
 	 nvmet_trace_parse_nvm_cmd(p, opcode, cdw10) :			\
 	 nvmet_trace_parse_admin_cmd(p, opcode, cdw10)))
 
-const char *nvmet_trace_ctrl_name(struct trace_seq *p, struct nvmet_ctrl *ctrl);
-#define __print_ctrl_name(ctrl)				\
-	nvmet_trace_ctrl_name(p, ctrl)
+const char *nvmet_trace_ctrl_id(struct trace_seq *p, u16 ctrl_id);
+#define __print_ctrl_id(ctrl_id)			\
+	nvmet_trace_ctrl_id(p, ctrl_id)
 
 const char *nvmet_trace_disk_name(struct trace_seq *p, char *name);
 #define __print_disk_name(name)				\
 	nvmet_trace_disk_name(p, name)
 
 #ifndef TRACE_HEADER_MULTI_READ
-static inline struct nvmet_ctrl *nvmet_req_to_ctrl(struct nvmet_req *req)
+static inline u16 nvmet_req_to_ctrl_id(struct nvmet_req *req)
 {
-	return req->sq->ctrl;
+	/*
+	 * The queue and controller pointers are not valid until an association
+	 * has been established.
+	 */
+	if (!req->sq || !req->sq->ctrl)
+		return 0;
+	return req->sq->ctrl->cntlid;
 }
 
 static inline void __assign_req_name(char *name, struct nvmet_req *req)
@@ -62,7 +68,7 @@ TRACE_EVENT(nvmet_req_init,
 	TP_ARGS(req, cmd),
 	TP_STRUCT__entry(
 		__field(struct nvme_command *, cmd)
-		__field(struct nvmet_ctrl *, ctrl)
+		__field(u16, ctrl_id)
 		__array(char, disk, DISK_NAME_LEN)
 		__field(int, qid)
 		__field(u16, cid)
@@ -75,7 +81,7 @@ TRACE_EVENT(nvmet_req_init,
 	),
 	TP_fast_assign(
 		__entry->cmd = cmd;
-		__entry->ctrl = nvmet_req_to_ctrl(req);
+		__entry->ctrl_id = nvmet_req_to_ctrl_id(req);
 		__assign_req_name(__entry->disk, req);
 		__entry->qid = req->sq->qid;
 		__entry->cid = cmd->common.command_id;
@@ -89,7 +95,7 @@ TRACE_EVENT(nvmet_req_init,
 	),
 	TP_printk("nvmet%s: %sqid=%d, cmdid=%u, nsid=%u, flags=%#x, "
 		  "meta=%#llx, cmd=(%s, %s)",
-		__print_ctrl_name(__entry->ctrl),
+		__print_ctrl_id(__entry->ctrl_id),
 		__print_disk_name(__entry->disk),
 		__entry->qid, __entry->cid, __entry->nsid,
 		__entry->flags, __entry->metadata,
@@ -103,7 +109,7 @@ TRACE_EVENT(nvmet_req_complete,
 	TP_PROTO(struct nvmet_req *req),
 	TP_ARGS(req),
 	TP_STRUCT__entry(
-		__field(struct nvmet_ctrl *, ctrl)
+		__field(u16, ctrl_id)
 		__array(char, disk, DISK_NAME_LEN)
 		__field(int, qid)
 		__field(int, cid)
@@ -111,7 +117,7 @@ TRACE_EVENT(nvmet_req_complete,
 		__field(u16, status)
 	),
 	TP_fast_assign(
-		__entry->ctrl = nvmet_req_to_ctrl(req);
+		__entry->ctrl_id = nvmet_req_to_ctrl_id(req);
 		__entry->qid = req->cq->qid;
 		__entry->cid = req->cqe->command_id;
 		__entry->result = le64_to_cpu(req->cqe->result.u64);
@@ -119,7 +125,7 @@ TRACE_EVENT(nvmet_req_complete,
 		__assign_req_name(__entry->disk, req);
 	),
 	TP_printk("nvmet%s: %sqid=%d, cmdid=%u, res=%#llx, status=%#x",
-		__print_ctrl_name(__entry->ctrl),
+		__print_ctrl_id(__entry->ctrl_id),
 		__print_disk_name(__entry->disk),
 		__entry->qid, __entry->cid, __entry->result, __entry->status)
 
-- 
2.43.0



