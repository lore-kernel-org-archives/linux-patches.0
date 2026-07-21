Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8418635C6A1;
	Tue, 21 Jul 2026 21:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668851; cv=none; b=F6Y8POdf3sdE2NSdIv1SpV5dV9dXtm8uSpfdfmDlQNTuACQbOZv6Q0bl3XwnopgNHYu+o3nSRqu407/sQdzK0/fZEljg8yWHTs3Tumtd+olLazIqmXl7sRMvySWG1Z2IQlb3nNapQ19GX0EonhgyuYRV3NgP94gF1v/64GCBQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668851; c=relaxed/simple;
	bh=lc+O1iM38PqScV95TqH4OXepp+5xJ6CKVuy7BAg5st8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i4+bjsZyFkSjO3pC4ZCpTY6vfg/i/O2Gfa+meJthG5AI0AVdChefAXVaadCACFvO19PRGMmD4q69i88p38+um4NdW2PZojTgF7HtXGrffme6lf4xYgQx62dEUmEppplg9T2t/yOfoSyFM2cRxognmXEcJZPk9LbPZOdsiSa8/Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjUdSTIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjUdSTIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B3B1F000E9;
	Tue, 21 Jul 2026 21:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668850;
	bh=vGzgYw41tyqwXpss5arstjNryLJ8yEQU6NF9By7qUqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjUdSTIfBA+QBPur+axr9s69ZqI2Jc57ToFX/5dyxG8a4aYRsfXmwKjw8nxA8w697
	 KMMBYJWBbxM+CWbDHdsf1uppoBLqET12exrRyCFWnnHMO6JZ5Fn5xuaiQriBQYvp4T
	 c5c/yofMXDV1PnLWJbejYVdtlnpg34bq+594y7+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0289/1067] wifi: ath9k: fix OOB access from firmware tx status queue ID
Date: Tue, 21 Jul 2026 17:14:50 +0200
Message-ID: <20260721152431.069045867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eeabdd67fbccdd..59e022846a974e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2736,6 +2736,11 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
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



