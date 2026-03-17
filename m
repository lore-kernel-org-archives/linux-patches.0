Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610B52116F6;
	Tue, 17 Mar 2026 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767508; cv=none; b=gCtKRPwGM/uTd4fZyuYFsijlzW3V3+3YmqxrMLb44kl9AroipOMWjpG/eFOhvV0cwOamd5k6P6qKTK6MQnLR/qIc2svURTKXKAnKdImn+8fYG3Wibx05WyD9qPzolGfVs4qdpH7s4qrZl42iR+uz+utWLOJnKwWT8/vFGTkf3Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767508; c=relaxed/simple;
	bh=9GyASCNVXNbiJUwPPMmIHBlp/Z1+HsZmQlBL3T0aR2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EK8CkK8eYyE7kJ4tTAvgUfSVi00WsDh23aCgCuaFsfZ3CPQBrVnH2bwQb1LBS5xqbVt7Y56GyeNGeGjGWpn9ZY8qdhwkWkt7fV7TrBEmvHBA1ntUWsveNSlht5r4yhlvT0z7MfvRbWCxvFsemVuFvakAF5tRcGT4Q2QoZDyeD4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xx2c4qzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xx2c4qzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E4CC4CEF7;
	Tue, 17 Mar 2026 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767508;
	bh=9GyASCNVXNbiJUwPPMmIHBlp/Z1+HsZmQlBL3T0aR2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xx2c4qzbxupz8uiZ81BXnvLc/2bhk5v1bMZuW6zMJQf3JkJeulEIaSpuyU0TkmoGu
	 3HRwm++kbG/XKup1Tu9u55Kdg/W3UpK/IVvynF5Hnfo6WeVgGKCZHW28XvQn1bdIVn
	 XOxVPqHQ3fC9m8m9MEEyqdyxFZMbGZyQIS2g6izs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/333] octeontx2-af: devlink: fix NIX RAS reporter recovery condition
Date: Tue, 17 Mar 2026 17:32:08 +0100
Message-ID: <20260317163003.042751748@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dc26ca99b835e21e76a58b1463b84adb0ca34f58 ]

The NIX RAS health reporter recovery routine checks nix_af_rvu_int to
decide whether to re-enable NIX_AF_RAS interrupts. This is the RVU
interrupt status field and is unrelated to RAS events, so the recovery
flow may incorrectly skip re-enabling NIX_AF_RAS interrupts.

Check nix_af_rvu_ras instead before writing NIX_AF_RAS_ENA_W1S.

Fixes: 5ed66306eab6 ("octeontx2-af: Add devlink health reporters for NIX")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20260310184824.1183651-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 3735372539bd9..23f51fed4666d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -475,7 +475,7 @@ static int rvu_hw_nix_ras_recover(struct devlink_health_reporter *reporter,
 	if (blkaddr < 0)
 		return blkaddr;
 
-	if (nix_event_ctx->nix_af_rvu_int)
+	if (nix_event_ctx->nix_af_rvu_ras)
 		rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
 
 	return 0;
-- 
2.51.0



