Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D35243371;
	Tue, 20 May 2025 14:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750156; cv=none; b=s7VAYxu/FiB7KO2Z107W7Zc1dUlC9lcCSXJ+QT6X+4vijTKt5crFyw1QE8UfzJ/aho6mdwbZEhjSwnSvZlrc//6pIfSa3dnJfqPLiBHB1DtGmR9nVHxJO0VBO1pQSSaXsBazdkVXCwgIkkGE+1vDyHh1Lr48/y/FNGjqUw01I28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750156; c=relaxed/simple;
	bh=JMPBP1B5GG7tt09kuQTYLUGkJ2zrMjTFV/OOoIQ28xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHfoayiIPQ7v4XlQQ06WDdqWF+mwIxsD6lHPnUG9tQ8imTC5Pk2N2ThJFN59eSpCxFDSbN9AqjbECAcVcUCPvlj371ESTz4UK65ucL80oAu8RTmAaCScfJF7z0ymzljwIPfoXcLXM/tPGz/21uXKIZ1zU2e2cRNSjZK0neFiedc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOnZa4BZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOnZa4BZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B408DC4CEEA;
	Tue, 20 May 2025 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750156;
	bh=JMPBP1B5GG7tt09kuQTYLUGkJ2zrMjTFV/OOoIQ28xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOnZa4BZ6WWvElAakK47seQk7N9GrmbapIUzwjdyvGO/Ad/tzUwrhlfkCyDaXk7Dv
	 CuSF3OTPqoY+pptClfQJ3r33T2rYkMzDFOmfn98oEtNBk1Rnn8A4h2ObP6H+KVH+lg
	 R1Kbr2CnSE0u2tWcQpgmkyvmQzngfvxntRJSrC3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/143] octeontx2-pf: macsec: Fix incorrect max transmit size in TX secy
Date: Tue, 20 May 2025 15:50:15 +0200
Message-ID: <20250520125812.414426538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 865ab2461375e3a5a2526f91f9a9f17b8931bc9e ]

MASCEC hardware block has a field called maximum transmit size for
TX secy. Max packet size going out of MCS block has be programmed
taking into account full packet size which has L2 header,SecTag
and ICV. MACSEC offload driver is configuring max transmit size as
macsec interface MTU which is incorrect. Say with 1500 MTU of real
device, macsec interface created on top of real device will have MTU of
1468(1500 - (SecTag + ICV)). This is causing packets from macsec
interface of size greater than or equal to 1468 are not getting
transmitted out because driver programmed max transmit size as 1468
instead of 1514(1500 + ETH_HDR_LEN).

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1747053756-4529-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 6cc7a78968fc1..74953f67a2bf9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -533,7 +533,8 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
 	if (sw_tx_sc->encrypt)
 		sectag_tci |= (MCS_TCI_E | MCS_TCI_C);
 
-	policy = FIELD_PREP(MCS_TX_SECY_PLCY_MTU, secy->netdev->mtu);
+	policy = FIELD_PREP(MCS_TX_SECY_PLCY_MTU,
+			    pfvf->netdev->mtu + OTX2_ETH_HLEN);
 	/* Write SecTag excluding AN bits(1..0) */
 	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_ST_TCI, sectag_tci >> 2);
 	policy |= FIELD_PREP(MCS_TX_SECY_PLCY_ST_OFFSET, tag_offset);
-- 
2.39.5



