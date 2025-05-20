Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A76222570;
	Tue, 20 May 2025 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749867; cv=none; b=twJegSwtsbLVf9Pk7yJg9dIC7KUYx5kQTx1oEY3pvXILKAjMCw7GqunF6q9egGBn8DpJJUMGVNakp9kwEYs1mRV2R+sFMuZaJiAYZNuXzrFQ7biblhfhJCFv74teH2pziuRwh7bZ/hnj8eE82RJMsqrfP5YQsN2jWiTjP7Vg/5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749867; c=relaxed/simple;
	bh=80u4pUaKRopfhW3HDmvpuKjQaCs2OI/fqcWQV3tvN84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnXrb4dE4xQch2H9aHGmNuzLX8fG871DW2uTd5to3Hrh3tAr9R2wHRX8K7misTzGELybI1P4T0SllPS8fnZr8UcEah0KMpWHzMTZBfSdA8S4pp3Vl+RLQBr7vvV6VGYVq3y7zsPsdcp8DrRqOZdpZaVa5lsBw9z0Mi+t2YByDHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKnnkunm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKnnkunm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E7CC4CEE9;
	Tue, 20 May 2025 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749866;
	bh=80u4pUaKRopfhW3HDmvpuKjQaCs2OI/fqcWQV3tvN84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKnnkunm0bxLrpjVA1hwi6WFGpvbXdRklOo2+aCv+CWA+A3hExJ+Y8WyNxROyGUYq
	 VDLcl/WS329Q/igbBMhcdJ3vgMsxjZxTAdBIOFentGAnl+A6XPqpiAg0G5xIophPvV
	 ojuIui/LR0AXdRttajrSPyLrwUfi4AzegRrmmY7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/117] octeontx2-af: Fix CGX Receive counters
Date: Tue, 20 May 2025 15:50:19 +0200
Message-ID: <20250520125806.134901652@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit bf449f35e77fd44017abf991fac1f9ab7705bbe0 ]

Each CGX block supports 4 logical MACs (LMACS). Receive
counters CGX_CMR_RX_STAT0-8 are per LMAC and CGX_CMR_RX_STAT9-12
are per CGX.

Due a bug in previous patch, stale Per CGX counters values observed.

Fixes: 66208910e57a ("octeontx2-af: Support to retrieve CGX LMAC stats")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20250513071554.728922-1-hkelam@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 52792546fe00d..339be6950c039 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -707,6 +707,11 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 
 	if (!is_lmac_valid(cgx, lmac_id))
 		return -ENODEV;
+
+	/* pass lmac as 0 for CGX_CMR_RX_STAT9-12 */
+	if (idx >= CGX_RX_STAT_GLOBAL_INDEX)
+		lmac_id = 0;
+
 	*rx_stat =  cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT0 + (idx * 8));
 	return 0;
 }
-- 
2.39.5



