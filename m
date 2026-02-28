Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F2B36C9CD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302289; cv=none; b=YxSd7pdMNa3luaqBMFQs8cjacNKO8cjoT+ulTQUhFCD43H4wWSesKcD8TTuuUBVoRN/22P0qw3rV4+OTXj1HICNldplLvtQ5X/AhFI7ZckVdDytfUgGreVoNX/sJNyD3/lFwkXZPKbs5FSDm4ESj2aLpvaeFsTVyI9afhvr31xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302289; c=relaxed/simple;
	bh=ZcLtMZ55CvCApql4v/W1gA/dd+Jadmfq3JsCZ/RypjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F3+XHcXdRGumgxTaFoPTcUHKYcFbC/tS4pAksqMqq4JQfJ2MRqCaBhRtscfGse5e0WdeoFkqKQRSo+XxhZNAFxnO/Nxg+YB+1D4StIxYcXp9nRd1Wb9idZpiBteTLAREzuMdRhw51EZeK//QWLJgHVrbjgariNwtwSa8Yus62/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WF6mJisr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WF6mJisr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57E2C116D0;
	Sat, 28 Feb 2026 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302289;
	bh=ZcLtMZ55CvCApql4v/W1gA/dd+Jadmfq3JsCZ/RypjQ=;
	h=From:To:Cc:Subject:Date:From;
	b=WF6mJisrgnO9wcLHt/JaBNIjpqaN+u3BIqx8qAsrBrgTiB83sU4gXo/clLr8T4/c4
	 yEepxV1LQAdaZv/o1TChOHEKpT84iUp4LuimTneRP7z1xR/JCo7jn3P04BjhIxmESs
	 S0gVgYYXULsuGisPLkA+FTyRKL7renjz3MgqNzB9Ff0Gh1MdBR4zfLQYetAyNT2MAY
	 pD6Dx4Vfyv2O++40haJ+WAzGBu8d40mBe1yaHJ2u/DZWoCFVAumUEiuEgtHwMItlaz
	 fIggOb0fGKYRDlFdtSLOmh70nfVk9X5xy6Xk5YDGxxO8za+k8mfnoETDP16XDTMH1R
	 m1rC9H3K3h+dg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: YunJe Shin <yjshin0438@gmail.com>,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Bernard Metzler <bernard.metzler@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 001/232] RDMA/siw: Fix potential NULL pointer dereference in header processing
Date: Sat, 28 Feb 2026 13:07:34 -0500
Message-ID: <20260228181127.1592657-1-sashal@kernel.org>
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
index fd721cc19682e..6b049858644e8 100644
--- a/drivers/infiniband/sw/siw/siw_qp_rx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_rx.c
@@ -1456,7 +1456,8 @@ int siw_tcp_rx_data(read_descriptor_t *rd_desc, struct sk_buff *skb,
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

