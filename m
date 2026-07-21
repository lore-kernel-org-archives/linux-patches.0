Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20C62D5436;
	Tue, 21 Jul 2026 17:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655669; cv=none; b=Ie0cJjKXDZ8csBg09/t09ikpMitZbh089AoPtRA+e/IvazLlNOD/DxHuU+Gw2wduEH6od7b5wrsqW8CIe+xDSk2rUhbDgiPnzAQtTYF6psx//Y6JGym3waZQ36gnXwKQvlic8OadM++jJExzSNNLhw12V2Ritj6jXz3V8fPOPy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655669; c=relaxed/simple;
	bh=Z6kJ32JpS0bvCFaeIH0/tVM45AhYJd2bCYUE5H6wfaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwY/qFQp9312uttYv4vRememTr5qfFgxdrc4aR2aMP76HaP3Hc7TQUQOP9TtITptOD+3WNe2/4b08gzIfugaV8itJV7Qhy6xxOouaQEhmf8M7N5j/u4Z0Y3HgIot1WeifH4DFn8KRxqpYnxJT3V71SQbXedV+gu6IWu6n7Dr8Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OL1pgHBr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OL1pgHBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653A21F000E9;
	Tue, 21 Jul 2026 17:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655667;
	bh=lg23n59yDJPPEZbSkAR+Ufla+F4ZcbPF7ORHiQ4/P/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OL1pgHBr7FQSjw71zSRuiPGsLxkiwVFu3DREDbt9T+RF8enR+M2kuz/ak+2xFQ6Lb
	 NKejIGGMkp31TTToS85QHF1t3rHF1zjY2J+E+DLtAm5wiESsyrPWc7q/lcoRcARs2V
	 s3i3x9+X3hJuXPFNZcovoNSHyrayHj6t1goq8d/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0094/1611] wifi: ath9k: fix OOB access from firmware tx status queue ID
Date: Tue, 21 Jul 2026 17:03:30 +0200
Message-ID: <20260721152516.960615891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



