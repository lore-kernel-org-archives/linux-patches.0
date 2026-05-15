Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AEB3C9896;
	Fri, 15 May 2026 16:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861317; cv=none; b=K+VanVtvzrlZVfP12JNjS4rR1jNegA/4LtUa3nT2NMty9kpgN9+tL+NtDSjzunUkr/g53/85XqPkhA/tgT6z8r+NPHxLE/KvPWy6FWhsmof9f0YjY2/k20ISpjtCZAeyJV1EXl1y9HWnrQAsoriwbkUnWQfLsFM2IGfoW7mTWVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861317; c=relaxed/simple;
	bh=qFRpuFESJPJE3l75xoLeUsJxBoZDiQoEyTArCMeb8w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBZUwq45kf282s2NgQt3AwU2vL9jdAXrs6jOtE50YwVc0eFuy0GYlkyqtHartTn2/d8GteThzYbMEI8tIiY+MxGBtzCtJ5tqYVxCQTw4HA45ziYXHzCyQvSQzloqK80Y1hsD3a0/bGZXf31MN38q2AJz3QsicOaNw1FnsI8bwPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwIUw4YE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwIUw4YE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AFBC2BCB0;
	Fri, 15 May 2026 16:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861316;
	bh=qFRpuFESJPJE3l75xoLeUsJxBoZDiQoEyTArCMeb8w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwIUw4YEzQUeJCjZVX9d7A0uAIOTXG5atDC4GE1W+2D3FstHNzzfuEqulg0kSB+bo
	 zkJG7hVETYR8e4rqWli96uV7uGzkw1dz7nzQkzFf+5Cw3UmUffQTO2Za8Z413OSoGy
	 tHBxQtZe8QJMfg7PAVrItPYX+IBmoovxO8dZakjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.6 281/474] RDMA/rxe: Reject unknown opcodes before ICRC processing
Date: Fri, 15 May 2026 17:46:30 +0200
Message-ID: <20260515154721.080793214@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,6 +330,17 @@ void rxe_rcv(struct sk_buff *skb)
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


