Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51331B0F17;
	Tue, 20 May 2025 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749860; cv=none; b=I1uc9agLOuo2t/O8kGLUSTFy29WLC76wz5ZG/8bDZ/gCnDV7qSb9NftzQqXy0g0hgZqgRsd3OLmfsG9g7DAlA/MXHzyacdOohvbA3+mtBjdeQwf1uuK0YjApzNB2qPHKzaqpi2/xlApa4tjuNZxsTqx85p93IZgE+6qJFvC5Xv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749860; c=relaxed/simple;
	bh=aEu0NEoPS1Qs42ch8wsODhX+6Ycx8dhdNVIl3MPk0h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+l0yC2VBYzxZui/jdCBAMpu5uWPYEdu3KsLaarmrnxeaLqBVzE1+Hd6/dk2B1yHz0fmIFDskVhp5FML84yEk7JYNdDDYzzkrGBzYd7Nm6niJnNV0O9dastMxKgk85rxj9lyTuSbNWrPJgsnmBDeiMT6zPpx8GKXem4H3cIdVRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/LL+eTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/LL+eTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423E7C4CEE9;
	Tue, 20 May 2025 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749860;
	bh=aEu0NEoPS1Qs42ch8wsODhX+6Ycx8dhdNVIl3MPk0h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/LL+eTjBv3v8LguRIlBYzZI9k+GnfYgz1tH8dAPvpDatqR2rRTt1BektBTLfwNsR
	 lvA0kb8CEknHmaSUOJJXa6H7bd8MWi2s2HTbDPdJsrIEy0IsxCYLuNdWEuW8Q8z2os
	 R4pL5DTWDfSHTMawIJCAIoar6ijI2qKw08H6iLdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/117] octeontx2-pf: macsec: Fix incorrect max transmit size in TX secy
Date: Tue, 20 May 2025 15:50:17 +0200
Message-ID: <20250520125806.059308030@linuxfoundation.org>
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



