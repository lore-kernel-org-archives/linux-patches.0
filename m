Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C82B42F704;
	Tue, 21 Jul 2026 20:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665627; cv=none; b=a9+BoLT0LPPGS1/pK2eZ/9HngZXevC7LIOdhg4LShL3SitFXeLOvUnDgIg+TXhfPEHsxb/SwOdV7mI6eJ82KCdYECwbGH//DFwh5MUFVViB6t+E5xiQTxGrmQkw9u3GOWPGAoPd642PyitUFOMDOPPt1cO68r0d18x1+FwzoMf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665627; c=relaxed/simple;
	bh=9Ao811yfMrHLdO/4c56tThkT3sEBm28XtrFK4ZA4DeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vGEx5CyIC8n8d7kISYEtqflWG5CR88QE9cNkDONynh1+XBcfLjIZQdVpZwlKaJp+B2UoNcYQ64W5Yum1DtnJH5tGkIZOrJuFHP0TxSrVeYiqmj/1pPn84nKU0R+XWvRrf/W+srgBDPxTFWl6rOTB9Vg2+WIyXRoatJZY9YNeKkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHZqQSLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHZqQSLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892B41F000E9;
	Tue, 21 Jul 2026 20:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665626;
	bh=XY+qi1HbUajS07jpskBM5my+ycLPW+JZ8U9p5RsqzAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHZqQSLDOSXt4I/26hb1ilbaTkJgvnpBzQLw/aYWoZGAo7ZgPR9ohuHYbRdzTXTP6
	 3bAd+MGPd1D017vL6bdYmIyIRLjh+h4kaw4hm9faYVhfMYqrcdPoU06HbpH8hIz/UW
	 Xpwf0Mzl9AQwCbZj6CXM2cMxFAPflqedmqVEgKHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0376/1266] wifi: ath9k: fix OOB access from firmware tx status queue ID
Date: Tue, 21 Jul 2026 17:13:33 +0200
Message-ID: <20260721152450.241455953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4e939dcac1c9dc..c1807356bea76b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2754,6 +2754,11 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
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



