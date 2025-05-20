Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A2D24679E;
	Tue, 20 May 2025 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749412; cv=none; b=r8uNCbXbXp7g3svnkHXEQrw6WvUf4/r8rNLc34xwBxlD87wg6zdeLUE6MQK6odL/VQJGrnfZxvmTSf4kKvs81Sjs5tox0jIQIPY51sifO8TliVpcR9Y7jyvwC+CX2LiHChkgSTp+aMzo3x4M7RDv/MiUVyMjMXdLJ1fNJ8M+fmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749412; c=relaxed/simple;
	bh=IwsYtQcXvD4zKXNSCUc4JxPRVDH6pNBg8/vcC17CEBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpTMWIiSxAKkAw14gksZaDc/3sg/bkmLznf3/jQddYe4dCJNcZsUfC5llH9RkAdr1D3rRRCZhnjRYxjFdXwpgwyKWTyR0b0NfsVdX7Zpy6vwdJqjEyFWl8sKFx9RpVhqpSd9qWN7OK+nmT6YRm8s560muglBxodmKKLIq+ouhyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI3CGibw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI3CGibw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215B0C4CEE9;
	Tue, 20 May 2025 13:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749412;
	bh=IwsYtQcXvD4zKXNSCUc4JxPRVDH6pNBg8/vcC17CEBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qI3CGibwd1d7AYyc3oAokKvJIkBtox1ZKAyZJpKcxrouy6UfavdYymqIq6BoZGtmc
	 zZ8zZZ1DG0hzE8VBqBpDlvmioKnnt8KoI8+wbfQS//DhQyzumhTVlvdOEjdI9OOGnh
	 nBRYL9vCZO4OyArckMiNuc+1+WszJE5HHi/X24mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/97] octeontx2-pf: macsec: Fix incorrect max transmit size in TX secy
Date: Tue, 20 May 2025 15:50:02 +0200
Message-ID: <20250520125802.111523893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a487a98eac88c..6da8d8f2a8701 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -428,7 +428,8 @@ static int cn10k_mcs_write_tx_secy(struct otx2_nic *pfvf,
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



