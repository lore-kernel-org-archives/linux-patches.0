Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C107C42DFF6;
	Thu, 16 Jul 2026 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212483; cv=none; b=NsWMfRrP+jY6w3nAN13HOAier9Up8UR5q5wXTZ4Dtlju02HGklV4L7cSx+k2C+Q19x3vrBx1vBE8+iKMqcwvP+FAIhhkkdyaBB/Bpcy/uy7B1v58F5asmwSou7Wuf+s63nO6z8OJ4a3h1rwd/dnz9/7e4zeiiKOKM+RUqV1OPf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212483; c=relaxed/simple;
	bh=HlcQXfYy8CzsXfnHdKraqWqqH29XjKQKbIe1jdpBpXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fF7HcbIaploE8QW87XeZ9fBwsqyyWyk4FBeT3sdP1FTSsjSS2PZG9xwgbvRUUaWjayH0Lz2eayVgYaVUHH2sDwdQ7PlQDl7bfrICkE3orIEJ2ZP3+KnxXEwE7FfdwDHx6viI67IylDagGsiiKiEIRGYA/Z1LW33Gkl2IZpMmJiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWbZ7Vyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWbZ7Vyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A971F000E9;
	Thu, 16 Jul 2026 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212481;
	bh=v5C8sqjKyT1dXo7fQCZV0+dv0aaiqHNheCw8vdY9xF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWbZ7VyyTg11RqXNgjIo7PWzJnLyNoMGlfbTl2P/QrxBWHMyx7Mze0TKhVHl9rwnq
	 BEMStskL8fSHRS1mfIPBCEo2UejIi8xjThP1f7YmO6zjlP/kzu4bv5D6ZAlXO5yby6
	 Myx9cWgsuglFLpblv6C5y08m9FcBQbC3u8NoPtnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.12 345/349] RDMA/siw: bound Read Response placement to the RREAD length
Date: Thu, 16 Jul 2026 15:34:39 +0200
Message-ID: <20260716133041.026646870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 7d29f7e9dbd844cae4d3e559cf78324b9642fd6b upstream.

In drivers/infiniband/sw/siw/siw_qp_rx.c, siw_proc_rresp() places each
inbound Read Response DDP segment at sge->laddr + wqe->processed and then
accumulates wqe->processed, but it never checks the running total against
the sink buffer length on continuation segments. siw_check_sge() resolves
and validates the sink memory only on the first fragment (the if (!*mem)
branch), and siw_rresp_check_ntoh() compares the cumulative length against
wqe->bytes only on the final segment (the !frx->more_ddp_segs guard).

A connected siw peer that answers an outstanding RREAD with Read Response
segments that keep the DDP Last flag clear, carrying more total payload
than the RREAD requested, drives wqe->processed past the validated sink
buffer; the next siw_rx_data() call writes out of bounds at
sge->laddr + wqe->processed. siw runs iWARP over ordinary routable TCP,
so the peer is the remote end of an established RDMA connection and needs
no local privilege.

Bound every segment before placement, exactly as siw_proc_send() and
siw_proc_write() already do for their tagged and untagged paths, and
terminate the connection with a base-or-bounds DDP error when the
Read Response would overrun the sink buffer.

This is the second receive-path length fix for this file. A separate
change rejects an MPA FPDU length that underflows the per-fragment
remainder in the header decode; that guard does not cover this case,
because here each individual segment length is self-consistent and only
the accumulated placement offset overruns the buffer.

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Link: https://patch.msgid.link/r/20260602194700.2273758-1-michael.bommarito@gmail.com
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -844,6 +844,15 @@ int siw_proc_rresp(struct siw_qp *qp)
 	}
 	mem_p = *mem;
 
+	if (unlikely(wqe->processed + srx->fpdu_part_rem > wqe->bytes)) {
+		siw_dbg_qp(qp, "rresp len: %d + %d > %d\n",
+			   wqe->processed, srx->fpdu_part_rem, wqe->bytes);
+		wqe->wc_status = SIW_WC_LOC_LEN_ERR;
+		siw_init_terminate(qp, TERM_ERROR_LAYER_DDP,
+				   DDP_ETYPE_TAGGED_BUF,
+				   DDP_ECODE_T_BASE_BOUNDS, 0);
+		return -EINVAL;
+	}
 	bytes = min(srx->fpdu_part_rem, srx->skb_new);
 	rv = siw_rx_data(mem_p, srx, &frx->pbl_idx,
 			 sge->laddr + wqe->processed, bytes);


