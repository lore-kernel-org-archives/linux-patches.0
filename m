Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE13046AA71;
	Tue, 21 Jul 2026 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648199; cv=none; b=Z8bFD3JX+XELNQDDQAvVRnLqko2PIEy4ipEsGODpsTIvCBkKX7u4qZiNpxHO2MmO9Pjce2doDoB7htnqpOA8TWv4ijEofXUduFvPkF3MV4gA+v0btzmYyiORN7o2xSUOQc2rOl+5xpG8yix/1IcBlpApeTUHJZBGOLI7TWaVV/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648199; c=relaxed/simple;
	bh=0sWKlhMSg8+ufGqvK63MAzHdbccEhx/lkH4YFwl7WxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LPRFRV/iZdPjXHjJKYsgO5jT6wBq3g5si8rFAIRvzWPWvK02qDIsxh/k9X2isB7M1Z/7tqcoqkFgAX9NFKuBtBkPlEyZXyfnJieJn7oQLDdyo9VFTkoh0N96OgRiDP4KdJ853chFo5Snq+dP2alFdolgR6XwrYADm1j598sBPAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uvCpbzO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uvCpbzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D961F000E9;
	Tue, 21 Jul 2026 15:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648198;
	bh=X/Tkg7SpV4E2cJqwCjVhe1mdtKThKoJNl2kRp0754VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uvCpbzOdL///Td8FDNa+uE66eaCrFb1iTsPDGf/yFW33IXBPISweC/9Ap6PHCXus
	 e0+Y5Nbm2MjmaOIOu9z4Hr9bylwNn+pHJtJXesROhs5nUZQcYlzmBhWfNH/4TIs75S
	 QIZULtHpCSXa9r8ct/xirL3Ic14HpnxtVSBs2zVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0109/2077] wifi: ath9k: fix OOB access from firmware tx status queue ID
Date: Tue, 21 Jul 2026 16:56:22 +0200
Message-ID: <20260721152555.265162623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 7ce2f118a2389e8f0a64068c6fe7cc7d40639be0 ]

ath_tx_edma_tasklet() accesses sc->tx.txq[ts.qid] where ts.qid is a
4-bit hardware field (0-15), but the txq array only has
ATH9K_NUM_TX_QUEUES (10) entries. A qid >= 10 causes an OOB array
access.

Add a bounds check on ts.qid before using it as an array index.

Fixes: fce041beb03f ("ath9k: unify edma and non-edma tx code, improve tx fifo handling")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260415222343.1540564-1-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0ac9212e42f75e..957646b2df4ded 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2746,6 +2746,11 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 			continue;
 		}
 
+		if (ts.qid >= ATH9K_NUM_TX_QUEUES) {
+			ath_dbg(common, XMIT, "invalid qid %d\n", ts.qid);
+			continue;
+		}
+
 		txq = &sc->tx.txq[ts.qid];
 
 		ath_txq_lock(sc, txq);
-- 
2.53.0



