Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE0E2206B5;
	Mon, 19 May 2025 21:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689785; cv=none; b=T9pBp9gWfBVZ3zr4y9SABrx+It6wA7U+kKOYB9MuE+A6cVW0X/mshiLjAUF3JqBzd63gqt30OMZs7d3ZAUBTurxN+FUhtn2viyiY+KQ7WXbCipokkV7q9fySw7sBTpYLt3ER0vLEHYsxKaC5Zw9a0uGQ7kSe9JU6LxfrPn84cBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689785; c=relaxed/simple;
	bh=Cj3KGAKM5g24m22nJ6N3XMlJxhdPvcN6/6t+Z7L/ytE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P5fnktexYPsKPsiCSYnGVuSmNrbwX2r3XtoT2tw3T48deFtcjbDqVKPJD9YInFvrH6GjQGCG0MRGWJnSEJF7X/KDir2Vx+kO/fgiagssStXlYAOwoKSG3/98RRhprdpGdSVpeRKF0jssq0t1QfJpT+gI3QEIsvKfiyKoqVFMg6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbxuIf2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbxuIf2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87240C4CEEB;
	Mon, 19 May 2025 21:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689785;
	bh=Cj3KGAKM5g24m22nJ6N3XMlJxhdPvcN6/6t+Z7L/ytE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbxuIf2AQOE/wTWaOHHAGlIyzphAH2fs9+YzfrzLIc8Mi4kXlThQgNTWuLNLRvodU
	 ECkmVaJEWFiPyO/s1j091hvKwl/ccfMbSjynOI8/6SzPYVRCkgePwmHSpuXVEcKmco
	 lY4Xs/LIw+4Ags0dncij8iIgcPP/DX6G2u4oqojtdp+OuS6p/FtWpJBDf7q+zw4m7g
	 kgUR1NgTo/cLgIMHoOAJ6aM7FfMSbQJpErjaUPi5NhVS9Nrn55a0jLmVzTPsJgczBJ
	 P21IcZXoJEPvH1zU2nEs9yj+CzWUedARLh2JlRO/ErxnkHn+X7pHwVM0jsFOhmESCB
	 XK2uQ4zI414ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilya Guterman <amfernusus@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>,
	kbusch@kernel.org,
	axboe@fb.com,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 6/8] nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro
Date: Mon, 19 May 2025 17:22:53 -0400
Message-Id: <20250519212255.1986527-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212255.1986527-1-sashal@kernel.org>
References: <20250519212255.1986527-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.139
Content-Transfer-Encoding: 8bit

From: Ilya Guterman <amfernusus@gmail.com>

[ Upstream commit e765bf89f42b5c82132a556b630affeb82b2a21f ]

This commit adds the NVME_QUIRK_NO_DEEPEST_PS quirk for device
[126f:2262], which belongs to device SOLIDIGM P44 Pro SSDPFKKW020X7

The device frequently have trouble exiting the deepest power state (5),
resulting in the entire disk being unresponsive.

Verified by setting nvme_core.default_ps_max_latency_us=10000 and
observing the expected behavior.

Signed-off-by: Ilya Guterman <amfernusus@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index da858463b2557..8e3283e0f0ae9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3590,6 +3590,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x025e, 0xf1ac),   /* SOLIDIGM  P44 pro SSDPFKKW020X7  */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
-- 
2.39.5

