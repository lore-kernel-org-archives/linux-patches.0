Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051238;
	b=kxD6a+Sztodd46kbkLYtb0ADCG5xgC1Uhh9io26deiHLXtXeNxwoVos9zjag1C83DUA3
	 TV1/sf2uN64pBjJAqjHoVVemPWay+khJFI7rfLRbIEcr3Zuqevvycmp3bt4GyrWVWcgun
	 Oi0Xe4/NfKE3Yi1OAriWACXm2MTnxF4VWtJl6py3xVPWTBPvBeIKD8RavCumbfV7cHGTg
	 EMZNzWBOAZh4o5XAediScRJ/dCshze56ddta2AA+WUyVqO847vkka2A1FqesafQRKGSJv
	 5U4yL7wKUvgLSTdIh65S7TupkZtMBTJeeo2ilhBWaiT8pNC85rx76Diw053Lt1z95qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xNjY5ASW/PxgySfgRYehckvigrvfeu9OUGxQhU2gqnQ=;
	b=qhKKwVSENiVy1jYG+xtTU7PfOsjDeKcicB6bNmG+6R5/Tu/nhH4+d6QnHEFEzoaTMq3G
	 ARQJVxgKcF8D65nriqrMuZwcQmGp1r3CPp49NMuNmS4yccGK05GDbJWMPN8zUVxy3Y42R
	 HAd8WD21aYn2FJsHr1PPFTWK+5yeDVU9unmYohI0k+uYDPoGMV0BvWGmqvQZjodTblYcI
	 bZsTUjiwqJpUtGNRY1UlIm6hUof2B04fWGWb2imIJoD7o/NHspQ5M8RKJaVCssR+vpoNV
	 mT6v/1VNQq900E01m1DQqIju8trQZ7xePomWJ6o7Pu9LXt21VmlIa2SNv6H+CrjIvzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00DZBYQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF354606A31C;
	Thu, 19 Nov 2026 01:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00DZBYQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D91D1F000C4;
	Thu, 19 Nov 2026 01:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051238;
	bh=xNjY5ASW/PxgySfgRYehckvigrvfeu9OUGxQhU2gqnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00DZBYQ2U/E/KrqBvBkMPCTr1nTbGbvLoLQdLdrmfmy7in5Zl0gXR5W61EJK1W4Mg
	 RTbAMS+eivbOlDk4rcj59GQwj+eyTOgyC7Gw2Rr10Zqhwce6susLqBupE2WelnLKCk
	 eBeTYOE+XYKKOIv8zqdwgqISoiVvcRSHChcTsFz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0139/2214] iommu/rockchip: Clear stale page faults before enabling stall
Date: Wed, 18 Nov 2026 15:30:15 +0100
Message-ID: <20261118150015.744396706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxing Hu <gahing@gahingwoo.com>

[ Upstream commit b10d5920cafa292ee3cab9c20f813da4fe4f00b8 ]

Boot firmware can leave an IOMMU bank in PAGE_FAULT_ACTIVE before the
driver has configured paging:

  PAGE_FAULT_ACTIVE=1  STALL_ACTIVE=0  IDLE=1

Such a bank ignores CMD_ENABLE_STALL and never reaches STALL_ACTIVE, so
rk_iommu_enable_stall()'s readx_poll_timeout() spins until it times out
(seen on the RK3576 NPU, whose MMUs share this poll across banks).

Rather than special-casing these banks in the stall path, acknowledge the
stale fault with CMD_PAGE_FAULT_DONE before enabling stall, so every bank
starts from a clean state and the normal stall sequence applies to all of
them.  Banks without a pending fault are untouched.

Signed-off-by: Jiaxing Hu <gahing@gahingwoo.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/rockchip-iommu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index bb40b2ddbc71d..14b2201d42ec8 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -418,6 +418,19 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
 	if (!rk_iommu_is_paging_enabled(iommu))
 		return 0;
 
+	/*
+	 * Boot firmware can leave a bank in PAGE_FAULT_ACTIVE with no handler
+	 * (PAGE_FAULT_ACTIVE & !STALL_ACTIVE & IDLE).  Such a bank ignores
+	 * CMD_ENABLE_STALL and never reaches STALL_ACTIVE, timing out the poll
+	 * below.  Acknowledge any stale fault first so every bank starts clean.
+	 */
+	for (i = 0; i < iommu->num_mmu; i++) {
+		if (rk_iommu_read(iommu->bases[i], RK_MMU_STATUS) &
+		    RK_MMU_STATUS_PAGE_FAULT_ACTIVE)
+			writel(RK_MMU_CMD_PAGE_FAULT_DONE,
+			       iommu->bases[i] + RK_MMU_COMMAND);
+	}
+
 	rk_iommu_command(iommu, RK_MMU_CMD_ENABLE_STALL);
 
 	ret = readx_poll_timeout(rk_iommu_is_stall_active, iommu, val,
-- 
2.53.0



