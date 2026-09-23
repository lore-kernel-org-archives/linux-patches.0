Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA623B27D1;
	Wed, 23 Sep 2026 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174553; cv=none; b=K1xXQrsOBkJqiBn/UKOCoEW+fgz32jYwPs1nibdR6NXojgrxiec1j6jP6ol7TzE1m7W6sFn7jY903xt7Rxi9Wip7YlfP0c2Fn2WvwQ3ckpJ9eklZilnduz2kjD1G0YTEEWNE6VJRBx0qmbMm1mYV5x5XR9lG0ac7TKBC4j5AfuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174553; c=relaxed/simple;
	bh=E5kfU+9BLGRxuH094t86gp/6aCTWinDgwSENZYL+kr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osK5ZFEXJNc1LoAyut1TLf0ZfnsrB7DyflfRII6HPxWC0dsRj6It5K7T1mJQzgJNNPkQ43clSh7YI+HJ2S1B51NYNzn8q22aBD78lB2SsW6g8ttF2xym3+5JfPgM+YXB9xDBT64ioy4hwx8PKMDsiWrZJENscPvnuBTcaAD/SBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwXQi8mn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwXQi8mn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBCA1F000FF;
	Wed, 23 Sep 2026 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174552;
	bh=+HArx7qdr1pFw4RZbXL5oh6kIEJ7E3f2/p0ep1Wt+es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwXQi8mniZpN/qLRsj82j+fy+k0wmteJ4nTHQVEKWV4Vsv45EG3y/NY59oRqv3kbQ
	 DZkK3Deb5gcD6YVu5hbKnLX+7HuC2yrZFoA6LgOjIx3lDrq1xIGpyXoaLw32Yddz9H
	 ZRVvjUZwNrieqCS0SdVLDVjQRRO17kMWqeunq/jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/398] Bluetooth: btintel_pcie: fix off-by-one bounds check in RX submit
Date: Wed, 23 Sep 2026 16:03:46 +0200
Message-ID: <20260923140647.369611204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>

[ Upstream commit 2ea5a87a5a7ae58cb2662b8a7d06f209383e1765 ]

btintel_pcie_submit_rx() used frbd_index > rxq->count to guard the
FRBD array access, allowing frbd_index == rxq->count to pass through
and index one element past the end of the array. Change the check to
>= rxq->count so every out-of-range index is rejected.

This issue was reported by Claude Mythos.

Fixes: c2b636b3f788 (Bluetooth: btintel_pcie: Add support for PCIe transport)
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 90494871e0d37..8d3129aa2a1a3 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -465,7 +465,7 @@ static int btintel_pcie_submit_rx(struct btintel_pcie_data *data)
 
 	frbd_index = data->ia.tr_hia[BTINTEL_PCIE_RXQ_NUM];
 
-	if (frbd_index > rxq->count)
+	if (frbd_index >= rxq->count)
 		return -ERANGE;
 
 	/* Prepare for RX submit. It updates the FRBD with the address of DMA
-- 
2.53.0



