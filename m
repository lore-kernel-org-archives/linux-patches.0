Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049FC352003;
	Sat, 12 Sep 2026 08:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200175; cv=none; b=MUhkNskcy4/XJyhzV/16Wf9dknmXz8ozgLleJCoTf/90bxNLvqKPhg7sgoYgeeglYzdyQkg6pDAV8WayRBnWNHR16672Ow785cul8x+DPc0v9w7OFSAOem7WnnhaGE5/JfEvZnCxdIk/N/IagD9B0UW0sXevLk7wpAAFh9OnLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200175; c=relaxed/simple;
	bh=gtjG7dVWmTFlmfCLBeDv8sC+poTI+Cp3tCJgMQ01eAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUNdfdT0l1/fi5uLTd9U4LcD0kXIpHOVX8Ck5EUEy8NGTPCCByfQ89iqkQltC7TBva3iuvy6LCYzr1QdgcBRli6VkziZpQPZpU6DmHWAqpOdajjklMkRo/G3Vp/QNKgRbbrER550AQmjUd9VJcugofcOMpzA1G+vw26vOuwKMrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQe1ry/i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQe1ry/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8F81F000FF;
	Sat, 12 Sep 2026 08:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200173;
	bh=ZG9mNAqpJqte59eczYS0r7s9uEuN/SB5CumDKD52AGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQe1ry/idXSo85FlAPmNoTWRxWfZvOUu4uoBFhCRkc8AaIYNmaX76NH2WylW0qa0q
	 gEGwiHS/spVbjKHkamY62hndnQqoxAV7C4q9d1erFg3ilj0TJbdNQZmWmgseoua0Ip
	 nuXgXAqNc6MAmWVWSFNDmo24WIaDIMyOw0s3tIcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0737/1815] IB/isert: reject PDUs declaring more data than was received
Date: Sat, 12 Sep 2026 08:41:27 +0200
Message-ID: <20260912065706.203809170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 957f92ea4022fb6af4618271615a2a21a7b5bef9 ]

isert_recv_done() hands each received PDU to the opcode handlers without
ever looking at wc->byte_len, the number of bytes the HCA actually placed
in the receive descriptor. The handlers then copy that many bytes - the
data-segment length the initiator declared in the BHS
(ntoh24(hdr->dlength), via the derived unsol_data_len / imm_data_len) -
out of the fixed-size descriptor:

  isert_handle_iscsi_dataout():
        sg_copy_from_buffer(sg_start, sg_nents, isert_get_data(rx_desc),
                            unsol_data_len);
  isert_handle_scsi_cmd():
        sg_copy_from_buffer(cmd->se_cmd.t_data_sg, sg_nents,
                            isert_get_data(rx_desc), imm_data_len);

Because the declared length is never checked against wc->byte_len, an
initiator can declare a data segment larger than the bytes it actually
sent (and larger than the descriptor) and cause an out-of-bounds read of
the receive buffer.

Nothing upstream of isert closes this door:

  - __iscsit_check_dataout_hdr() bounds the inbound payload against
    conn_ops->MaxXmitDataSegmentLength (MXDSL) - a transmit parameter,
    used here for the inbound check.
  - iscsi_set_connection_parameters() sets
    ops->MaxXmitDataSegmentLength = ops->TargetRecvDataSegmentLength;
    and TARGETRECVDATASEGMENTLENGTH is absent from the min()-clamp list in
    iscsi_check_acceptor_state(), so the value the initiator declares is
    adopted verbatim (type range 512..16777215). The initiator effectively
    raises its own ceiling.
  - isert never clamps the negotiated value to its own fixed receive
    descriptor (ISER_RX_SIZE, 9216 bytes), so the target core's bound and
    the descriptor size are unrelated.

The imm_data_len == data_len path is more than an over-read: it aliases
the receive descriptor via sg_set_buf() and passes it to the backend as
the data source for the SCSI WRITE, so an over-declared length causes heap
contents past the descriptor to be written through the backend to the
backing store. The backend is the victim of the oversized scatterlist
isert hands it, not the cause; no read-back of the written bytes was
demonstrated.

Trigger: after login completes (full feature phase), an initiator that has
declared a large TargetRecvDataSegmentLength and a FirstBurstLength that
permits unsolicited/immediate data sends a PDU whose declared data-segment
length exceeds what was received. With KASAN:

  BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0x150/0x1c0
  Read of size 4096 at addr ffff888109720800 by task kworker/1:0H/25
  Workqueue: ib-comp-wq ib_cq_poll_work
  Call Trace:
   sg_copy_buffer+0x150/0x1c0
   isert_recv_done+0xba6/0x2390
   __ib_process_cq+0xe1/0x390
   ib_cq_poll_work+0x46/0x150

isert_recv_done+0xba6 resolves to isert_handle_iscsi_dataout()
(ib_isert.c:1160), inlined through isert_rx_opcode().

Validate wc->byte_len against the framing in isert_recv_done() before the
PDU reaches any handler, and reinstate the connection if it is short.
Because the test compares without subtracting the header length, it also
rejects PDUs shorter than the iSER and iSCSI headers, which would otherwise
be parsed out of stale descriptor contents. The login handler rejects PDUs
shorter than ISER_HEADERS_LEN (commit 29e7b925ae6d ("IB/isert: Reject login
PDUs shorter than ISER_HEADERS_LEN")) but does not bound the declared
length either; that is fixed in the next patch. The data handlers had no
length check at all.

isert reads the data segment from a fixed offset: isert_get_data()
returns the iSER header plus ISER_HEADERS_LEN and makes no adjustment for
an AHS.  The bytes the handlers touch are therefore exactly
[ISER_HEADERS_LEN, ISER_HEADERS_LEN + dlength), and comparing that sum
against wc->byte_len bounds precisely the region that is read.  An AHS
term would only make the test stricter without bounding anything further,
and cannot cause a false reject: a PDU carrying an AHS is longer, not
shorter.

This is a memory-safety fix that verifies the bytes that were actually
received; it does not touch RFC 7145 length negotiation and is not the
MaxXmitDataSegmentLength negotiation redesign raised in the 2017 "[Query]
iSER-Target: QP errors observed on increasing MaxXmitDataSegmentLength"
discussion. That redesign is explicitly out of scope here.

The patched kernel rejects the malformed DataOut PDU and both
immediate-data variants with "PDU declares ... bytes were received" and
continues to pass normal traffic with no regression.

Reproduced with soft-RoCE (rdma_rxe) and a raw rdma_cm/ibv initiator; no
kernel-side test hooks were needed.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Link: https://patch.msgid.link/20260726163931.971063-2-yhlee@isslab.korea.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1015a51f750af..66435a0a5c7a8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1333,6 +1333,21 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
 			ISER_RX_SIZE, DMA_FROM_DEVICE);
 
+	/*
+	 * The data segment length declared in the BHS is attacker controlled
+	 * and is used further down to read that many bytes out of the fixed
+	 * size receive descriptor, so it has to be checked against the number
+	 * of bytes that were actually received. Comparing without subtracting
+	 * also rejects PDUs shorter than the iSER and iSCSI headers, which
+	 * would otherwise be parsed out of stale descriptor contents.
+	 */
+	if (unlikely(wc->byte_len < ISER_HEADERS_LEN + ntoh24(hdr->dlength))) {
+		isert_err("PDU declares %u data bytes but only %u bytes were received\n",
+			  ntoh24(hdr->dlength), wc->byte_len);
+		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		return;
+	}
+
 	isert_dbg("DMA: 0x%llx, iSCSI opcode: 0x%02x, ITT: 0x%08x, flags: 0x%02x dlen: %d\n",
 		 rx_desc->dma_addr, hdr->opcode, hdr->itt, hdr->flags,
 		 (int)(wc->byte_len - ISER_HEADERS_LEN));
-- 
2.53.0



