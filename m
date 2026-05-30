Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE6D2690D5;
	Sat, 30 May 2026 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160699; cv=none; b=t5K2UIYrhvyvwjpfzxIgZ+K4zig64ossIuPyLvV2Q3d13hFlcwILD2OX9bGLTtKAep4bBo2lIgCPhE1Xa+SykkDW8wNeo1ruNkK1eAIn6GkCZD70N2Oxx7YrJ8DYoj7nKkGNg060JTUUNBq1weTC6V6OfZhdvEpVzo9LasX/KlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160699; c=relaxed/simple;
	bh=CN8BV1dr/DFNvW70ObHzjSIVk5mDZaP9hLCTfkNz17k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiNzo/HKMiZ9aW+crIOqt3WEnVy2g/t9KADGtduYMFXL/ZjUNxuBZ/dHFdlT1P0fSImgKCgQ8GRX/z/IHlpXILAytrBvzXyb0Yqukl+JWUgEy9+Fi7EcN45nKradz7dgAQHcJPW9cnrINv+S1a5G088tifsdt/7K3LJgvVly0Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjk6WEHe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjk6WEHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B131F00893;
	Sat, 30 May 2026 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160698;
	bh=C6oIQOoMBbc2Sor4MHromC4jdFd6+8H4FEXEEEfSvug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rjk6WEHev6xFQBMhvrR/08dGXBDuDBj8aZN1MaP/qkLtNNlQrqLyBHhY/00LP5z3I
	 B7PcgVA2SltxmvxHzBMoNvDh9jUspx/95nymtM8WJJ2CAnai/BPB5Y8Ep9zxGoKX4P
	 22BHE3+hnq5E7rvwx5uWHgvPLmtv0YGY/DkmwRdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.1 369/969] RDMA/rxe: Reject unknown opcodes before ICRC processing
Date: Sat, 30 May 2026 17:58:13 +0200
Message-ID: <20260530160310.509326249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 4c6f86d85d03cdb33addce86aa69aa795ca6c47a upstream.

Even after applying commit 7244491dab34 ("RDMA/rxe: Validate pad and ICRC
before payload_size() in rxe_rcv"), a single unauthenticated UDP packet
can still trigger panic.  That patch handled payload_size() underflow only
for valid opcodes with short packets, not for packets carrying an unknown
opcode.  The unknown-opcode OOB read described below predates that commit
and reaches back to the initial Soft RoCE driver.

The check added there reads

    pkt->paylen < header_size(pkt) + bth_pad(pkt) + RXE_ICRC_SIZE

where header_size(pkt) expands to rxe_opcode[pkt->opcode].length.  The
rxe_opcode[] array has 256 entries but is only populated for defined IB
opcodes; any other entry (for example opcode 0xff) is zero-initialized, so
length == 0 and the check degenerates to

    pkt->paylen < 0 + bth_pad(pkt) + RXE_ICRC_SIZE

which does not constrain pkt->paylen enough.  rxe_icrc_hdr() then computes

    rxe_opcode[pkt->opcode].length - RXE_BTH_BYTES

which underflows when length == 0 and passes a huge value to rxe_crc32(),
causing an out-of-bounds read of the skb payload.

Reproduced on v7.0-rc7 with that fix applied, QEMU/KVM with
CONFIG_RDMA_RXE=y and CONFIG_KASAN=y, after

    rdma link add rxe0 type rxe netdev eth0

A single 48-byte UDP packet to port 4791 with BTH opcode=0xff and
QPN=IB_MULTICAST_QPN triggers:

    BUG: KASAN: slab-out-of-bounds in crc32_le+0x115/0x170
    Read of size 1 at addr ...
    The buggy address is located 0 bytes to the right of
     allocated 704-byte region
    Call Trace:
     crc32_le+0x115/0x170
     rxe_icrc_hdr.isra.0+0x226/0x300
     rxe_icrc_check+0x13f/0x3a0
     rxe_rcv+0x6e1/0x16e0
     rxe_udp_encap_recv+0x20a/0x320
     udp_queue_rcv_one_skb+0x7ed/0x12c0

Subsequent packets with the same shape fault on unmapped memory and panic
the kernel.  The trigger requires only module load and "rdma link add"; no
QP, no connection, and no authentication.

Fix this by rejecting packets whose opcode has no rxe_opcode[] entry,
detected via the zero mask or zero length, before any length arithmetic
runs.

Cc: stable@vger.kernel.org
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://patch.msgid.link/r/20260414111555.3386793-1-michael.bommarito@gmail.com
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -322,6 +322,17 @@ void rxe_rcv(struct sk_buff *skb)
 	pkt->qp = NULL;
 	pkt->mask |= rxe_opcode[pkt->opcode].mask;
 
+	/*
+	 * Unknown opcodes have a zero-initialized rxe_opcode[] entry, so
+	 * both mask and length are 0.  Reject them before any length math:
+	 * rxe_icrc_hdr() would otherwise compute length - RXE_BTH_BYTES
+	 * and pass the underflowed value to rxe_crc32(), producing an
+	 * out-of-bounds read.
+	 */
+	if (unlikely(!rxe_opcode[pkt->opcode].mask ||
+		     !rxe_opcode[pkt->opcode].length))
+		goto drop;
+
 	if (unlikely(pkt->paylen < header_size(pkt) + bth_pad(pkt) +
 		       RXE_ICRC_SIZE))
 		goto drop;


