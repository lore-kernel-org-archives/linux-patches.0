Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9F852F7C;
	Tue, 23 Jan 2024 00:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969900; cv=none; b=iOljd2adu3qtgPvbjQrU1abCgDi+tI2Om5uSX3re4kTxwR0dMqPM4wx6mjoi4kyVyxcwwc6R05MfWhjzFUaqwYhQ0EXkwzuJYN1MMpOeltuFV3O7hDLHyRMG05CP6jI/xNdra2jWs7O4quUSwGIiMjYwZ8s/iqTEF3euOHDjntM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969900; c=relaxed/simple;
	bh=ZjPVYU/dP0ox3s5ayrlljiVplTUowQjxJ9WStqwfTcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skjpguGLPJg9AtgbbzoFyZy3Z1TzZ2sdkUOGTiJEWX+Me9Ta9+Fp2cRlR6aev16XOtbJGmNReX4TW7n1TK/D/K/7CpyZtpYTp2Lq4RGQV0jhjNsmR3wi31iABv7Ks8z172BK/HObn5r7pi6a53pDLUUB0TRHjdYd1muAr0tjZSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po+xBV+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po+xBV+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D1AC433F1;
	Tue, 23 Jan 2024 00:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969900;
	bh=ZjPVYU/dP0ox3s5ayrlljiVplTUowQjxJ9WStqwfTcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po+xBV+JEygz3nYLdPjZwuDD+MQI/U/gLleZuyXD6IGIPHAvrcj2lvYw1Z/7LeDP5
	 wgPnF2G2BLxf0glym/avS2evOhjdMK+UJ9z/rWnyuPmGGw0tJWef6kDOIE+dTlf3L1
	 853Sf3mw8NqApZJvXVwt9/TpDq6zZOwhx8P1jcOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 515/641] vfio/pds: Fix calculations in pds_vfio_dirty_sync
Date: Mon, 22 Jan 2024 15:56:59 -0800
Message-ID: <20240122235834.201823743@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 4004497cec3093d7b0087bc70709b45969fa07b6 ]

The incorrect check is being done for comparing the
iova/length being requested to sync. This can cause
the dirty sync operation to fail. Fix this by making
sure the iova offset added to the requested sync
length doesn't exceed the region_size.

Also, the region_start is assumed to always be at 0.
This can cause dirty tracking to fail because the
device/driver bitmap offset always starts at 0,
however, the region_start/iova may not. Fix this by
determining the iova offset from region_start to
determine the bitmap offset.

Fixes: f232836a9152 ("vfio/pds: Add support for dirty page tracking")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Link: https://lore.kernel.org/r/20231117001207.2793-2-brett.creeley@amd.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/pds/dirty.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index c937aa6f3954..27607d7b9030 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -478,8 +478,7 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		pds_vfio->vf_id, iova, length, pds_vfio->dirty.region_page_size,
 		pages, bitmap_size);
 
-	if (!length || ((dirty->region_start + iova + length) >
-			(dirty->region_start + dirty->region_size))) {
+	if (!length || ((iova - dirty->region_start + length) > dirty->region_size)) {
 		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
 			iova, length);
 		return -EINVAL;
@@ -496,7 +495,8 @@ static int pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
 		return -EINVAL;
 	}
 
-	bmp_offset = DIV_ROUND_UP(iova / dirty->region_page_size, sizeof(u64));
+	bmp_offset = DIV_ROUND_UP((iova - dirty->region_start) /
+				  dirty->region_page_size, sizeof(u64));
 
 	dev_dbg(dev,
 		"Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
-- 
2.43.0



