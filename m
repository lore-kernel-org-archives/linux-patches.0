Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAC2356742;
	Sat, 12 Sep 2026 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231084; cv=none; b=UdWrDdF3H1cJXW8kDMRPfUI2CWeJw+ZSCfLv+G9Hr1Xig1bv+NAMpMrAUTp080GH2c2aJirHO2Fk5I59le8TdBZcPO6p+0UfFDfSjCRmrewEDBQi+9ZUewAG7R7n5qeuajYXJPSqZI/EmHT4FP15soQ0zmrbTWg/qurih/GgXbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231084; c=relaxed/simple;
	bh=X/ank3DNKQdphdJrw0sNh8NCxnxoPGTzvxBa2zVEkEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlqTnNaVie9HvxPluZmPfLdf1L/Ek9BuBdrGW8mbVzzzcz+cPk1mNOQGmwgg0rIi0vp4rYleyFPCozJxGTr1sOKSDowvne0UaS+uPE806x+HbCndpBosCWTDgjIU8WO8T1N4mucQmDaiCOvqlbkfUFjPAhvNs08kGizrPR1JlpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVnReyvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVnReyvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5134D1F000FF;
	Sat, 12 Sep 2026 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231082;
	bh=LRE3Fo6sfVVb+TOZl22vhW3UE4b3JRxVFHLQ7KHHNi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVnReyvj/HTu+CUJdpvs6xI7t0ii2XnkHgKt9QjdjAUQ07MPn3STWi2ryUtH/DNfF
	 TuQMaMekV7vJXK2szizevutluJQfJ/FvY9jmNCAmyEmphoGGCIvn7Es/kNYbdP6qbK
	 2FQi0DjW1dxBTk2Dj/+ow4jAsSDKJ3jFb6NEV4l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0873/1191] RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ
Date: Sat, 12 Sep 2026 09:00:01 +0200
Message-ID: <20260912065607.861188034@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 961ac0f0c5e414abdd6b33fae84b311d9fde0bd0 ]

srp_recv_done() passes wc->byte_len to srp_process_rsp(). It passes
nothing to srp_process_cred_req() and srp_process_aer_req(), which read
fixed-size fields from the receive buffer without checking that those
fields were received.

The buffer size is max_ti_iu_len, which comes from the login response
and is not validated. A target that advertises 8 and then sends an
8-byte SRP_CRED_REQ makes the initiator read req->tag from beyond the
end of the buffer. req->tag is copied into the SRP_CRED_RSP and sent
back, so those bytes reach the target. SRP_AER_REQ behaves the same way
and also reads req->lun.

The leak is 8 bytes per response. max_ti_iu_len also decides which slab
cache the buffer comes from. With 8 the buffer is a kmalloc-8 object and
the read is entirely outside it:

  BUG: KASAN: slab-out-of-bounds in srp_recv_done+0x172b/0x1aa0
  Read of size 8 at addr ffff888104714da8 by task kworker/u8:3/50
   which belongs to the cache kmalloc-8 of size 8
  The buggy address is located 0 bytes to the right of
   allocated 8-byte region [ffff888104714da0, ffff888104714da8)

Without KASAN the returned bytes are whatever is next in the slab. One
run returned ".strtab".

rsp->data[3] in srp_process_rsp() has the same problem: only
resp_data_len is checked before it is read.

Drop a request that is shorter than the structure being parsed, and
check byte_len before the tsk_mgmt read.

Fixes: bb12588a38e6 ("IB/srp: Implement SRP_CRED_REQ and SRP_AER_REQ")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260729093203.1503201-1-yhlee@isslab.korea.ac.kr
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 45 +++++++++++++++++++----------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6492e5f3b1047..d9acbfe24f1ec 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1948,7 +1948,8 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp,
 		ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
 		if (rsp->tag == ch->tsk_mgmt_tag) {
 			ch->tsk_mgmt_status = -1;
-			if (be32_to_cpu(rsp->resp_data_len) >= 4)
+			if (be32_to_cpu(rsp->resp_data_len) >= 4 &&
+			    byte_len >= sizeof(*rsp) + 4)
 				ch->tsk_mgmt_status = rsp->data[3];
 			complete(&ch->tsk_mgmt_done);
 		} else {
@@ -2048,13 +2049,20 @@ static int srp_response_common(struct srp_rdma_ch *ch, s32 req_delta,
 }
 
 static void srp_process_cred_req(struct srp_rdma_ch *ch,
-				 struct srp_cred_req *req)
+				 struct srp_cred_req *req, u32 byte_len)
 {
-	struct srp_cred_rsp rsp = {
-		.opcode = SRP_CRED_RSP,
-		.tag = req->tag,
-	};
-	s32 delta = be32_to_cpu(req->req_lim_delta);
+	struct srp_cred_rsp rsp = { .opcode = SRP_CRED_RSP };
+	s32 delta;
+
+	if (byte_len < sizeof(*req)) {
+		shost_printk(KERN_ERR, ch->target->scsi_host, PFX
+			     "dropping truncated SRP_CRED_REQ (%u bytes received, %zu expected)\n",
+			     byte_len, sizeof(*req));
+		return;
+	}
+
+	rsp.tag = req->tag;
+	delta = be32_to_cpu(req->req_lim_delta);
 
 	if (srp_response_common(ch, delta, &rsp, sizeof(rsp)))
 		shost_printk(KERN_ERR, ch->target->scsi_host, PFX
@@ -2062,14 +2070,21 @@ static void srp_process_cred_req(struct srp_rdma_ch *ch,
 }
 
 static void srp_process_aer_req(struct srp_rdma_ch *ch,
-				struct srp_aer_req *req)
+				struct srp_aer_req *req, u32 byte_len)
 {
 	struct srp_target_port *target = ch->target;
-	struct srp_aer_rsp rsp = {
-		.opcode = SRP_AER_RSP,
-		.tag = req->tag,
-	};
-	s32 delta = be32_to_cpu(req->req_lim_delta);
+	struct srp_aer_rsp rsp = { .opcode = SRP_AER_RSP };
+	s32 delta;
+
+	if (byte_len < sizeof(*req)) {
+		shost_printk(KERN_ERR, target->scsi_host, PFX
+			     "dropping truncated SRP_AER_REQ (%u bytes received, %zu expected)\n",
+			     byte_len, sizeof(*req));
+		return;
+	}
+
+	rsp.tag = req->tag;
+	delta = be32_to_cpu(req->req_lim_delta);
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX
 		     "ignoring AER for LUN %llu\n", scsilun_to_int(&req->lun));
@@ -2111,11 +2126,11 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		break;
 
 	case SRP_CRED_REQ:
-		srp_process_cred_req(ch, iu->buf);
+		srp_process_cred_req(ch, iu->buf, wc->byte_len);
 		break;
 
 	case SRP_AER_REQ:
-		srp_process_aer_req(ch, iu->buf);
+		srp_process_aer_req(ch, iu->buf, wc->byte_len);
 		break;
 
 	case SRP_T_LOGOUT:
-- 
2.53.0



