Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3940876;
	Mon,  1 Apr 2024 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990044; cv=none; b=IZmOGBLaIHdKg+BFir4fsc4ozvef486bSkA6ZisqKrPrfqITutsHgBYGHnVe8ptc/WWvpMlw95RNixhnF0RT7D7s9fVhzg5vJMzTOcdIesrNhpIBoHaiBMD4b6y2uujt1D564rtMoNnWVsRF94DzEd3wZCkzW2jSe4bm6C/t/CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990044; c=relaxed/simple;
	bh=Wnolj0mJMs5sg6Ua++1OuPK7GB2Xn+RDQjVbZcfFtHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6ty1A2VxE3sgOFzqS3HkRUMPHHelAou5L9Zbe9+LCAbwR5rf25gLwAKbP9IvfjO2ojlqCEk1/uRoP5WSLPx1L+lCe8Fl8QjswlqfwAk5U/TqnkTr6gde9zRRehdDAJnG1o20AEJcYP3Yb1VDhrrJjM4yaRr2aZludaKsIMeYTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCVN247K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCVN247K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE05C433F1;
	Mon,  1 Apr 2024 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990043;
	bh=Wnolj0mJMs5sg6Ua++1OuPK7GB2Xn+RDQjVbZcfFtHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCVN247KhWH7128e5hvetIlFgatxgXT+QMBYQEKRDicUdYBHp2ftZneteWYa3Rq9K
	 OgFmYpvPwbim0arp+1qmzEoAofO12Y7mlb6ivr3SUoHHvHFMDkpjNhHzsMOYvLh9qe
	 tsfiTbbLylEF3/Rpt1YxyxOineZV7CBfZrcZlPTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 229/396] misc: fastrpc: Pass proper arguments to scm call
Date: Mon,  1 Apr 2024 17:44:38 +0200
Message-ID: <20240401152554.747199023@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit a283d7f179ff83976af27bcc71f7474cb4d7c348 upstream.

For CMA memory allocation, ownership is assigned to DSP to make it
accessible by the PD running on the DSP. With current implementation
HLOS VM is stored in the channel structure during rpmsg_probe and
this VM is passed to qcom_scm call as the source VM.

The qcom_scm call will overwrite the passed source VM with the next
VM which would cause a problem in case the scm call is again needed.
Adding a local copy of source VM whereever scm call is made to avoid
this problem.

Fixes: 0871561055e6 ("misc: fastrpc: Add support for audiopd")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240224114247.85953-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -263,7 +263,6 @@ struct fastrpc_channel_ctx {
 	int domain_id;
 	int sesscount;
 	int vmcount;
-	u64 perms;
 	struct qcom_scm_vmperm vmperms[FASTRPC_MAX_VMIDS];
 	struct rpmsg_device *rpdev;
 	struct fastrpc_session_ctx session[FASTRPC_MAX_SESSIONS];
@@ -1279,9 +1278,11 @@ static int fastrpc_init_create_static_pr
 
 		/* Map if we have any heap VMIDs associated with this ADSP Static Process. */
 		if (fl->cctx->vmcount) {
+			u64 src_perms = BIT(QCOM_SCM_VMID_HLOS);
+
 			err = qcom_scm_assign_mem(fl->cctx->remote_heap->phys,
 							(u64)fl->cctx->remote_heap->size,
-							&fl->cctx->perms,
+							&src_perms,
 							fl->cctx->vmperms, fl->cctx->vmcount);
 			if (err) {
 				dev_err(fl->sctx->dev, "Failed to assign memory with phys 0x%llx size 0x%llx err %d",
@@ -1915,8 +1916,10 @@ static int fastrpc_req_mmap(struct fastr
 
 	/* Add memory to static PD pool, protection thru hypervisor */
 	if (req.flags == ADSP_MMAP_REMOTE_HEAP_ADDR && fl->cctx->vmcount) {
+		u64 src_perms = BIT(QCOM_SCM_VMID_HLOS);
+
 		err = qcom_scm_assign_mem(buf->phys, (u64)buf->size,
-			&fl->cctx->perms, fl->cctx->vmperms, fl->cctx->vmcount);
+			&src_perms, fl->cctx->vmperms, fl->cctx->vmcount);
 		if (err) {
 			dev_err(fl->sctx->dev, "Failed to assign memory phys 0x%llx size 0x%llx err %d",
 					buf->phys, buf->size, err);
@@ -2290,7 +2293,6 @@ static int fastrpc_rpmsg_probe(struct rp
 
 	if (vmcount) {
 		data->vmcount = vmcount;
-		data->perms = BIT(QCOM_SCM_VMID_HLOS);
 		for (i = 0; i < data->vmcount; i++) {
 			data->vmperms[i].vmid = vmids[i];
 			data->vmperms[i].perm = QCOM_SCM_PERM_RWX;


