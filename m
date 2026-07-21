Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C383E49CF;
	Tue, 21 Jul 2026 22:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673419; cv=none; b=CVepXkxVio5vpm9NZymI3Mj3sgGsmkju6mxnL0au96xRKiFSWAqtNTBFiO1HD9nG0L9LapsAszRSjg2MZyDbhiJAN2iWqLbnsveU3WhbDZdVBLljUgTdiuMIh8xF+pmR5ycaUkHG2oN7fSE+B23luJkksK4X387raLP6Dvo8MGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673419; c=relaxed/simple;
	bh=ZMDlCJJK7/t/39UatUGzMyw+z8FoOLY+ZtZ+/zjUoMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbB/9zOkA+rlGZyZX524jKmldKJlBfHoR2Cq0qyJd7Ir/gKkddecC0AdoS7ZQvDoU83F5oB4vjSF3nGgodYtfZ6DMIzWtR3QyqR7VGEtHBCZdOwTE31oHoWwjk7SCHiIVZZuzjG17MUxsAL0m0P2QD05Y93Wue7P0AUnhzsbIkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/b79fSD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/b79fSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641981F000E9;
	Tue, 21 Jul 2026 22:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673417;
	bh=L0XnIHS5lOrVV0MqSxIMJPfieb6xqDkf94hiBDCbqP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s/b79fSD/xJSl6tmWE9chKJ3u5Bj/V1eY7TNtheON3WZB441K4bNN5DliVwBW2Q5S
	 BzwBV8/xxhukZEjXxsoM73WKgkp1QZgYyU9o0Xw1JyyD4cy+21tWKN+M8LBn9ValvC
	 eh3c89hikum88X8qJo1fmDyAST5aKbILMbIky4r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 155/699] RDMA/siw: bound Read Response placement to the RREAD length
Date: Tue, 21 Jul 2026 17:18:34 +0200
Message-ID: <20260721152359.198125119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -848,6 +848,15 @@ int siw_proc_rresp(struct siw_qp *qp)
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
 
 	if (mem_p->mem_obj == NULL)


