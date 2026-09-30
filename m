Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865BD51A14B;
	Wed, 30 Sep 2026 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788474; cv=none; b=XYWaRDsqxxla05b/kPl8L4NHwwPrOSgwrXGCh6ZD883mq8OFRMtzlTjKNY0+ySZtkd5QdGb55v9CHOxBeewi6ixKYB9J/Vz6PGIOLIEYoVwS3WIz/GGH0+wqb5kqPNp2UXTvmMPlzybZHHDGD9SgP21ej9p5DEb244h5XHAbph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788474; c=relaxed/simple;
	bh=5md29J7snxW+VYtSc3JfGYe/NZZclXDh8Y9qMBJElX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7AS2E3tuf0JKEyECuZrikDKZ14elxflqwhN6bgPFIG6J8trx9p7YW1Gi258r2ls2sAV7CBch+kd7btPD0UNNEdpsJYkqtBIPyBkRqs0i4rwMhXJ6AnMozMu9qOA6B3rRLu1ZBja+6BHS7BsD86X3jVaaUwMEDjDMGmNiuhnOX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z9kUPAAE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z9kUPAAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905E01F000FF;
	Wed, 30 Sep 2026 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788473;
	bh=BvnHO0UYCAlQPzTZdnqbIDYo+T+etEPmL9oXC37J26Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9kUPAAEGMxJW1do66K2tT5VcUUzKon3kcWoJZVrbhaJmqKvLrdaQSDqzQkqO8Xo6
	 eqfKWD6dEjw+5exUWAy+2jToWp1qUA/E6MuTkTKzAAiDiLz1zWFpF0B4mCiZQbRFn9
	 UFFreoH9mlyNBqkRz+if+Ll+hLizSak3hVmbluP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/877] Bluetooth: btintel_pcie: fix off-by-one bounds check in RX submit
Date: Wed, 30 Sep 2026 17:17:28 +0200
Message-ID: <20260930152417.685890614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8ebdfd9744ca0..bc87ebc46f4db 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -210,7 +210,7 @@ static int btintel_pcie_submit_rx(struct btintel_pcie_data *data)
 
 	frbd_index = data->ia.tr_hia[BTINTEL_PCIE_RXQ_NUM];
 
-	if (frbd_index > rxq->count)
+	if (frbd_index >= rxq->count)
 		return -ERANGE;
 
 	/* Prepare for RX submit. It updates the FRBD with the address of DMA
-- 
2.53.0



