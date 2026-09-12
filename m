Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B80833689D;
	Sat, 12 Sep 2026 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209100; cv=none; b=abIgaOaCN2Zz1tfeOsKO5Orm/mAxDj/A2qPptpLluRq9/38bhbvtAwu/lZjQlB+Z6VEYPiWD5As8KjfjnY3CSM1GgCJECAoSeAW40ZYCPkhxYxX2v1is9MJ/rrHQscmphNEhLiKFzUYpXJru5GyHI1BKf1OPzl4HyAfQIuas7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209100; c=relaxed/simple;
	bh=x0uIZnReyWXgLOy6sLN2vVPA8ljbYj7h+pH0RWTwzB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIduZVrN70z2GFf8jK5wJYombLn+52HT56pxlqI3qru+bAnW1zzRwnAqSV+5z86I12li1KbTgJB+xBJz875zBDlDb1jP6c+FtgziwfSgNKwjk+/G09i1dLCWDLt7+3G98CsyIR+teG3aaspjA6stiD+33IZ4uOqc8BjW3AML34E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pY2N++sO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pY2N++sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9041F000FF;
	Sat, 12 Sep 2026 10:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209099;
	bh=aqpL4PthDg7ey+oHxxoaabaQ1RjLnB075YRKQGVi+TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pY2N++sOJJFg5W29lImzxmlzA4OsczyY50npVMzw62IWnAC+g/ghpN6wqR03b9dOf
	 urrD5xbnKTwsHtBkY3AHshHbht9FhYVlXuomM+xbD7SqiaaWNMoyL0p46UkzFhgv08
	 gDh/OAoT5AqrmOS1zr3goABmqJCzHVbo4MC/zeI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0753/1518] wifi: mt76: fix RXDMAD_C buffer recycling race
Date: Sat, 12 Sep 2026 08:48:42 +0200
Message-ID: <20260912065640.463873499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit e1f97c10a4ec2b9db69a134b757304399ca903ce ]

The RXDMAD_C buffers come from the RRO data queues' page pools, which are
bound to a different NAPI, so the direct page-pool recycle used here could
race the owning NAPI; take the non-direct path as is already done for WED
RX queues.

Fixes: e50d4d710efd ("wifi: mt76: Add mt76_dma_get_rxdmad_c_buf utility routione")
Link: https://patch.msgid.link/20260722082610.2699628-17-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 3fcd0c46ecd94..f1048e3dff1d3 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -976,7 +976,8 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 	struct sk_buff *skb;
 	unsigned char *data;
 	bool check_ddone = false;
-	bool allow_direct = !mt76_queue_is_wed_rx(q);
+	bool allow_direct = !mt76_queue_is_wed_rx(q) &&
+			    !mt76_queue_is_wed_rro_rxdmad_c(q);
 	bool more;
 
 	if ((q->flags & MT_QFLAG_WED_RRO_EN) ||
-- 
2.53.0



