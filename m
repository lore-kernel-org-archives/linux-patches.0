Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98451D04A6;
	Wed,  2 Oct 2024 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875462; cv=none; b=LGuU+h7ysKtuXamNAKvwRGn5ahc8hZ2n6rhdJu+lkWj4nP/xJ7aTU0zLeRw5xrjbFDTH2bNUw09YC4/kMdzZFtA3hC3HjnBeAmQRskekONUXChh+Yd0urFN1StgO0hCTHqwfwbzk3nOlhrKDfdKt3PIQrx+hASjnSglk2k1ApHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875462; c=relaxed/simple;
	bh=LjCYTI3J83ECB0535m9tgrgOlQLjabaROdSzW1mILAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrGnhzzn/grYEiFskXhP/NfIjKKsVFCz6IVDC8ZnrwZvUl9SKTmb+ammsvijSqv1/jZpi+ob4R9TNtj88aDc+uYo5Ggj+xGvId4wLfqYo64wsopr1jZ+UTSBDQ8LbfWWI3MKGGjdaQH/NO9inxt59jqfcMgAD1DpXPqlvNuysVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=roJaN/ba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="roJaN/ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E73C4CECD;
	Wed,  2 Oct 2024 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875462;
	bh=LjCYTI3J83ECB0535m9tgrgOlQLjabaROdSzW1mILAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roJaN/baCu56EsggZ34WB/vYDFWQf9dfmZvGKkIIX7diGbRfaWIfaNYzD9+qEnS/X
	 wHBjVEutNPAfSMBeu0VxhVREBsO/cqaQQl4Ub23LMDrWryTZGnUc2HVHLSM3yoE+Qy
	 I1ePiCNYVhcZQtrKHZNzpzTZsKyVW0W+Bx/SqqzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 109/695] net: enetc: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Wed,  2 Oct 2024 14:51:47 +0200
Message-ID: <20241002125826.823754653@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 799a9225997799f7b1b579bc50a93b78b4fb2a01 ]

disable_irq() after request_irq() still has a time gap in which
interrupts can come. request_irq() with IRQF_NO_AUTOEN flag will
disable IRQ auto-enable when request IRQ.

Fixes: bbb96dc7fa1a ("enetc: Factor out the traffic start/stop procedures")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240911094445.1922476-3-ruanjinjie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 5c45f42232d32..f04f42ea60c0f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2305,12 +2305,11 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
 		snprintf(v->name, sizeof(v->name), "%s-rxtx%d",
 			 priv->ndev->name, i);
-		err = request_irq(irq, enetc_msix, 0, v->name, v);
+		err = request_irq(irq, enetc_msix, IRQF_NO_AUTOEN, v->name, v);
 		if (err) {
 			dev_err(priv->dev, "request_irq() failed!\n");
 			goto irq_err;
 		}
-		disable_irq(irq);
 
 		v->tbier_base = hw->reg + ENETC_BDR(TX, 0, ENETC_TBIER);
 		v->rbier = hw->reg + ENETC_BDR(RX, i, ENETC_RBIER);
-- 
2.43.0



