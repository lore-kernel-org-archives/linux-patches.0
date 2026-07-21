Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7576A43D51D;
	Tue, 21 Jul 2026 22:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673515; cv=none; b=eG7XbxsMy8y+IEi+hP8KUonMcv7iGF9xBSANTbbRn4UZ+cZquLB4/4d1DV5OQT3EOZSgFKbieyCx1IZ3SptfyedkdXGGjF5HU172RUIt43zena2tS0RebRF/loylfJOxm2ysmoZ6iMCgSvjUWbiFNW0fN5Ep0QygN2n2nzwVF5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673515; c=relaxed/simple;
	bh=Wz2wDzoKMkvX1rCo6cSC12ALwPY7UhT4bXaOeJbUA+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mbiVBazsg5LzcHVrKFi0FKOf7xN/8KY5aWWOXGECvpaX4m15nkQD1m38spAcMITjFfDn2kIErfaRwsDIkmSL/XkQdY6rctwWrCwpWy702GLCCLk/xyRUc8OQQpF1VDgB0Y8ij4tk8SbdnYa7E+LksS2h2Ou+NRznUaDrZd9fJPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cC+FBHYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cC+FBHYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E921F000E9;
	Tue, 21 Jul 2026 22:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673514;
	bh=r2d6UNppvE9Vw/o3Ygcz7T0t/TW1OvABbjFgRdTD8x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cC+FBHYnyw+mYxOGiUILZ+tXMc3WcGgYQvtc1hRgXIFkmDIyYVOj2hXlceEIVUtyI
	 bp1dNDH5Pe18CYuRT64dRg7dQ8OX4CAl4+S103mRAY1VshQzY52Q33jDOCrUqqHvfZ
	 oeoUZjaVA5Nf6GRz3xXVKW7GFY6gO490g07iK1Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/699] wifi: ath9k: fix OOB access from firmware tx status queue ID
Date: Tue, 21 Jul 2026 17:18:53 +0200
Message-ID: <20260721152359.626159790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 84c68aefc171a7..cd175d9e729df3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2695,6 +2695,11 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
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



