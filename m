Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5CE23F413;
	Mon, 19 May 2025 21:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689799; cv=none; b=WXFO4tZAL9eiYV3TvbQoyvF/fxaqdcChv7bEO+/ZVgmiPv41cVPlz/hnhYg3mBE1smUzrUZIW5W+aRZmlMOh6ZwXKsbiLzcNpUQI098QQC/ZcM+udz1ba/YOLYvqPxwnXPrbxvxVhFIcDqoxlFycgVTO1RqxgHt40BzuvxvO1jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689799; c=relaxed/simple;
	bh=Bb9S9RrPEnkTAetITz9CuJIrUWdR9A9NoHlCGB9OVhs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Tq1bWgfbgHq6cyIp9zjZc6TEtkutj8JMvnrufFx5GdIcfOWN/3myxIZM6l1XZ7ppPHhwO3GLmXOmV8V8jr1C3i6bwYtRQyqTWvLVzcXVwTnpTG6IL26N0ntPJXLNkLx99RgDHmKJfCpT8tO60IykAxdpNwaFM9eAbnrMkVUKe4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efu54CJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efu54CJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C9FC4CEE4;
	Mon, 19 May 2025 21:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689798;
	bh=Bb9S9RrPEnkTAetITz9CuJIrUWdR9A9NoHlCGB9OVhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efu54CJhjZGwwMY3PTZLZR1mLFvbOMmGczTO7iUzsKBg9vxUj+TbmXOPB4whw9Xqr
	 4u4Rpvw6jjGi3JQzN35MltQpu9vj/gQFm3Ztx87mlW03NARiHRDNtpdKGdWkFHApuP
	 3iZDMn3qiMjZBhBmKo26cGWaYzHnnbLYa+6gWULYt8WSNJQ46zOXMie/59zTcSN8pM
	 YwNB0vC/ThnMPa4U9nYi0NkH9stAOitS/hOHBE8b8xit8ECq/c8yVC4Jv/CWVvFPUk
	 Oav7UOpPzPYWH2sXv0h1EZgtqH2YK4oGg8qD/jKM0TDSqOEjxRXvYmPj2vbhk9xdrt
	 CD07SwyDnR5Rg==
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
Subject: [PATCH AUTOSEL 5.15 6/7] nvme-pci: add NVME_QUIRK_NO_DEEPEST_PS quirk for SOLIDIGM P44 Pro
Date: Mon, 19 May 2025 17:23:07 -0400
Message-Id: <20250519212308.1986645-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212308.1986645-1-sashal@kernel.org>
References: <20250519212308.1986645-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.183
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
index a3c5af95e8f3e..5f60a6ca247fe 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3448,6 +3448,8 @@ static const struct pci_device_id nvme_id_table[] = {
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

