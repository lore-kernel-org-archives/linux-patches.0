Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B35249219A;
	Sat, 12 Sep 2026 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239638; cv=none; b=IQYEZafNQXjy2tK04PTsE0xp/9tP11kSlN4Leu7YvG9mQmQ+thut2k6MQYXtAsvpQF9Dx1foQluJYkuIzH055vHsQGYjVLJz0Jcjqx1tiBZSrZtrL4yCcgmBzbwhbpn30DZ5h53YBmWH4PNjFWN2T+zf+J9njemLfMAbbnBwbGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239638; c=relaxed/simple;
	bh=hJ2238ZiF1z0BO0/7N0tw+axdvWhRC5kV2k3OO+SzAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFkHJJGvXCWkgZ/YQjn6G9wUzte6pnbX73njtOsb5PrOwprlSGt3EpuYKGR8Y7miBtT25zb0WXp0e/VO3+PdHp0K1H7ipDiDswnNinrKs5N0oXxrN8CH08Avl2szdc9drrFkHdaRgsS97Cig0tLl2G8EwtiYC0uVRqSqPJxL/ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkjX15g8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkjX15g8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC17E1F000FF;
	Sat, 12 Sep 2026 19:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239633;
	bh=vl2feJwOD0ENmGkON36T5eX55j+vt1enopq/oZgGmKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkjX15g8rdNYBzbaHOhqdfIvk4gIYmqw+lVzD3Ex6C0xVrxUbSZou5qDBRQ49zgxw
	 01qRVf19il9XxR0b19v1JrHjqeZZbrb4h23+kimdUk33tVC73jqKl+pNL9E0O2HFIH
	 tz4wHjUYSol58oumgaDXEGXpFon1NT7d6AhjElp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 703/935] RDMA/srp: fix heap information leak on a truncated SRP_CRED_REQ
Date: Sat, 12 Sep 2026 09:02:13 +0200
Message-ID: <20260912065542.961022966@linuxfoundation.org>
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
index bc10eca37c244..a517869456119 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1942,7 +1942,8 @@ static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp,
 		ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
 		if (rsp->tag == ch->tsk_mgmt_tag) {
 			ch->tsk_mgmt_status = -1;
-			if (be32_to_cpu(rsp->resp_data_len) >= 4)
+			if (be32_to_cpu(rsp->resp_data_len) >= 4 &&
+			    byte_len >= sizeof(*rsp) + 4)
 				ch->tsk_mgmt_status = rsp->data[3];
 			complete(&ch->tsk_mgmt_done);
 		} else {
@@ -2042,13 +2043,20 @@ static int srp_response_common(struct srp_rdma_ch *ch, s32 req_delta,
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
@@ -2056,14 +2064,21 @@ static void srp_process_cred_req(struct srp_rdma_ch *ch,
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
@@ -2105,11 +2120,11 @@ static void srp_recv_done(struct ib_cq *cq, struct ib_wc *wc)
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



