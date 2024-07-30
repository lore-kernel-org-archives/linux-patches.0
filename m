Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732021A6161;
	Tue, 30 Jul 2024 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356570; cv=none; b=ZftRZKzG+O4aeKfqEzSh2a2KCMBbtRycouTqcT7aG+5VhCqzponYbhXlvczdzwjEgaOyFY7NoW6Qkvb38lvjXpJmWych2gw7Yyzq/MsKOEgCmhoMuw7HPshHxX3rBELYrHoPelPvvzOjL5StHsaR2X2yfusnr6SwkZ/ABCwRTzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356570; c=relaxed/simple;
	bh=HM3ys2qwrcdD42pdmkgRwpX6LNU5h8vZyeFwPKl42UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9Z4tPia15xNLip/kEsZYqbbsPx4MXrs+uZ36JFAKyEDNbjXlqqIQeubcODgHcQd3RLckSxygM/YuGJumqBlC4Lv8D96ctrr2uLpquwMeavSREz/7L+tq3TC5Zj/oip8ZustPtN1BibOedgbM+mvTSLpnnUEeaEMbnNNCcRkXcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lb/CtrtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lb/CtrtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA447C32782;
	Tue, 30 Jul 2024 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356570;
	bh=HM3ys2qwrcdD42pdmkgRwpX6LNU5h8vZyeFwPKl42UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lb/CtrtKs/IuEVVd0KW98rLsR2eqx+j+VIiUFaw5yaDqeuR7apru0awSUfHKCo1qb
	 5JfYrK6SSYWh17j/MjWcV+QRfdP6URQp5lmuBpnxU3PIZeXtGa0NN3Dc0UIMelWF41
	 CcexmqplNO4SgHdyYVT41udY3+NNsQY2UxHI2K/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honggang LI <honggangli@163.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 201/440] RDMA/rxe: Dont set BTH_ACK_MASK for UC or UD QPs
Date: Tue, 30 Jul 2024 17:47:14 +0200
Message-ID: <20240730151623.722472230@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Honggang LI <honggangli@163.com>

[ Upstream commit 4adcaf969d77d3d3aa3871bbadc196258a38aec6 ]

BTH_ACK_MASK bit is used to indicate that an acknowledge
(for this packet) should be scheduled by the responder.
Both UC and UD QPs are unacknowledged, so don't set
BTH_ACK_MASK for UC or UD QPs.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://lore.kernel.org/r/20240624020348.494338-1-honggangli@163.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 2ace1007a4195..35768fdbd5b74 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -390,7 +390,7 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 	int			paylen;
 	int			solicited;
 	u32			qp_num;
-	int			ack_req;
+	int			ack_req = 0;
 
 	/* length from start of bth to end of icrc */
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
@@ -411,8 +411,9 @@ static struct sk_buff *init_req_packet(struct rxe_qp *qp,
 	qp_num = (pkt->mask & RXE_DETH_MASK) ? ibwr->wr.ud.remote_qpn :
 					 qp->attr.dest_qp_num;
 
-	ack_req = ((pkt->mask & RXE_END_MASK) ||
-		(qp->req.noack_pkts++ > RXE_MAX_PKT_PER_ACK));
+	if (qp_type(qp) != IB_QPT_UD && qp_type(qp) != IB_QPT_UC)
+		ack_req = ((pkt->mask & RXE_END_MASK) ||
+			   (qp->req.noack_pkts++ > RXE_MAX_PKT_PER_ACK));
 	if (ack_req)
 		qp->req.noack_pkts = 0;
 
-- 
2.43.0



