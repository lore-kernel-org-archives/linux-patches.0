Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622088;
	b=A2+JUzEPkD2/+2cqXlyFcvUvNdkKBjMMYCE9KKso0+Wd+iO7mKeML0zzlv1eXYGNov76
	 JImfTngmgci4lD7yQRblb7/MfDTApfuWAxbnKhLWV5L8XkEITGAf5UuPcmJzNq3Zj24kr
	 vdK5XA+ZB/hsrnZaT8IgK3UUsF9qnjjnW/AJObHyaXrijw5oyDtUCoeKroQUvODDYLBHn
	 DcIJI001EEcxaARrLeT7OWEr1ECey2HEJxefeinSRonwGlhVpO+sBZvMaqgRLC5isOoF5
	 9DeQFlH33Jei/U6lkibAflXpUilJLH+hPieTBNmjEovd5weRHrwIq7SxYfvAjqus30g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QRTaes/Bbr2i6ZofOKEIt4vpRq/rqYB2dqVdJAVbVB0=;
	b=TO6vu1kZvUiCBTLGxqhmclctgPAlEyXJqTnuK7y4ridgt5ONC/ANLlvKYiKztn9jOjh4
	 SMIYMq4IWGymGsQ8rBBXDXhzH4J5q1cuJYvE5OdxK+YvSrGEuvIBsaXE5b+qfEpTUy9cP
	 b5mHlWtGSjs1rr6aJkByTW4rggp+dkndttuTaFimwtmHDPRGmk64KIY1VpdBVdk+Ji0sB
	 ObGcI12eQnZUKkuFY6KToWlsqPIIepCKEGND/8w2YZwW6D/ZE1HcPY/B4Mey3xG6jYCEY
	 KA0QqpnZXQIn+5T7+t/Smr45xt5uWTTZ084WRzc2WiWR+x2fPPYxgj6at8anHxM2Etw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PODJWM1+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30F5606A323;
	Wed, 25 Nov 2026 15:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PODJWM1+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61341F000C4;
	Wed, 25 Nov 2026 15:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622088;
	bh=QRTaes/Bbr2i6ZofOKEIt4vpRq/rqYB2dqVdJAVbVB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PODJWM1+zm3UGxvTlHznF+6NdbmZggoatBOvdlMgWTvUE06qg9aqpTssudX6JItw9
	 HEA2QyhoXd2H0z9um90XN51gd7iKij/nmnvGD3NBiqTrguUVlGdKjA5xsHrYRaIYb6
	 +GQMnlbQ1o3Uz5mTtjLginjB4AkApwTQBuWMNitQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 426/990] fbnic: Disable PTP completions during the Tx force-flush
Date: Wed, 25 Nov 2026 15:29:53 +0100
Message-ID: <20261125143832.075622407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 7d4568edce74ac72794cdd42767cc116bf1ca9b4 ]

When the Tx queues fail to go idle, fbnic_wait_all_queues_idle() falls
back to fbnic_tx_flush(), which sets FBNIC_TMI_DROP_CTRL_EN. That bit
only drops packets at the Tx MAC Interface start of packet protection FIFO.

The PTP completion path is governed by a separate bit in the same
register. With only the drop enable set, a timestamped frame has its
packet discarded while the matching completion is still forwarded to
the host. fbnic_clean_tsq() then walks the ring with no packet left to
match it against and reports "Tx timestamp without matching packet".
The drop does not retire the completion either, as the completion FIFO
is only drained when the completion disable is set.

Set FBNIC_TMI_DROP_CTRL_CMPL_DIS together with the drop enable so the
completions are drained rather than leaked to the host, and clear both
bits again when the flush is turned off.

Fixes: ad3d9f8bc66c ("eth: fbnic: add TX packets timestamping support")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://patch.msgid.link/179381515954.9644.10831265959574467679.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_csr.h  |  1 +
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
index cf659be3004b2..9ef4dd9609edf 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_csr.h
@@ -456,6 +456,7 @@ enum {
 #define FBNIC_TMI_SOP_PROT_CTRL		0x04400		/* 0x11000 */
 #define FBNIC_TMI_DROP_CTRL		0x04401		/* 0x11004 */
 #define FBNIC_TMI_DROP_CTRL_EN			CSR_BIT(0)
+#define FBNIC_TMI_DROP_CTRL_CMPL_DIS		CSR_BIT(1)
 #define FBNIC_TMI_DROP_PKTS		0x04402		/* 0x11008 */
 #define FBNIC_TMI_DROP_BYTE_L		0x04403		/* 0x1100c */
 #define FBNIC_TMI_ILLEGAL_PTP_REQS	0x04409		/* 0x11024 */
diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index d7ca0216155bf..0a278f2a2ee7a 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -2290,15 +2290,19 @@ void fbnic_disable(struct fbnic_net *fbn)
 
 static void fbnic_tx_flush(struct fbnic_dev *fbd)
 {
+	u32 drop_ctrl = FBNIC_TMI_DROP_CTRL_EN | FBNIC_TMI_DROP_CTRL_CMPL_DIS;
+
 	netdev_warn(fbd->netdev, "triggering Tx flush\n");
 
-	fbnic_rmw32(fbd, FBNIC_TMI_DROP_CTRL, FBNIC_TMI_DROP_CTRL_EN,
-		    FBNIC_TMI_DROP_CTRL_EN);
+	/* Drop packets and retire their PTP completions */
+	fbnic_rmw32(fbd, FBNIC_TMI_DROP_CTRL, drop_ctrl, drop_ctrl);
 }
 
 static void fbnic_tx_flush_off(struct fbnic_dev *fbd)
 {
-	fbnic_rmw32(fbd, FBNIC_TMI_DROP_CTRL, FBNIC_TMI_DROP_CTRL_EN, 0);
+	u32 drop_ctrl = FBNIC_TMI_DROP_CTRL_EN | FBNIC_TMI_DROP_CTRL_CMPL_DIS;
+
+	fbnic_rmw32(fbd, FBNIC_TMI_DROP_CTRL, drop_ctrl, 0);
 }
 
 struct fbnic_idle_regs {
-- 
2.53.0



