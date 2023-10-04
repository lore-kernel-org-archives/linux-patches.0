Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8ADC1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB7FC433C7;
	Wed,  4 Oct 2023 18:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443230;
	bh=QM4Hn4l4cr3zBEogZ+8L9Fn2DshVGHyV3Esy9VkpSjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvCZfETUYYu/TT48W4nfzRCVpCDDLDtLpUYF8y+FFsI/BoDQIoNwbzDF39g2ACW7F
	 KRuf8if6yNsNY29BadFDzP9p05vlA54WoB2JRDK9TF4wLzAko6V8WTN2WgJ3B/IHLY
	 wzQbOtxV2pqQrGobcuJrnuva4KKmTLdU966rSAS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Andy Gospodarek <gospo@broadcom.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/259] bnxt_en: Flush XDP for bnxt_poll_nitroa0()s NAPI
Date: Wed,  4 Oct 2023 19:54:15 +0200
Message-ID: <20231004175221.136969834@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit edc0140cc3b7b91874ebe70eb7d2a851e8817ccc ]

bnxt_poll_nitroa0() invokes bnxt_rx_pkt() which can run a XDP program
which in turn can return XDP_REDIRECT. bnxt_rx_pkt() is also used by
__bnxt_poll_work() which flushes (xdp_do_flush()) the packets after each
round. bnxt_poll_nitroa0() lacks this feature.
xdp_do_flush() should be invoked before leaving the NAPI callback.

Invoke xdp_do_flush() after a redirect in bnxt_poll_nitroa0() NAPI.

Cc: Michael Chan <michael.chan@broadcom.com>
Fixes: f18c2b77b2e4e ("bnxt_en: optimized XDP_REDIRECT support")
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 969db3c45d176..e81cb825dff4c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2654,6 +2654,7 @@ static int bnxt_poll_nitroa0(struct napi_struct *napi, int budget)
 	struct rx_cmp_ext *rxcmp1;
 	u32 cp_cons, tmp_raw_cons;
 	u32 raw_cons = cpr->cp_raw_cons;
+	bool flush_xdp = false;
 	u32 rx_pkts = 0;
 	u8 event = 0;
 
@@ -2688,6 +2689,8 @@ static int bnxt_poll_nitroa0(struct napi_struct *napi, int budget)
 				rx_pkts++;
 			else if (rc == -EBUSY)	/* partial completion */
 				break;
+			if (event & BNXT_REDIRECT_EVENT)
+				flush_xdp = true;
 		} else if (unlikely(TX_CMP_TYPE(txcmp) ==
 				    CMPL_BASE_TYPE_HWRM_DONE)) {
 			bnxt_hwrm_handler(bp, txcmp);
@@ -2707,6 +2710,8 @@ static int bnxt_poll_nitroa0(struct napi_struct *napi, int budget)
 
 	if (event & BNXT_AGG_EVENT)
 		bnxt_db_write(bp, &rxr->rx_agg_db, rxr->rx_agg_prod);
+	if (flush_xdp)
+		xdp_do_flush();
 
 	if (!bnxt_has_work(bp, cpr) && rx_pkts < budget) {
 		napi_complete_done(napi, rx_pkts);
-- 
2.40.1



