Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A256B49BD70;
	Wed, 23 Sep 2026 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173224; cv=none; b=p6PjGXOvuwfAtc+PciwVL/PE6uK590oWmIXQbL4BLrwi/S7PISqlW7HQaLBeMbMmuNvoGuwtuvmYlUq/Yr5sFH2wUhR7CXahlJof87yJn6PlKliN+ri2D9+IJNOM5+bpeWxL7XfflIa41Ss7Xokc/pe+b0I803LuaCccMX4pTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173224; c=relaxed/simple;
	bh=BX/QiDDNbewHAd+23Mf1rLAs9yk68TYV+63lBBumhm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVPbq2tREFRC1bNA2ON9fmKI2N00uTekCVr2UszZA9OR2wLASU1syJEMGFbXHLlVZ5CpZyK6xlcjus5KVfrH21r22rQMLxdEGrsQdH4OaM1RWkvBZZN3DCMZFvUBadKBOaLMXKtHXS3zIpc4zl7ylp1kei7LAqqi/5dvMvVO2X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcpAnPkK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcpAnPkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7A91F000FF;
	Wed, 23 Sep 2026 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173223;
	bh=VxhYPvRVKU/VdrSHNnveVrb8I4cq7bM8ArV93HXw6w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YcpAnPkKW56gH8I0gX4XFHfHEv/Km7wJ7vwAPNgMay9Ht5EU9F24YakRut515eI2H
	 OqihilZC27oVVg93KmDx5OhqvhMoWNzclLc1On0tZEJjgnae7BvHU8TgNEAkv0Lk7g
	 jHgzBaD2MCVAS7jYGJfdJ591+VhOViVtSaG2HX+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 178/438] Bluetooth: btintel_pcie: fix off-by-one bounds check in RX submit
Date: Wed, 23 Sep 2026 16:03:19 +0200
Message-ID: <20260923140649.378549935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index aad466e453013..3262e950a6bd8 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -508,7 +508,7 @@ static int btintel_pcie_submit_rx(struct btintel_pcie_data *data)
 
 	frbd_index = data->ia.tr_hia[BTINTEL_PCIE_RXQ_NUM];
 
-	if (frbd_index > rxq->count)
+	if (frbd_index >= rxq->count)
 		return -ERANGE;
 
 	/* Prepare for RX submit. It updates the FRBD with the address of DMA
-- 
2.53.0



