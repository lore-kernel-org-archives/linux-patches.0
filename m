Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815942F0C70;
	Wed, 28 Jan 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615554; cv=none; b=myLP4yQ4UQn/cFOU7IUDAxmZ9h6FlpnXerJsWXWcs0FVF3E0EH9Q4obttIm+6wwtS0PmF4Mt+dlBTB0PQfliBSBWFQHu0qLN6D5GidnUYP5yv63a/3YkNmSdcdWmBRbiQy2Hz9bq++FKCqjOtUAvafcl/BkiBsSq6+IV2eIXGFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615554; c=relaxed/simple;
	bh=jtN5BgxHUzuRehfYxI7RTUDJNi/oIt4yJwuB3b8cBEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3mjuQWBagUaXL0aZDQ8HKjx8Ie7teHq9acED2PmQrlnQaX1k+OkCMm75kQnOzaHIsy+x8tHqa+x4abgvUWmWuehZ6I6eiwp/RoHBUnmO8JHP9LOJylAi8knV8R+1D2D/ahPipcPgo2gLshK4eQdIerCdcJTi/IK4YOKLkGj8aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4yXHJpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4yXHJpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1BFFC4CEF1;
	Wed, 28 Jan 2026 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615554;
	bh=jtN5BgxHUzuRehfYxI7RTUDJNi/oIt4yJwuB3b8cBEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4yXHJpkggl4zbudc2O0NwBms+tMMBsggu1VSu8d3lwej7zLQPBuBuMmKjMQYJr6r
	 ECCrzbNQSmKkDZNT1+WlhsXAU6uq+ZEMezypVu1AzpxedRZgLyBkATiMKcd2jWk87y
	 Yxup0rypd38mvvKAaoqll2LiaedZVmGLknUFF25s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/227] octeontx2: cn10k: fix RX flowid TCAM mask handling
Date: Wed, 28 Jan 2026 16:21:29 +0100
Message-ID: <20260128145345.929431587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

[ Upstream commit ab9b218a1521133a4410722907fa7189566be9bc ]

The RX flowid programming initializes the TCAM mask to all ones, but
then overwrites it when clearing the MAC DA mask bits. This results
in losing the intended initialization and may affect other match fields.

Update the code to clear the MAC DA bits using an AND operation, making
the handling of mask[0] consistent with mask[1], where the field-specific
bits are cleared after initializing the mask to ~0ULL.

Fixes: 57d00d4364f3 ("octeontx2-pf: mcs: Match macsec ethertype along with DMAC")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/20260116164724.2733511-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 4c7e0f345cb5b..060c715ebad0a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -328,7 +328,7 @@ static int cn10k_mcs_write_rx_flowid(struct otx2_nic *pfvf,
 
 	req->data[0] = FIELD_PREP(MCS_TCAM0_MAC_DA_MASK, mac_da);
 	req->mask[0] = ~0ULL;
-	req->mask[0] = ~MCS_TCAM0_MAC_DA_MASK;
+	req->mask[0] &= ~MCS_TCAM0_MAC_DA_MASK;
 
 	req->data[1] = FIELD_PREP(MCS_TCAM1_ETYPE_MASK, ETH_P_MACSEC);
 	req->mask[1] = ~0ULL;
-- 
2.51.0



