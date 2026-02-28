Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCF72E040D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301613; cv=none; b=O1Sg/8e17ySS/BKc7CQNgKVE5gQgatekBnSUMzQoLp+roD9wHtRzPQBE/Hwgj2rEdxE461BLkePu/SL1mYR+T1SiUBhD0SYm9pvGLJGq33toWx3EeJpxxNgn5RVL827xKX2iRm3SmQrhMRKsTNKJaMjAY98KuGbPMvBZoRDP3oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301613; c=relaxed/simple;
	bh=rgdtpGXxqx8P6dPo0yWex68Te28mur4T5xhIg6v64LM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t0JFutBLYxaEEmJCN/l0EDNyUrgpQ04NHyFq8lOsHGvdIh0KN/K0P2OnKgbPrrN1DR2mMR4ZpCjYW4qYX3WDQemaIjjSGGju5kPMhUWtgNNxhufeWPjRSjfLr3xVyTEbK/hsMZT4FnZVLx1K81LPQ1ZcFRjH99clE8tLmBUSuiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApBFcmMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApBFcmMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42753C116D0;
	Sat, 28 Feb 2026 18:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301612;
	bh=rgdtpGXxqx8P6dPo0yWex68Te28mur4T5xhIg6v64LM=;
	h=From:To:Cc:Subject:Date:From;
	b=ApBFcmMsm4npkg4b7kpNC/2SWEvE17EpksfKLNVQTcYxEVrfgHaJTKB+wbr3FHGM7
	 wJeMWKDJmeqUbRBXbvnepGnOCMyX3n4eH0XJK7Pvf+cKya5mwzO+m7JNZ2UarpQ2t/
	 WbUsgOTfMoVDdDDANHqDh/rYcbdjeXtXHyhCNZ0NB63WW8pxqg3yPljUap02HzLzqR
	 LfiuDkyQYEXBNkKVU2zOfEkolxn69DlTlvKXlvG3Hb8YdauLUSOtiE9gqnWlYCLHv3
	 femJ0vY7Bd8auv4w/Z54/wZ7KxvAPkP1kLUDB0GXVIBZxlCJAwwidh36FTwI6rFj0C
	 g+iRc+I1VTKrQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: YunJe Shin <yjshin0438@gmail.com>,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.12 001/385] RDMA/siw: Fix potential NULL pointer dereference in header processing
Date: Sat, 28 Feb 2026 12:53:43 -0500
Message-ID: <20260228180011.1568201-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: YunJe Shin <yjshin0438@gmail.com>

commit 14ab3da122bd18920ad57428f6cf4fade8385142 upstream.

If siw_get_hdr() returns -EINVAL before set_rx_fpdu_context(),
qp->rx_fpdu can be NULL. The error path in siw_tcp_rx_data()
dereferences qp->rx_fpdu->more_ddp_segs without checking, which
may lead to a NULL pointer deref. Only check more_ddp_segs when
rx_fpdu is present.

KASAN splat:
[  101.384271] KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
[  101.385869] RIP: 0010:siw_tcp_rx_data+0x13ad/0x1e50

Fixes: 8b6a361b8c48 ("rdma/siw: receive path")
Signed-off-by: YunJe Shin <ioerts@kookmin.ac.kr>
Link: https://patch.msgid.link/20260204092546.489842-1-ioerts@kookmin.ac.kr
Acked-by: Bernard Metzler <bernard.metzler@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/siw/siw_qp_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_rx.c b/drivers/infiniband/sw/siw/siw_qp_rx.c
index ed4fc39718b49..06738f582c7af 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1436,7 +1436,8 @@ int siw_tcp_rx_data(read_descriptor_t *rd_desc, struct sk_buff *skb,
 		}
 		if (unlikely(rv != 0 && rv != -EAGAIN)) {
 			if ((srx->state > SIW_GET_HDR ||
-			     qp->rx_fpdu->more_ddp_segs) && run_completion)
+			     (qp->rx_fpdu && qp->rx_fpdu->more_ddp_segs)) &&
+			    run_completion)
 				siw_rdmap_complete(qp, rv);
 
 			siw_dbg_qp(qp, "rx error %d, rx state %d\n", rv,
-- 
2.51.0

