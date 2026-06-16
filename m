Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DDE43E490;
	Tue, 16 Jun 2026 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625682; cv=none; b=OJol5mqBnlbP6A4SF/pxvBpWz/d4hBSSAuGgWo4WALIX8Yb2HGTYNz8v7gwhqzDcnQMkD1J6Nvqf04qitGB77A0wS4XzovCdhqV4if7KxZyKRZmhGeExqlDEWwBhH7q9PX12jsZS5ISPFCHCK0at2jrbAnZP9opxXGbsZKYGd+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625682; c=relaxed/simple;
	bh=HhjNQyef5jqr0bfZ8sTPLaR07lHjuFiSh++JZU6A7xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYSC13JJ2ylvfzfCPyI+YJBdPf7Krq4hp1HdcCh8ujISFGyy5tzmma4iwXuke7nTV6V2kYsF1J8MjXYUpIfCKMzeO2x5QOBKsOTdcBYmruT/KGOF8FxBhf5AL67r3SywKukBEmPsR8azaeDZExx9fsPZ9HoiVXOQGii7H4S/xmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RefHcdBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RefHcdBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1F91F000E9;
	Tue, 16 Jun 2026 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625680;
	bh=OOss+QLRfBNZSGmMgMNpsen11+Tspj65LwktzXkaTbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RefHcdBEFAanZMsmi2ml5XpoofAbGEIWmC4bE794ZAHIuakc7GHO47GoMaGcLft5I
	 IRF2VRotOvXDMKmQUnJt2k8a4FDQ+27Cp/BgWdeRf48hPIEakebnlTYfro4yY6LyuZ
	 TinOmEv/neIXKdf/RJwxn8x8dhC6YbvDjEkqyNsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 188/325] RDMA/srp: bound SRP_RSP sense copy by the received length
Date: Tue, 16 Jun 2026 20:29:44 +0530
Message-ID: <20260616145107.273833393@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 13e91fd076306f5d0cdfa14f53d69e37274723c4 upstream.

srp_process_rsp() copies sense data from rsp->data + resp_data_len,
where resp_data_len is the full 32-bit value supplied by the SRP target
and is never checked against the number of bytes actually received
(wc->byte_len). The copy length is bounded to SCSI_SENSE_BUFFERSIZE, so
at most 96 bytes are copied, but the source offset is not bounded.

A malicious or compromised SRP target on the InfiniBand/RoCE fabric that
the initiator has logged into can return an SRP_RSP with
SRP_RSP_FLAG_SNSVALID set and a large resp_data_len. The receive buffer
is allocated at the target-chosen max_ti_iu_len, so the source of the
sense copy lands past the bytes actually received; with resp_data_len
near 0xFFFFFFFF it is gigabytes past the buffer and the read faults.

Copy the sense data only if it has not been truncated, that is, only if
the response header, the response data, and the sense region fit within
the bytes actually received; otherwise drop the sense and log. The
in-tree iSER and NVMe-RDMA receive paths already bound their parse by
wc->byte_len; this brings ib_srp into line with them.

Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
Link: https://patch.msgid.link/r/20260602220457.2542840-1-michael.bommarito@gmail.com
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1930,7 +1930,8 @@ static int srp_post_recv(struct srp_rdma
 	return ib_post_recv(ch->qp, &wr, NULL);
 }
 
-static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp)
+static void srp_process_rsp(struct srp_rdma_ch *ch, struct srp_rsp *rsp,
+			    u32 byte_len)
 {
 	struct srp_target_port *target = ch->target;
 	struct srp_request *req;
@@ -1971,10 +1972,27 @@ static void srp_process_rsp(struct srp_r
 		scmnd->result = rsp->status;
 
 		if (rsp->flags & SRP_RSP_FLAG_SNSVALID) {
-			memcpy(scmnd->sense_buffer, rsp->data +
-			       be32_to_cpu(rsp->resp_data_len),
-			       min_t(int, be32_to_cpu(rsp->sense_data_len),
-				     SCSI_SENSE_BUFFERSIZE));
+			u32 resp_len = be32_to_cpu(rsp->resp_data_len);
+			u32 sense_len = be32_to_cpu(rsp->sense_data_len);
+
+			/*
+			 * The sense data starts resp_data_len bytes past the
+			 * response data area; both lengths come from the
+			 * target-controlled response.  Copy the sense data
+			 * only if it has not been truncated, that is, only if
+			 * the full sense region fits within the bytes actually
+			 * received.  Otherwise the copy source would run past
+			 * the receive buffer (sized to the target-chosen
+			 * max_ti_iu_len), reading out of bounds.
+			 */
+			if (sizeof(*rsp) + (u64)resp_len + sense_len <= byte_len)
+				memcpy(scmnd->sense_buffer,
+				       rsp->data + resp_len,
+				       min(sense_len, SCSI_SENSE_BUFFERSIZE));
+			else
+				shost_printk(KERN_ERR, target->scsi_host,
+					     "dropping truncated sense data (resp_data_len %u sense_data_len %u, %u bytes received)\n",
+					     resp_len, sense_len, byte_len);
 		}
 
 		if (unlikely(rsp->flags & SRP_RSP_FLAG_DIUNDER))
@@ -2084,7 +2102,7 @@ static void srp_recv_done(struct ib_cq *
 
 	switch (opcode) {
 	case SRP_RSP:
-		srp_process_rsp(ch, iu->buf);
+		srp_process_rsp(ch, iu->buf, wc->byte_len);
 		break;
 
 	case SRP_CRED_REQ:


