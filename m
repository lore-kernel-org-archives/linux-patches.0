Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222811D0412;
	Wed,  2 Oct 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876533; cv=none; b=pnHaNEtsBIQqTpZL0LFJVHCrvL+TQs4Tg8027p1r5VTtKSFzkDxiFDhPCnPkN+mB+7yiBSUPp0WyWksSA7KE+pMe83foeoGFswtJlG3gQwJJi7p9cIeYrL2j/VF7giX+gedTaJEwA/wL1Qkv7fI+d9ysNNctFSNzvBLXMJ04Izw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876533; c=relaxed/simple;
	bh=3PYEEoPSNlZf61OwdcUsDG1F41W/n9wiFzpGm4bNtYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZiJfNtnlthbgX7nh7f+ih+Ja5XOjrmTaK0QtD+2cglcV8lPiub1GgiYboLhOL/CK8vlUVx+9YosUxygdT1h04gmxcEn4H9VHWI9NmvOqAoqoNGEmxglmv5+Ibu80notys5AVJ2sMCtCYg40C13sTuX42kKnIVESJEiQIdz3KYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqJl3QvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqJl3QvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB46C4CEC5;
	Wed,  2 Oct 2024 13:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876533;
	bh=3PYEEoPSNlZf61OwdcUsDG1F41W/n9wiFzpGm4bNtYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqJl3QvBX1bV836dbVlRAbgRm7wrA6zkGOLUa6zV4Y3S9T5rmZdturM7XJy/ZvaKu
	 peGvqyaUsBVGhIeB0ivr6HxWlDWnZ8RBL38VRwSonyghaTkPsAU/eXQKHjQO+kUfHi
	 3iGQXH+mkBFCprqmglcHd9m6bipLKmnqz1MwmtBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 476/695] net: xilinx: axienet: Schedule NAPI in two steps
Date: Wed,  2 Oct 2024 14:57:54 +0200
Message-ID: <20241002125841.471594071@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit ba0da2dc934ec5ac32bbeecbd0670da16ba03565 ]

As advised by Documentation/networking/napi.rst, masking IRQs after
calling napi_schedule can be racy. Avoid this by only masking/scheduling
if napi_schedule_prep returns true.

Fixes: 9e2bc267e780 ("net: axienet: Use NAPI for TX completion path")
Fixes: cc37610caaf8 ("net: axienet: implement NAPI and GRO receive")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240913145711.2284295-1-sean.anderson@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9eb300fc35909..3de6559ceea62 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1222,9 +1222,10 @@ static irqreturn_t axienet_tx_irq(int irq, void *_ndev)
 		u32 cr = lp->tx_dma_cr;
 
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
-
-		napi_schedule(&lp->napi_tx);
+		if (napi_schedule_prep(&lp->napi_tx)) {
+			axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
+			__napi_schedule(&lp->napi_tx);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -1266,9 +1267,10 @@ static irqreturn_t axienet_rx_irq(int irq, void *_ndev)
 		u32 cr = lp->rx_dma_cr;
 
 		cr &= ~(XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_DELAY_MASK);
-		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
-
-		napi_schedule(&lp->napi_rx);
+		if (napi_schedule_prep(&lp->napi_rx)) {
+			axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, cr);
+			__napi_schedule(&lp->napi_rx);
+		}
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



